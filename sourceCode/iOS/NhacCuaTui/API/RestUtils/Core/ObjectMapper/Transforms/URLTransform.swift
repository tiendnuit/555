//
//  URLTransform.swift
//  Rest
//
//  Created by Delphinus on 6/7/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation

open class URLTransform: TransformType {
    public typealias Object = URL
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: AnyObject?) -> URL? {
        if let URLString = value as? String {
            return URL(string: URLString)
        }
        return nil
    }
    
    open func transformToJSON(_ value: URL?) -> String? {
        if let URL = value {
            return URL.absoluteString
        }
        return nil
    }
}
