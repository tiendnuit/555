//
//  DataTableViewCellListSong.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit

struct DataTableViewCellListSongData {
    init(id_Song: String, title_Song: String, title_Author: String, count_Listen: String , link_url: String , image_Song: String , description_Song: String) {
        self.idSong = id_Song
        self.titleSong = title_Song
        self.titleAuthor = title_Author
        self.countListen = count_Listen
        self.linkUrl = link_url
        self.imageSong = image_Song
        self.descriptionSong = description_Song
        
    }
    
    var idSong: String
    var titleSong: String
    var titleAuthor: String
    var countListen: String
    var linkUrl: String
    var imageSong: String
    var descriptionSong: String
}

class DataTableViewCellListSong: BaseTableViewCellLeft {
    var textTitleSong: UILabel!
    var textTitleAuthor: UILabel!
    var textCountListen: UILabel!
//    var imageButtonDownload: UIButton!
    var imageButtonShare: UIButton!
    var imageButtonAdd: UIButton!
    var imageHeadphone: UIImageView!
    var idChoose: Int!
    var formLogin: DataUiViewFormLogin!
    
    var link_url_song: String! = ""
    var list_id_song: [String] = []
    var song:Song! = Song()
    var id_song: String! = ""
    var title_song: String! = ""
    var description_song: String! = ""
    var image_song: String! = ""
    var name_artist: String! = ""
    var count_listen: String! = ""
    
    //khai bao content facebook
    var checklogin: String! = ""
    let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
    let checkloginkey = "checklogin"
    var preferences = UserDefaults.standard
    
    var imageViewHome: DataViewHome!
    var imageViewSearch: DataViewSearch!
    var imageViewBXH: DataViewBXH!
    var imageViewBaiHat: DataViewBaiHat!
    var imageViewPlayList: DataViewPlayList!
    var imageViewVideo: DataViewVideo!
    var imageViewChuDe: DataViewChuDe!
    var imageViewNgheSi: DataViewNgheSi!
    var imageViewNCT: DataViewNCT!

    override func awakeFromNib(){
        createInterface()
        if preferences.object(forKey: "checklogin") != nil{
        checklogin = preferences.string(forKey: checkloginkey)
        }
    }
    
