//
//  UITextFieldSearch.swift
//  ecoinsystem
//
//  Created by Delphinus on 6/25/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import UIKit

class UITextFieldSearch: UITextFieldView {
    override init(frame: CGRect) {
        super.init(frame: frame);
        initComponent()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initComponent()
    }
    override func initComponent() {
        super.initComponent()
//        let btnClear = self.valueForKey("_clearButton") as! UIButton;
//        btnClear.setImage(UIImage(named: "nav_cancel.png"), forState: UIControlState.Normal);
        self.clearButtonMode = UITextFieldViewMode.whileEditing;
        self.returnKeyType = UIReturnKeyType.search
        self.tintColor = UIColor.mainAppColor()
    }
    override func initLeftView() {
        btnLeftView = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30));
        btnLeftView.setImage(UIImage(named: "ic_searchclick.png"), for: UIControlState());
        btnLeftView.imageEdgeInsets = UIEdgeInsetsMake(8,10, 8, 6);
        
        self.leftView = btnLeftView
        self.leftViewMode = UITextFieldViewMode.always;
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 30, y: 0, width: bounds.width - 50, height: bounds.height).offsetBy(dx: 0, dy: 3)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return self.editingRect(forBounds: bounds)
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        var holderOne:String! = self.placeholder!
        let attributesOne: NSDictionary = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: UIFont.font56Italic(13)
        ]
//        if CGFloat(holderOne.characters.count) > 20 * ScreenSize.MUL_WIDTH {
//            holderOne = holderOne.substringWithRange(Range(start: holderOne.startIndex, end: holderOne.startIndex.advancedBy(20))) + "..."
//        }
        holderOne.draw(in: CGRect(x: 0, y: rect.height*0.25, width: rect.width, height: rect.height), withAttributes: attributesOne as? [String : AnyObject])
        let sizeOne:CGSize = holderOne.size(attributes: attributesOne as? [String : AnyObject])
        
        let attributesTwo: NSDictionary = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: UIFont.font56Italic(13)
        ]
        
        if holderExtra != nil {
            holderExtra.draw(in: CGRect(x: sizeOne.width, y: rect.height * 0.3 , width: rect.width - sizeOne.width, height: rect.height), withAttributes: attributesTwo as? [String : AnyObject] )
        }
    }

}
