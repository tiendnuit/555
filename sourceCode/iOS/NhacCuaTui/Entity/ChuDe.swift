//
//  ChuDe.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/18/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
class ChuDe:BaseEntity {
    var idsubject:Int!
    var descriPtion:String!
    var subname:String!
    var image:String!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idsubject                       <~ map["idsubject"]
        descriPtion                     <~ map["description"]
        image                           <~ map["image"]
        subname                         <~ map["subname"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        
        return super.defineRequestMapping()
    }
}
@available(iOS 8.0, *)
class ListChuDe: BaseEntity {
    var items:[ChuDe]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                             <~ map["records"]
    }
}
