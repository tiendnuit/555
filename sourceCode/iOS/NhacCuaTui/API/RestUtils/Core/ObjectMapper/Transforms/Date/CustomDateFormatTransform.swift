//
//  CustomDateFormatTransform.swift
//  Rest
//
//  Created by Delphinus on 6/7/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import Foundation

open class CustomDateFormatTransform: DateFormaterTransform {
    
    public init(formatString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = formatString
        
        super.init(dateFormatter: formatter)
    }
}
