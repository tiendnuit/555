//
//  BaseService.swift
//  Rest
//
//  Created by Delphinus on 6/6/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Alamofire

@available(iOS 8.0, *)
open class RestService:OAuth1Manager{
    
    public override init(options: [String : String]) {
        super.init(options: options)
    }
    
    public required init(configuration: URLSessionConfiguration?) {
        fatalError("init(configuration:) has not been implemented")
    }
    
    /*
    *   upload file
    */
    open func upload<T:Mappable>(_ api:String,requestEntity:RestEntity,data:Data,progressHandler:((Double)->Void)?,success:((T?)->Void)?,failure:((T?,String)->Void)?){
        var url1 = "http://wsdev.betteradvice.com/upload.php"

        super.upload(HTTPMethod.post, api, parameters: requestEntity.defineRequestMapping(), data: data)
            .uploadProgress { progress in // main queue by default
                let percent:Double = ((Double)(progress.completedUnitCount) / (Double)(progress.totalUnitCount))
                progressHandler?(percent)
            }
            .responseObject({ (request, response, responseEntity: T?, JSON, error) in
//                print("> " + Date().description)
//                print(HTTPMethod.post.rawValue + " '" + self.baseURL.appendingPathComponent(api).description + "'")
//                print("request.body=" + (requestEntity.rawQuery as String))
                
                if responseEntity != nil {
                    // print("response.body=" + Mapper<T>().toJSONString(responseEntity!, prettyPrint: true)! as String)
                    let tmp = responseEntity as! RestEntity
                    
                    if error == nil {
                        if tmp.message == nil{
                            failure!(nil,"Error")
                        }else{
                            if tmp.message == "Error"{
                                failure!(responseEntity!,tmp.message)
                            }else{
                                if tmp.message == "Success" {
                                    success!(responseEntity!)
                                }else{
                                    failure!(nil,tmp.message)
                                }
                            }
                        }
                    }else{
                        failure!(nil,error!.localizedDescription)
                    }
                    
                }else{
                    failure!(nil,"NETWORK ERROR")
                }
            })
    }
    
    /*
    *   reponse T class
    */
    
    open func request<T: Mappable>(_ method:HTTPMethod,api:String,requestEntity:RestEntity,success:((T?)->Void)?,failure:((T?,String)->Void)?){
        
        
        let parameters = requestEntity.defineRequestMapping()
        let url = self.baseURL.appendingPathComponent(api)
        _ = super.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseObject { (request, response, responseEntity: T?, JSON, error) in
            print(method.rawValue + " '" + self.baseURL.appendingPathComponent(api).description + "'")
            print("request.body=" + (requestEntity.rawQuery as String))
            
            if responseEntity != nil {
                //print("response.body=" + Mapper<T>().toJSONString(responseEntity!, prettyPrint: true)! as String)
                let tmp = responseEntity as! RestEntity
                
                if error == nil {
                    if tmp.message == nil{
                        failure!(nil,"Error")
                    }else{
                        if tmp.message == "Error"{
                            failure!(responseEntity!,tmp.message)
                        }else{
                            if tmp.message == "Find success!" {
                                success!(responseEntity!)
                            }else{
                                failure!(nil,tmp.message)
                            }
                        }
                    }
                }else{
                    failure!(nil,error!.localizedDescription)
                }
            }else{
                
                failure!(nil,"NETWORK ERROR")
            }
        }
    }
}
