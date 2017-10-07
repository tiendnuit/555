//
//  OAuth1.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Alamofire
#if os(iOS)
    import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

    #else
    import AppKit
#endif


@available(iOS 8.0, *)
open class OAuth1Manager : AuthManager {

    let consumerKey             : String!
    let consumerSecret          : String!
    let requestTokenPath        : String!
    let authorizePath           : String!
    let accessTokenPath         : String!
    let callbackURL             : URL!
    
    let scope                   : String?
    let realm                   : String?
    let signatureMethod         : String?
    
    
    open var authorizeURL : URL? {
        if let key = (self.account as? OAuth1Account)?.requestToken?.key { return URL(string: "\(self.baseURL.absoluteString)/\(self.authorizePath)?oauth_token=\(key)")! }
        return nil
    }
    
    
    lazy var OAuthParameters : [String: AnyObject] = {
        var parameters = [String: AnyObject]()
        parameters["oauth_version"]           = "1.0" as AnyObject
        parameters["oauth_consumer_key"]      = self.consumerKey as AnyObject;
        parameters["oauth_timestamp"]         = String(Int64(Date().timeIntervalSince1970)) as AnyObject
        parameters["oauth_signature_method"]  = "HMAC-SHA1" as AnyObject;
        parameters["oauth_nonce"]             = (UUID().uuidString as NSString).substring(to: 8) as AnyObject
        return parameters
        }()
    
    
    
    
    
    public override init(options: [String : String]) {
        self.consumerKey = options["consumerKey"]
        self.consumerSecret = options["consumerSecret"]
        self.requestTokenPath = options["requestTokenPath"]
        self.authorizePath = options["authorizePath"]
        self.accessTokenPath = options["accessTokenPath"]
        var callbackURL : URL?
        if let url = options["callbackURL"] { callbackURL = URL(string: url) }
        self.callbackURL = callbackURL
        self.scope = options["scope"]
        self.realm = options["realm"]
        self.signatureMethod = options["signatureMethod"]
        super.init(options: options)
        if self.consumerKey == nil { print("consumerKey is missing") }
        if self.consumerSecret == nil { print("consumerSecret is missing") }
        if self.requestTokenPath == nil { print("requestTokenPath is missing") }
        if self.authorizePath == nil { print("authorizePath is missing") }
        if self.accessTokenPath == nil { print("accessTokenPath is missing") }
        if (self.consumerKey == nil || self.consumerSecret == nil || self.requestTokenPath == nil || self.authorizePath == nil || self.accessTokenPath == nil) {
            //return nil
        }
    }
    
    
    public required init(configuration: URLSessionConfiguration?) {
        fatalError("init(configuration:) has not been implemented")
    }
    
    
    fileprivate func OAuth1Signature(_ method: HTTPMethod, _ URLString: String, parameters: [String : AnyObject]) -> String {
        var tokenSecret = "\(self.consumerSecret.urlEncodedStringWithEncoding(String.Encoding.utf8))&"
        if let accessToken = (self.account as? OAuth1Account)?.accessToken { tokenSecret +=  accessToken.secret.urlEncodedStringWithEncoding(String.Encoding.utf8) }
        else if let requestToken = (self.account as? OAuth1Account)?.requestToken { tokenSecret += requestToken.secret.urlEncodedStringWithEncoding(String.Encoding.utf8) }
        
        
        let key = tokenSecret.data(using: String.Encoding.utf8)
        
        
        
        var queryString = ""
        var queryStrings = parameters.urlEncodedQueryStringWithEncoding(String.Encoding.utf8).components(separatedBy: "&") as [String]
        queryStrings.sort { $0 < $1 }
        queryString = queryStrings.joined(separator: "&")
        
        queryString = queryString.urlEncodedStringWithEncoding(String.Encoding.utf8)
        let encodedURL = self.baseURL.appendingPathComponent(URLString).absoluteString.urlEncodedStringWithEncoding(String.Encoding.utf8)
        
        let message = "\(method.rawValue)&\(encodedURL)&\(queryString)".data(using: String.Encoding.utf8) //base signature
        
        let sha1 = HMAC.sha1(key: key!, message: message!)
        
        return sha1!.base64EncodedString(options: [])
    }
    
    
    fileprivate func OAuth1AuthorizationHeader(_ method: HTTPMethod, _ URLString: String, parameters: [String : AnyObject]?) -> String {
        var authorizationParameters = self.OAuthParameters
        var result = ""
        var query = ""
        if let params = parameters {
            for (key,value) in params {
                
                //if key.hasPrefix("oauth_") {
                authorizationParameters[key] = value
                //}
                
                
            }
        }
        if let token = (self.account as? OAuth1Account)?.accessToken { authorizationParameters["oauth_token"] = token.key as AnyObject }
        authorizationParameters["oauth_signature"] = self.OAuth1Signature(method, URLString, parameters: authorizationParameters) as AnyObject
        var parameterComponents = authorizationParameters.urlEncodedQueryStringWithEncoding(String.Encoding.utf8).components(separatedBy: "&") as [String]
        parameterComponents.sort { $0 < $1 }
        var components = [String]()
        for component in parameterComponents {
            let subComponent = component.components(separatedBy: "=") as [String]
            if subComponent.count == 2 { components.append("\(subComponent[0])=\"\(subComponent[1])\"") }
        }
        
        let tmp:NSString  = NSString(format: "%@","OAuth "+components.joined(separator: ", "))
        
        return tmp as String
    }
    
    
    open func upload(_ method: HTTPMethod, _ URLString: String, parameters: [String : AnyObject]?, data: Data) -> UploadRequest {
        var mutableRequest = try! self.getRequest(method, URLString, parameters: parameters)
        
        mutableRequest.httpMethod = method.rawValue
        let boundaryConstant = "93ufb-2uvn-euvnwjenvrbvi";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        var uploadData = Data()
        
        // add media
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"fieldname\"; filename=\"file.jpg\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: media\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(data)
        // add parameters
        var mutableParameters = [String: AnyObject]()
        if let params = parameters {
            mutableParameters = params
            for (key,value) in params {
                uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
            }
        }
        
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)

