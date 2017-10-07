//
//  DataUICollectionViewCellImage.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
struct DataUICollectionViewCellVideoData{
    init(image_Song: String , text_Count_Listen: String , text_Title_PlayList: String , text_Author: String) {
        self.imageSong = image_Song
        self.textAuthor = text_Author
        self.textCountListen = text_Count_Listen
        self.textTitlePlayList = text_Title_PlayList
    }
    
    var imageSong: String
    var textCountListen: String
    var textTitlePlayList: String
    var textAuthor: String
}

class DataUICollectionViewCellVideo: BaseUICollectionViewCellVideo {
    
    @IBOutlet weak var image_Song: UIImageView!
    @IBOutlet weak var text_Count_listen: UILabel!
    @IBOutlet weak var text_titile_playList: UILabel!
    @IBOutlet weak var text_author: UILabel!

    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        self.text_titile_playList.font = UIFont.font65Medium(11)
        self.text_author.font = UIFont.font66MediumItalic(9)
    }
    
    override class func height() -> CGFloat {
        return 110 * ScreenSize.MUL_HEIGHT
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataUICollectionViewCellVideoData {
            print("anh video",data.imageSong)
            if data.imageSong.isEmpty == false && data.imageSong != "" && data.imageSong != AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/" {
                self.image_Song.imageFromUrl(data.imageSong)
            }else {
                self.image_Song.image = UIImage(named: "down")
            }
            
            if data.textAuthor.isEmpty == false {
                self.text_author.text = data.textAuthor
            }else {
                self.text_author.text = ""
            }
            
            if data.textCountListen.isEmpty == false {
                self.text_Count_listen.text = data.textCountListen
            }else{
                self.text_Count_listen.text = ""
            }
            
            if data.textTitlePlayList.isEmpty == false {
                self.text_titile_playList.text = data.textTitlePlayList
            }else{
                self.text_titile_playList.text = ""
            }   
        }
    }
    
}
