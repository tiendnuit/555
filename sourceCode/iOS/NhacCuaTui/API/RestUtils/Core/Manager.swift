//
//  Manager.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
/**
Responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
*/
@available(iOS 8.0, *)
open class Manager {
    
    // MARK: - Properties
    
    /**
    A shared instance of `Manager`, used by top-level Alamofire request methods, and suitable for use directly for any ad hoc requests.
    */
    open static let sharedInstance: Manager = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        
        return Manager(configuration: configuration)
        }()
    
    /**
    Creates default values for the "Accept-Encoding", "Accept-Language" and "User-Agent" headers.
    
    - returns: The default header values.
    */
    open static let defaultHTTPHeaders: [String: String] = {
        // Accept-Encoding HTTP Header; see http://tools.ietf.org/html/rfc7230#section-4.2.3
        let acceptEncoding: String = "gzip;q=1.0,compress;q=0.5"
        
        // Accept-Language HTTP Header; see http://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage: String = {
            var components: [String] = []
            for (index, languageCode) in (Locale.preferredLanguages ).enumerated() {
                let q = 1.0 - (Double(index) * 0.1)
                components.append("\(languageCode);q=\(q)")
                if q <= 0.5 {
                    break
                }
            }
            
            return components.joined(separator: ",")
            }()
        
        // User-Agent Header; see http://tools.ietf.org/html/rfc7231#section-5.5.3
        let userAgent: String = {
            if let info = Bundle.main.infoDictionary {
                let executable: AnyObject = info[kCFBundleExecutableKey as String] as AnyObject ?? "Unknown" as AnyObject
                let bundle: AnyObject = info[kCFBundleIdentifierKey as String] as AnyObject ?? "Unknown" as AnyObject
                let version: AnyObject = info[kCFBundleVersionKey as String] as AnyObject ?? "Unknown" as AnyObject
                let os: AnyObject = ProcessInfo.processInfo.operatingSystemVersionString as AnyObject ?? "Unknown" as AnyObject
                
                var mutableUserAgent = NSMutableString(string: "\(executable)/\(bundle) (\(version); OS \(os))") as CFMutableString
                let transform = NSString(string: "Any-Latin; Latin-ASCII; [:^ASCII:] Remove") as CFString
                if CFStringTransform(mutableUserAgent, nil, transform, false) {
                    return mutableUserAgent as String
                }
            }
            
            return "Alamofire"
            }()
        
        return [
            "Accept-Encoding": acceptEncoding,
            "Accept-Language": acceptLanguage,
            "User-Agent": userAgent
        ]
        }()
    
    let queue = DispatchQueue(label: "queue", attributes: [])
    
    /// The underlying session.
    open let session: URLSession
    
    /// The session delegate handling all the task and session delegate callbacks.
    open let delegate: SessionDelegate
    
    /// Whether to start requests immediately after being constructed. `true` by default.
    open var startRequestsImmediately: Bool = true
    
    /// The background completion handler closure provided by the UIApplicationDelegate `application:handleEventsForBackgroundURLSession:completionHandler:` method. By setting the background completion handler, the SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` closure implementation will automatically call the handler. If you need to handle your own events before the handler is called, then you need to override the SessionDelegate `sessionDidFinishEventsForBackgroundURLSession` and manually call the handler when finished. `nil` by default.
    open var backgroundCompletionHandler: (() -> Void)?
    
    // MARK: - Lifecycle
    
    /**
    - parameter configuration: The configuration used to construct the managed session.
    */
    required public init(configuration: URLSessionConfiguration? = nil) {
        self.delegate = SessionDelegate()
        self.session = URLSession(configuration: configuration!, delegate: delegate, delegateQueue: nil)
        
        self.delegate.sessionDidFinishEventsForBackgroundURLSession = { [weak self] session in
            if let strongSelf = self {
                strongSelf.backgroundCompletionHandler?()
            }
        }
    }
    
    deinit {
        self.session.invalidateAndCancel()
    }
    
    
    
    
    // MARK: - Request
    
    /**
    Creates a request for the specified method, URL string, parameters, and parameter encoding.
    
    - parameter method: The HTTP method.
    - parameter URLString: The URL string.
    - parameter parameters: The parameters. `nil` by default.
    - parameter encoding: The parameter encoding. `.URL` by default.
    
    - returns: The created request.
    */
    @available(iOS 8.0, *)
    open func request(_ method: Method, _ URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .url) -> Request {
        return request(encoding.encode(URLRequest(url: method, cachePolicy: URLString) as! URLRequestConvertible, parameters: parameters).0)
    }
    
    /**
    Creates a request for the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter URLRequest: The URL request
    
    - returns: The created request.
    */
    @available(iOS 8.0, *)
    open func request(_ URLRequest: URLRequestConvertible) -> Request {
        var dataTask: URLSessionDataTask?
        queue.sync {
            dataTask = self.session.dataTask(with: URLRequest.URLRequest)
        }
        
        let request = Request(session: session, task: dataTask!)
        delegate[request.delegate.task] = request.delegate
        
        if startRequestsImmediately {
            request.resume()
        }
        
        return request
    }
    
    // MARK: - SessionDelegate
    
    /**
    Responsible for handling all delegate callbacks for the underlying session.
    */
    @available(iOS 8.0, *)
    public final class SessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate, URLSessionDownloadDelegate {
        fileprivate var subdelegates: [Int: Request.TaskDelegate] = [:]
        fileprivate let subdelegateQueue = DispatchQueue(label: "subdelegateQueue", attributes: DispatchQueue.Attributes.concurrent)
        
        subscript(task: URLSessionTask) -> Request.TaskDelegate? {
            get {
                var subdelegate: Request.TaskDelegate?
                subdelegateQueue.sync {
                    subdelegate = self.subdelegates[task.taskIdentifier]
                }
                
                return subdelegate
            }
            
            set {
                subdelegateQueue.async(flags: .barrier, execute: {
                    self.subdelegates[task.taskIdentifier] = newValue
                }) 
            }
        }
        
        // MARK: - NSURLSessionDelegate
        
        // MARK: Override Closures
        
        /// NSURLSessionDelegate override closure for `URLSession:didBecomeInvalidWithError:` method.
        public var sessionDidBecomeInvalidWithError: ((Foundation.URLSession, Error?) -> Void)?
        
        /// NSURLSessionDelegate override closure for `URLSession:didReceiveChallenge:completionHandler:` method.
        public var sessionDidReceiveChallenge: ((Foundation.URLSession, URLAuthenticationChallenge) -> (Foundation.URLSession.AuthChallengeDisposition, URLCredential?))?
        
        /// NSURLSessionDelegate override closure for `URLSessionDidFinishEventsForBackgroundURLSession:` method.
        public var sessionDidFinishEventsForBackgroundURLSession: ((Foundation.URLSession) -> Void)?
        
        // MARK: Delegate Methods
        
        public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
            sessionDidBecomeInvalidWithError?(session, error)
        }
        
        public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: (@escaping (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) {
            if sessionDidReceiveChallenge != nil {
                //completionHandler(sessionDidReceiveChallenge!((session, challenge))
                let receiveChallenge = sessionDidReceiveChallenge!((session, challenge))
                
                    
                completionHandler(receiveChallenge.0, receiveChallenge.1)
            } else {
                completionHandler(.performDefaultHandling, nil)
            }
        }
        
        public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
            sessionDidFinishEventsForBackgroundURLSession?(session)
        }
        
        // MARK: - NSURLSessionTaskDelegate
        
        // MARK: Override Closures
        
        /// Overrides default behavior for NSURLSessionTaskDelegate method `URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:`.
        public var taskWillPerformHTTPRedirection: ((Foundation.URLSession, URLSessionTask, HTTPURLResponse, Foundation.URLRequest) -> Foundation.URLRequest?)?
        
        /// Overrides default behavior for NSURLSessionTaskDelegate method `URLSession:task:didReceiveChallenge:completionHandler:`.
        public var taskDidReceiveChallenge: ((Foundation.URLSession, URLSessionTask, URLAuthenticationChallenge) -> (Foundation.URLSession.AuthChallengeDisposition, URLCredential?))?
        
        /// Overrides default behavior for NSURLSessionTaskDelegate method `URLSession:session:task:needNewBodyStream:`.
        public var taskNeedNewBodyStream: ((Foundation.URLSession, URLSessionTask) -> InputStream?)?
        
        /// Overrides default behavior for NSURLSessionTaskDelegate method `URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:`.
        public var taskDidSendBodyData: ((Foundation.URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
        
        /// Overrides default behavior for NSURLSessionTaskDelegate method `URLSession:task:didCompleteWithError:`.
        public var taskDidComplete: ((Foundation.URLSession, URLSessionTask, Error?) -> Void)?
        
        // MARK: Delegate Methods
        
        public func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: (@escaping (Foundation.URLRequest?) -> Void)) {
            var redirectRequest: Foundation.URLRequest? = request
            
            if taskWillPerformHTTPRedirection != nil {
                redirectRequest = taskWillPerformHTTPRedirection!(session, task, response, request)
            }
            
            completionHandler(redirectRequest)
        }
        
        public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: (@escaping (Foundation.URLSession.AuthChallengeDisposition, URLCredential?) -> Void)) {
            if taskDidReceiveChallenge != nil {
                let receiveChallenge = taskDidReceiveChallenge!(session, task, challenge)
                completionHandler(receiveChallenge.0, receiveChallenge.1)
            } else if let delegate = self[task] {
                delegate.urlSession(session, task: task, didReceive: challenge, completionHandler: completionHandler)
            } else {
                urlSession(session, didReceive: challenge, completionHandler: completionHandler)
            }
        }
        
        public func urlSession(_ session: URLSession, task: URLSessionTask, needNewBodyStream completionHandler: (@escaping (InputStream?) -> Void)) {
            if taskNeedNewBodyStream != nil {
                completionHandler(taskNeedNewBodyStream!(session, task))
            } else if let delegate = self[task] {
                delegate.urlSession(session, task: task, needNewBodyStream: completionHandler)
            }
        }
        
        public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            if taskDidSendBodyData != nil {
                taskDidSendBodyData!(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
            } else if let delegate = self[task] as? Request.UploadTaskDelegate {
                delegate.URLSession(session, task: task, didSendBodyData: bytesSent, totalBytesSent: totalBytesSent, totalBytesExpectedToSend: totalBytesExpectedToSend)
            }
        }
        
        public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            if taskDidComplete != nil {
                taskDidComplete!(session, task, error)
            } else if let delegate = self[task] {
                delegate.urlSession(session, task: task, didCompleteWithError: error)
                
                self[task] = nil
            }
        }
        
        // MARK: - NSURLSessionDataDelegate
        
        // MARK: Override Closures
        
        /// Overrides default behavior for NSURLSessionDataDelegate method `URLSession:dataTask:didReceiveResponse:completionHandler:`.
        public var dataTaskDidReceiveResponse: ((Foundation.URLSession, URLSessionDataTask, URLResponse) -> Foundation.URLSession.ResponseDisposition)?
        
        /// Overrides default behavior for NSURLSessionDataDelegate method `URLSession:dataTask:didBecomeDownloadTask:`.
        public var dataTaskDidBecomeDownloadTask: ((Foundation.URLSession, URLSessionDataTask, URLSessionDownloadTask) -> Void)?
        
        /// Overrides default behavior for NSURLSessionDataDelegate method `URLSession:dataTask:didReceiveData:`.
        public var dataTaskDidReceiveData: ((Foundation.URLSession, URLSessionDataTask, Data) -> Void)?
        
        /// Overrides default behavior for NSURLSessionDataDelegate method `URLSession:dataTask:willCacheResponse:completionHandler:`.
        public var dataTaskWillCacheResponse: ((Foundation.URLSession, URLSessionDataTask, CachedURLResponse) -> CachedURLResponse?)?
        
        // MARK: Delegate Methods
        
        public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: (@escaping (Foundation.URLSession.ResponseDisposition) -> Void)) {
            var disposition: Foundation.URLSession.ResponseDisposition = .allow
            
            if dataTaskDidReceiveResponse != nil {
                disposition = dataTaskDidReceiveResponse!(session, dataTask, response)
            }
            
            completionHandler(disposition)
        }
        
       // @available(iOS 8.0, *)
        public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didBecome downloadTask: URLSessionDownloadTask) {
            if dataTaskDidBecomeDownloadTask != nil {
                dataTaskDidBecomeDownloadTask!(session, dataTask, downloadTask)
            } else {
                let downloadDelegate = Request.DownloadTaskDelegate(task: downloadTask)
                self[downloadTask] = downloadDelegate
            }
        }
        
        public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            if dataTaskDidReceiveData != nil {
                dataTaskDidReceiveData!(session, dataTask, data)
            } else if let delegate = self[dataTask] as? Request.DataTaskDelegate {
                delegate.urlSession(session, dataTask: dataTask, didReceive: data)
            }
        }
        
        public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: (@escaping (CachedURLResponse?) -> Void)) {
            if dataTaskWillCacheResponse != nil {
                completionHandler(dataTaskWillCacheResponse!(session, dataTask, proposedResponse))
            } else if let delegate = self[dataTask] as? Request.DataTaskDelegate {
                delegate.urlSession(session, dataTask: dataTask, willCacheResponse: proposedResponse, completionHandler: completionHandler)
            } else {
                completionHandler(proposedResponse)
            }
        }
        
        // MARK: - NSURLSessionDownloadDelegate
        
        // MARK: Override Closures
        
        /// Overrides default behavior for NSURLSessionDownloadDelegate method `URLSession:downloadTask:didFinishDownloadingToURL:`.
        public var downloadTaskDidFinishDownloadingToURL: ((Foundation.URLSession, URLSessionDownloadTask, URL) -> Void)?
        
        /// Overrides default behavior for NSURLSessionDownloadDelegate method `URLSession:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:`.
        public var downloadTaskDidWriteData: ((Foundation.URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
        
        /// Overrides default behavior for NSURLSessionDownloadDelegate method `URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:`.
        public var downloadTaskDidResumeAtOffset: ((Foundation.URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?
        
        // MARK: Delegate Methods
        
        public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            if downloadTaskDidFinishDownloadingToURL != nil {
                downloadTaskDidFinishDownloadingToURL!(session, downloadTask, location)
            } else if let delegate = self[downloadTask] as? Request.DownloadTaskDelegate {
                delegate.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
            }
        }
        
        public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            if downloadTaskDidWriteData != nil {
                downloadTaskDidWriteData!(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
            } else if let delegate = self[downloadTask] as? Request.DownloadTaskDelegate {
                delegate.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
            }
        }
        
        public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
            if downloadTaskDidResumeAtOffset != nil {
                downloadTaskDidResumeAtOffset!(session, downloadTask, fileOffset, expectedTotalBytes)
            } else if let delegate = self[downloadTask] as? Request.DownloadTaskDelegate {
                delegate.urlSession(session, downloadTask: downloadTask, didResumeAtOffset: fileOffset, expectedTotalBytes: expectedTotalBytes)
            }
        }
        
        // MARK: - NSObject
        
        public override func responds(to selector: Selector) -> Bool {
            switch selector {
            case #selector(URLSessionDelegate.urlSession(_:didBecomeInvalidWithError:)):
                return (sessionDidBecomeInvalidWithError != nil)
            case #selector(URLSessionDelegate.urlSession(_:didReceive:completionHandler:)):
                return (sessionDidReceiveChallenge != nil)
            case #selector(URLSessionDelegate.urlSessionDidFinishEvents(forBackgroundURLSession:)):
                return (sessionDidFinishEventsForBackgroundURLSession != nil)
            case #selector(URLSessionTaskDelegate.urlSession(_:task:willPerformHTTPRedirection:newRequest:completionHandler:)):
                return (taskWillPerformHTTPRedirection != nil)
            case #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:completionHandler:)):
                return (dataTaskDidReceiveResponse != nil)
            case #selector(URLSessionDataDelegate.urlSession(_:dataTask:willCacheResponse:completionHandler:)):
                return (dataTaskWillCacheResponse != nil)
            default:
                return type(of: self).instancesRespond(to: selector)
            }
        }
    }
}
