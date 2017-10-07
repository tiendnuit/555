//
//  BaseTableViewCellLeft.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

open class BaseTableViewCellLeft: UITableViewCell {
    class var identifier: String { return String.className(self) }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    open override func awakeFromNib() {
    }
    
    open func setup() {
    }
    
    open class func height() -> CGFloat {
        return 48
    }
    
    open func setData(_ data: Any?) {
        self.textLabel?.textColor = UIColor.bubbleLighGrayColor()
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    open func setDataListChoose(_ data: Any?) {
        self.textLabel?.textColor = UIColor.bubbleLighGrayColor()
        self.textLabel?.font = UIFont(name: "Helvetica", size: 14)
        if let menuText = data as? String {
            self.textLabel?.text = menuText
        }
    }
    
    override open func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
    }
    
    // ignore the default handling
    override open func setSelected(_ selected: Bool, animated: Bool) {
    }
}