    override class func height() -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 29
    }
    
    override func setData(_ data: Any?) {
        if let data = data as? DataTableViewCellListSongData {
            self.textTitleSong.text = data.titleSong
            self.textTitleAuthor.text = data.titleAuthor
            self.textCountListen.text = data.countListen
            
            self.link_url_song = data.linkUrl
            self.title_song = data.titleSong
            self.description_song = data.descriptionSong
            self.image_song = data.imageSong
            self.name_artist = data.titleAuthor
            self.count_listen = data.countListen
            self.id_song = data.idSong
        }
    }
    
       
    /****************************************
    ham xét sự kiện khi click vào các button
    *****************************************/
    func actionEvent(_ sender:UIButton){
        idChoose = sender.tag
        if idChoose == 1 {
            
        }else if idChoose == 2 {
            if link_url_song.range(of: "googledrive.com") == nil
            {
            print("Share:  " + link_url_song)
                let prString = link_url_song.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
                content.contentURL = URL(string: prString)
                content.contentTitle = title_song
                content.contentDescription = description_song
                content.imageURL = URL(string: AppsSettings.Static.BASE_IMAGE_URL + image_song)
                FBSDKShareDialog.show(from: AppsSettings.root, with: content, delegate: nil)
            }
            else{
                UIToast.makeText("កំហុស").show()
            }

        }else if idChoose == 3 {
//Dau cong 2
            if AppsSettings.checklog == "1"
            {
                
                let idUser = preferences.object(forKey: "useridkey")
                print("idUser: \(idUser)")
                let idSong2 = self.id_song
                preferences.set(idSong2, forKey: "idsongtoadd")
                AppsSettings.root.showActivityIndicator()
                preferences.set("2", forKey: "keykey")
                AppsSettings.flag = 1
                
                print("-------idSong 2: \(AppsSettings.idSong)")
            }
            else
            {
                UIToast.makeText("លោកអ្នកត្រូវតែចូលគណនី").show()
            }
        }
    }
    
    /**********************************
    ham tao uiview
    ***********************************/
    func createInterface(){
        self.backgroundColor = UIColor.clear
        self.textTitleSong = UILabel(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 7, width: ScreenSize.MUL_WIDTH * 161, height: ScreenSize.MUL_HEIGHT * 17))
        self.textTitleSong.textColor = UIColor(hex: "FFFFFF")
        self.textTitleAuthor = UILabel(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 27, width: ScreenSize.MUL_WIDTH * 161, height: ScreenSize.MUL_HEIGHT * 15))
        self.textTitleAuthor.textColor = UIColor(hex: "FFFFFF")
        
        self.imageHeadphone = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 203, y: ScreenSize.MUL_HEIGHT * 15, width: ScreenSize.MUL_WIDTH * 15, height: ScreenSize.MUL_HEIGHT * 12))
        imageHeadphone.image = UIImage(named: "ic_audio.png")
        
        self.textCountListen = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 226, y: ScreenSize.MUL_HEIGHT * 15, width: ScreenSize.MUL_WIDTH * 47, height: ScreenSize.MUL_HEIGHT * 15))
        self.textCountListen.textColor = UIColor(hex: "FFFFFF")
        if AppsSettings.checkClickPlaylist == 1{
//            AppsSettings.btnDownloadMusic = UIButton()
//            AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
//            AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), forState: UIControlState.Normal)
//            AppsSettings.btnDownloadMusic.addTarget(self, action: "actionEventDownload:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.imageButtonShare = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 300, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25))
            self.imageButtonShare.setBackgroundImage(UIImage(named:"ic_share_white.png"), for: UIControlState())
            self.imageButtonShare.addTarget(self, action: #selector(DataTableViewCellListSong.actionEvent(_:)), for: UIControlEvents.touchUpInside)
            self.imageButtonShare.tag = 2
            
            self.imageButtonAdd = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 340, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25))
            self.imageButtonAdd.setBackgroundImage(UIImage(named:"ic_plus_white.png"), for: UIControlState())
            self.imageButtonAdd.addTarget(self, action: #selector(DataTableViewCellListSong.actionEvent(_:)), for: UIControlEvents.touchUpInside)
            self.imageButtonAdd.tag = 3
            AppsSettings.checkClickPlaylist = 0
        }else{
//            AppsSettings.btnDownloadMusic = UIButton()
//            AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
//            AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), forState: UIControlState.Normal)
//            AppsSettings.btnDownloadMusic.addTarget(self, action: "actionEventDownload:", forControlEvents: UIControlEvents.TouchUpInside)
            
            self.imageButtonShare = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 300, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25))
            self.imageButtonShare.setBackgroundImage(UIImage(named:"ic_share_white.png"), for: UIControlState())
            self.imageButtonShare.addTarget(self, action: #selector(DataTableViewCellListSong.actionEvent(_:)), for: UIControlEvents.touchUpInside)
            self.imageButtonShare.tag = 2
            
            self.imageButtonAdd = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 340, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25))
            self.imageButtonAdd.setBackgroundImage(UIImage(named:"ic_plus_white.png"), for: UIControlState())
            self.imageButtonAdd.addTarget(self, action: #selector(DataTableViewCellListSong.actionEvent(_:)), for: UIControlEvents.touchUpInside)
            self.imageButtonAdd.tag = 3
        }
        
        self.textTitleSong.font = UIFont.font65Medium(12)
        self.textTitleAuthor.font = UIFont.font66MediumItalic(9)
        self.textCountListen.font = UIFont.font65Medium(8)
        
        self.addSubview(textTitleSong)
        self.addSubview(textTitleAuthor)
        self.addSubview(imageHeadphone)
        self.addSubview(textCountListen)
//        self.addSubview(AppsSettings.btnDownloadMusic)
        self.addSubview(imageButtonShare)
        self.addSubview(imageButtonAdd)
        
    }
    
    
}
