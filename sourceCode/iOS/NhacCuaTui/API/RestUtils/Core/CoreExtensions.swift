 //
//  CoreExtensions.swift
//  Rest
//
//  Created by Delphinus on 6/6/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Alamofire

extension DataRequest {


    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response object (of type Mappable) and any error produced while making the request
    
    :returns: The request.
    */
    public func responseObject<T: Mappable>(_ completionHandler: @escaping (T?, Error?) -> Void) -> Self {
        return responseObject(nil) { (request, response, object, data, error) -> Void in
            completionHandler(object, error)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.
    
    :returns: The request.
    */
    public func responseObject<T: Mappable>(_ completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, T?, AnyObject?, Error?) -> Void) -> Self {
        return responseObject(nil, completionHandler: completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: completionHandler A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response object (of type Mappable), the raw response data, and any error produced making the request.
    
    :returns: The request.
    */
    public func responseObject<T: Mappable>(_ queue: DispatchQueue?, completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, T?, AnyObject?, Error?) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments), completionHandler: { (response) in
            if let _json = response.result.value as? [String: AnyObject]{
                let parsedObject = Mapper<T>().map(_json)
                print("Json: " + String(describing: _json))
                
                (queue ?? DispatchQueue.main).async {
                    completionHandler(response.request!, response.response, parsedObject, response.result.value as AnyObject, response.error)
                }
            }else{
                (queue ?? DispatchQueue.main).async {
                    completionHandler(response.request!, response.response, nil, response.result.value as AnyObject, response.error)
                }
            }
            
        })

    }
    
    // MARK: Array responses
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 2 arguments: the response array (of type Mappable) and any error produced while making the request
    
    :returns: The request.
    */
    public func responseArray<T: Mappable>(_ completionHandler: @escaping ([T]?, Error?) -> Void) -> Self {
        return responseArray(nil) { (request, response, object, data, error) -> Void in
            completionHandler(object, error)
        }
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: completionHandler A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response array (of type Mappable), the raw response data, and any error produced making the request.
    
    :returns: The request.
    */
    public func responseArray<T: Mappable>(_ completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, [T]?, AnyObject?, Error?) -> Void) -> Self {
        return responseArray(nil, completionHandler: completionHandler)
    }
    
    /**
    Adds a handler to be called once the request has finished.
    
    :param: queue The queue on which the completion handler is dispatched.
    :param: completionHandler A closure to be executed once the request has finished and the data has been mapped to a swift Object. The closure takes 5 arguments: the URL request, the URL response, the response array (of type Mappable), the raw response data, and any error produced making the request.
    
    :returns: The request.
    */
    public func responseArray<T: Mappable>(_ queue: DispatchQueue?, completionHandler: @escaping (Foundation.URLRequest, HTTPURLResponse?, [T]?, AnyObject?, Error?) -> Void) -> Self {
        
//        return response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments), completionHandler: { (response) in
//            
//            DispatchQueue.global(qos: .default).async(execute: {
//                
//                //let parsedObject = Mapper<T>().mapArray(response.data)
//                
//                (queue ?? DispatchQueue.main).async {
//                    completionHandler(response.request, response.response, nil, response.data, response.error)
//                }
//            })
//        })
        
        return response(queue: queue, responseSerializer: DataRequest.jsonResponseSerializer(options: .allowFragments), completionHandler: { (response) in
            if let _json = response.result.value as? [String: AnyObject]{
                let parsedObject = Mapper<T>().mapArray(_json as AnyObject)
                print("Json: " + String(describing: response.result.value))
                
                (queue ?? DispatchQueue.main).async {
                    completionHandler(response.request!, response.response, parsedObject, response.data as AnyObject, response.error)
                }
            }else{
                (queue ?? DispatchQueue.main).async {
                    completionHandler(response.request!, response.response, nil, response.data as AnyObject, response.error)
                }
            }
        })
    }
    
}
