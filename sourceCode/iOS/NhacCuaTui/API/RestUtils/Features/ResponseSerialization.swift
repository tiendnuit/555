//
//  ResponseSerialization.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
// MARK: String

extension Request {
    /**
    Creates a response serializer that returns a string initialized from the response data with the specified string encoding.
    
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set, ISO-8859-1.
    
    - returns: A string response serializer.
    */
    public class func stringResponseSerializer(_ encoding: String.Encoding? = nil) -> Serializer {
        var encoding = encoding
        return { _, response, data in
            if data == nil || data?.count == 0 {
                return (nil, nil)
            }
            
            if encoding == nil {
                if let encodingName = response?.textEncodingName {
                    encoding = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding(encodingName as CFString)))
                }
            }
            
            let string = NSString(data: data!, encoding: encoding.map { $0.rawValue } ?? String.Encoding.isoLatin1.rawValue)
            
            return (string, nil)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter encoding: The string encoding. If `nil`, the string encoding will be determined from the server response, falling back to the default HTTP default character set, ISO-8859-1.
    - parameter completionHandler: A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the string, if one could be created from the URL response and data, and any error produced while creating the string.
    
    - returns: The request.
    */
    public func responseString(_ encoding: String.Encoding? = nil, completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, String?, NSError?) -> Void) -> Self  {
        return response(serializer: Request.stringResponseSerializer(encoding), completionHandler: { request, response, string, error in
            completionHandler(request, response, string as? String, error)
        })
    }
}

// MARK: - JSON

extension Request {
    /**
    Creates a response serializer that returns a JSON object constructed from the response data using `NSJSONSerialization` with the specified reading options.
    
    - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
    
    - returns: A JSON object response serializer.
    */
    public class func JSONResponseSerializer(_ options: JSONSerialization.ReadingOptions = .allowFragments) -> Serializer {
        return { request, response, data in
            if data == nil || data?.count == 0 {
                return (nil, nil)
            }
            
            var serializationError: NSError?
            let JSON: AnyObject?
            do {
                JSON = try JSONSerialization.jsonObject(with: data!, options: options) as AnyObject
            } catch let error as NSError {
                serializationError = error
                JSON = nil
            } catch {
                fatalError()
            }
            
            return (JSON, serializationError)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter options: The JSON serialization reading options. `.AllowFragments` by default.
    - parameter completionHandler: A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the JSON object, if one could be created from the URL response and data, and any error produced while creating the JSON object.
    
    - returns: The request.
    */
    public func responseJSON(_ options: JSONSerialization.ReadingOptions = .allowFragments, completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, AnyObject?, NSError?) -> Void) -> Self {
        return response(serializer: Request.JSONResponseSerializer(options), completionHandler: { request, response, JSON, error in
            completionHandler(request, response, JSON, error)
        })
    }
}

// MARK: - Property List

extension Request {
    /**
    Creates a response serializer that returns an object constructed from the response data using `NSPropertyListSerialization` with the specified reading options.
    
    - parameter options: The property list reading options. `0` by default.
    
    - returns: A property list object response serializer.
    */
    public class func propertyListResponseSerializer(_ options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions(rawValue: 0)) -> Serializer {
        return { request, response, data in
            if data == nil || data?.count == 0 {
                return (nil, nil)
            }
            
            var propertyListSerializationError: NSError?
            let plist: AnyObject?
            do {
                plist = try PropertyListSerialization.propertyList(from: data!, options: options, format: nil) as AnyObject
            } catch let error as NSError {
                propertyListSerializationError = error
                plist = nil
            } catch {
                fatalError()
            }
            
            return (plist, propertyListSerializationError)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    - parameter options: The property list reading options. `0` by default.
    - parameter completionHandler: A closure to be executed once the request has finished. The closure takes 4 arguments: the URL request, the URL response, if one was received, the property list, if one could be created from the URL response and data, and any error produced while creating the property list.
    
    - returns: The request.
    */
    public func responsePropertyList(_ options: PropertyListSerialization.ReadOptions = PropertyListSerialization.ReadOptions(rawValue: 0), completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, AnyObject?, NSError?) -> Void) -> Self {
        return response(serializer: Request.propertyListResponseSerializer(options), completionHandler: { request, response, plist, error in
            completionHandler(request, response, plist, error)
        })
    }
}
