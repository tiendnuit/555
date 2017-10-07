//
//  DataTableViewCellCountry.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/25/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

struct DataTableViewCellListCountryData {
    init(title_Country: String) {
        self.titleCountry = title_Country
    }
    var titleCountry: String
}
class DataTableViewCellCountry: BaseTableViewCellLeft {
    
    @IBOutlet weak var textNameCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(hex: "F0F0F0")
        //self.textNameCountry.textColor = UIColor.whiteColor()
        self.textNameCountry.font = UIFont.font65Medium(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 25
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellListCountryData {
            self.textNameCountry.text = data.titleCountry
        }
    }
}
