//
//  DataViewSearch.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewSearch: UIView , UISearchBarDelegate, UIScrollViewDelegate{

    var searchBar: UISearchBar!
    var tableDataSearch: UITableView!
    
    //khai bao list
    var list_image_all: [String]! = []
    var list_image_take_all: [String]! = []
    var list_title_all: [String]! = []
    var list_status: [String]! = []
    var list_url: [String]! = []
    var list_url_video: [String]! = []
    var list_url_play_list: [String]! = []
    var list_image_artist: [String]! = []
    var list_author_artist: [String]! = []
    
    //khai bao doi tuong
    var listVideoBXH: [VideoVideo]! = []
    var listSongBXH: [Song]! = []
    var listArtistBXH: [ArtistSearch]! = []
    var listPlayList: [PlayList]! = []
    var songBXH: Song!
    var playlist: PlayList!
    var videoBXH: VideoVideo!
    var artistBXH: ArtistSearch!
    var bangXepHang: BangXepHang!
    var idChoose: Int!
    
    var searchActive : Bool = false
    var filtered:[String] = []
    var thamsotruyen:UserDefaults!
    
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    var viewPlayListByID: DataViewArtistByID!
    
//    var artist: ArtistSearch!
//    var list_artist: [ArtistSearch]! = []
    
    override func awakeFromNib() {
        //searchBar.searchBarStyle = .Minimal
        
        createInterface()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
//        self.addGestureRecognizer(tap)
        searchBar.delegate = self
        thamsotruyen = UserDefaults()
//        tableDataSearch.hidden = true
    }

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(searchBar.text!.length > 0){
            AppsSettings.root.showActivityIndicator()
            searchActive = true;
            parceApi(searchBar.text)
            tableDataSearch.isHidden = false
        } else {
            searchActive = false;
            tableDataSearch.isHidden = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.dismissKeyboard()
    }
    
    /**************************************
    Hàm tao giao dien uiview
    ***************************************/
    func createInterface(){
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 30))
        searchBar.backgroundColor = UIColor.clear
        
        tableDataSearch = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 5 , y: ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 200))
        tableDataSearch.backgroundColor = UIColor.clear
        self.tableDataSearch.registerCellNib(DataTableViewCellListSearch.self)
        
        self.addSubview(searchBar)
        self.addSubview(tableDataSearch)
        
        tableDataSearch.delegate = self
        tableDataSearch.dataSource = self
        
    }
    /***************************************************
    Khoi tao View playListID
    ****************************************************/
    func createViewPlayListId(){
        //khoi tao view dim back ground
        self.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 250))
        dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        dimBackgroundColor.alpha=0.5
        
        buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 55, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
        buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewSearch.actionEven), for: UIControlEvents.touchUpInside)

        viewPlayListByID = DataViewArtistByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        
        
        
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
    }
    
    var isCheckedOpenOrClose: Bool = false {
        didSet{
            if isCheckedOpenOrClose == true {
                self.buttonOpenOrClose.setBackgroundImage(UIImage(named:"background_next.png"), for: UIControlState())
            } else {
                self.buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
            }
        }
    }
    
    
    /***************************************************
    xet su kien khi click vao button
    ****************************************************/
    func actionEven(){
        self.dimBackgroundColor.removeFromSuperview()
        viewPlayListByID.removeFromSuperview()
        buttonOpenOrClose.removeFromSuperview()
    }

    
    /**************************************
    Hàm parce api
    ***************************************/
    func parceApi(_ keySearch: String!){
        
        self.songBXH = Song()
        self.videoBXH = VideoVideo()
        self.artistBXH = ArtistSearch()
        self.list_image_all.removeAll()
        self.list_title_all.removeAll()
        self.listSongBXH.removeAll()
        self.listVideoBXH.removeAll()
        self.listArtistBXH.removeAll()
        
        list_status = []
        list_url = []
        bangXepHang = BangXepHang()
        bangXepHang.keySearch = keySearch
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getBangXepHang("api/search",bangXepHang: bangXepHang , success: { (response) -> Void in
            
            let a = response
            
            self.listSongBXH = a.listSong
            self.listVideoBXH = a.listVideo
            self.listArtistBXH = a.listArtistSearch
            
            if self.listVideoBXH.count > 0 {
                //self.list_url_video = []
                for i in 0..<self.listVideoBXH.count {
                    self.videoBXH = self.listVideoBXH[i]
                    self.list_title_all.append(self.videoBXH.title)
                    self.list_image_all.append("ic_video_search.png")
                    self.list_image_take_all.append(self.videoBXH.image)
                    self.list_status.append("2")
                    if self.videoBXH.linkUrl != nil && self.videoBXH.linkUrl != ""{
                        self.list_url.append(self.videoBXH.linkUrl!)
                    }else {
                        if self.videoBXH.filepath != nil{
                            self.list_url.append(self.videoBXH.filepath)
                        }
                    }
                }
            }
            
            if self.listSongBXH.count > 0 {
                for i in 0..<self.listSongBXH.count {
                    self.songBXH = self.listSongBXH[i]
                    self.list_title_all.append(self.songBXH.title)
                    self.list_image_all.append("ic_song_search.png")
                    self.list_image_take_all.append(self.songBXH.image)
                    self.list_status.append("1")
                    if self.songBXH.linkUrl != nil && self.songBXH.linkUrl != ""{
                        self.list_url.append(self.songBXH.linkUrl!)
                        
                    }else {
                        if self.songBXH.filepath != nil{
                        self.list_url.append(self.songBXH.filepath)
                        }
                    }
                }
            }
            
            if self.listArtistBXH.count > 0 {
                
                for i in 0..<self.listArtistBXH.count {
                    self.artistBXH = self.listArtistBXH[i]
                    self.list_title_all.append(self.artistBXH.artistname)
                    self.list_image_all.append("ic_avatar_artist.png")
                    self.list_image_take_all.append(self.artistBXH.image)
                    self.list_status.append("3")
                    self.list_url.append(String(self.artistBXH.idArtist))
                }
            }
            for i in 0..<self.list_image_all.count{
                print("cac anh:", self.list_image_all[i])
                print("cac ten:", self.list_title_all[i])
            }
           
            self.tableDataSearch.reloadData()
            AppsSettings.root.hideActivityIndicator()
            
            }) { (error) -> Void in
                AppsSettings.root.hideActivityIndicator()
                self.tableDataSearch.reloadData()
                self.dismissKeyboard()
        }
    }
    
}

