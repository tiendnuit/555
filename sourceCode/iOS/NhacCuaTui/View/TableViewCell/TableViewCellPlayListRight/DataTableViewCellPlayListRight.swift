//
//  DataTableViewCellPlayListRight.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/29/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit

struct DataTableViewCellPlayListRightData {
    init(stt: String , name_Song: String , name_Artist: String , count_Listen: String) {
        self.stt = stt
        self.nameSong = name_Song
        self.nameArtist = name_Artist
        self.countListen = count_Listen
    }
    var stt: String
    var nameSong: String
    var nameArtist: String
    var countListen: String
    
}
class DataTableViewCellPlayListRight: BaseTableViewCellLeft {
    
    @IBOutlet weak var txtStt: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak var textCountListen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtStt.font = UIFont.font65Medium(10)
        self.nameSong.font = UIFont.font65Medium(10)
        self.nameArtist.textColor = UIColor(hex: "7B7B7B")
        self.nameArtist.font = UIFont.font65Medium(8)
        self.textCountListen.textColor = UIColor(hex: "7B7B7B")
        self.textCountListen.font = UIFont.font65Medium(7)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 25
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellPlayListRightData {
            self.txtStt.text = data.stt
            self.nameSong.text = data.nameSong
            self.nameArtist.text = data.nameArtist
            self.textCountListen.text = ""
        }
    }
}
