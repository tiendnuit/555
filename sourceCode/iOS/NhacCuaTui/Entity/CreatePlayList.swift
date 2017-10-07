//
//  CreatePlayList.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/30/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
class CreatePlayList:BaseEntity {
    var mSuccess: String!
    var mErrorField:String!
    var mMessage:String!
    var namePlayList: String!
    var idUser: String!
    var idUserPlaylist: String!
    var idPlayList: String!
    var idSong: String!
    
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        mSuccess                      <~ map["mSuccess"]
        mErrorField                   <~ map["mErrorField"]
        mMessage                      <~ map["mMessage"]

    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        if self.namePlayList != nil             {self.addQuery(["playlist":self.namePlayList])}
        if self.idUser != nil                   {self.addQuery(["id":self.idUser])}
        if self.idPlayList != nil               {self.addQuery(["idplaylist":self.idPlayList])}
        if self.idSong != nil                   {self.addQuery(["idsong":self.idSong])}
        if self.idUserPlaylist != nil           {self.addQuery(["iduser":self.idUserPlaylist])}
        return super.defineRequestMapping()
    }
    
}
//@available(iOS 8.0, *)
//class ListPlayList: BaseEntity {
//    var items:[PlayList]!
//    override func defineResponseMapping(map: Map) {
//        super.defineResponseMapping(map)
//        items                             <~ map["records"]
//    }
//}
