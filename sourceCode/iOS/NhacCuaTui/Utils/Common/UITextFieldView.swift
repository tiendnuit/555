//
//  UITextFieldView.swift
//  ecoinsystem
//
//  Created by Delphinus on 5/12/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UITextFieldView:UITextField{
    @IBInspectable var color:UIColor = UIColor.black {
        didSet{
            self.setNeedsDisplay()
        }
    }
    @IBInspectable var holderExtra:String!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    override var placeholder:String!{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var underline:Bool! = true{
        didSet{
            self.setNeedsDisplay()
        }
    }
    var btnLeftView:UIButton!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initComponent()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initComponent()
        
    }
    func initComponent(){
        self.backgroundColor = UIColor.clear
        self.contentMode = .redraw
        self.font = UIFont.font56Italic(13)
        self.textColor = color
        initLeftView()
    }
    func initLeftView(){
        btnLeftView = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = btnLeftView
    }
    override func draw(_ rect: CGRect) {
        let box = CGRect(x: 0,y: self.bounds.height - 1.0,width: self.bounds.width,height: 1.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        func draw_rect(_ color: CGColor) {
            ctx?.beginPath()
            ctx?.move(to: CGPoint(x: box.midX, y: box.midY))
            ctx?.setFillColor(color)
            
            ctx?.addRect(box)
            
            ctx?.closePath()
            ctx?.fillPath()
            
        }
        
        if self.underline == true { draw_rect(color.cgColor)}
        
    }
    

    override func drawPlaceholder(in rect: CGRect) {
        let holderOne:String! = self.placeholder!
        let attributesOne: NSDictionary = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: UIFont.font56Italic(13)
        ]
        holderOne.draw(in: CGRect(x: 0, y: rect.height*0.15, width: rect.width, height: rect.height), withAttributes: attributesOne as? [String : AnyObject])
        let sizeOne:CGSize = holderOne.size(attributes: attributesOne as? [String : AnyObject])
        
        let attributesTwo: NSDictionary = [
            NSForegroundColorAttributeName: color,
            NSFontAttributeName: UIFont.font56Italic(13)
        ]
       
        if holderExtra != nil {
            holderExtra.draw(in: CGRect(x: sizeOne.width, y: rect.height * 0.3 , width: rect.width - sizeOne.width, height: rect.height), withAttributes: attributesTwo as? [String : AnyObject])
        }
    }
      
}
