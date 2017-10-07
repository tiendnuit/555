//
//  AuthManager.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Alamofire

@available(iOS 8.0, *)
public protocol AuthManagerDelegate {
    
    func didCancelAuthentication(_ manager:AuthManager)
    func didFinishAuthentication(_ manager:AuthManager, account:AuthAccount)
}


@available(iOS 8.0, *)
open class AuthManager : SessionManager {
    
    open let baseURL            : URL!
    open var keychainIdentifier : String?
    open var idKey              : String?
    open var usernameKey        : String?
    open var authDelegate       : AuthManagerDelegate?
    open var account            : AuthAccount?
    
    
    public init(baseURL:URL) {
        self.baseURL = baseURL
        super.init(configuration: URLSessionConfiguration.default)
    }
    
    
    public init(options: [String:String]) {
        var url : URL?
        if options["baseURL"] != nil { url = URL(string: options["baseURL"]!) }
        var x = AppsSettings.Static.BASE_URL
        self.baseURL = url
        self.keychainIdentifier = options["keychainIdentifier"]
        self.idKey = options["idKey"]
        self.usernameKey = options["usernameKey"]
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        super.init(configuration: configuration)
        if self.baseURL == nil {
            print("Base URL is missing")
           // return nil
        }
    }
    
    
    public required init(configuration: URLSessionConfiguration?) {
        fatalError("init(configuration:) has not been implemented")
        
    }

//    open override func request(_ method: Method, _ URLString: URLStringConvertible, parameters: [String : AnyObject]?, encoding: ParameterEncoding) -> Request {
//        let url = self.baseURL.appendingPathComponent(URLString.URLString)
//        return super.request(method, url.URLString, parameters: parameters, encoding: encoding)
//    }
}
