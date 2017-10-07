//
//  DataViewBaiHat.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewBaiHat: UIView {
    
    //khai bao bien UIView
    var textObject: UILabel!
    var textMoiAndHot: UIButton!
    var textNhacTre: UIButton!
    var textTruTinh: UIButton!
    var textDropdown: UIButton!
    var listTypeSongHorizontal: UICollectionView!
    
    //khai bao bien doi tượng
    var tableViewListSong: UITableView!
    var list_id_song: [String]! = []
    var list_image_song: [String]! = []
    var list_title_song: [String]! = []
    var list_artistName_song: [String]! = []
    var list_counter_song: [String]! = []
    var list_description_song: [String]! = []
    var list_lyric_song: [String]! = []
    var list_linkUrl_song: [String]! = []
    var list_title_and_author_song: [String]! = []
    var list_type: [String]! = []
    var song: Song!
    var list_song: [Song]! = []
    var idChoose: Int!
    var checkOpen: Bool! = false
    override func awakeFromNib() {
        createInterface()
//        listTypeSongHorizontal.removeFromSuperview()
        song = Song()
//        AppsSettings.listSong.removeAll()
//        AppsSettings.list_url_song.removeAll()
//        AppsSettings.list_title_song.removeAll()
        tableViewListSong.delegate = self
        tableViewListSong.dataSource = self
        textObject.text = "បទយុវវ័យ"
        textObject.textColor = UIColor(hex: "00C8CD")
//        parceApi()
        parceApi(String(AppsSettings.listType[0].idtype))
    }
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(listTypeSongHorizontal != nil){
            listTypeSongHorizontal.removeFromSuperview()
            listTypeSongHorizontal.removeFromSuperview()
        }
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if listTypeSongHorizontal != nil {
            listTypeSongHorizontal.removeFromSuperview()
        }
    }
    
    /**********************************************
    hàm parce api tất cả danh sach bài hát
    **********************************************/
    func parceApi(){
        song = Song()
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListSong("api/listsong",song:song, success: {(response) -> Void in
            self.list_song = response.items
            AppsSettings.listSong = []
            AppsSettings.listSong = response.items
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
                    }else{
                        self.list_artistName_song.append("")
                    }
                    
                    if self.song.counter != nil{
                        self.list_counter_song.append(self.song.counter)
                    }else{
                        self.list_counter_song.append("")
                    }
                    
                    if self.song.descriPtion != nil {
                        self.list_description_song.append(self.song.descriPtion)
                    }else{
                        self.list_description_song.append("")
                    }
                    if self.song.lyric != nil{
                        self.list_lyric_song.append(self.song.lyric)
                    }else{
                        self.list_lyric_song.append("")
                    }
                    
                    if self.song.linkUrl != nil && self.song.linkUrl != ""{
                        self.list_linkUrl_song.append(self.song.linkUrl!)
                        
                    }else {
                        self.list_linkUrl_song.append("")
                    }
                    if self.song.title != nil && self.song.artistname != nil{
                        self.list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                    }else{
                        self.list_title_and_author_song.append("")
                    }
                    
                }
            }
            self.tableViewListSong.reloadData()
            //print(AppsSettings.listSong.count)
            }) { (error) -> Void in
        }
    }
    
    
    /**********************************************
    hàm parce api theo thể loại bài hát
    **********************************************/
    func parceApi(_ idTypeSong: String!){
        AppsSettings.listSong = []
        self.list_song.removeAll()
        AppsSettings.listSong.removeAll()
        self.list_id_song.removeAll()
        self.list_image_song.removeAll()
        self.list_artistName_song.removeAll()
        self.list_counter_song.removeAll()
        self.list_description_song.removeAll()
        self.list_linkUrl_song.removeAll()
        self.list_title_and_author_song.removeAll()
        self.list_title_song = []
        song = Song()
        song.idTypeSong = idTypeSong
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListSong("api/findsongbyidtype",song:song, success: {(response) -> Void in
            self.list_song = response.items
            AppsSettings.listSong = response.items
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
                    }else{
                        self.list_description_song.append("")
                    }
                    
                    if self.song.lyric != nil{
                        self.list_lyric_song.append(self.song.lyric)
                    }else{
                        self.list_lyric_song.append("")
                    }
                    
                    if self.song.linkUrl != nil && self.song.linkUrl != ""{
                        if self.song.linkUrl != nil{
                        self.list_linkUrl_song.append(self.song.linkUrl!)
                        }
                    }else {
                        if self.song.filepath != nil{
                        self.list_linkUrl_song.append(self.song.filepath)
                        }
                    }
                    if self.song.title != nil && self.song.artistname != nil{
                        self.list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                    }else {
                        self.list_artistName_song.append("")
                    }
                    
                    
                }
            }
            
