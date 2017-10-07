//
//  Alamofire.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
/// Alamofire errors
public let AlamofireErrorDomain = "com.alamofire.error"

// MARK: - URLStringConvertible

/**
Types adopting the `URLStringConvertible` protocol can be used to construct URL strings, which are then used to construct URL requests.
*/
public protocol URLStringConvertible {
    /**
    A URL that conforms to RFC 2396.
    
    Methods accepting a `URLStringConvertible` type parameter parse it according to RFCs 1738 and 1808.
    
    See http://tools.ietf.org/html/rfc2396
    See http://tools.ietf.org/html/rfc1738
    See http://tools.ietf.org/html/rfc1808
    */
    var URLString: String { get }
}

extension String: URLStringConvertible {
    public var URLString: String {
        return self
    }
}

extension URL: URLStringConvertible {
    public var URLString: String {
        return absoluteString
    }
}

extension URLComponents: URLStringConvertible {
    public var URLString: String {
        return url!.URLString
    }
}

extension Foundation.URLRequest: URLStringConvertible {
    public var URLString: String {
        return url!.URLString
    }
}

// MARK: - URLRequestConvertible

/**
Types adopting the `URLRequestConvertible` protocol can be used to construct URL requests.
*/
public protocol URLRequestConvertible {
    /// The URL request.
    var URLRequest: Foundation.URLRequest { get }
}

extension Foundation.URLRequest: URLRequestConvertible {
    public var URLRequest: Foundation.URLRequest {
        return self
    }
}

// MARK: - Convenience

extension URLRequest {
    /// Creates an instance with the specified `method`, `urlString` and `headers`.
    ///
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    public init(url: URLConvertible, method: HTTPMethod, headers: HTTPHeaders? = nil) throws {
        let url = try url.asURL()
        
        self.init(url: url)
        
        httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }
    
    func adapt(using adapter: RequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.adapt(self)
    }
}

//func URLRequest(_ method: Method, URLString: URLStringConvertible, headers: [String: String]? = nil) -> NSMutableURLRequest {
//    let mutableURLRequest = NSMutableURLRequest(url: URL(string: URLString.URLString)!)
//    mutableURLRequest.httpMethod = method.rawValue
//    
//    if let headers = headers {
//        for (headerField, headerValue) in headers {
//            mutableURLRequest.setValue(headerValue, forHTTPHeaderField: headerField)
//        }
//    }
//    
//    return mutableURLRequest
//}

// MARK: - Request Methods

/**
Creates a request using the shared manager instance for the specified method, URL string, parameters, and parameter encoding.

:param: method The HTTP method.
:param: URLString The URL string.
:param: parameters The parameters. `nil` by default.
:param: encoding The parameter encoding. `.URL` by default.

:returns: The created request.
*/

@available(iOS 8.0, *)
public func request(_ method: Method, URLString: URLStringConvertible, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = .url) -> Request {
    return Manager.sharedInstance.request(method, URLString, parameters: parameters, encoding: encoding)
}

/**
Creates a request using the shared manager instance for the specified URL request.

If `startRequestsImmediately` is `true`, the request will have `resume()` called before being returned.

:param: URLRequest The URL request

:returns: The created request.
*/
@available(iOS 8.0, *)
public func request(_ URLRequest: URLRequestConvertible) -> Request {
    return Manager.sharedInstance.request(URLRequest.URLRequest)
}

// MARK: - Upload Methods

// MARK: File

/**
Creates an upload request using the shared manager instance for the specified method, URL string, and file.

:param: method The HTTP method.
:param: URLString The URL string.
:param: file The file to upload.

:returns: The crea@available(iOS 8.0, *)
ted upload request.
*/
@available(iOS 8.0, *)
public func upload(_ method: Method, URLString: URLStringConvertible, file: URL) -> Request {
    return Manager.sharedInstance.upload(method, URLString, file: file)
}

/**
Creates an upload request using the shared manager instance for the specified URL request and file.

:param: URLRequest The URL request.
:param: file The file to upload.

:returns: The crea@available(iOS 8.0, *)
@available(iOS 8.0, *)
@available(iOS 8.0, *)
@available(iOS 8.0, *)
@available(iOS 8.0, *)
@available(iOS 8.0, *)
@available(iOS 8.0, *)
ted upload request.
*/
@available(iOS 8.0, *)
public func upload(_ URLRequest: URLRequestConvertible, file: URL) -> Request {
    return Manager.sharedInstance.upload(URLRequest, file: file)
}

// MARK: Data

/**
Creates an upload request using the shared manager instance for the specified method, URL string, and data.

:param: method The HTTP method.
:param: URLString The URL string.
:param: data The data to upload.

:returns: The crea@available(iOS 8.0, *)
ted upload request.
*/
@available(iOS 8.0, *)
public func upload(_ method: Method, URLString: URLStringConvertible, data: Data) -> Request {
    return Manager.sharedInstance.upload(method, URLString, data: data)
}

/**
Creates an upload request using the shared manager instance for the specified URL request and data.

:param: URLRequest The URL request.
:param: data The data to upload.

:returns: The created upload request.
*/
@available(iOS 8.0, *)
public func upload(_ URLRequest: URLRequestConvertible, data: Data) -> Request {
    return Manager.sharedInstance.upload(URLRequest, data: data)
}

// MARK: Stream

/**
Creates an upload request using the shared manager instance for the specified method, URL string, and stream.

:param: method The HTTP method.
:param: URLString The URL string.
:param: stream The stream to upload.

:returns: The created upload request.
*/
@available(iOS 8.0, *)
public func upload(_ method: Method, URLString: URLStringConvertible, stream: InputStream) -> Request {
    return Manager.sharedInstance.upload(method, URLString, stream: stream)
}

/**
Creates an upload request using the shared manager instance for the specified URL request and stream.

:param: URLRequest The URL request.
:param: stream The stream to upload.

:returns: The created upload request.
*/
@available(iOS 8.0, *)
public func upload(_ URLRequest: URLRequestConvertible, stream: InputStream) -> Request {
    return Manager.sharedInstance.upload(URLRequest, stream: stream)
}

// MARK: - Download Methods

// MARK: URL Request

/**
Creates a download request using the shared manager instance for the specified method and URL string.

:param: method The HTTP method.
:param: URLString The URL string.
:param: destination The closure used to determine the destination of the downloaded file.

:returns: The created download request.
*/
@available(iOS 8.0, *)
public func download(_ method: Method, URLString: URLStringConvertible, destination: Request.DownloadFileDestination) -> Request {
    return Manager.sharedInstance.download(method, URLString, destination: destination)
}

/**
Creates a download request using the shared manager instance for the specified URL request.

:param: URLRequest The URL request.
:param: destination The closure used to determine the destination of the downloaded file.

:returns: The created download request.
*/
@available(iOS 8.0, *)
public func download(_ URLRequest: URLRequestConvertible, destination: Request.DownloadFileDestination) -> Request {
    return Manager.sharedInstance.download(URLRequest, destination: destination)
}

// MARK: Resume Data

/**
Creates a request using the shared manager instance for downloading from the resume data produced from a previous request cancellation.

:param: resumeData The resume data. This is an opaque data blob produced by `NSURLSessionDownloadTask` when a task is cancelled. See `NSURLSession -downloadTaskWithResumeData:` for additional information.
:param: destination The closure used to determine the destination of the downloaded file.

:returns: The created download request.
*/
@available(iOS 8.0, *)
public func download(resumeData data: Data, destination: Request.DownloadFileDestination) -> Request {
    return Manager.sharedInstance.download(data, destination: destination)
}
