//
//  UIColorUtils.swift
//  ecoinsystem
//
//  Created by Delphinus on 8/3/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    
    convenience init(hex: String) {
        self.init(hex: hex, alpha:1)
    }
    
    convenience init(hex: String, alpha: CGFloat) {
        var hexWithoutSymbol = hex
        if hexWithoutSymbol.hasPrefix("#") {
            hexWithoutSymbol = hex.substring(1)
        }
        
        let scanner = Scanner(string: hexWithoutSymbol)
        var hexInt:UInt32 = 0x0
        scanner.scanHexInt32(&hexInt)
        
        var r:UInt32!, g:UInt32!, b:UInt32!
        switch (hexWithoutSymbol.length) {
        case 3: // #RGB
            r = ((hexInt >> 4) & 0xf0 | (hexInt >> 8) & 0x0f)
            g = ((hexInt >> 0) & 0xf0 | (hexInt >> 4) & 0x0f)
            b = ((hexInt << 4) & 0xf0 | hexInt & 0x0f)
            break;
        case 6: // #RRGGBB
            r = (hexInt >> 16) & 0xff
            g = (hexInt >> 8) & 0xff
            b = hexInt & 0xff
            break;
        default:
            // TODO:ERROR
            break;
        }
        
        self.init(
            red: (CGFloat(r)/255),
            green: (CGFloat(g)/255),
            blue: (CGFloat(b)/255),
            alpha:alpha)
    }
    
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
    
//    convenience init(netHex:Int) {
//        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
//    }
    class func bubbleGreenColor() -> UIColor{
        return UIColor(hue: 130.0 / 360.0, saturation: 0.68, brightness: 0.84, alpha: 1.0)
    }
    class func bubbleBlueColor() -> UIColor{
        return UIColor(hue: 210.0 / 360.0, saturation: 0.94, brightness: 1.0, alpha: 1.0)
    }
    class func bubbleRedColor() -> UIColor{
        return UIColor(hue: 0.0 / 360.0, saturation: 0.79, brightness: 1.0, alpha: 1.0)
    }
    class func bubbleLighGrayColor() -> UIColor{
        return UIColor(hue: 240.0 / 360.0, saturation: 0.02, brightness: 0.92, alpha: 1.0)
    }
    class func mainAppColor() -> UIColor{
        return UIColor(red: 190/255.0,green: 42/255.0,blue: 56/255.0,alpha: 1.0)
    }
    class func lightGrayMainAppColor() -> UIColor{
        return UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
    }
    class func grayMainAppColor() -> UIColor{
        return UIColor(red: 161/255.0, green: 161/255.0, blue: 161/255.0, alpha: 1.0)
    }
    
    
}
