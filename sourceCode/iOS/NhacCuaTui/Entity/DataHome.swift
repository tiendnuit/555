//
//  DataHome.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/17/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
class DataHome:BaseEntity {
    var listPlayList: [PlayList]!
    var listSong: [Song]!
    var listVideo: [VideoVideo]!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
//        listPlayList                      <~ map["idplaylist"]
//        listSong                          <~ map["playlist"]
//        listVideo                         <~ map["image"]
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        
        return super.defineRequestMapping()
    }
}

@available(iOS 8.0, *)
class ListDataHome: BaseEntity {
    var items:[DataHome]!
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        items                        <~ map["Video"]
    }
}
