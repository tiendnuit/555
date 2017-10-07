//
//  Download.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
@available(iOS 8.0, *)

public protocol URLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func asURL() throws -> URL
}

extension String: URLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `AFError`.
    ///
    /// - throws: An `AFError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw AFError.invalidURL(url: self) }
        return url
    }
}

extension URL: URLConvertible {
    /// Returns self.
    public func asURL() throws -> URL { return self }
}

extension URLComponents: URLConvertible {
    /// Returns a URL if `url` is not nil, otherise throws an `Error`.
    ///
    /// - throws: An `AFError.invalidURL` if `url` is `nil`.
    ///
    /// - returns: A URL or throws an `AFError`.
    public func asURL() throws -> URL {
        guard let url = url else { throw AFError.invalidURL(url: self) }
        return url
    }
}

// MARK: -

///// Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
//public protocol URLRequestConvertible {
//    /// Returns a URL request or throws if an `Error` was encountered.
//    ///
//    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
//    ///
//    /// - returns: A URL request.
//    func asURLRequest() throws -> URLRequest
//}
//
//extension URLRequestConvertible {
//    /// The URL request.
//    public var urlRequest: URLRequest? { return try? asURLRequest() }
//}
//
//extension URLRequest: URLRequestConvertible {
//    /// Returns a URL request or throws if an `Error` was encountered.
//    public func asURLRequest() throws -> URLRequest { return self }
//}

extension Manager {
//    fileprivate enum Downloadable {
//        case request(Foundation.URLRequest)
//        case resumeData(Data)
//    }
//    
//    fileprivate func download(_ downloadable: Downloadable, destination: @escaping Request.DownloadFileDestination) -> Request {
//        var downloadTask: URLSessionDownloadTask!
//        
//        switch downloadable {
//        case .request(let request):
//            queue.sync {
//                downloadTask = self.session.downloadTask(with: request)
//            }
//        case .resumeData(let resumeData):
//            queue.sync {
//                downloadTask = self.session.downloadTask(withResumeData: resumeData)
//            }
//        }
//        
//        let request = Request(session: session, task: downloadTask)
//        if let downloadDelegate = request.delegate as? Request.DownloadTaskDelegate {
//            downloadDelegate.downloadTaskDidFinishDownloadingToURL = { session, downloadTask, URL in
//                return destination(URL, downloadTask.response as! HTTPURLResponse)
//            }
//        }
//        delegate[request.delegate.task] = request.delegate
//        
//        if startRequestsImmediately {
//            request.resume()
//        }
//        
//        return request
//    }
//    
//    // MARK: Request
//    
//    /**
//    Creates a download request using the shared manager instance for the specified method and URL string.
//    
//    - parameter method: The HTTP method.
//    - parameter URLString: The URL string.
//    - parameter destination: The closure used to determine the destination of the downloaded file.
//    
//    - returns: The created download request.
//    */
//    public func download(_ method: Method, _ URLString: URLStringConvertible, destination: Request.DownloadFileDestination) -> Request {
//        let request = URLRequest(
//        return download(URLRequest(method, URLString: URLString), destination: destination)
//    }
//    
//    /**
//    Creates a request for downloading from the specified URL request.
//    
//    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
//    
//    - parameter URLRequest: The URL request
//    - parameter destination: The closure used to determine the destination of the downloaded file.
//    
//    - returns: The created download request.
//    */
//    public func download(_ URLRequest: URLRequestConvertible, destination: Request.DownloadFileDestination) -> Request {
//        return download(.request(URLRequest.URLRequest), destination: destination)
//    }
//    
//    // MARK: Resume Data
//    
//    /**
//    Creates a request for downloading from the resume data produced from a previous request cancellation.
//    
//    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
//    
//    - parameter resumeData: The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask` when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional information.
//    - parameter destination: The closure used to determine the destination of the downloaded file.
//    
//    - returns: The created download request.
//    */
//    public func download(_ resumeData: Data, destination: Request.DownloadFileDestination) -> Request {
//        return download(.resumeData(resumeData), destination: destination)
//    }
    
