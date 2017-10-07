//
//  DataTableViewCellListSearch.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 2/3/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit


struct DataTableViewCellListSearchData {
    init(title_Song: String, image: String) {
        self.titleSong = title_Song
        self.image = image
    }
    var titleSong: String
    var image: String
}

class DataTableViewCellListSearch: BaseTableViewCellLeft {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var nameObject: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        nameObject.textColor = UIColor.white
        nameObject.font = UIFont.font65Medium(10)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 23
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellListSearchData {
            self.imageLogo.image = UIImage(named: data.image)
            self.nameObject.text = data.titleSong
        }
    }
}
