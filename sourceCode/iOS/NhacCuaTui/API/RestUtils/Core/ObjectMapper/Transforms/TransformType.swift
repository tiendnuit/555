//
//  TransformType.swift
//  Rest
//
//  Created by Delphinus on 6/7/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
public protocol TransformType {
    associatedtype Object
    associatedtype JSON
    
    func transformFromJSON(_ value: AnyObject?) -> Object?
    func transformToJSON(_ value: Object?) -> JSON?
}
