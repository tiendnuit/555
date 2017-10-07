//
//  ArtistSearch.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 2/3/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
@available(iOS 8.0, *)
class ArtistSearch:BaseEntity {
    var idArtist:String!
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
class ListArtistSearch: BaseEntity {
    var items:[ArtistSearch]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                             <~ map["records"]
    }
}
