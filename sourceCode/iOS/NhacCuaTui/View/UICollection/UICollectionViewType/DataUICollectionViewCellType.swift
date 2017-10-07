//
//  DataUICollectionViewCellType.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/28/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
struct DataUICollectionViewCellTypeData{
    init(name_Type: String) {
        self.nameType = name_Type
    }
    var nameType: String
}

class DataUICollectionViewCellType: BaseUICollectionViewCellType {
    
    @IBOutlet weak var nameType: UILabel!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hex: "000000")
        nameType.textColor = UIColor(hex: "FFFFFF")
        nameType.font = UIFont.font65Medium(9)
    }
    
    override class func height() -> CGFloat {
        return 25 * ScreenSize.MUL_HEIGHT
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataUICollectionViewCellTypeData {
            nameType.text = data.nameType
        }
    }
}