        return super.upload(uploadData, to: mutableRequest as! URLConvertible)
    }
//    fileprivate func getRequestUpload(_ method: Method, _ URLString: String, parameters: [String : AnyObject]?, data:Data)-> (URLRequestConvertible,Data) {
//        let mutableRequest = self.getRequest(method, URLString, parameters: parameters)
//        
//        mutableRequest.httpMethod = method.rawValue
//        let boundaryConstant = "93ufb-2uvn-euvnwjenvrbvi";
//        let contentType = "multipart/form-data;boundary="+boundaryConstant
//        mutableRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
//        
//        // create upload data to send
//        let uploadData = NSMutableData()
//        
//        // add media
//        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
//        uploadData.append("Content-Disposition: form-data; name=\"fieldname\"; filename=\"file.jpg\"\r\n".data(using: String.Encoding.utf8)!)
//        uploadData.append("Content-Type: media\r\n\r\n".data(using: String.Encoding.utf8)!)
//        uploadData.append(data)
//        // add parameters
//        var mutableParameters = [String: AnyObject]()
//        if let params = parameters {
//            mutableParameters = params
//            for (key,value) in params {
//                uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
//                uploadData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
//            }
//        }
//        
//        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
//        return (mutableRequest as! URLRequestConvertible,uploadData as Data)
//    }
    
    fileprivate func getRequest(_ method: HTTPMethod, _ URLString: String, parameters: [String : AnyObject]?) throws -> URLRequest {
        var mutableParameters = [String: AnyObject]()
        var query:String! = ""
        if let params = parameters {
            mutableParameters = params
            for (key,value) in params {
                if key.hasPrefix("oauth_") { mutableParameters.removeValue(forKey: key)}
                else{
                    query = key + "=" + (value as! String)
                }
            }
        }
        var temp_url_string = URLString
        if method == .get  && parameters?.count > 0 {
            temp_url_string += "?" + query
        }
        
        
        var mutableRequest = URLRequest(url: self.baseURL.appendingPathComponent(temp_url_string))
        mutableRequest.httpMethod = method.rawValue
        mutableRequest.setValue(self.OAuth1AuthorizationHeader(method, URLString, parameters: parameters), forHTTPHeaderField: "Authorization")
        
        return try URLEncoding.default.encode(mutableRequest, with: parameters)
    }
