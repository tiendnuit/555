//
//  DataUICollectionViewCellImage.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

struct DataUICollectionViewCellImageData{
    init(image_Name: String, songName: String, songListenCount: String) {
        self.imageName = image_Name
        self.songName = songName
        self.songListenCount = songListenCount
    }
    
    var imageName: String
    var songName: String
    var songListenCount: String
}

class DataUICollectionViewCellImage: BaseUICollectionViewCellPlayList {
    
//    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var countListen: UILabel!
    @IBOutlet weak var nameSong: UILabel!
    
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
//        self.backgroundColor = UIColor .clearColor()
        self.nameSong.font = UIFont.font65Medium(10)
//        self.text_author.font = UIFont.font66MediumItalic(8)

    }
    
    override class func height() -> CGFloat {
        return 110 * ScreenSize.MUL_HEIGHT
    }
        override func setData(_ data: Any?) {
        if let data = data as? DataUICollectionViewCellImageData {
            //self.imageHouse.image = UIImage(named: data.imageUrl)
            
            if data.imageName != ""
            {
            //let url = "http://222.255.46.7:8080/music/public/media/songs/tb/" + data.imageName
                let url = AppsSettings.Static.BASE_IMAGE_URL + data.imageName
                print("this url: " + url)
                //self.imageSong.imageFromUrl(url)
                self.imageSong.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "down"))
            }
            else
            {
                self.imageSong.image = UIImage(named: "down")
            }
            self.nameSong.text = data.songName
            self.countListen.text = data.songListenCount
            
//            if data.imageName.isEmpty != false {
//                
//            }else {
//                //self.imageHouse.image = UIImage(named: "")
//            }
        }
    }
    
}
