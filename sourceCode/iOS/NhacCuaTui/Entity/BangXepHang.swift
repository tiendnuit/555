//
//  BangXepHang.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/25/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
class BangXepHang:BaseEntity {
    var listSong: [Song]!
    var listPlayList: [PlayList]!
    var listVideo: [VideoVideo]!
    var listArtistSearch: [ArtistSearch]!
    var idCountry: String!
    var keySearch: String!
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        listSong                       <~ map["Song"]
        listPlayList                   <~ map["Playlist"]
        listVideo                      <~ map["Video"]
        listArtistSearch               <~ map["Artist"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.idCountry != nil    {self.addQuery(["id":self.idCountry])}
        if self.keySearch != nil    {self.addQuery(["key":self.keySearch])}
        return super.defineRequestMapping()
    }
}
//@available(iOS 8.0, *)
//class ListChuDe: BaseEntity {
//    var items:[ChuDe]!
//    override func defineResponseMapping(map: Map) {
//        super.defineResponseMapping(map)
//        items                             <~ map["records"]
//    }
//}
