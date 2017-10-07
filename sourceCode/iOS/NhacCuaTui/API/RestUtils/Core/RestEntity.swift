//
//  BaseEntity.swift
//  Rest
//
//  Created by Delphinus on 6/6/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
open class RestEntity:NSObject,Mappable {
    open var status: String!
    open var message: String!
    open var records: String!

    
    open var FilePathUrlImage:String!
    var dicQuery:NSMutableDictionary!
    var rawQuery:NSString!=""
    
    @objc public override init(){
        super.init()
        //initCache()
    }

    public required init?(_ map: Map) {
        super.init()
        defineMapping(map)
    }

    
    open func defineMapping(_ map: Map) {
       // initCache()
        defineResponseMapping(map)
    }
    /**
    *   define responseMapping
    */
    
    open func defineResponseMapping (_ map: Map) {
       
        status              <~ map["status"]
        message             <~ map["message"]
        records             <~ map["records"]

    }

    /*
    *   add query
    */
    open func addQuery(_ keyPathToAttributeNames:NSDictionary){
        if dicQuery == nil { dicQuery = NSMutableDictionary()}
        self.dicQuery.addEntries(from: keyPathToAttributeNames as! [AnyHashable: Any])
    }
    /*
    *   compile query
    */
    fileprivate func complieQuery(){
        if self.dicQuery != nil {
            var jsonData: Data?
            do {
                jsonData = try JSONSerialization.data(withJSONObject: self.dicQuery, options: JSONSerialization.WritingOptions())
                self.rawQuery = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)
            } catch{
                jsonData = nil
            }
            
        }
        
    }
    /*
    *   define request
    */
    open func defineRequestMapping()->[String : AnyObject]?{
        self.complieQuery()
        return self.rawQuery.length > 0 ? ["q":self.rawQuery ] : nil
        let x = self.rawQuery
        print(self.rawQuery)
    }
}
