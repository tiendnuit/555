//
//  BaseEntity.swift
//  ecoinsystem
//
//  Created by Delphinus on 5/23/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
@available(iOS 8.0, *)
class BaseEntity: RestEntity {

    override init() {
        super.init();
    }

    required init?(_ map: Map) {
        super.init(map)
    }

    override func defineRequestMapping() -> [String : AnyObject]? {

        return super.defineRequestMapping()
    }
   
}