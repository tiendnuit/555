//
//  Upload.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation

@available(iOS 8.0, *)
extension Manager {
    fileprivate enum Uploadable {
        case data(Foundation.URLRequest, Foundation.Data)
        case file(Foundation.URLRequest, URL)
        case stream(Foundation.URLRequest, InputStream)
    }
    
    @available(iOS 8.0, *)
    fileprivate func upload(_ uploadable: Uploadable) -> Request {
        var uploadTask: URLSessionUploadTask!
        var HTTPBodyStream: InputStream?
        
        switch uploadable {
        case .data(let request, let data):
            queue.sync {
                uploadTask = self.session.uploadTask(with: request, from: data)
            }
        case .file(let request, let fileURL):
            queue.sync {
                uploadTask = self.session.uploadTask(with: request, fromFile: fileURL)
            }
        case .stream(let request, let stream):
            queue.sync {
                uploadTask = self.session.uploadTask(withStreamedRequest: request)
            }
            
            HTTPBodyStream = stream
        }
        
        let request = Request(session: session, task: uploadTask)
        
        if HTTPBodyStream != nil {
            request.delegate.taskNeedNewBodyStream = { _, _ in
                return HTTPBodyStream
            }
        }
        
        delegate[request.delegate.task] = request.delegate
        
        if startRequestsImmediately {
            request.resume()
        }
        
        return request
    }
    
    // MARK: File
    
    /**
    Creates a request for uploading a file to the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter URLRequest: The URL request
    - parameter file: The file to upload
    
    - returns: The created upload request.
    */
    @available(iOS 8.0, *)
    public func upload(_ URLRequest: URLRequestConvertible, file: URL) -> Request {
        return Manager.sharedInstance.upload(.file(URLRequest.URLRequest as URLRequest, file))
    }
    
    /**
    Creates a request for uploading a file to the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter method: The HTTP method.
    - parameter URLString: The URL string.
    - parameter headers: The HTTP headers. `nil` by default.
    - parameter file: The file to upload.
    
    - returns: The created upload request.
    */
    @available(iOS 8.0, *)
    public func upload(_ method: Method, _ URLString: URLStringConvertible, headers: [String: String]? = nil, file: URL) -> Request {
        let mutableURLRequest = URLRequest(url: method, cachePolicy: URLString, timeoutInterval: headers)
        return upload(mutableURLRequest as! URLRequestConvertible, file: file)
    }
    
    // MARK: Data
    
    /**
    Creates a request for uploading data to the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter URLRequest: The URL request.
    - parameter data: The data to upload.
    
    - returns: The created upload request.
    */
    @available(iOS 8.0, *)
    public func upload(_ URLRequest: URLRequestConvertible, data: Data) -> Request {
        return Manager.sharedInstance.upload(.data(URLRequest.URLRequest as URLRequest, data))
    }
    
    /**
    Creates a request for uploading data to the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter method: The HTTP method.
    - parameter URLString: The URL string.
    - parameter headers: The HTTP headers. `nil` by default.
    - parameter data: The data to upload.
    
    - returns: The created upload request.
    */
    @available(iOS 8.0, *)
    public func upload(_ method: Method, _ URLString: URLStringConvertible, headers: [String: String]? = nil, data: Data) -> Request {
        let mutableURLRequest = URLRequest(url: method, cachePolicy: URLString, timeoutInterval: headers)
        
        return upload(mutableURLRequest as! URLRequestConvertible, data: data)
    }
    
    // MARK: Stream
    
    /**
    Creates a request for uploading a stream to the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter URLRequest: The URL request.
    - parameter stream: The stream to upload.
    
    - returns: The created upload request.
    */
    @available(iOS 8.0, *)
    public func upload(_ URLRequest: URLRequestConvertible, stream: InputStream) -> Request {
        return Manager.sharedInstance.upload(.stream(URLRequest.URLRequest as URLRequest, stream))
    }
    
    /**
    Creates a request for uploading a stream to the specified URL request.
    
    If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.
    
    - parameter method: The HTTP method.
    - parameter URLString: The URL string.
    - parameter headers: The HTTP headers. `nil` by default.
    - parameter stream: The stream to upload.
    
    - returns: The created upload request.
    */
    @available(iOS 8.0, *)
    public func upload(_ method: Method, _ URLString: URLStringConvertible, headers: [String: String]? = nil, stream: InputStream) -> Request {
        let mutableURLRequest = URLRequest(url: method, cachePolicy: URLString, timeoutInterval: headers)
        
        return upload(mutableURLRequest as! URLRequestConvertible, stream: stream)
    }
}

// MARK: -

extension Request {
    
    // MARK: - UploadTaskDelegate
    
    class UploadTaskDelegate: DataTaskDelegate {
        var uploadTask: URLSessionUploadTask? { return task as? URLSessionUploadTask }
        var uploadProgress: ((Int64, Int64, Int64) -> Void)!
        
        // MARK: - NSURLSessionTaskDelegate
        
        // MARK: Override Closures
        
        var taskDidSendBodyData: ((Foundation.URLSession, URLSessionTask, Int64, Int64, Int64) -> Void)?
        
        // MARK: Delegate Methods
        
        func URLSession(_ session: Foundation.URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
            if taskDidSendBodyData != nil {
                taskDidSendBodyData!(session, task, bytesSent, totalBytesSent, totalBytesExpectedToSend)
            } else {
                progress.totalUnitCount = totalBytesExpectedToSend
                progress.completedUnitCount = totalBytesSent
                
                uploadProgress?(bytesSent, totalBytesSent, totalBytesExpectedToSend)
            }
        }
    }
}