extension DataViewSearch : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 23
    }
}

extension DataViewSearch : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            print("thi:" + String(self.list_title_all.count))
            return self.list_image_all.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableDataSearch.dequeueReusableCell(withIdentifier: DataTableViewCellListSearch.identifier) as! DataTableViewCellListSearch
        //if(searchActive){
            print("nha ra", indexPath.row)
            let data = DataTableViewCellListSearchData(title_Song: list_title_all[indexPath.row], image: list_image_all[indexPath.row])
            cell.setData(data)
        //}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if list_status[indexPath.row] == "1"{
            AppsSettings.linkSong = list_url[indexPath.row]
            AppsSettings.tittle_Song_Drive = list_title_all[indexPath.row]
            AppsSettings.idSong = listSongBXH[indexPath.row].idSong
            print("Song    " + list_url[indexPath.row])
            AppsSettings.list_title_song = []
            AppsSettings.list_url_song = []
            AppsSettings.originTime.invalidate()
            AppsSettings.position = 0
            AppsSettings.list_url_song = [list_url[indexPath.row]]
            AppsSettings.list_title_song = [list_title_all[indexPath.row]]
            AppsSettings.isCheckedButtonPlay = true
            AppsSettings.playMusic(list_url[indexPath.row] , titleSong: list_title_all[indexPath.row])
            dismissKeyboard()
        }else if list_status[indexPath.row] == "2" {
            AppsSettings.playAudio?.pause()
            AppsSettings.isCheckedButtonPlay = false
            thamsotruyen.set(String(list_url[indexPath.row]), forKey: "linkUrlVideo")
//            print("link url video" + list_url_video[indexPath.row])
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let alertsAnFavoritesController = storyboard.instantiateViewController(withIdentifier: "PlayVideoController") as! PlayVideoController
            AppsSettings.root.navigationController?.pushViewController(alertsAnFavoritesController, animated: true)
            
            dismissKeyboard()
        }else if list_status[indexPath.row] == "3" {
            //print("Artist  " + list_url[indexPath.row])
            AppsSettings.idArtist = list_url[indexPath.row]
            AppsSettings.titleArtist = list_title_all[indexPath.row]
            print("anh o day la ", list_image_take_all[indexPath.row])
            AppsSettings.imageArtits = AppsSettings.Static.BASE_IMAGE_URL + "/artists/tb/"+list_image_take_all[indexPath.row]
            createViewPlayListId()
            dismissKeyboard()
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
}
