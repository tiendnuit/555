//
//  BaseService.swift
//  ecoinsystem
//
//  Created by Delphinus on 5/28/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Alamofire

protocol BaseServiceDelegate{
    func didReceieveTokenExpried();
}
@available(iOS 8.0, *)
open class BaseService: NSObject {
    var delegate:BaseServiceDelegate!
    var isShowLoading:Bool! = true
    var service:RestService!

    convenience init(viewController:BaseViewController, isShowLoading:Bool = true) {
        self.init()
        self.isShowLoading = isShowLoading
        self.getSerivce()
    }
    func getSerivce(){
        
        self.service =  RestService(options: AppsSettings.Static.OAUTH1_PARAMETERS)
       
    }
//    func upload<T: Mappable>(api:String,requestEntity:CFile,progress:((Double)->Void)?,success:((T?)->Void)?,failure:((T?,String)->Void)?){
//
//        self.service!.upload(api, requestEntity: requestEntity, data: requestEntity.file_raw_data,
//            progress:{percent -> Void in
//                progress!(percent)
//            },
//            success: { (responseEntity: T?) -> Void in
//                success!(responseEntity)
//                
//            }) { (record, error) -> Void in
//                failure!(record, error)
//        }
//    }
    func request<T: Mappable>(_ api:String!,method:HTTPMethod = HTTPMethod.post,requestEntity:RestEntity,success:((T?)->Void)?,failure:((T?,String)->Void)?){
//        if self.isShowLoading == true {
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                UIProgressHUD.instance.show()
//            })
//            
//        }
        self.service!.request(method,api: api, requestEntity: requestEntity, success: { (responseEntity: T?) -> Void in
            let tmp = responseEntity as! RestEntity

            if tmp.message == "Error" {
                failure!(nil,tmp.message)
             
            }else{
                success!(responseEntity!)
            }
//            if self.isShowLoading == true {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    UIProgressHUD.instance.hide()
//                })
//            }
        }) { (record,error) -> Void in
           
            failure!(record,error)
//            if self.isShowLoading == true {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    UIProgressHUD.instance.hide()
//                })
//               
//            }
        }
    }
}
