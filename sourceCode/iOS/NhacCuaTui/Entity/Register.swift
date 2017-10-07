//
//  Register.swift
//  NhacCuaTui
//
//  Created by GRVI on 4/1/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
class Register: BaseEntity{
    var username: String!
    var email:String!
    var password:String!
    var id:Int!
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        username                      <~ map["records.username"]
        email                       <~ map["records.email"]
        id                       <~ map["records.id"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.username != nil                  {self.addQuery(["username":self.username])}
        if self.email != nil              {self.addQuery(["email":self.email])}
        if self.password != nil                   {self.addQuery(["password":self.password])}
        return super.defineRequestMapping()
    }

}
