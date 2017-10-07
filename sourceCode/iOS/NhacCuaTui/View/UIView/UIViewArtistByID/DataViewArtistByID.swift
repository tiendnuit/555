//
//  DataViewArtistByID.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/17/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewArtistByID: UIView {

    //khai bao UIView
    var imageViewHeader: UIImageView!
    var imageAvater: UIImageView!
    var nameArtist: UILabel!
    var descriptionArtist: UILabel!
    var buttonBaiHat: UIButton!
    var buttonPlayList: UIButton!
    var buttonVideo: UIButton!
    var tableList: UITableView!
    
    //khai bao bien
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
    
    
    override func awakeFromNib() {
        createInterface()
        
        tableList.delegate = self
        tableList.dataSource = self
        
        parceApi()
    }

    
    /***************************************************
    ham parce api
    ****************************************************/
    func parceApi(){
        song = Song()
        song.idByPlayList = String(AppsSettings.idArtist)
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListSong("api/findsongbyidartist",song:song, success: {(response) -> Void in
            self.list_song = response.items
            if self.list_song.count > 0 {
                for i in 0..<self.list_song.count {
                    self.song = self.list_song[i]
                    
                    if self.song.idSong != nil{
                        self.list_id_song.append(self.song.idSong)
                    }else{
                        self.list_id_song.append("")
                    }
                    
                    
                    if self.song.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "artists/tb/" + self.song.image
                        self.list_image_song.append(link_image)
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
                        if self.song.filepath != nil{
                        self.list_linkUrl_song.append(self.song.linkUrl!)
                        }else{
                            self.list_linkUrl_song.append("")
                        }
                    }else {
                        if self.song.filepath != nil{
                        self.list_linkUrl_song.append(self.song.filepath)
                        }else{
                            self.list_linkUrl_song.append("")
                        }
                    }
                    
                    if self.song.title != nil && self.song.artistname != nil{
                        self.list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                    }else{
                        self.list_title_and_author_song.append("")
                    }
                    
                    
                    //print("list_linkUrl_song  " + self.song.counter)
                }
                
            }
            
            self.tableList.reloadData()
//            print(AppsSettings.listSong.count)
            
            }) { (error) -> Void in
        }
    }
    
    
    /***************************************************
    Khoi tao View
    ****************************************************/
    func createInterface(){
        imageViewHeader = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 90))
        imageViewHeader.image = UIImage(named: "backgroundhomefragment.png")
        
        imageAvater = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 5, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 80))
        if AppsSettings.imageArtits != AppsSettings.Static.BASE_IMAGE_URL + "artists/tb/" && AppsSettings.imageArtits != nil {
            imageAvater.imageFromUrl(AppsSettings.imageArtits)
        }
        else
        {
            imageAvater.image = UIImage(named: "down")
        }
        nameArtist = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 100, y:ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 300, height: ScreenSize.MUL_HEIGHT * 17))
        nameArtist.textColor = UIColor(hex: "FFFFFF")
        nameArtist.font = UIFont.font65Medium(13)
        if AppsSettings.titleArtist != nil {
            nameArtist.text = AppsSettings.titleArtist
        }
        
        descriptionArtist = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 100, y:ScreenSize.MUL_HEIGHT * 20, width: ScreenSize.MUL_WIDTH * 300, height: ScreenSize.MUL_HEIGHT * 17))
        descriptionArtist.textColor = UIColor(hex: "FFFFFF")
        descriptionArtist.font = UIFont.font65Medium(11)
//        if AppsSettings.descriptionArtist != nil {
//            descriptionArtist.text = AppsSettings.descriptionArtist
//        }
        
        tableList = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y:ScreenSize.MUL_HEIGHT * 90, width: ScreenSize.MUL_WIDTH * 375, height: ScreenSize.MUL_HEIGHT * 160))
        tableList.registerCellNib(DataTableViewCellListSong.self)
        
        
        
        self.addSubview(imageViewHeader)
        self.addSubview(imageAvater)
        self.addSubview(nameArtist)
        self.addSubview(descriptionArtist)
        self.addSubview(tableList)
    }
}

@available(iOS 8.0, *)
extension DataViewArtistByID : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 40
    }
}

extension DataViewArtistByID : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("-------------------" + String(list_id_song.count) + "-------------------")
        return list_linkUrl_song.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableList.dequeueReusableCell(withIdentifier: DataTableViewCellListSong.identifier) as! DataTableViewCellListSong
        cell.textTitleSong.textColor = UIColor(hex: "000000")
        cell.textTitleAuthor.textColor = UIColor(hex: "000000")
        cell.textCountListen.textColor = UIColor(hex: "000000")
        let data = DataTableViewCellListSongData(id_Song: list_id_song[indexPath.row] , title_Song: list_title_song[indexPath.row], title_Author: list_artistName_song[indexPath.row], count_Listen: list_counter_song[indexPath.row] , link_url: list_linkUrl_song[indexPath.row] , image_Song: list_image_song[indexPath.row] , description_Song: list_description_song[indexPath.row])
        cell.setData(data)
        AppsSettings.btnDownloadMusic = UIButton()
        AppsSettings.btnDownloadMusic.frame = CGRect(x: ScreenSize.MUL_WIDTH * 260, y: ScreenSize.MUL_HEIGHT * 12, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
        AppsSettings.btnDownloadMusic.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
        AppsSettings.btnDownloadMusic.addTarget(self, action: #selector(DataViewArtistByID.actionEventDownload(_:)), for: UIControlEvents.touchUpInside)
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
        AppsSettings.list_song_object.removeAll()
        for i in 0..<self.list_song.count
        {
            AppsSettings.list_song_object.append(list_song[i])
        }
        AppsSettings.originTime.invalidate()
        AppsSettings.position = indexPath.row
        AppsSettings.list_url_song = list_linkUrl_song
        AppsSettings.list_title_song = list_title_and_author_song
        AppsSettings.isCheckedButtonPlay = true
        AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
        AppsSettings.idSong = list_id_song[indexPath.row]
        AppsSettings.textNameSong.text = list_title_song[indexPath.row]
        var song = Song()
        song.idSong = list_id_song[indexPath.row]
        AppsSettings.root.updateCountSong(song.idSong)
        
        list_counter_song[indexPath.row] = String(Int(list_counter_song[indexPath.row])! + 1)
        tableView.reloadData()
    }
    
}
