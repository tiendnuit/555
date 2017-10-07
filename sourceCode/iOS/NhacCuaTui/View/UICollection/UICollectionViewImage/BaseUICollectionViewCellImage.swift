//
//  BaseUICollectionViewCellImage.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

open class BaseUICollectionViewCellImage: UICollectionViewCell {
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
    
    open class func width() -> CGFloat{
        return 80 * ScreenSize.MUL_WIDTH
    }
    open func setData(_ data: Any?) {
        self.backgroundColor = UIColor.clear
            }
}
