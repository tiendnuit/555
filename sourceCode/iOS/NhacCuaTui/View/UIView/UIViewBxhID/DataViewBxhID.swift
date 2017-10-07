//
//  DataViewBxhID.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 2/16/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewBxhID: UIView {

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
    var list_song: [Song]!
    let preferences = UserDefaults.standard
    var userIDFacebook: String!
    var checklogin: String! = ""
    var thamsotruyen:UserDefaults!
    var bangXepHang: BangXepHang!
    var listVideoBXH: [VideoVideo]! = []
    var listSongBXH: [Song]! = []
    var listPlayListBXH: [PlayList]! = []
    var songBXH: Song!
    var videoBXH: VideoVideo!
    var playListBXH: PlayList!
    
    //khai bao bien song
    var list_image_song: [String]! = []
    var list_title_song: [String]! = []
    var list_linkUrl_song: [String]! = []
    var list_id_song: [String]! = []
    var list_counter_song: [String]! = []
    var list_artistName_song: [String]! = []
    var list_description_song: [String]! = []
    var list_lyric_song: [String]! = []
    var list_title_and_author_song: [String]! = []
    
    //khai bao bien video
    var list_id_video: [String]! = []
    var list_image_video: [String]! = []
    var list_title_video: [String]! = []
    var list_author_video: [String]! = []
    var list_count_screen: [String]! = []
    var list_linkUrl_video: [String]! = []
    var list_counter_video: [String]! = []
    var list_artistName_video: [String]! = []
    
    //khai bao bien playList
    var list_id_playList: [String]! = []
    var list_image_playList: [String]! = []
    var list_title_playList: [String]! = []
    var list_author_playList: [String]! = []
    var list_count_listen: [String]! = []
    
    //khai bao bien playListByID
    var viewPlayListByID: DataViewPlayListByID!
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    
    var createNewPlayList = CreatePlayList()
    override func awakeFromNib(){
        thamsotruyen = UserDefaults()
        let idfacebookkey = "idfacebook"
        let checkloginkey = "checklogin"
//        if preferences.objectForKey(idfacebookkey) == nil && preferences.objectForKey(checkloginkey) == nil{
//            print("Does't exits login: ")
        if preferences.object(forKey: idfacebookkey) != nil && preferences.object(forKey: checkloginkey) != nil{
            userIDFacebook = preferences.string(forKey: idfacebookkey)
            checklogin = preferences.string(forKey: checkloginkey)
            print("This userid facebook: " + userIDFacebook)
            print("This checklogin facebook: " + checklogin)
        }
    
//        AppsSettings.listSong.removeAll()
//        AppsSettings.list_url_song.removeAll()
//        AppsSettings.list_title_song.removeAll()
        
        creatInterface()
        
        tableList.delegate = self
        tableList.dataSource = self
        
        parceApi(AppsSettings.idCountryBXH)
        
    }
    
    
    /**************************************
    Hàm parce api
    ***************************************/
    func parceApi(_ idCountry: String!){
        bangXepHang = BangXepHang()
        bangXepHang.idCountry = idCountry
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getBangXepHang("api/BXH",bangXepHang: bangXepHang , success: { (response) -> Void in
            
            let a = response
            self.listSongBXH = []
            self.listVideoBXH = []
            self.listPlayListBXH = []
            self.listSongBXH = a.listSong
            self.listVideoBXH = a.listVideo
            self.listPlayListBXH = a.listPlayList
            
            if self.listSongBXH.count > 0 {
                for i in 0..<self.listSongBXH.count {
                    if i < 3
                    {
                    self.songBXH = self.listSongBXH[i]
                    
                    if self.songBXH.title != nil{
                        self.list_title_song.append(self.songBXH.title)
                    }else{
                        self.list_title_song.append("")
                    }
                    
                    
                    if self.songBXH.idSong != nil{
                        self.list_id_song.append(self.songBXH.idSong)
                    }else{
                        self.list_id_song.append("")
                    }
                    
                    
                    if self.songBXH.image != nil{
                        self.list_image_song.append(self.songBXH.image)
                    }else{
                        self.list_image_song.append("")
                    }
                    
                    if self.songBXH.artistname != nil{
                        self.list_artistName_song.append(self.songBXH.artistname)
                    }else{
                        self.list_artistName_song.append("")
                    }
                    
                    if self.songBXH.counter != nil{
                        self.list_counter_song.append(self.songBXH.counter)
                    }else{
                        self.list_counter_song.append("")
                    }
                    
                    if self.songBXH.descriPtion != nil {
                        self.list_description_song.append(self.songBXH.descriPtion)
                    }
                    self.list_lyric_song.append(self.songBXH.lyric)
                    if self.songBXH.linkUrl != nil && self.songBXH.linkUrl != ""{
                        self.list_linkUrl_song.append(self.songBXH.linkUrl!)
                        
                    }else {
                        if self.songBXH.filepath != nil{
                        self.list_linkUrl_song.append(self.songBXH.filepath)
                        }
                    }
                    if self.songBXH.title != nil && self.songBXH.artistname != nil{
                        self.list_title_and_author_song.append(self.songBXH.title + " - " + self.songBXH.artistname)
                    }else{
                        self.list_title_and_author_song.append("")
                    }
                    
                } else
                    {
                        print("out")
                    }
                }
            }
            
            if self.listVideoBXH.count > 0 {
                for i in 0..<self.listVideoBXH.count {
                    
                    self.videoBXH = self.listVideoBXH[i]
                    self.list_id_video.append(self.videoBXH.idVideo)
                    if self.videoBXH.title != nil {
                        self.list_title_video.append(self.videoBXH.title)
                    }
                    if  self.videoBXH.linkUrl != nil && self.videoBXH.linkUrl != ""{
                        self.list_linkUrl_video.append(self.videoBXH.linkUrl!)
                    }else {
                        if self.videoBXH.filepath != nil{
                        self.list_linkUrl_video.append(self.videoBXH.filepath)
                        }
                    }
                    if self.videoBXH.counter != nil {
                        self.list_counter_video.append(self.videoBXH.counter)
                    }
                    if self.videoBXH.artistname != nil {
                        self.list_artistName_video.append(self.videoBXH.artistname)
                    }else{
                        self.list_artistName_video.append("")
                    }
                }
            }
            
            if self.listPlayListBXH.count > 0 {
                for i in 0..<self.listPlayListBXH.count {
                    self.playListBXH = self.listPlayListBXH[i]
                    if self.playListBXH.title != nil {
                        self.list_title_playList.append(self.playListBXH.title)
                    }else{
                        self.list_title_playList.append("")
                    }
                    if self.playListBXH.counter != nil {
                        self.list_count_listen.append(String(self.playListBXH.counter))
                    }else{
                        self.list_count_listen.append("")
                    }
                    if self.playListBXH.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/" + self.playListBXH.image
                        self.list_image_playList.append(link_image)
                    }else{
                        self.list_image_playList.append("")
                    }
                    if self.playListBXH.idplaylist != nil {
                        self.list_id_playList.append(self.playListBXH.idplaylist)
                    }
                }
            }

            self.tableList.reloadData()
            }) { (error) -> Void in
                
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
    xet su kien khi click vao button đóng mở playList ID
    ****************************************************/
    func actionEven(){
        self.dimBackgroundColor.removeFromSuperview()
        viewPlayListByID.removeFromSuperview()
        buttonOpenOrClose.removeFromSuperview()
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
                AppsSettings.dimBackgroundColor.isHidden = false
                AppsSettings.formLogin.isHidden = false
            }
        }else if idChoose == 2{
            if checklogin == "1"{
                if preferences.object(forKey: "useridkey") != nil {

                }
            }else{
                AppsSettings.dimBackgroundColor.isHidden = false
                AppsSettings.formLogin.isHidden = false
            }
        }else if idChoose == 3 {
           
                    AppsSettings.backGroundViewPlayListID = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * -190, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
                    AppsSettings.backGroundViewPlayListID.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
                    AppsSettings.backGroundViewPlayListID.alpha=0.5
                    formDownload = DataUIViewFormDownload.loadNib()
                    formDownload.frame = CGRect(x: ScreenSize.MUL_WIDTH * -30, y:ScreenSize.MUL_HEIGHT * 30, width: ScreenSize.MUL_WIDTH * 270, height: ScreenSize.MUL_HEIGHT * 220)
                    self.addSubview(AppsSettings.backGroundViewPlayListID)
                    self.addSubview(formDownload)
        }
    }
    
    /***************************************************
    Hàm tao giao diện View playListID
    ****************************************************/
    func createViewPlayListId(){
        //khoi tao view dim back ground
        self.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 250))
        dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        dimBackgroundColor.alpha=0.5
        
        buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * -25, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
        buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewBxhID.actionEven as (DataViewBxhID) -> () -> ()), for: UIControlEvents.touchUpInside)
        
        viewPlayListByID = DataViewPlayListByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
    }
    
    /***************************************************
    Khoi tao View
    ****************************************************/
    func creatInterface(){
        //self.backgroundColor = UIColor.clearColor()
        
        imageViewHeader = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 85))
        imageViewHeader.image = UIImage(named: "backgroundhomefragment.png")
        
        imageAvater = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 5, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 75, height: ScreenSize.MUL_HEIGHT * 75))
        if AppsSettings.imagePlayList != nil {
            imageAvater.imageFromUrl(AppsSettings.imagePlayList)
        }else{
            imageAvater.image = UIImage(named: "down.png")
        }
        
        textTitle = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 90, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 300, height: ScreenSize.MUL_HEIGHT * 17))
        textTitle.textColor = UIColor(hex: "FFFFFF")
        textTitle.font = UIFont.font65Medium(13)
        if AppsSettings.titlePlayList != nil  && AppsSettings.checkClickMyPlaylist == true{
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
        
        
        
        buttonLike = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 140, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 30))
        buttonLike.setBackgroundImage(UIImage(named:"btn_like_white.png"), for: UIControlState())
        buttonLike.addTarget(self, action: #selector(DataViewBxhID.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonLike.tag = 1
        
        buttonShare = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 220, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 30))
        buttonShare.setBackgroundImage(UIImage(named:"button_share_white.png"), for: UIControlState())
        buttonShare.addTarget(self, action: #selector(DataViewBxhID.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonShare.tag = 2
        
        buttonDownload = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 300, y:ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 30))
        buttonDownload.setBackgroundImage(UIImage(named:"button_download_white.png"), for: UIControlState())
        buttonDownload.addTarget(self, action: #selector(DataViewBxhID.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonDownload.tag = 3
        
        tableList = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y:ScreenSize.MUL_HEIGHT * 85, width: ScreenSize.MUL_WIDTH * 375, height: ScreenSize.MUL_HEIGHT * 165))
        tableList.registerCellNib(DataTableViewCellListSong.self)
        
        //self.addSubview(buttonOpenOrClose)
        self.addSubview(imageViewHeader)
        self.addSubview(imageAvater)
        self.addSubview(textTitle)
        self.addSubview(textSinger)
        self.addSubview(imageHeadphone)
        self.addSubview(textCountListen)
        self.addSubview(tableList)
        
        if AppsSettings.idTypeBXH == "2" {
//            self.addSubview(buttonLike)
//            self.addSubview(buttonShare)
//            self.addSubview(buttonDownload)
        }
    }
}

