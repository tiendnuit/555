//
//  DataTableViewCellListDownload.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 2/2/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

struct DataTableViewCellListDownloadData{
    init(name_Song: String , name_Artist: String, url_song:String, indextPath:Int) {
        self.nameSong = name_Song
        self.nameArtist = name_Artist
        self.urlSong = url_song
        self.indext = indextPath
    }
    var nameSong: String
    var nameArtist: String
    var urlSong: String
    var indext:Int
}

var idSong:String!
class DataTableViewCellListDownload: BaseTableViewCellLeft {

    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nameArtise: UILabel!
    var urltest:String!  = ""
    var checkBox: UIButton!
    var check: Bool = false
    var index:Int!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.nameSong.font = UIFont.font65Medium(10)
        self.nameSong.font = UIFont.font65Medium(10)
        self.nameSong.textColor = UIColor(hex: "FFFFFF")
        self.nameArtise.font = UIFont.font65Medium(8)
        self.nameArtise.textColor = UIColor(hex: "FFFFFF")
        self.nameArtise.font = UIFont.font65Medium(7)
        
        checkBox = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 227, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 17, height: ScreenSize.MUL_HEIGHT * 17))
        checkBox.setBackgroundImage(UIImage(named:"unchecked.png"), for: UIControlState())
        self.checkBox.addTarget(self, action: #selector(DataTableViewCellListDownload.chooseActionStar), for: UIControlEvents.touchUpInside)
        self.addSubview(checkBox)
    }

    
    func chooseActionStar() {
        print("check day:")
        
        if AppsSettings.listCheckbox[index] == true {
            AppsSettings.listCheckbox[index] = false
            checkBox.setBackgroundImage(UIImage(named:"unchecked.png"), for: UIControlState())
            AppsSettings.checkflagok = false
            check = false
        } else {
            AppsSettings.listCheckbox[index] = true
            checkBox.setBackgroundImage(UIImage(named:"checkbox.png"), for: UIControlState())
            AppsSettings.checkflagok = true
            check = true
            
        }
        var dem = 0
        for i in 0  ..< AppsSettings.listCheckbox.count {
            if(AppsSettings.listCheckbox[i] == true){
                dem += 1
            }
        }
        if(dem == AppsSettings.listCheckbox.count){
            AppsSettings.checkAll = true
            //check
        }else{
            //uncheck
            AppsSettings.checkAll = false
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 25
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellListDownloadData {
            self.nameSong.text = data.nameSong
            self.nameArtise.text = data.nameArtist
            self.urltest = data.urlSong
            self.index = data.indext
            //self.checkBox.addTarget(self, action: "actionEven", forControlEvents: UIControlEvents.TouchUpInside)
        }
    }

}

//class CheckBox: UIButton {
//    // Images
//    let checkedImage = UIImage(named: "checkbox.png")! as UIImage
//    let uncheckedImage = UIImage(named: "unchecked.png")! as UIImage
//    
//    // Bool property
//    var isChecked: Bool = false {
//        didSet{
//            if isChecked == true {
//                self.setImage(checkedImage, forState: .Normal)
//            } else {
//                self.setImage(uncheckedImage, forState: .Normal)
//            }
//        }
//    }
//    
//    override func awakeFromNib() {
//        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.isChecked = false
//    }
//    
//    func buttonClicked(sender: UIButton) {
//        if sender == self {
//            if isChecked == true {
//                isChecked = false
//            } else {
//                isChecked = true
//            }
//        }
//    }
//}
