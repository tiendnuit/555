//
//  String.swift
//  IMMO
//
//  Created by Nguyễn Hà on 13/12/2015.
//  Copyright © Năm 2015 Nguyễn Hà. All rights reserved.
//

import Foundation
extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.characters.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.characters.count
    }
    
    
//    var floatValue: CGFloat {
//        return CGFloat((self as NSString).floatValue)
//    }
    
    var utf8Encoded:Data! {
        return data(using: String.Encoding.utf8)
    }
    func stringByTrimingWhitespace() ->String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func stringByTrimingQuote() ->String {
        return self.stringValue.replacingOccurrences(of: "\"", with: "")
    }
    
    
    var stringValue:NSString {
        return NSString(format: "%@", self)
    }
    func toDouble() ->Double {
        return self.stringValue.doubleValue
    }
    //    func toPhone() -> String{
    //        var temp = self.stringByReplacingOccurrencesOfString("+", withString: "")
    //        temp = temp.stringByReplacingOccurrencesOfString("-", withString: "")
    //        temp = temp.stringByReplacingOccurrencesOfString("(", withString: "")
    //        temp = temp.stringByReplacingOccurrencesOfString(")", withString: "")
    //        temp = "".join(temp.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet))
    //        return temp.stringByReplacingOccurrencesOfString(" ", withString: "")
    //    }
    var first:String{
        if self.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            let index: String.Index = self.characters.index(self.startIndex, offsetBy: 1)
            let temp = self.substring(to: index)
            return temp.uppercased()
        }
        return ""
        
    }
//    var base64Decoded : String {
//        
//        let decodedData = NSData(base64EncodedString: self, options:NSDataBase64DecodingOptions())
//        return decodedData!.utf8Decoded
//    }
    func checkRequest() -> Bool {
        return self != ""
    }
    func toDateString() ->String
        
        
    {
        
        let timeinterval : TimeInterval = (self as NSString).doubleValue
        
        let dateFromServer = Date(timeIntervalSince1970:timeinterval)
        
        let dateFormater : DateFormatter = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: dateFromServer)
    }
    
}