@available(iOS 8.0, *)
extension DataViewBxhID : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 43
    }
}

extension DataViewBxhID : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-------------------" + String(list_id_song.count) + "-------------------")
        if AppsSettings.idTypeBXH == "1" {
            print("this is sizeeee: " + String(list_linkUrl_song.count))
            return list_linkUrl_song.count
        } else if AppsSettings.idTypeBXH == "2" {
            return list_id_playList.count
        } else {
            return list_linkUrl_video.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableList.dequeueReusableCell(withIdentifier: DataTableViewCellListSong.identifier) as! DataTableViewCellListSong
        cell.textTitleSong.textColor = UIColor(hex: "000000")
        cell.textTitleAuthor.textColor = UIColor(hex: "000000")
        cell.textCountListen.textColor = UIColor(hex: "000000")
        if AppsSettings.idTypeBXH == "1" {
            let data = DataTableViewCellListSongData(id_Song: list_id_song[indexPath.row] ,title_Song: list_title_song[indexPath.row], title_Author: list_artistName_song[indexPath.row], count_Listen: list_counter_song[indexPath.row] , link_url: list_linkUrl_song[indexPath.row] , image_Song: list_image_song[indexPath.row] , description_Song: list_description_song[indexPath.row])
            
            cell.setData(data)
            AppsSettings.btnDownloadMusic = UIButton()
            AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
            AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
            AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewBxhID.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
            AppsSettings.btnDownloadMusic.tag = indexPath.row
            cell.addSubview(AppsSettings.btnDownloadMusic)
            
            return cell
        }
        else if AppsSettings.idTypeBXH == "2" {
            let data = DataTableViewCellListSongData(id_Song: list_id_playList[indexPath.row] ,title_Song: list_title_playList[indexPath.row], title_Author: "", count_Listen: list_count_listen[indexPath.row] , link_url: "" , image_Song: list_image_playList[indexPath.row] , description_Song: "")
            cell.setData(data)
            AppsSettings.btnDownloadMusic = UIButton()
            AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
            AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
            AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewBxhID.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
            AppsSettings.btnDownloadMusic.tag = indexPath.row
            cell.addSubview(AppsSettings.btnDownloadMusic)
            
            return cell
        }
            else {
            
            print("this list video: " + String(list_id_video.count) + String(list_title_video.count) + String(list_artistName_video.count) + String(list_counter_video.count) + String(list_linkUrl_video.count))
            let data = DataTableViewCellListSongData(id_Song: list_id_video[indexPath.row] ,title_Song: list_title_video[indexPath.row], title_Author: list_artistName_video[indexPath.row], count_Listen: list_counter_video[indexPath.row] , link_url: list_linkUrl_video[indexPath.row] , image_Song: "" , description_Song: "")
            cell.setData(data)
            AppsSettings.btnDownloadMusic = UIButton()
            AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
            AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
            AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewBxhID.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
            AppsSettings.btnDownloadMusic.tag = indexPath.row
            cell.addSubview(AppsSettings.btnDownloadMusic)
            
            return cell
        }

        
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
        if AppsSettings.idTypeBXH == "1" {
            AppsSettings.list_song_object.removeAll()
            AppsSettings.tittle_Song_Drive = list_title_song[indexPath.row]
            print("Song " + list_linkUrl_song[indexPath.row])
            //AppsSettings.linkUrlSong = list_linkUrl_song[indexPath.row]
            AppsSettings.position = indexPath.row
            AppsSettings.list_url_song = list_linkUrl_song
            AppsSettings.list_title_song = list_title_and_author_song
            AppsSettings.isCheckedButtonPlay = true
            //AppsSettings.idSong = list_id_song[indexPath.row]
//            var song = Song()
//            song.idSong = list_id_song[indexPath.row]
//            AppsSettings.root.updateCountSong(song.idSong)
//            
//            list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
//            tableView.reloadData()
            AppsSettings.root.updateCountSong(list_id_song[indexPath.row])
            list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
            AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
            for i in 0..<3
            {
                AppsSettings.list_song_object.append(listSongBXH[i])
            }
            tableView.reloadData()
            //AppsSettings.textNameSong.text = list_title_song[indexPath.row]
        }else if AppsSettings.idTypeBXH == "2" {
            AppsSettings.originTime.invalidate()
            AppsSettings.idPlayList = list_id_playList[indexPath.row]
            AppsSettings.imagePlayList = list_image_playList[indexPath.row]
            AppsSettings.titlePlayList = list_title_playList[indexPath.row]
            AppsSettings.turncount = list_count_listen[indexPath.row]
            
            AppsSettings.root.updatePlaylist(list_id_playList[indexPath.row])
            list_count_listen[indexPath.row] = String(Int(list_count_listen[indexPath.row])! + 1)
            tableView.reloadData()
            createViewPlayListId()
        }else {
            AppsSettings.playAudio?.pause()
            AppsSettings.isCheckedButtonPlay = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let alertsAnFavoritesController = storyboard.instantiateViewController(withIdentifier: "PlayVideoController") as! PlayVideoController
            AppsSettings.root.navigationController?.pushViewController(alertsAnFavoritesController, animated: true)
            thamsotruyen.set(String(list_linkUrl_video[indexPath.row]), forKey: "linkUrlVideo")
            
            AppsSettings.root.updateVideo(list_id_video[indexPath.row])
//            list_count_screen[indexPath.row] = String(Int(list_count_screen[indexPath.row])! + 1)
            tableView.reloadData()
            print("link url video" + list_linkUrl_video[indexPath.row])
        }
    }

}
