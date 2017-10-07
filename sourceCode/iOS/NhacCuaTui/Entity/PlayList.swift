//
//  PlayList.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/11/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
class PlayList:BaseEntity {
    var idType: String!
    var idplaylist:String!
    var title:String!
    var image:String!
    var counter:String!
    var idUser: String!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idplaylist                      <~ map["idplaylist"]
        title                           <~ map["playlist"]
        image                           <~ map["image"]
        counter                         <~ map["counter"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.idType != nil             {self.addQuery(["id":self.idType])}
        if self.idUser != nil             {self.addQuery(["id":self.idUser])}
        if self.idplaylist != nil          {self.addQuery(["id":self.idplaylist])}
        return super.defineRequestMapping()
    }
}
@available(iOS 8.0, *)
class ListPlayList: BaseEntity {
    var items:[PlayList]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                             <~ map["records"]
    }
}

