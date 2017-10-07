//
//  Constants.swift
//  Rest
//
//  Created by Delphinus on 6/5/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
public let NapErrorDomain = "nap.error"


public enum NapError : Int {
    case cannotReadOAuth1DataFromQueryString  = 1001
}


@available(iOS 8.0, *)
public protocol LoginViewControllerProtocol {
    func setManager(_ manager:AuthManager)
}