//    open override func request(_ method: HTTPMethod, _ URLString: String, parameters: [String : AnyObject]?) -> DataRequest {
//
//        return self.request(self.getRequest(method, URLString, parameters: parameters) as URLRequestConvertible)
//    }

}


@available(iOS 8.0, *)
extension OAuth1Manager {
    
    public func requestToken(_ completionHandler: @escaping ((_ account: AuthAccount?, _ error: NSError?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["oauth_callback"] = self.callbackURL as AnyObject
        parameters["scope"] = self.scope as AnyObject
        
        let request = try! self.request(self.getRequest(HTTPMethod.post, self.requestTokenPath, parameters: parameters) as URLRequestConvertible)
        
        request.responseData { (response) in
            if response.error != nil { completionHandler(nil, response.error as! NSError) }
            else if let data = response.data as? Data, let queryString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                let parameters = queryString.parametersFromQueryString()
                if let key = parameters["oauth_token"], let secret = parameters["oauth_token_secret"] {
                    let account = OAuth1Account(manager: self)
                    account.requestToken = OAuth1Token(key: key, secret: secret)
                    self.account = account
                    completionHandler(self.account!, nil)
                } else {
                    let error = NSError(domain: NapErrorDomain, code: NapError.cannotReadOAuth1DataFromQueryString.rawValue, userInfo: nil)
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    
    public func verifierWithURLRequest(_ request:Foundation.URLRequest) -> String? {
        let urlString = "\(String(describing: request.url!.scheme))://\(request.url!.host!)\(request.url!.path)"
        if let parameters = request.url?.query?.parametersFromQueryString(), urlString == self.callbackURL.absoluteString {
            if let _ = parameters["oauth_token"], let verifier = parameters["oauth_verifier"] { return verifier }
        }
        return nil
    }
    
    
    public func accessToken(_ verifier: String, completionHandler:@escaping ((_ account: AuthAccount?, _ error: NSError?)  -> Void)) {
        if let oauth1Account = self.account as? OAuth1Account, let requestToken = oauth1Account.requestToken {
            var parameters = [String: AnyObject]()
            parameters["oauth_token"]    = requestToken.key as AnyObject
            parameters["oauth_verifier"] = verifier as AnyObject
            
            let request = try! self.request(self.getRequest(HTTPMethod.get, self.accessTokenPath, parameters: parameters) as URLRequestConvertible)
            request.responseData { (response) in
                if response.error != nil { completionHandler(nil, response.error! as NSError) }
                else if let data = response.data, let parameterString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    let parameters = (parameterString as String).parametersFromQueryString()
                    if let token = parameters["oauth_token"], let secret = parameters["oauth_token_secret"] {
                        let accessToken = OAuth1Token(key: token, secret: secret)
                        (self.account as? OAuth1Account)?.accessToken = accessToken
                        if let key = self.idKey, let id = parameters[key] { self.account?.userID = id }
                        if let key = self.usernameKey, let username = parameters[key] { self.account?.username = username }
                        completionHandler(self.account, nil)
                    }
                } else {
                    let error = NSError(domain: NapErrorDomain, code: NapError.cannotReadOAuth1DataFromQueryString.rawValue, userInfo: nil)
                    completionHandler(nil, error)
                }
            }
        } else {
            let error : NSError?
          //  completionHandler(account: nil,error: error)
        }
    }
}


public struct OAuth1Token {
    
    public let key    : String
    public let secret : String
    
    public init(key:String, secret:String) {
        self.key = key
        self.secret = secret
    }
}
@available(iOS 8.0, *)
open class OAuth1Account: AuthAccount {
    open var requestToken : OAuth1Token?
    open var accessToken  : OAuth1Token?
}
