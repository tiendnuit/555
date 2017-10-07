//
//  Country.swift
//  NhacCuaTui
//
//  Created by GRVI on 4/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
class Country: BaseEntity{
    var idCountry:Int!
    var nameCountry:String!
    var nameCode:String!
    
    override init(){
        super.init()
    }
    
    required init?(_ map: Map) {
        super.init(map)
        self.defineResponseMapping(map)
    }
    
    override func defineResponseMapping(_ map: Map) {
        super.defineResponseMapping(map)
        idCountry                       <~ map["idcountry"]
        nameCountry                        <~ map["name"]
        nameCode                                <~ map["code"]
        
    }
    
    override func defineRequestMapping() -> [String : AnyObject]? {
        
        
        return super.defineRequestMapping()
    }

}