//            print("list: " + String(self.list_id_song) + String(self.list_title_song))
            
            self.tableViewListSong.reloadData()
            //print(AppsSettings.listSong.count)
            }) { (error) -> Void in
            self.tableViewListSong.reloadData()
        }
    }
    
    /**********************************************
    hàm xet sự kiện khi click vào các nút button
    **********************************************/
    func actionEven(_ sender:UIButton) {
        idChoose = sender.tag
        if idChoose == 1 {
            textObject.text = AppsSettings.listType[0].nametype
            textObject.textColor = UIColor(hex: "00C8CD")
            textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            parceApi(String(AppsSettings.listType[0].idtype))
            
        }else if idChoose == 2 {
            textObject.text = AppsSettings.listType[1].nametype
            textObject.textColor = UIColor(hex: "00C8CD")
            textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            parceApi(String(AppsSettings.listType[1].idtype))
        }else if idChoose == 3 {
            textObject.text = AppsSettings.listType[2].nametype
            textObject.textColor = UIColor(hex: "00C8CD")
            textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            parceApi(String(AppsSettings.listType[2].idtype))
        }else if idChoose == 4 {
            if listTypeSongHorizontal != nil {
                listTypeSongHorizontal.removeFromSuperview()
            }
            if checkOpen == false{
                createTableViewListChooseTypeSong()
            }else{
                checkOpen = false
                self.listTypeSongHorizontal.removeFromSuperview()
            }
            
        }
    }
    
    /**********************************************
    hàm tao giao diện view chọn thể loại bài hát
    **********************************************/
    func createTableViewListChooseTypeSong(){
        checkOpen = true
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 85 * ScreenSize.MUL_WIDTH , height: 28 * ScreenSize.MUL_HEIGHT)
        //layoutPlayList.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.listTypeSongHorizontal = UICollectionView(frame: CGRect(x: 0 * ScreenSize.MUL_WIDTH , y: 27 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 80 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.listTypeSongHorizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellType.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellType", bundle:nil)
        self.listTypeSongHorizontal.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellType.identifier)
        self.listTypeSongHorizontal.isPagingEnabled = true
        self.listTypeSongHorizontal.backgroundColor = UIColor(hex: "030303")
        self.addSubview(listTypeSongHorizontal)
        
        listTypeSongHorizontal.delegate = self
        listTypeSongHorizontal.dataSource = self
    }
    
    
    /**********************************************
    hàm tao giao diện
    **********************************************/
    func createInterface(){
        textObject = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y: ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 18))
        textObject.font = UIFont.font65Medium(13)
        textObject.textColor = UIColor(hex: "FFFFFF")
        
        textMoiAndHot = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 156, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 73, height: ScreenSize.MUL_HEIGHT * 28))
        textMoiAndHot.setTitle(AppsSettings.listType[0].nametype, for: UIControlState())
        textMoiAndHot.setTitleColor(UIColor.white, for: UIControlState())
        textMoiAndHot.titleLabel?.font = UIFont.font65Medium(13)
        textMoiAndHot.addTarget(self, action: #selector(DataViewBaiHat.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textMoiAndHot.tag = 1
        
        textNhacTre = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 241, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 62, height: ScreenSize.MUL_HEIGHT * 28))
        textNhacTre.setTitle(AppsSettings.listType[1].nametype, for: UIControlState())
        textNhacTre.setTitleColor(UIColor.white, for: UIControlState())
        textNhacTre.titleLabel?.font = UIFont.font65Medium(13)
        textNhacTre.addTarget(self, action: #selector(DataViewBaiHat.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textNhacTre.tag = 2
        
        textTruTinh = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 315, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 54, height: ScreenSize.MUL_HEIGHT * 28))
        textTruTinh.setTitle(AppsSettings.listType[2].nametype, for: UIControlState())
        textTruTinh.setTitleColor(UIColor.white, for: UIControlState())
        textTruTinh.titleLabel?.font = UIFont.font65Medium(13)
        textTruTinh.addTarget(self, action: #selector(DataViewBaiHat.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textTruTinh.tag = 3
        
        
        let imageN = UIImage(named: "btn_choose.png") as UIImage?
        textDropdown = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 360, y: ScreenSize.MUL_HEIGHT * 1, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 28))
        textDropdown.titleLabel?.font = UIFont.font65Medium(13)
        textDropdown.setTitle("ផ្សេងៗ", for: UIControlState())
        textDropdown.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, -3.0, 0.0);
        textDropdown.setImage(imageN, for: UIControlState())
        textDropdown.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        textDropdown.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        textDropdown.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        textDropdown.addTarget(self, action: #selector(DataViewBaiHat.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textDropdown.tag = 4
        
        self.tableViewListSong = UITableView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 35, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 230))
        tableViewListSong.backgroundColor = UIColor.clear
        self.tableViewListSong.registerCellNib(DataTableViewCellListSong.self)
        
        self.addSubview(textObject)
        self.addSubview(textMoiAndHot)
        self.addSubview(textNhacTre)
        self.addSubview(textTruTinh)
        self.addSubview(textDropdown)
        self.addSubview(tableViewListSong)
    }
}
extension DataViewBaiHat : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 43
    }
}

