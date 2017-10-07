//
//  DataViewPlayListByID.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/15/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewPlayListByID: UIView {

    //khai bao UIView
    var imageViewHeader: UIImageView!
    var imageAvater: UIImageView!
    var imageHeadphone: UIImageView!
    var textTitle: UILabel!
    var textSinger: UILabel!
    var textCountListen: UILabel!
    var buttonShare: UIButton!
    var buttonLike: UIButton!
    var buttonDownload: UIButton!
    var tableList: UITableView!
    var formDownload: DataUIViewFormDownload!
    
    //khai bao bien
    var idChoose: Int!
    var song: Song!
    var list_image_song: [String]! = []
    var list_title_song: [String]! = []
    var list_linkUrl_song: [String]! = []
    var list_id_song: [String]! = []
    var list_counter_song: [String]! = []
    var list_artistName_song: [String]! = []
    var list_description_song: [String]! = []
    var list_lyric_song: [String]! = []
    var list_title_and_author_song: [String]! = []
    var list_song: [Song]!
    let preferences = UserDefaults.standard
    var userIDFacebook: String!
    var checklogin: String! = ""
    
    var createNewPlayList = CreatePlayList()
    override func awakeFromNib(){
        let idfacebookkey = "idfacebook"
        let checkloginkey = "checklogin"
        if preferences.object(forKey: idfacebookkey) != nil && preferences.object(forKey: checkloginkey) != nil{
            userIDFacebook = preferences.string(forKey: idfacebookkey)
            checklogin = preferences.string(forKey: checkloginkey)
            print("This userid facebook: " + userIDFacebook)
            print("This checklogin facebook: " + checklogin)
        }

        AppsSettings.imageButtonPlay.isEnabled = true
        creatInterface()
        
        tableList.delegate = self
        tableList.dataSource = self
        if AppsSettings.checkClickMyPlaylist == true{
            parceApi("api/findsongbyidplaylist")
        }else{
            parceApi("api/findsongbyidsub")
        }
    
    }

    
    /***************************************************
    hàm parce api
    ****************************************************/
    func parceApi(_ api : String!){
        song = Song()
        song.idByPlayList = String(AppsSettings.idPlayList)
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListSong(api,song:song, success: {(response) -> Void in
            AppsSettings.list_song_object.removeAll()
            self.list_song = response.items
            AppsSettings.list_song_download_subject = response.items
            if self.list_song.count > 0 {
                for i in 0..<self.list_song.count {
                    self.song = self.list_song[i]
                    
                    if self.song.idSong != nil{
                        self.list_id_song.append(self.song.idSong)
                    }else{
                        self.list_id_song.append("")
                    }
                    
                    
                    if self.song.image != nil{
                        self.list_image_song.append(self.song.image)
                    }else{
                        self.list_image_song.append("")
                    }
                    
                    
                    if self.song.title != nil{
                        self.list_title_song.append(self.song.title)
                    }else{
                        self.list_title_song.append("")
                    }
                    
                    if self.song.artistname != nil{
                        self.list_artistName_song.append(self.song.artistname)
                    }else {
                        self.list_artistName_song.append("")
                    }
                    if self.song.counter != nil{
                        self.list_counter_song.append(self.song.counter)
                    }else{
                        self.list_counter_song.append("")
                    }
                    if self.song.descriPtion != nil {
                        self.list_description_song.append(self.song.descriPtion)
                    }else {
                        self.list_description_song.append("")
                    }
                    
                    if self.song.lyric != nil{
                        self.list_lyric_song.append(self.song.lyric)
                    }else{
                        self.list_lyric_song.append("")
                    }
                    
                    
                    if self.song.linkUrl != nil && self.song.linkUrl != "" {
                        self.list_linkUrl_song.append(self.song.linkUrl!)
                        
                    }else {
                        self.list_linkUrl_song.append(self.song.filepath)
                    }
                    if self.song.title != nil && self.song.artistname != nil{
                        self.list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                    }else{
                        self.list_title_and_author_song.append("")
                    }
                    AppsSettings.list_song_object.append(self.list_song[i])
                    //print("list_linkUrl_song  " + self.song.counter)
                }
            }
            AppsSettings.checkClickMyPlaylist = false
            AppsSettings.list_id_song = self.list_id_song
            self.tableList.reloadData()
//            print(AppsSettings.listSong.count)
            }) { (error) -> Void in
                AppsSettings.checkClickMyPlaylist = false
        }
    }
    
    /******************************************
    hàm parce api thích play list
    *******************************************/
    func parceApiUpdateLikePlayList(_ idUser: String! , idPlayList: String!){
        createNewPlayList = CreatePlayList()
        createNewPlayList.idUserPlaylist = idUser
        createNewPlayList.idPlayList = idPlayList
        AccountService(viewController: AppsSettings.root, isShowLoading: true).createPlayList("api/updatelike", playList: createNewPlayList, success: { (response) -> Void in
            let a = response
            print(a.mMessage)
            UIToast.makeText("បានចូលចិត្ត").show()
            }) { (error) -> Void in
                print("error")
                UIToast.makeText("បានចូលចិត្ត").show()
        }
    }
    
    
    /***************************************************
    xet hanh dong khi click button
    ****************************************************/
    func actionEven(_ sender:UIButton){
        idChoose = sender.tag
        if idChoose == 1 {
            if checklogin == "1"{
                if preferences.object(forKey: "useridkey") != nil {
                    let idUser = preferences.string(forKey: "useridkey")
                    parceApiUpdateLikePlayList(idUser, idPlayList: AppsSettings.idPlayList)
                }
            }else {
                //AppsSettings.dimBackgroundColor.hidden = false
                //AppsSettings.formLogin.hidden = false
                UIToast.makeText("លោកអ្នកត្រូវចូលគណនីដើម្បីចូលចិត្ត").show()
            }
        }else if idChoose == 2{
            if checklogin == "1"{
                if preferences.object(forKey: "useridkey") != nil {
                    let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
                    content.contentTitle = textTitle.text
                    if AppsSettings.imagePlayList != nil && AppsSettings.imagePlayList != AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/"
{
                        content.imageURL = URL(string: AppsSettings.imagePlayList)
                    }else{
                        content.imageURL = URL(string: AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/pl.png")
                    }
                    let fbdialog: FBSDKShareDialog = FBSDKShareDialog()
                    fbdialog.shareContent = content
                    fbdialog.delegate = nil
                    fbdialog.show()
                    
                }
            }else{
                UIToast.makeText("លោកអ្នកត្រូវតែចូលគណនី").show()
                //AppsSettings.dimBackgroundColor.hidden = false
                //AppsSettings.formLogin.hidden = false
            }
//A92 2
        }else if idChoose == 3 {
            print("da vao day roi:")
                    AppsSettings.backGroundViewPlayListID = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * -190, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
                    AppsSettings.backGroundViewPlayListID.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                    AppsSettings.backGroundViewPlayListID.alpha=0.5
                    self.addSubview(AppsSettings.backGroundViewPlayListID)
            
                    formDownload = DataUIViewFormDownload.loadNib()
                    formDownload.frame = CGRect(x: ScreenSize.MUL_WIDTH * -30, y:ScreenSize.MUL_HEIGHT * 30, width: ScreenSize.MUL_WIDTH * 270, height: ScreenSize.MUL_HEIGHT * 220)
                    self.addSubview(formDownload)
        }
    }
    
    
    
    /***************************************************
    Khoi tao View
    ****************************************************/
    func creatInterface(){
        //self.backgroundColor = UIColor.clearColor()

        imageViewHeader = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 85))
        imageViewHeader.image = UIImage(named: "backgroundhomefragment.png")
        
        imageAvater = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 5, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 75, height: ScreenSize.MUL_HEIGHT * 75))
        //print("anh dai dien la: ", AppsSettings.imagePlayList)
        if AppsSettings.imagePlayList != nil && AppsSettings.imagePlayList != AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/"
        {
            imageAvater.imageFromUrl(AppsSettings.imagePlayList)
        }else{
            imageAvater.image = UIImage(named: "down.png")
        }
        
        
        textTitle = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 90, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 300, height: ScreenSize.MUL_HEIGHT * 17))
        textTitle.textColor = UIColor(hex: "FFFFFF")
        textTitle.font = UIFont.font65Medium(13)
        if AppsSettings.titlePlayList != nil  {
            textTitle.text = AppsSettings.titlePlayList
        }
        
        textSinger = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 90, y:ScreenSize.MUL_HEIGHT * 20, width: ScreenSize.MUL_WIDTH * 300, height: ScreenSize.MUL_HEIGHT * 17))
        textSinger.textColor = UIColor(hex: "FFFFFF")
        textSinger.font = UIFont.font56Italic(12)
        textSinger.text = "អ្នកចំរៀងជាច្រើន"
        
        imageHeadphone = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 320, y:ScreenSize.MUL_HEIGHT * 25, width: ScreenSize.MUL_WIDTH * 13, height: ScreenSize.MUL_HEIGHT * 10))
        imageHeadphone.image = UIImage(named: "ic_audio.png")
        
        textCountListen = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 335, y:ScreenSize.MUL_HEIGHT * 23, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 17))
        textCountListen.textColor = UIColor(hex: "FFFFFF")
        textCountListen.font = UIFont.font65Medium(13)
        textCountListen.text = AppsSettings.turncount
        
            buttonLike = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 140, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 30))
            buttonLike.setBackgroundImage(UIImage(named:"btn_like_white.png"), for: UIControlState())
            buttonLike.addTarget(self, action: #selector(DataViewPlayListByID.actionEven(_:)), for: UIControlEvents.touchUpInside)
            buttonLike.tag = 1
        buttonLike.setTitle("     ចូលចិត្ត", for: UIControlState())
        
        buttonLike.titleLabel?.font = UIFont.font65Medium(10)
        
            
            buttonShare = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 220, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 30))
            buttonShare.setBackgroundImage(UIImage(named:"button_share_white.png"), for: UIControlState())
            buttonShare.addTarget(self, action: #selector(DataViewPlayListByID.actionEven(_:)), for: UIControlEvents.touchUpInside)
            buttonShare.tag = 2
            
            buttonDownload = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 300, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 30))
            buttonDownload.setBackgroundImage(UIImage(named:"button_download_white.png"), for: UIControlState())
            buttonDownload.addTarget(self, action: #selector(DataViewPlayListByID.actionEven(_:)), for: UIControlEvents.touchUpInside)
            buttonDownload.tag = 3
        buttonDownload.setTitle("    ទាញយក", for: UIControlState())
        buttonDownload.titleLabel?.font = UIFont.font65Medium(10)
        

        
        
        tableList = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y:ScreenSize.MUL_HEIGHT * 85, width: ScreenSize.MUL_WIDTH * 375, height: ScreenSize.MUL_HEIGHT * 165))
        
        tableList.registerCellNib(DataTableViewCellListSong.self)
        
        //self.addSubview(buttonOpenOrClose)
        self.addSubview(imageViewHeader)
        self.addSubview(imageAvater)
        self.addSubview(textTitle)
        self.addSubview(textSinger)
        self.addSubview(imageHeadphone)
        self.addSubview(textCountListen)
        self.addSubview(buttonLike)
        //self.addSubview(buttonShare)
        self.addSubview(buttonDownload)
        self.addSubview(tableList)
    }
}

