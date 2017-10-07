//
//  DataViewContentSong.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/23/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewContentSong: UIView {

    var imageBackground: UIImageView!
    var dimBackground: UIView!
    var imageSong: UIImageView!
    var buttonClose: UIButton!
    var nameSong: UILabel!
    var nameAuthor: UILabel!
    var contentSong: UILabel!
    
    var position:Int!
    var song: Song!
    
    override func awakeFromNib(){
        createInterface()
        song = Song()
        position = AppsSettings.position
        
        print(position)
        
        print(AppsSettings.listSong.count)
        song = AppsSettings.listSong[position]
//
        nameSong.text = song.title
        nameAuthor.text = song.artistname
        let url = AppsSettings.Static.BASE_IMAGE_URL + song.image
        //imageBackground.imageFromUrl(url)
        imageBackground.sd_setImage(with: URL(string: url), placeholderImage: nil)
        //imageSong.imageFromUrl(url)
        imageSong.sd_setImage(with: URL(string: url), placeholderImage: nil)
        contentSong.text = song.descriPtion
    }

    
    
    
    /***************************************
    Hàm tạo interface
    ****************************************/
    func createInterface(){
        imageBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        imageBackground.image = UIImage(named: "s10.png")
        
        dimBackground = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        dimBackground.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        dimBackground.alpha=0.5
        
        buttonClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 20, y:ScreenSize.MUL_HEIGHT * 20, width: ScreenSize.MUL_HEIGHT * 30, height: ScreenSize.MUL_HEIGHT * 30))
        buttonClose.setBackgroundImage(UIImage(named:"slidedown.png"), for: UIControlState())
        buttonClose.addTarget(self, action: #selector(DataViewContentSong.actionCloseView), for: UIControlEvents.touchUpInside)
        
        nameSong = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 70, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 200, height: ScreenSize.MUL_HEIGHT * 20))
        nameSong.text = "Anh nhớ mùa đông ấy"
        nameSong.textColor = UIColor(hex: "FFFFFF")
        nameSong.textAlignment = .center
        nameSong.font = UIFont.font65Medium(15)
        
        nameAuthor = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 70, y:ScreenSize.MUL_HEIGHT * 60, width: ScreenSize.MUL_WIDTH * 200, height: ScreenSize.MUL_HEIGHT * 20))
        nameAuthor.text = "The Men"
        nameAuthor.font = UIFont.font65Medium(15)
        nameAuthor.textAlignment = .center
        nameAuthor.textColor = UIColor(hex: "00D3F0")
        
        imageSong = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 95, y:ScreenSize.MUL_HEIGHT * 90, width: ScreenSize.MUL_HEIGHT * 130, height: ScreenSize.MUL_HEIGHT * 130))
        imageSong.image = UIImage(named: "img_detail.png")
        
        
        contentSong = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 320, y:ScreenSize.MUL_HEIGHT * 30, width: ScreenSize.MUL_WIDTH * 220, height: ScreenSize.MUL_HEIGHT * 250))
        contentSong.text = "Anh nhớ mùa đông ấy"
        contentSong.textColor = UIColor(hex: "FFFFFF")
        contentSong.textAlignment = .center
        contentSong.font = UIFont.font65Medium(12)
        
        
        self.addSubview(imageBackground)
        self.addSubview(dimBackground)
        self.addSubview(buttonClose)
        self.addSubview(nameSong)
        self.addSubview(nameAuthor)
        self.addSubview(imageSong)
        self.addSubview(contentSong)
    }
    
    /***************************************
    su kien khi click vao button dong view
    ****************************************/
    func actionCloseView(){
        self.removeFromSuperview()
    }
    
}
