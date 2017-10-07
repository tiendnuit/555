//
//  DeviceType.swift
//  Rest
//
//  Created by Delphinus on 6/17/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import UIKit
public struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let MUL_WIDTH            = SCREEN_WIDTH / 568.0
    static let MUL_HEIGHT           = SCREEN_HEIGHT / 320.0
    
    static let MUL_WIDTH_UIVIEW     = SCREEN_WIDTH / 410.0
    static let MUL_HEIGHT_UIVIEW    = SCREEN_HEIGHT / 230.0
}

public struct DeviceType
{
    public static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    public static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    public static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    public static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    public static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
public struct DeviceElementSize{
    public static let HEIGHT_OF_NAVIGATON_BAR:CGFloat                   = 64
    public static let HEIGHT_OF_TABBAR:CGFloat                          = 44
    public static let RATIO:CGFloat                                     = 2.0

}
