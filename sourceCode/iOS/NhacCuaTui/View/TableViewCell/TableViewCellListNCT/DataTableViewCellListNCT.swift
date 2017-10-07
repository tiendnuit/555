//
//  DataTableViewCellListNCT.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/22/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit

struct DataTableViewCellListNCTData {
    init(title_Song: String, title_Author: String) {
        self.titleSong = title_Song
        self.titleAuthor = title_Author
    }
    
    var titleSong: String
    var titleAuthor: String
}



class DataTableViewCellListNCT: BaseTableViewCellLeft{
    
    var textTitleSong: UILabel!
    var textTitleAuthor: UILabel!

    var buttonDelete: UIButton!
    
    var titleSong:String! = ""
    override func awakeFromNib(){
        
        createInterface()
    }
    
    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 29
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellListNCTData {
            titleSong = data.titleSong
            self.textTitleSong.text = data.titleSong
            self.textTitleAuthor.text = data.titleAuthor
        }
    }
    
    /**********************************
    ham tao uiview
    ***********************************/
    func createInterface(){
        self.backgroundColor = UIColor.clear
        self.textTitleSong = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 8, y: ScreenSize.MUL_HEIGHT * 3, width: ScreenSize.MUL_HEIGHT * 323, height: ScreenSize.MUL_HEIGHT * 21))
        self.textTitleSong.font = UIFont.font65Medium(12)
        
        self.textTitleAuthor = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 8, y: ScreenSize.MUL_HEIGHT * 20, width: ScreenSize.MUL_HEIGHT * 323, height: ScreenSize.MUL_HEIGHT * 21))
        self.textTitleAuthor.font = UIFont.font56Italic(11)
        
        self.buttonDelete = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 420, y: ScreenSize.MUL_HEIGHT * 8, width: ScreenSize.MUL_HEIGHT * 20, height: ScreenSize.MUL_HEIGHT * 20))
        self.buttonDelete.setBackgroundImage(UIImage(named:"del.png"), for: UIControlState())

        
        self.addSubview(textTitleSong)
        self.addSubview(textTitleAuthor)
        self.addSubview(buttonDelete)
    }
    
}
