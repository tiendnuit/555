//
//  DateFormatterTransform.swift
//  Rest
//
//  Created by Delphinus on 6/7/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation

open class DateFormaterTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String
    
    let dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    open func transformFromJSON(_ value: AnyObject?) -> Date? {
        if let dateString = value as? String {
            return dateFormatter.date(from: dateString)
        }
        return nil
    }
    
    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
