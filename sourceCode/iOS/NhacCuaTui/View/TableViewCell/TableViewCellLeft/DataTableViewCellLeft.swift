//
//  DataTableViewCellLeft.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
struct DataTableViewCellData {
    init(image_Url: String, text_Title: String , color: String) {
        self.imageUrl = image_Url
        self.textTitle = text_Title
        self.color = color
    }
    
    var imageUrl: String
    var textTitle: String
    var color: String
}

class DataTableViewCellLeft: BaseTableViewCellLeft {
    @IBOutlet weak var image_icon: UIImageView!
    @IBOutlet weak var text_title: UILabel!
    
    
    override func awakeFromNib(){
        self.backgroundColor = UIColor.clear
        self.text_title.textColor = UIColor.lightGray
        self.text_title.font = UIFont.font65Medium(12)
        self.text_title.alpha = 1
        self.image_icon.alpha = 1
    }
    
    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 29
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellData {
            self.text_title.text = data.textTitle
            self.image_icon.image = UIImage(named: data.imageUrl)
            self.text_title.textColor = UIColor(hex: data.color)
        }
    }
}
