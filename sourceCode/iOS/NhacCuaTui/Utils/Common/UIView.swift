//
//  UIView.swift
//  IMMO
//
//  Created by Nguyễn Hà on 13/12/2015.
//  Copyright © Năm 2015 Nguyễn Hà. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
}

