//
//  Song.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/11/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
@available(iOS 8.0, *)
class Song:BaseEntity {
    var idSong:String!
    var title:String!
    var image:String!
    var counter:String!
    var linkUrl: String?
    var descriPtion: String!
    var lyric: String!
    var artistname: String!
    var filepath: String!
    var idByPlayList: String!
    var idTypeSong: String!
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idSong                       <~ map["idsong"]
        title                        <~ map["namesong"]
        image                        <~ map["image"]
        counter                      <~ map["counter"]
        linkUrl                      <~ map["linkdrive"]
        descriPtion                  <~ map["description"]
        lyric                        <~ map["lyric"]
        artistname                   <~ map["artistname"]
        filepath                     <~ map["filepath"]
        
        if !image.contains("songs/tb/") {
            image = "songs/tb/" + image
        }
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.idByPlayList != nil           {self.addQuery(["id":self.idByPlayList])}
        if self.idTypeSong != nil             {self.addQuery(["id":self.idTypeSong])}
        if self.idSong != nil                 {self.addQuery(["id":self.idSong])}
        return super.defineRequestMapping()
    }
}
@available(iOS 8.0, *)
class ListSong: BaseEntity {
    var items:[Song]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                             <~ map["records"]
    }
}
