//
//  TransformOf.swift
//  Rest
//
//  Created by Delphinus on 6/7/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
open class TransformOf<ObjectType, JSONType>: TransformType {
    public typealias Object = ObjectType
    public typealias JSON = JSONType
    
    fileprivate let fromJSON: (JSONType?) -> ObjectType?
    fileprivate let toJSON: (ObjectType?) -> JSONType?
    
    public init(fromJSON: @escaping (JSONType?) -> ObjectType?, toJSON: @escaping (ObjectType?) -> JSONType?) {
        self.fromJSON = fromJSON
        self.toJSON = toJSON
    }
    
    open func transformFromJSON(_ value: AnyObject?) -> ObjectType? {
        return fromJSON(value as? JSONType)
    }
    
    open func transformToJSON(_ value: ObjectType?) -> JSONType? {
        return toJSON(value)
    }
}
