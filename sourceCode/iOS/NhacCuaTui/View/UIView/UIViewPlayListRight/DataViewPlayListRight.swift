//
//  DataViewPlayListRight.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/29/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewPlayListRight: UIView {

    @IBOutlet weak var UIBackground: UIView!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var tableSong: UITableView!
    @IBOutlet weak var buttonClose: UIButton!
    
    //khai báo biến
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
    var list_title_NCT: [String]! = []
    var list_song: [Song]!
    
    override func awakeFromNib(){
        UIBackground.backgroundColor = UIColor(hex: "29373B")
        buttonClose.addTarget(self, action: #selector(DataViewPlayListRight.actionEven), for: UIControlEvents.touchUpInside)
        tableSong.registerCellNib(DataTableViewCellPlayListRight.self)
        nameTitle.text = "បញ្ជីបទចំរៀងរបស់ខ្ញុំ"
        
        tableSong.delegate = self
        tableSong.dataSource = self
        //parceApi()
        if(AppsSettings.flagNCT == true){
            list_title_NCT = AppsSettings.list_tittle_NCT
        }
        
        if AppsSettings.list_song_object.count > 0 {
            for i in 0  ..< AppsSettings.list_song_object.count {
                self.song = AppsSettings.list_song_object[i]
                
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
                }
//                self.list_lyric_song.append(self.song.lyric)
                if self.song.linkUrl != nil && self.song.linkUrl != ""{
                    self.list_linkUrl_song.append(self.song.linkUrl!)
                    
                }else {
                    self.list_linkUrl_song.append(self.song.filepath)
                }
                
                if self.song.title != nil && self.song.artistname != nil{
                    self.list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                }else{
                    self.list_title_and_author_song.append("")
                }
                
                
                //print("list_linkUrl_song  " + self.song.counter)
            }
            self.tableSong.reloadData()
        }
        
    }


    func actionEven(){
        self.removeFromSuperview()
    }
    
    
    
    
    /***************************************************
    hàm parce api
    ****************************************************/
    func parceApi(){
        song = Song()
        song.idByPlayList = String(AppsSettings.idPlayList)
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListSong("api/findsongbyidplaylist",song:song, success: {(response) -> Void in
            
            self.list_song = response.items
            if self.list_song.count > 0 {
                for i in 0..<self.list_song.count {
                    self.song = self.list_song[i]
                    self.list_id_song.append(self.song.idSong)
                    self.list_image_song.append(self.song.image)
                    self.list_title_song.append(self.song.title)
                    self.list_artistName_song.append(self.song.artistname)
                    self.list_counter_song.append(self.song.counter)
                    if self.song.descriPtion != nil {
                        self.list_description_song.append(self.song.descriPtion)
                    }
                    self.list_lyric_song.append(self.song.lyric)
                    if self.song.linkUrl != nil && self.song.linkUrl != ""{
                        self.list_linkUrl_song.append(self.song.linkUrl!)
                        
                    }else {
                        self.list_linkUrl_song.append("")
                    }
                    
                    self.list_title_and_author_song.append(self.song.title + " - " + self.song.artistname)
                    
                    //print("list_linkUrl_song  " + self.song.counter)
                }
                
            }
            
            self.tableSong.reloadData()
            print(AppsSettings.listSong.count)
            
            
            
            }) { (error) -> Void in
        }
    }
    
}
@available(iOS 8.0, *)
extension DataViewPlayListRight : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 35
    }
}

extension DataViewPlayListRight : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(AppsSettings.flagNCT == true){
            return list_title_NCT.count
        }else{
        return list_id_song.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableSong.dequeueReusableCell(withIdentifier: DataTableViewCellPlayListRight.identifier) as! DataTableViewCellPlayListRight
        if(AppsSettings.flagNCT == true){
            let data = DataTableViewCellPlayListRightData(stt: String(indexPath.row + 1), name_Song: list_title_NCT[indexPath.row], name_Artist: "", count_Listen: "")
            cell.setData(data)
        }else{
        let data = DataTableViewCellPlayListRightData(stt: String(indexPath.row + 1), name_Song: list_title_song[indexPath.row], name_Artist: list_artistName_song[indexPath.row], count_Listen: list_counter_song[indexPath.row])
        cell.setData(data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if(AppsSettings.flagNCT == true){
            AppsSettings.playMusicLocal(list_title_NCT[indexPath.row] , titleSong: list_title_NCT[indexPath.row])
        }else{
            print("Song " + list_linkUrl_song[indexPath.row])
            let url = AppsSettings.Static.BASE_IMAGE_URL + list_image_song[indexPath.row]
            //AppsSettings.imageSong.imageFromUrl(url)
            AppsSettings.imageSong.sd_setImage(with: URL(string: url), placeholderImage: nil)
            AppsSettings.position = indexPath.row
            AppsSettings.list_url_song = list_linkUrl_song
            AppsSettings.list_title_song = list_title_and_author_song
            AppsSettings.isCheckedButtonPlay = true
            //AppsSettings.idSong = list_id_song[indexPath.row]
            AppsSettings.playMusic(list_linkUrl_song[indexPath.row] , titleSong: list_title_and_author_song[indexPath.row])
            AppsSettings.flagNCT = false
            AppsSettings.list_tittle_NCT.removeAll()
            //AppsSettings.textNameSong.text = list_title_song[indexPath.row]

        }
        
        
            }
    
}
