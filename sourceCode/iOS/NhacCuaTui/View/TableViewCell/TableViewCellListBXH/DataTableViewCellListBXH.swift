//
//  DataTableViewCellListBXH.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
struct DataTableViewCellListBXHData {
    init(title_Song: String, stt_text: String) {
        self.titleSong = title_Song
        self.stt = stt_text
    }
    var titleSong: String
    var stt: String
}

class DataTableViewCellListBXH: BaseTableViewCellLeft {
    
    @IBOutlet weak var sttText: UILabel!
    @IBOutlet weak var nameTitleSong: UILabel!
    
    var listColor: [String] = ["FF0015","2E45EA","C912D5","DCE35D","A9A9DD","4D9B4C","00BEC2","00BFC3"]
    
    override func awakeFromNib(){
        self.backgroundColor = UIColor.clear
        let randomNumber = arc4random_uniform(7)
        self.sttText.font = UIFont.font65Medium(10)
        self.sttText.textColor = UIColor(hex: listColor[Int(randomNumber)])
        self.nameTitleSong.font = UIFont.font65Medium(10)
        self.nameTitleSong.textColor = UIColor.white
        
    }
    
    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 25
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellListBXHData {
            self.sttText.text = data.stt
            self.nameTitleSong.text = data.titleSong
        }
    }
}
