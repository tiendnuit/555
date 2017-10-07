//
//  Video.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/11/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
@available(iOS 8.0, *)
class VideoVideo:BaseEntity {
    var idVideo:String!
    var title:String!
    var image:String!
    var counter:String!
    var linkUrl: String?
    var artistname: String!
    var filepath: String!
    var idTypeVideo: String!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idVideo                      <~ map["idvideo"]
        title                        <~ map["namevideo"]
        image                        <~ map["image"]
        counter                      <~ map["counter"]
        linkUrl                      <~ map["linkdrive"]
        artistname                   <~ map["artistname"]
        filepath                     <~ map["filepath"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.idTypeVideo != nil             {self.addQuery(["id":self.idTypeVideo])}
        if self.idVideo != nil {self.addQuery(["id":self.idVideo])}
        return super.defineRequestMapping()
    }
}
@available(iOS 8.0, *)
class ListVideo: BaseEntity {
    var items:[VideoVideo]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                             <~ map["records"]
    }
}