    // MARK: - Download Request
    // MARK: URL Request
    /// Creates a `DownloadRequest` using the default `SessionManager` to retrieve the contents of the specified `url`,
    /// `method`, `parameters`, `encoding`, `headers` and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// - parameter url:         The URL.
    /// - parameter method:      The HTTP method. `.get` by default.
    /// - parameter parameters:  The parameters. `nil` by default.
    /// - parameter encoding:    The parameter encoding. `URLEncoding.default` by default.
    /// - parameter headers:     The HTTP headers. `nil` by default.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    public func download(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        return SessionManager.default.download(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers,
            to: destination
        )
    }
    
    /// Creates a `DownloadRequest` using the default `SessionManager` to retrieve the contents of a URL based on the
    /// specified `urlRequest` and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// - parameter urlRequest:  The URL request.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    public func download(
        _ urlRequest: URLRequestConvertible,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        return SessionManager.default.download(urlRequest, to: destination)
    }
    
    // MARK: Resume Data
    /// Creates a `DownloadRequest` using the default `SessionManager` from the `resumeData` produced from a
    /// previous request cancellation to retrieve the contents of the original request and save them to the `destination`.
    ///
    /// If `destination` is not specified, the contents will remain in the temporary location determined by the
    /// underlying URL session.
    ///
    /// On the latest release of all the Apple platforms (iOS 10, macOS 10.12, tvOS 10, watchOS 3), `resumeData` is broken
    /// on background URL session configurations. There's an underlying bug in the `resumeData` generation logic where the
    /// data is written incorrectly and will always fail to resume the download. For more information about the bug and
    /// possible workarounds, please refer to the following Stack Overflow post:
    ///
    ///    - http://stackoverflow.com/a/39347461/1342462
    ///
    /// - parameter resumeData:  The resume data. This is an opaque data blob produced by `URLSessionDownloadTask`
    ///                          when a task is cancelled. See `URLSession -downloadTask(withResumeData:)` for additional
    ///                          information.
    /// - parameter destination: The closure used to determine the destination of the downloaded file. `nil` by default.
    ///
    /// - returns: The created `DownloadRequest`.
    @discardableResult
    public func download(
        resumingWith resumeData: Data,
        to destination: DownloadRequest.DownloadFileDestination? = nil)
        -> DownloadRequest
    {
        return SessionManager.default.download(resumingWith: resumeData, to: destination)
    }
}

// MARK: -

extension Request {
    /**
    A closure executed once a request has successfully completed in order to determine where to move the temporary file written to during the download process. The closure takes two arguments: the temporary file URL and the URL response, and returns a single argument: the file URL where the temporary file should be moved.
    */
    //public typealias DownloadFileDestination = (URL, HTTPURLResponse) -> URL
    
    /**
    Creates a download file destination closure which uses the default file manager to move the temporary file to a file URL in the first available directory with the specified search path directory and search path domain mask.
    
    - parameter directory: The search path directory. `.DocumentDirectory` by default.
    - parameter domain: The search path domain mask. `.UserDomainMask` by default.
    
    - returns: A download file destination closure.
    */
//    public class func suggestedDownloadDestination(_ directory: FileManager.SearchPathDirectory = .documentDirectory, domain: FileManager.SearchPathDomainMask = .userDomainMask) -> DownloadFileDestination {
//        
//        return { temporaryURL, response -> URL in
//            if let directoryURL = FileManager.default.urls(for: directory, in: domain)[0] as? URL {
//                return directoryURL.appendingPathComponent(response.suggestedFilename!)
//            }
//            
//            return temporaryURL
//        }
//    }
    
    // MARK: - DownloadTaskDelegate
    
//    class DownloadTaskDelegate: TaskDelegate, URLSessionDownloadDelegate {
//        var downloadTask: URLSessionDownloadTask? { return task as? URLSessionDownloadTask }
//        var downloadProgress: ((Int64, Int64, Int64) -> Void)?
//        
//        var resumeData: Data?
//        override var data: Data? { return resumeData }
//        
//        // MARK: - NSURLSessionDownloadDelegate
//        
//        // MARK: Override Closures
//        
//        var downloadTaskDidFinishDownloadingToURL: ((Foundation.URLSession, URLSessionDownloadTask, URL) -> URL)?
//        var downloadTaskDidWriteData: ((Foundation.URLSession, URLSessionDownloadTask, Int64, Int64, Int64) -> Void)?
//        var downloadTaskDidResumeAtOffset: ((Foundation.URLSession, URLSessionDownloadTask, Int64, Int64) -> Void)?
//        
//        // MARK: Delegate Methods
//        
//        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//            if downloadTaskDidFinishDownloadingToURL != nil {
//                let destination = downloadTaskDidFinishDownloadingToURL!(session, downloadTask, location)
//                var fileManagerError: NSError?
//                
//                do {
//                    try FileManager.default.moveItem(at: location, to: destination)
//                } catch let error as NSError {
//                    fileManagerError = error
//                }
//                
//                if fileManagerError != nil {
//                    error = fileManagerError
//                }
//            }
//        }
//        
//        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//            if downloadTaskDidWriteData != nil {
//                downloadTaskDidWriteData!(session, downloadTask, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
//            } else {
//                progress.totalUnitCount = totalBytesExpectedToWrite
//                progress.completedUnitCount = totalBytesWritten
//                
//                downloadProgress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
//            }
//        }
//        
//        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//            if downloadTaskDidResumeAtOffset != nil {
//                downloadTaskDidResumeAtOffset!(session, downloadTask, fileOffset, expectedTotalBytes)
//            } else {
//                progress.totalUnitCount = expectedTotalBytes
//                progress.completedUnitCount = fileOffset
//            }
//        }
//    }
}
