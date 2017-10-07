//
//  DataViewHome.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/6/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

@available(iOS 8.0, *)



class DataViewHome: UIView {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
//    var coinSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("coin", ofType: "wav")!)
//    var audioPlayer = AVAudioPlayer()
    var preferences = UserDefaults.standard
    //khai bao doi tuong
    var playList: PlayList!
    var video: VideoVideo!
    var song: Song!
    var listsong: [Song]!
    var thamsotruyen:UserDefaults!
    var dataHome: DataHome!
    
    
    //khai bao UIView
    var collectionView_Image_Horizontal: UICollectionView!
    var titlePlayList: UIImageView!
    var collectionView_play_list_Horizontal: UICollectionView!
    var titleVideo: UIImageView!
    var collectionView_video_Horizontal: UICollectionView!
    var titleSong: UIImageView!
    var tableViewListSong: UITableView!
    var dimBackgroundColor = UIView()
    var titleListSongHorizontal: UIImageView!
    //khai bao bien
    var list_image: [String]! = []
    var list_image_playList: [String]! = []
    var list_title_playList: [String]! = []
    var list_author_playList: [String]! = []
    var list_count_listen: [String]! = []
    var list_id_playList: [String]! = []
    
    //bien list video
    var list_image_video: [String]! = []
    var list_title_video: [String]! = []
    var list_linkUrl_video: [String]! = []
    var list_id_video: [String]! = []
    var list_counter_video: [String]! = []
    var list_artistName_video: [String]! = []
    
    //bien list song
    var list_image_song: [String]! = []
    var list_title_song: [String]! = []
    var list_linkUrl_song: [String]! = []
    var list_id_song: [String]! = []
    var list_counter_song: [String]! = []
    var list_artistName_song: [String]! = []
    var list_description_song: [String]! = []
    var list_lyric_song: [String]! = []
    var list_title_and_author_song: [String]! = []
    
    
    //bien playListByID
    var viewPlayListByID: DataViewPlayListByID!
    var buttonOpenOrClose: UIButton!
    
