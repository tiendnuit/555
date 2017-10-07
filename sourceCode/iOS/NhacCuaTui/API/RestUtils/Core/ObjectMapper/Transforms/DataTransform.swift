//
//  DataTransform.swift
//  ecoinsystem
//
//  Created by Delphinus on 8/17/15.
//
//

import Foundation

open class DataBase64Transform: TransformType {
    public typealias Object = Data
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: AnyObject?) -> Data? {
        if let data = value as? String {
            return Data(base64Encoded: data, options:NSData.Base64DecodingOptions())
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Data?) -> String? {
        if let data = value {
            return data.base64Encoded
        }
        return nil
    }
}
open class DataUtf8Transform: TransformType {
    public typealias Object = Data
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: AnyObject?) -> Data? {
        if let data = value as? String {
            return Data(base64Encoded: data, options:NSData.Base64DecodingOptions())
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: Data?) -> String? {
        if let data = value {
            return data.base64Encoded
        }
        return nil
    }
}
extension Data {
    var utf8Decoded:String {
        return NSString(data: self, encoding: String.Encoding.utf8.rawValue) as? String ?? ""
    }
    
    var base64Encoded : String {
        return self.base64EncodedString(options: NSData.Base64EncodingOptions()) ?? ""
    }
    
    
    
}