extension DataViewBaiHat : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_linkUrl_song.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewListSong.dequeueReusableCell(withIdentifier: DataTableViewCellListSong.identifier) as! DataTableViewCellListSong
        
        
        
//        print("this list video: " + String(list_id_song.count) + String(list_title_song.count) + String(list_artistName_song.count) + String(list_counter_song.count) + String(list_linkUrl_video.count))
        let data = DataTableViewCellListSongData(id_Song: list_id_song[indexPath.row] ,title_Song: list_title_song[indexPath.row], title_Author: list_artistName_song[indexPath.row], count_Listen: list_counter_song[indexPath.row] , link_url: list_linkUrl_song[indexPath.row] , image_Song: list_image_song[indexPath.row] , description_Song: list_description_song[indexPath.row])
        cell.setData(data)
        AppsSettings.btnDownloadMusic = UIButton()
        AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
        AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
        AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewBaiHat.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
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
        
        AppsSettings.list_song_object.removeAll()
        for i in 0..<list_song.count
        {
            AppsSettings.list_song_object.append(list_song[i])
        }
        if(listTypeSongHorizontal != nil){
            listTypeSongHorizontal.isHidden = true
        }
        AppsSettings.originTime.invalidate()
        AppsSettings.position = indexPath.row
        AppsSettings.list_url_song = list_linkUrl_song
        AppsSettings.list_title_song = list_title_and_author_song
        AppsSettings.isCheckedButtonPlay = true
        //AppsSettings.checkListenLocal == false
        //AppsSettings.idSong = list_id_song[indexPath.row]
        AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
        AppsSettings.tittle_Song_Drive = list_title_song[indexPath.row]
        var song = Song()
        song.idSong = list_id_song[indexPath.row]
        AppsSettings.root.updateCountSong(song.idSong)
        
        list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
        tableView.reloadData()
        
    }
}


extension DataViewBaiHat : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension DataViewBaiHat : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppsSettings.listType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listTypeSongHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellType.identifier, for: indexPath) as! DataUICollectionViewCellType
        let data = DataUICollectionViewCellTypeData(name_Type: AppsSettings.listType[indexPath.row].nametype)
        cell.setData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
        textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
        textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
        textObject.textColor = UIColor(hex: "00C8CD")
        textObject.text = AppsSettings.listType[indexPath.row].nametype
        
        parceApi(String(Int(AppsSettings.listType[indexPath.row].idtype)))
        listTypeSongHorizontal.removeFromSuperview()
    }
    
}
