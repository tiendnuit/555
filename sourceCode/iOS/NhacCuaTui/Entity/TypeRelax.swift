//
//  TypeRelax.swift
//  NhacCuaTui
//
//  Created by GRVI on 4/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
class TypeRelax: BaseEntity{
    var listType: [Type] = []
        override init(){
            super.init()
            
        }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        listType                       <~ map["records"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        return super.defineRequestMapping()
    }
}
