//
//  BaseUICollectionViewCellPlayList.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

open class BaseUICollectionViewCellPlayList: UICollectionViewCell {
    class var identifier: String { return String.className(self) }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //    override init(style: UICollectionViewCell, reuseIdentifier: String?) {
    //        super.init(style: style, reuseIdentifier: reuseIdentifier)
    //        setup()
    //    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 110 * ScreenSize.MUL_HEIGHT
    }
    
    open func setData(_ data: Any?) {
        self.backgroundColor = UIColor.clear
        //self.textLabel?.font = UIFont.italicSystemFontOfSize(18)
        //        self.textLabel?.textColor = UIColor(hex: "9E9E9E")
        //        if let menuText = data as? String {
        //            self.textLabel?.text = menuText
        //        }
    }
}
