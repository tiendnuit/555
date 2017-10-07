//
//  Type.swift
//  NhacCuaTui
//
//  Created by GRVI on 4/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
class Type: BaseEntity{
    var idtype:Int!
    var nametype:String!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idtype                       <~ map["idtype"]
        nametype                        <~ map["nametype"]

    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        
        
        return super.defineRequestMapping()
    }
}


