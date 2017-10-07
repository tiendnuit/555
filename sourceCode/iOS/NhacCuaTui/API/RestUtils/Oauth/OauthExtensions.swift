//
//  OauthExtensions.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
extension String {
    
    func urlEncodedStringWithEncoding(_ encoding: String.Encoding) -> String {
        let charactersToBeEscaped = ":/?&=;+!@#$()',*" as CFString
        let charactersToLeaveUnescaped = "[]." as CFString
        let raw: NSString = self as NSString
        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, raw, charactersToLeaveUnescaped, charactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding.rawValue))
        return result as! String
    }
    
    func parametersFromQueryString() -> [String: String] {
        var parameters = [String: String]()
        let scanner = Scanner(string: self)
        var key: NSString?
        var value: NSString?
        while !scanner.isAtEnd {
            key = nil
            scanner.scanUpTo("=", into: &key)
            scanner.scanString("=", into: nil)
            value = nil
            scanner.scanUpTo("&", into: &value)
            scanner.scanString("&", into: nil)
            if (key != nil && value != nil) { parameters.updateValue(value! as String, forKey: key! as String) }
        }
        return parameters
    }
}


extension Dictionary {
    
    func urlEncodedQueryStringWithEncoding(_ encoding: String.Encoding) -> String {
        //        var parts = [String]()
        //        for (key, value) in self {
        //            let keyString = "\(key)".urlEncodedStringWithEncoding(encoding)
        //            let valueString = "\(value)".urlEncodedStringWithEncoding(encoding)
        //            let query = "\(keyString)=\(valueString)" as String
        //            parts.append(query)
        //        }
        //        return "&".join(parts) as String
        var components: [(String, String)] = []
        for (key, value) in self {
            // let value: AnyObject! = parameters[key]
            components += self.queryComponents(key as! String, value as AnyObject)
        }
        
        return (components.map{"\($0)=\($1)"} as [String]).joined(separator: "&")
    }
    func queryComponents(_ key: String, _ value: AnyObject) -> [(String, String)] {
        var components: [(String, String)] = []
        if let dictionary = value as? [String: AnyObject] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [AnyObject] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append(contentsOf: [(escape(key), escape("\(value)"))])
        }
        
        return components
    }
    func escape(_ string: String) -> String {
        let generalDelimiters = ":#[]@?/" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimiters = "!$&'()*+,;="
        
        let legalURLCharactersToBeEscaped: CFString = generalDelimiters + subDelimiters as CFString
        
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
    }
    
    
}


extension NSMutableData {
    internal func appendBytes(_ arrayOfBytes: [UInt8]) {
        self.append(arrayOfBytes, length: arrayOfBytes.count)
    }
    
}


extension Data {
    func bytes() -> [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
    
    static public func withBytes(_ bytes: [UInt8]) -> Data {
        return Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
    }
}


func rotateLeft(_ v:UInt16, n:UInt16) -> UInt16 {
    return ((v << n) & 0xFFFF) | (v >> (16 - n))
}


func rotateLeft(_ v:UInt32, n:UInt32) -> UInt32 {
    return ((v << n) & 0xFFFFFFFF) | (v >> (32 - n))
}


func rotateLeft(_ x:UInt64, n:UInt64) -> UInt64 {
    return (x << n) | (x >> (64 - n))
}


func rotateRight(_ x:UInt16, n:UInt16) -> UInt16 {
    return (x >> n) | (x << (16 - n))
}


func rotateRight(_ x:UInt32, n:UInt32) -> UInt32 {
    return (x >> n) | (x << (32 - n))
}


func rotateRight(_ x:UInt64, n:UInt64) -> UInt64 {
    return ((x >> n) | (x << (64 - n)))
}


func reverseBytes(_ value: UInt32) -> UInt32 {
    let tmp1 = ((value & 0x000000FF) << 24) | ((value & 0x0000FF00) << 8)
    let tmp2 = ((value & 0x00FF0000) >> 8)  | ((value & 0xFF000000) >> 24)
    return tmp1 | tmp2
}


extension Int {
    public func bytes(_ totalBytes: Int = MemoryLayout<Int>.size) -> [UInt8] {
        return arrayOfBytes(self, length: totalBytes)
    }
}


func arrayOfBytes<T>(_ value:T, length:Int? = nil) -> [UInt8] {
    let totalBytes = length ?? MemoryLayout<T>.size
    
    let valuePointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
    valuePointer.pointee = value
    
    let bytesPointer = UnsafeMutablePointer<UInt8>(OpaquePointer(valuePointer))
    var bytes = [UInt8](repeating: 0, count: totalBytes)
    for j in 0..<min(MemoryLayout<T>.size, totalBytes) {
        bytes[totalBytes - 1 - j] = (bytesPointer + j).pointee
    }
    
    valuePointer.deinitialize()
    valuePointer.deallocate(capacity: 1)
    
    return bytes
}
