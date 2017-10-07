//
//  Validation.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
extension Request {
    
    /**
    A closure used to validate a request that takes a URL request and URL response, and returns whether the request was valid.
    */
    public typealias Validation = (Foundation.URLRequest, HTTPURLResponse) -> Bool
    
    /**
    Validates the request, using the specified closure.
    
    If validation fails, subsequent calls to response handlers will have an associated error.
    
    :param: validation A closure to validate the request.
    
    :returns: The request.
    */
    public func validate(_ validation: @escaping Validation) -> Self {
        delegate.queue.addOperation {
            if self.response != nil && self.delegate.error == nil {
                if !validation(self.request, self.response!) {
                    self.delegate.error = NSError(domain: AlamofireErrorDomain, code: -1, userInfo: nil)
                }
            }
        }
        
        return self
    }
    
    // MARK: - Status Code
    
    /**
    Validates that the response has a status code in the specified range.
    
    If validation fails, subsequent calls to response handlers will have an associated error.
    
    :param: range The range of acceptable status codes.
    
    :returns: The request.
    */
    public func validate<S : Sequence>(statusCode acceptableStatusCode: S) -> Self where S.Iterator.Element == Int {
        return validate { _, response in
            return acceptableStatusCode.contains(response.statusCode)
        }
    }
    
    // MARK: - Content-Type
    
    fileprivate struct MIMEType {
        let type: String
        let subtype: String
        
        init?(_ string: String) {
            let components = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).substring(to: string.range(of: ";")?.upperBound ?? string.endIndex).components(separatedBy: "/")
            
            if let type = components.first,
                let subtype = components.last
            {
                self.type = type
                self.subtype = subtype
            } else {
                return nil
            }
        }
        
        func matches(_ MIME: MIMEType) -> Bool {
            switch (type, subtype) {
            case (MIME.type, MIME.subtype), (MIME.type, "*"), ("*", MIME.subtype), ("*", "*"):
                return true
            default:
                return false
            }
        }
    }
    
    /**
    Validates that the response has a content type in the specified array.
    
    If validation fails, subsequent calls to response handlers will have an associated error.
    
    :param: contentType The acceptable content types, which may specify wildcard types and/or subtypes.
    
    :returns: The request.
    */
    public func validate<S : Sequence>(contentType acceptableContentTypes: S) -> Self where S.Iterator.Element == String {
        return validate { _, response in
            if let responseContentType = response.mimeType,
                let responseMIMEType = MIMEType(responseContentType)
            {
                for contentType in acceptableContentTypes {
                    if let acceptableMIMEType = MIMEType(contentType), acceptableMIMEType.matches(responseMIMEType)
                    {
                        return true
                    }
                }
            }
            
            return false
        }
    }
    
    // MARK: - Automatic
    
    /**
    Validates that the response has a status code in the default acceptable range of 200...299, and that the content type matches any specified in the Accept HTTP header field.
    
    If validation fails, subsequent calls to response handlers will have an associated error.
    
    :returns: The request.
    */
    public func validate() -> Self {
        let acceptableStatusCodes: CountableRange<Int> = 200..<300
        let acceptableContentTypes: [String] = {
            if let accept = self.request.value(forHTTPHeaderField: "Accept") {
                return accept.components(separatedBy: ",")
            }
            
            return ["*/*"]
            }()
        
        return validate(statusCode: acceptableStatusCodes).validate(contentType: acceptableContentTypes)
    }
}
