//
//  Artist.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/11/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
@available(iOS 8.0, *)
class Artist:BaseEntity {
    var idArtist:Int!
    var image:String!
    var descriPtion:String!
    var artistname: String!
    var counter: Int!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idArtist                        <~ map["idartist"]
        image                           <~ map["image"]
        descriPtion                     <~ map["description"]
        artistname                      <~ map["artistname"]
        counter                         <~ map["counter"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        
        return super.defineRequestMapping()
    }
}
@available(iOS 8.0, *)
class ListArtist: BaseEntity {
    var items:[Artist]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                             <~ map["records"]
    }
}
