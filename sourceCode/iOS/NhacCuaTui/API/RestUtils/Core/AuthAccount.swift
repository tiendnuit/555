//
//  Account.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Alamofire
@available(iOS 8.0, *)

@available(iOS 8.0, *)
open class AuthAccount : NSObject {
    
    open unowned let manager  : SessionManager
    open var userID           : String?
    open var username         : String?
    open var userInfo         : [String: AnyObject]?
    
    
    @available(iOS 8.0, *)
    public init(manager: SessionManager) {
        self.manager = manager
    }
}