    override func awakeFromNib() {
        
        
        
        createInterface()
        playList = PlayList()
        video = VideoVideo()
        song = Song()
        dataHome = DataHome()
        AppsSettings.list_url_song.removeAll()
        AppsSettings.list_title_song.removeAll()
        
        thamsotruyen = UserDefaults()
        
        collectionView_Image_Horizontal.delegate = self
        collectionView_Image_Horizontal.dataSource = self
        
        collectionView_play_list_Horizontal.delegate = self
        collectionView_play_list_Horizontal.dataSource = self
        
        collectionView_video_Horizontal.delegate = self
        collectionView_video_Horizontal.dataSource = self
        
        tableViewListSong.delegate = self
        tableViewListSong.dataSource = self

        
        if AppsSettings.listPlayList.count > 0 {
            for i in 0  ..< AppsSettings.listPlayList.count - 1 
            {
                for j in i+1  ..< AppsSettings.listPlayList.count 
                {
                    if Int(AppsSettings.listPlayList[i].counter) < Int(AppsSettings.listPlayList[j].counter)
                    {
                        let temp = AppsSettings.listPlayList[i]
                        AppsSettings.listPlayList[i] = AppsSettings.listPlayList[j]
                        AppsSettings.listPlayList[j] = temp
                    }
                }
            }
            
            for i in 0  ..< AppsSettings.listPlayList.count {
                if i < 10
                {
                self.playList = AppsSettings.listPlayList[i]
                list_title_playList.append(self.playList.title)
                list_count_listen.append(String(self.playList.counter))
                if self.playList.image != nil {
                    let link_image = AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/" + self.playList.image
                    list_image_playList.append(link_image)
                }
                list_id_playList.append(self.playList.idplaylist)
            } else
                {
                    print("not good")
                }
            }
        }
        
        if AppsSettings.listVideo.count > 0 {
            for i in 0  ..< AppsSettings.listVideo.count - 1 
            {
                for j in i+1  ..< AppsSettings.listVideo.count 
                {
                    if Int(AppsSettings.listVideo[i].counter) < Int(AppsSettings.listVideo[j].counter)
                    {
                        let temp = AppsSettings.listVideo[i]
                        AppsSettings.listVideo[i] = AppsSettings.listVideo[j]
                        AppsSettings.listVideo[j] = temp
                    }
                }
            }

            for i in 0  ..< AppsSettings.listVideo.count {
                if i<10
                {
                self.video = AppsSettings.listVideo[i]
                list_id_video.append(self.video.idVideo)
                list_title_video.append(self.video.title)
                if self.video.image != nil {
                    let link_image = AppsSettings.Static.BASE_IMAGE_URL + "videos/tb/" + self.video.image
                    list_image_video.append(link_image)
                }
                if self.video.linkUrl != nil && self.video.linkUrl != ""{
                    list_linkUrl_video.append(self.video.linkUrl!)
                }else if self.video.filepath != nil {
                    list_linkUrl_video.append(self.video.filepath)
                }
                list_counter_video.append(self.video.counter)
                list_artistName_video.append(self.video.artistname)
            } else
                {
                    print("notgood2")
                }
        }
        }
        
            if AppsSettings.listSong.count > 0 {
                for i in 0  ..< AppsSettings.listSong.count - 1 
                {
                    for j in i+1  ..< AppsSettings.listSong.count 
                    {
                        if Int(AppsSettings.listSong[i].counter) < Int(AppsSettings.listSong[j].counter)
                        {
                            let temp = AppsSettings.listSong[i]
                            AppsSettings.listSong[i] = AppsSettings.listSong[j]
                            AppsSettings.listSong[j] = temp
                        }
                    }
                }
                listsong = AppsSettings.listSong
                for i in 0  ..< AppsSettings.listSong.count {
                    self.song = AppsSettings.listSong[i]
                    if self.song.idSong != nil{
                        list_id_song.append(self.song.idSong)
                    }else{
                        list_id_song.append("")
                    }
                    
                    
                    if self.song.image != nil {
                        list_image_song.append(self.song.image)
                    }else{
                        list_image_song.append("")
                    }
                    
                    if self.song.title != nil{
                        list_title_song.append(self.song.title)
                    }else{
                        list_title_song.append("")
                    }
                    
                    if self.song.artistname != nil{
                        list_artistName_song.append(self.song.artistname)
                    }else{
                        list_artistName_song.append("")
                    }
                    
                    if self.song.counter != nil{
                        list_counter_song.append(self.song.counter)
                    }else{
                        list_counter_song.append("")
                    }
                    
                    
                    if self.song.descriPtion.characters.count > 0 {
                        list_description_song.append(self.song.descriPtion)
                    }else{
                        list_description_song.append("")
                    }
                    if self.song.lyric.characters.count > 0 {
                        list_lyric_song.append(self.song.lyric)
                    }else{
                        list_lyric_song.append("")
                    }
                    if self.song.linkUrl != nil && self.song.linkUrl != ""{
                        list_linkUrl_song.append(self.song.linkUrl!)
                    }else if self.song.filepath != nil {
                        list_linkUrl_song.append(self.song.filepath)
                    }else if self.song.linkUrl != nil && self.song.filepath == nil {
                        list_linkUrl_song.append("")
                    }
                    if self.song.title != nil && self.song.artistname != nil{
                        list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                    }else {
                        list_title_and_author_song.append("")
                    }
                }
                
                print("list_linkUrl_song  " + String(describing: list_linkUrl_song))
                AppsSettings.list_url_custom_download = list_linkUrl_song
                AppsSettings.list_title_customDownload = list_title_song
            }
    }
    
    
    /***********************************************
    ham tao giao dien
    ************************************************/
    func createInterface(){
        scrollView.contentSize.height = 690 * ScreenSize.MUL_HEIGHT
        //tao list image button scroll horizontal
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 80 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        
        
        
        self.titleListSongHorizontal = UIImageView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 5 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        self.titleListSongHorizontal.image = UIImage(named: "topbaihat.png")
        var topbaihat = UILabel(frame: CGRect(x: 5, y: ScreenSize.MUL_HEIGHT * 5 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        topbaihat.text = "បទចំរៀងល្បីជាងគេ"
        topbaihat.textColor = UIColor.white
        topbaihat.font = UIFont.font65Medium(10)
        scrollView.addSubview(topbaihat)
        
        self.collectionView_Image_Horizontal = UICollectionView(frame: CGRect(x: 0 , y: 20 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 110 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layout)
        self.collectionView_Image_Horizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellImage.identifier)
        let nipName=UINib(nibName: "DataUICollectionViewCellImage", bundle:nil)
        self.collectionView_Image_Horizontal.register(nipName, forCellWithReuseIdentifier: DataUICollectionViewCellImage.identifier)
        self.collectionView_Image_Horizontal.isPagingEnabled = true
        self.collectionView_Image_Horizontal.backgroundColor = UIColor.clear
        self.collectionView_Image_Horizontal.alwaysBounceHorizontal = false
//        gggg
        self.titlePlayList = UIImageView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 145 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        self.titlePlayList.image = UIImage(named: "titleplaylist.png")
        var titleplaylist = UILabel(frame: CGRect(x: 5, y: ScreenSize.MUL_HEIGHT * 145 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        titleplaylist.text = "បញ្ជីបទចំរៀង"
        titleplaylist.textColor = UIColor.white
        titleplaylist.font = UIFont.font65Medium(10)
        scrollView.addSubview(titleplaylist)
        //tao list play list scroll horizontal
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 80 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        layoutPlayList.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        
        self.collectionView_play_list_Horizontal = UICollectionView(frame: CGRect(x: 0 , y: 165 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 110 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.collectionView_play_list_Horizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.collectionView_play_list_Horizontal.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.collectionView_play_list_Horizontal.isPagingEnabled = true
        self.collectionView_play_list_Horizontal.backgroundColor = UIColor.clear
        
        self.titleVideo = UIImageView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 290 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        self.titleVideo.image = UIImage(named: "titlevidoe.png")
        var titlevideo = UILabel(frame: CGRect(x: 5, y: ScreenSize.MUL_HEIGHT * 290 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        titlevideo.text = "វីឌីអូ"
        titlevideo.textColor = UIColor.white
        titlevideo.font = UIFont.font65Medium(10)
        scrollView.addSubview(titlevideo)

        
        
        //tao list video scroll horizontal
        let layoutVideo: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutVideo.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutVideo.itemSize = CGSize(width: 80 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        layoutVideo.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.collectionView_video_Horizontal = UICollectionView(frame: CGRect(x: 0 , y: 310 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 130 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutVideo)
        self.collectionView_video_Horizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNameVideo=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.collectionView_video_Horizontal.register(nipNameVideo, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.collectionView_video_Horizontal.isPagingEnabled = true
        self.collectionView_video_Horizontal.backgroundColor = UIColor.clear
        
        self.titleSong = UIImageView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 445 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        self.titleSong.image = UIImage(named: "titlesong.png")
        var titlesong = UILabel(frame: CGRect(x: 5, y: ScreenSize.MUL_HEIGHT * 445 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 13 ))
        titlesong.text = "បទចំរៀង"
        titlesong.textColor = UIColor.white
        titlesong.font = UIFont.font65Medium(10)
        scrollView.addSubview(titlesong)
        
        
        //tao list table song
        self.tableViewListSong = UITableView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 465, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 230))
        tableViewListSong.backgroundColor = UIColor.clear
        self.tableViewListSong.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableViewListSong.registerCellNib(DataTableViewCellListSong.self)
        
        
        
        scrollView.addSubview(titlePlayList)
        scrollView.addSubview(collectionView_play_list_Horizontal)
        scrollView.addSubview(titleVideo)
        scrollView.addSubview(collectionView_video_Horizontal)
        scrollView.addSubview(titleSong)
        scrollView.addSubview(tableViewListSong)
        scrollView.addSubview(titleListSongHorizontal)
        scrollView.addSubview(collectionView_Image_Horizontal)
        
    }
    
    /***********************************************
    ham tao giao dien view cho playList Id
    ************************************************/
    func createViewPlayListId(){

        self.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 250))
        dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        dimBackgroundColor.alpha=0.5
        
        buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 55, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
        buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewHome.actionEven), for: UIControlEvents.touchUpInside)
        
        viewPlayListByID = DataViewPlayListByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
    }
    
    
    /***********************************************
    xet su kien khi click vao button dong mo playList
    ************************************************/
    func actionEven(){
        self.dimBackgroundColor.removeFromSuperview()
        viewPlayListByID.removeFromSuperview()
        buttonOpenOrClose.removeFromSuperview()
    }

}


@available(iOS 8.0, *)
extension DataViewHome : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 43
    }
}

extension DataViewHome : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_id_song.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewListSong.dequeueReusableCell(withIdentifier: DataTableViewCellListSong.identifier) as! DataTableViewCellListSong
        let data = DataTableViewCellListSongData(id_Song: list_id_song[indexPath.row] ,title_Song: list_title_song[indexPath.row], title_Author: list_artistName_song[indexPath.row], count_Listen: list_counter_song[indexPath.row] , link_url: list_linkUrl_song[indexPath.row] , image_Song: list_image_song[indexPath.row] , description_Song: list_description_song[indexPath.row])
        cell.setData(data)
        AppsSettings.btnDownloadMusic = UIButton()
        AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
        AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
        AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewHome.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
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

//An vao mot bai hat trong danh sach bai hat
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        AppsSettings.tittle_Song_Drive = list_title_song[indexPath.row]
        AppsSettings.originTime.invalidate()
        //AppsSettings.list_song_object.removeAll()
        AppsSettings.list_song_object.removeAll()
        for i in 0..<listsong.count
        {
            AppsSettings.list_song_object.append(listsong[i])
        }
        if list_image_song[indexPath.row].characters.count > 0 {
            print(list_image_song[indexPath.row])
            if list_image_song[indexPath.row] != ""
            {
                let url = AppsSettings.Static.BASE_IMAGE_URL + list_image_song[indexPath.row]
                //AppsSettings.imageSong.imageFromUrl(url)
                AppsSettings.imageSong.sd_setImage(with: URL(string: url), placeholderImage: nil)
            }
            else
            {
             AppsSettings.imageSong.image = UIImage(named: "down")
            }
        }else{
            AppsSettings.imageSong.image = UIImage(named: "down")
        }
        AppsSettings.checkListenLocal = true
        AppsSettings.position = indexPath.row
        AppsSettings.list_url_song.removeAll()
        AppsSettings.list_title_song.removeAll()
        AppsSettings.list_id_song.removeAll()
        AppsSettings.list_url_song = list_linkUrl_song
        AppsSettings.list_title_song = list_title_and_author_song
        AppsSettings.list_id_song = list_id_song
        AppsSettings.isCheckedButtonPlay = true
        if list_linkUrl_song[indexPath.row].characters.count > 0 {
            print(list_linkUrl_song[indexPath.row])
            AppsSettings.idSong = list_id_song[indexPath.row]
            AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
        }else{
            UIToast.makeText("កំហុសផ្លូវចម្រៀង").show()
        }
//        AppsSettings.idSong = AppsSettings.list_id_song[indexPath.row]
        var song = Song()
        song.idSong = list_id_song[indexPath.row]
        AppsSettings.root.updateCountSong(song.idSong)
        
        list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
        tableView.reloadData()
    }
}

@available(iOS 8.0, *)
extension DataViewHome : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}
extension DataViewHome : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionView_Image_Horizontal{
            
