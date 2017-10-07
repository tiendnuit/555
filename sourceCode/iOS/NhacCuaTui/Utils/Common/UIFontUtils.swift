//
//  UIFontUtils.swift
//  ecoinsystem
//
//  Created by Delphinus on 8/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import UIKit
extension UIFont{
    class func font45Light(_ size:CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeueLTStd-Lt", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font46LightItalic(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-LtIt", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font55Roman(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-Roman", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font65Medium(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-Md", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font86HeavyItalic(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-HvIt", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font35Thin(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-Th", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font56Italic(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-It", size: size * ScreenSize.MUL_HEIGHT)!
    }
    class func font66MediumItalic(_ size:CGFloat) ->UIFont {
        return UIFont(name: "HelveticaNeueLTStd-MdIt", size: size * ScreenSize.MUL_HEIGHT)!
    }

}