@available(iOS 8.0, *)
extension DataViewPlayListByID : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 43
    }
}

extension DataViewPlayListByID : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-------------------" + String(list_id_song.count) + "-------------------")
        return list_id_song.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableList.dequeueReusableCell(withIdentifier: DataTableViewCellListSong.identifier) as! DataTableViewCellListSong
        cell.textTitleSong.textColor = UIColor(hex: "000000")
        cell.textTitleAuthor.textColor = UIColor(hex: "000000")
        cell.textCountListen.textColor = UIColor(hex: "000000")
        let data = DataTableViewCellListSongData(id_Song: list_id_song[indexPath.row] ,title_Song: list_title_song[indexPath.row], title_Author: list_artistName_song[indexPath.row], count_Listen: list_counter_song[indexPath.row] , link_url: list_linkUrl_song[indexPath.row] , image_Song: list_image_song[indexPath.row] , description_Song: list_description_song[indexPath.row])
        cell.setData(data)
        AppsSettings.btnDownloadMusic = UIButton()
        AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
        AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
        AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewPlayListByID.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
        AppsSettings.btnDownloadMusic.tag = indexPath.row
        cell.addSubview(AppsSettings.btnDownloadMusic)
        
        return cell
    }
    
    
    func actionEventDownload(_ sender: AnyObject){
        UIToast.makeText("កំពុងទាញយក").show()
        var indexpath = sender.tag
        print("indexpath: \(indexpath)")
        var link_url_download:String = list_linkUrl_song[indexpath!]
        AppsSettings.tittle_Song_Drive = list_title_song[indexpath!]
        let prString = link_url_download.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
        
        if link_url_download.range(of: "docs.google.com") != nil {
            Downloader.loadSong(prString)
            UIToast.makeText("ទាញយកបទចំរៀងមិនជោគជ័យ!").show()
        }else{
            let url = URL(string: prString)
            print(String(describing: url) + "------------------")
            Downloader().loadFileAsync(url!, completion:{(path:String, error:NSError!) in
                print("pdf downloaded to: \(path)")
                UIToast.makeText("ទាញយកបទចំរៀងមិនជោគជ័យ!").show()
            })
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Song " + list_linkUrl_song[indexPath.row])
        AppsSettings.tittle_Song_Drive = list_title_song[indexPath.row]
        AppsSettings.position = indexPath.row
        AppsSettings.list_url_song = list_linkUrl_song
        AppsSettings.list_title_song = list_title_and_author_song
        AppsSettings.isCheckedButtonPlay = true
        AppsSettings.idSong = list_id_song[indexPath.row]
        AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
        
        //AppsSettings.textNameSong.text = list_title_song[indexPath.row]
        
        var song = Song()
        song.idSong = list_id_song[indexPath.row]
        AppsSettings.root.updateCountSong(song.idSong)
        
        list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
        tableView.reloadData()
    }
    
}