            return list_id_song.count
            //return 10
        }else if collectionView == collectionView_play_list_Horizontal {
            
            return list_id_playList.count
        }else {
            
            return list_id_video.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionView_Image_Horizontal {
            let cell = self.collectionView_Image_Horizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellImage.identifier, for: indexPath) as! DataUICollectionViewCellImage
            
            if list_image_song != [] && list_title_song != [] && list_counter_song != []{
                let data = DataUICollectionViewCellImageData(image_Name: list_image_song[indexPath.row], songName: list_title_song[indexPath.row], songListenCount: list_counter_song[indexPath.row])
                cell.setData(data)
            }
            return cell
            
        }else if collectionView == collectionView_play_list_Horizontal {
            let cell = self.collectionView_play_list_Horizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
            let data = DataUICollectionViewCellPlayListData(image_Song: list_image_playList[indexPath.row], text_Count_Listen: list_count_listen[indexPath.row], text_Title_PlayList: list_title_playList[indexPath.row], text_Author: "")
            print("PlayList " + String(list_image_playList[indexPath.row]))
            print("day ne")
            cell.setData(data)
            return cell
        }else {
            let cell = self.collectionView_video_Horizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
            let data = DataUICollectionViewCellPlayListData(image_Song: list_image_video[indexPath.row], text_Count_Listen: list_counter_video[indexPath.row], text_Title_PlayList: list_title_video[indexPath.row], text_Author: list_artistName_video[indexPath.row])
            print("Video " + list_image_video[indexPath.row])
            cell.setData(data)
            return cell
        }
    }
