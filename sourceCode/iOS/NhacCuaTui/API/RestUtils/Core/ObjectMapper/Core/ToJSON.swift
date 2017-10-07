//
//  ToJSON.swift
//  Rest
//
//  Created by Delphinus on 6/7/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import class Foundation.NSNumber

private func setValue(_ value: AnyObject, forKey key: String, dictionary: inout [String : AnyObject]) {
    return setValue(value, forKeyPathComponents: ArraySlice(key.characters.split { $0 == "." }.map { String($0) }), dictionary: &dictionary)
}

private func setValue(_ value: AnyObject, forKeyPathComponents components: ArraySlice<String>, dictionary: inout [String : AnyObject]) {
    if components.isEmpty {
        return
    }
    
    let head = components.first!
    
    if components.count == 1 {
        return dictionary[head] = value
    } else {
        var child = dictionary[head] as? [String : AnyObject]
        if child == nil {
            child = [:]
        }
        
        let tail = components.dropFirst()
        setValue(value, forKeyPathComponents: tail, dictionary: &child!)
        
        return dictionary[head] = child as AnyObject
    }
}

internal final class ToJSON {
    
    class func basicType<N>(_ field: N, key: String, dictionary: inout [String : AnyObject]) {
        func _setValue(_ value: AnyObject) {
            setValue(value, forKey: key, dictionary: &dictionary)
        }
        
        switch field {
            // basic Types
        case let x as NSNumber:
            _setValue(x)
        case let x as Bool:
            _setValue(x as AnyObject)
        case let x as Int:
            _setValue(x as AnyObject)
        case let x as Double:
            _setValue(x as AnyObject)
        case let x as Float:
            _setValue(x as AnyObject)
        case let x as String:
            _setValue(x as AnyObject)
            
            // Arrays with basic types
        case let x as Array<NSNumber>:
            _setValue(x as AnyObject)
        case let x as Array<Bool>:
            _setValue(x as AnyObject)
        case let x as Array<Int>:
            _setValue(x as AnyObject)
        case let x as Array<Double>:
            _setValue(x as AnyObject)
        case let x as Array<Float>:
            _setValue(x as AnyObject)
        case let x as Array<String>:
            _setValue(x as AnyObject)
        case let x as Array<AnyObject>:
            _setValue(x as AnyObject)
            
            // Dictionaries with basic types
        case let x as Dictionary<String, NSNumber>:
            _setValue(x as AnyObject)
        case let x as Dictionary<String, Bool>:
            _setValue(x as AnyObject)
        case let x as Dictionary<String, Int>:
            _setValue(x as AnyObject)
        case let x as Dictionary<String, Double>:
            _setValue(x as AnyObject)
        case let x as Dictionary<String, Float>:
            _setValue(x as AnyObject)
        case let x as Dictionary<String, String>:
            _setValue(x as AnyObject)
        case let x as Dictionary<String, AnyObject>:
            _setValue(x as AnyObject)
        default:
            //println("Default")
            return
        }
    }
    
    class func optionalBasicType<N>(_ field: N?, key: String, dictionary: inout [String : AnyObject]) {
        if let field = field {
            basicType(field, key: key, dictionary: &dictionary)
        }
    }
    
    class func object<N: Mappable>(_ field: N, key: String, dictionary: inout [String : AnyObject]) {
        setValue(Mapper().toJSON(field) as AnyObject, forKey: key, dictionary: &dictionary)
    }
    
    class func optionalObject<N: Mappable>(_ field: N?, key: String, dictionary: inout [String : AnyObject]) {
        if let field = field {
            object(field, key: key, dictionary: &dictionary)
        }
    }
    
    class func objectArray<N: Mappable>(_ field: Array<N>, key: String, dictionary: inout [String : AnyObject]) {
        let JSONObjects = Mapper().toJSONArray(field)
        
        if !JSONObjects.isEmpty {
            setValue(JSONObjects as AnyObject, forKey: key, dictionary: &dictionary)
        }
    }
    
    class func optionalObjectArray<N: Mappable>(_ field: Array<N>?, key: String, dictionary: inout [String : AnyObject]) {
        if let field = field {
            objectArray(field, key: key, dictionary: &dictionary)
        }
    }
    
    class func objectDictionary<N: Mappable>(_ field: Dictionary<String, N>, key: String, dictionary: inout [String : AnyObject]) {
        let JSONObjects = Mapper().toJSONDictionary(field)
        
        if !JSONObjects.isEmpty {
            setValue(JSONObjects as AnyObject, forKey: key, dictionary: &dictionary)
        }
    }
    
    class func optionalObjectDictionary<N: Mappable>(_ field: Dictionary<String, N>?, key: String, dictionary: inout [String : AnyObject]) {
        if let field = field {
            objectDictionary(field, key: key, dictionary: &dictionary)
        }
    }
    
    class func objectDictionaryOfArrays<N: Mappable>(_ field: Dictionary<String, [N]>, key: String, dictionary: inout [String : AnyObject]) {
        let JSONObjects = Mapper().toJSONDictionaryOfArrays(field)
        
        if !JSONObjects.isEmpty {
            setValue(JSONObjects as AnyObject, forKey: key, dictionary: &dictionary) as AnyObject
        }
    }
    
    class func optionalObjectDictionaryOfArrays<N: Mappable>(_ field: Dictionary<String, [N]>?, key: String, dictionary: inout [String : AnyObject]) {
        if let field = field {
            objectDictionaryOfArrays(field, key: key, dictionary: &dictionary)
        }
    }
}
