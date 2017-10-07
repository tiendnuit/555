//
//  LoginUser.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/30/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit
class LoginUser: BaseEntity {
    var idUser: Int!
    var email:String!
    var firstname:String!
    var emailUser: String!
    var firstnameUser: String!
    var lastname: String!
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idUser                      <~ map["records.id"]
        email                       <~ map["records.email"]
        firstname                   <~ map["records.firstname"]
        
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.emailUser != nil                  {self.addQuery(["email":self.emailUser])}
        if self.firstnameUser != nil              {self.addQuery(["firstname":self.firstnameUser])}
        if self.lastname != nil                   {self.addQuery(["lastname":self.lastname])}
        return super.defineRequestMapping()
    }
}