//An vao CollectionView
// UC 1.1.1
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionView_Image_Horizontal {
            AppsSettings.list_song_object.removeAll()
            for i in 0..<listsong.count
            {
                AppsSettings.list_song_object.append(listsong[i])
            }
            AppsSettings.originTime.invalidate()
            print("Image " + String(indexPath.row))
            print("link url:" + list_linkUrl_song[indexPath.row])
            print("id song la: " + list_id_song[indexPath.row])
            AppsSettings.tittle_Song_Drive = list_title_song[indexPath.row]
            AppsSettings.checkListenLocal = true
            AppsSettings.position = indexPath.row
            AppsSettings.list_url_song.removeAll()
            AppsSettings.list_title_song.removeAll()
            AppsSettings.list_id_song.removeAll()
            AppsSettings.list_url_song = list_linkUrl_song
            AppsSettings.list_title_song = list_title_and_author_song
            AppsSettings.list_id_song = list_id_song
            AppsSettings.isCheckedButtonPlay = true
            
            if list_linkUrl_song[indexPath.row].characters.count > 0 {
                print(list_linkUrl_song[indexPath.row])
                AppsSettings.idSong = list_id_song[indexPath.row]
                AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
            }else{
                UIToast.makeText("កំហុសផ្លូវចម្រៀង").show()
            }
            var song = Song()
            song.idSong = list_id_song[indexPath.row]
            AppsSettings.root.updateCountSong(song.idSong)
            
            list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
            collectionView.reloadData()
            
        }else if collectionView == collectionView_play_list_Horizontal {
            AppsSettings.checkClickPlaylist = 1
            AppsSettings.checkClickMyPlaylist = true
            print("PlayList " + String(list_image_playList[indexPath.row]))
            print(list_id_playList[indexPath.row])
            AppsSettings.idPlayList = list_id_playList[indexPath.row]
            AppsSettings.titlePlayList = list_title_playList[indexPath.row]
            
            //Update counter Playlist
            AppsSettings.root.updatePlaylist(list_id_playList[indexPath.row])
            list_count_listen[indexPath.row] = String(Int(list_count_listen[indexPath.row])! + 1)
            
            if list_image_playList[indexPath.row] != AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/"
            {
                AppsSettings.imagePlayList = list_image_playList[indexPath.row]
            }
            else
            {
                 AppsSettings.imagePlayList = nil
            }
            AppsSettings.turncount = list_count_listen[indexPath.row]
            //print("appsetting la", AppsSettings.imagePlayList)
            createViewPlayListId()
            collectionView.reloadData()
        }else {
            print("Video " + String(list_linkUrl_video[indexPath.row]))
            print("id cua video tim dc la: " + list_id_video[indexPath.row])
            
            //Update counter Playlist
            AppsSettings.root.updateVideo(list_id_video[indexPath.row])
            list_counter_video[indexPath.row] = String(Int(list_counter_video[indexPath.row])! + 1)
            
            AppsSettings.playAudio?.pause()
            AppsSettings.isCheckedButtonPlay = false
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let alertsAnFavoritesController = storyboard.instantiateViewController(withIdentifier: "PlayVideoController") as! PlayVideoController
            AppsSettings.root.navigationController?.pushViewController(alertsAnFavoritesController, animated: true)
            thamsotruyen.set(String(list_linkUrl_video[indexPath.row]), forKey: "linkUrlVideo")
            collectionView.reloadData()
        }
    }
}
