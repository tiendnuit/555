//
//  DataUIViewFormDownload.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 2/2/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataUIViewFormDownload: UIView {
    
    var title: UILabel!
    var buttonDownload: UIButton!
    var buttonCancel: UIButton!
    var tableViewList: UITableView!
    var titleChonTatCa: UILabel!
    var checkBox: UIButton!
    var lineView: UIImageView!
    
    //khai bao bien content
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
    var idChoose: Int!
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor(hex: "3F3F3D")
        createInterface()
        parceApi()
        var checkall = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(DataUIViewFormDownload.actionCheckAll), userInfo: nil, repeats: true)
    }
    func actionCheckAll(){
        if AppsSettings.checkAll == true {
            checkBox.setBackgroundImage(UIImage(named:"checkbox.png"), for: UIControlState())
        }else if AppsSettings.checkAll == false{
            checkBox.setBackgroundImage(UIImage(named:"unchecked.png"), for: UIControlState())
        }
    }
    
    func checkedAll() -> Bool{
        for i in 0 ..< AppsSettings.listCheckbox.count {
            if AppsSettings.listCheckbox[i] == true {
                return true
            }
        }
        return false
    }
    
    func actionEven(_ sender:UIButton){
        idChoose = sender.tag
        if idChoose == 1 {
            if AppsSettings.checkAll == true {
                AppsSettings.checkAll = false
                checkBox.setBackgroundImage(UIImage(named:"unchecked.png"), for: UIControlState())
                for i in 0  ..< AppsSettings.listCheckbox.count {
                    AppsSettings.listCheckbox[i] = false
                }
            } else {
                AppsSettings.checkAll = true
                checkBox.setBackgroundImage(UIImage(named:"checkbox.png"), for: UIControlState())
                for i in 0  ..< AppsSettings.listCheckbox.count {
                    AppsSettings.listCheckbox[i] = true
                }
            }
            tableViewList.reloadData()
        } else
            //download checkbox
            if idChoose == 2 {
                
              var prString: String?
                
                if  list_linkUrl_song.count > 0 {
                    var kt = 0
                    
                    if checkedAll() == true {
                        for i in 0 ..< AppsSettings.listCheckbox.count {
                            if AppsSettings.listCheckbox[i] == true {
                                kt += 1
                                UIToast.makeText("កំពុងទាញយក").show()
                                self.removeFromSuperview()
                                AppsSettings.backGroundViewPlayListID.removeFromSuperview()
                                
                                AppsSettings.tittle_Song_Drive = list_title_song[i]
                                prString = list_linkUrl_song[i].replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
                                
                                print("abcd: \(prString)")
                                
                                if prString!.range(of: "docs.google.com") != nil {
                                    Downloader.loadSong(prString!)
                                    UIToast.makeText("ទាញយកបទចំរៀងមិនជោគជ័យ!").show()
                                }else{
                                    let url = URL(string: prString!)
                                    print(String(describing: url) + "------------------")
                                    Downloader().loadFileAsync(url!, completion:{(path:String, error:NSError!) in
                                        UIToast.makeText("ទាញយកបទចំរៀងមិនជោគជ័យ!").show()
                                    })
                                }
                                
                                
                                let url = URL(string: prString!)
                                print(String(describing: url) + "------------------")
                            }
                            
                        }
                        AppsSettings.listCheckbox = []
                        AppsSettings.checkAll = false
                    }else{
                        UIToast.makeText("គ្មានបទចំរៀង").show()
                        print("deo co bai hat")
                    }
                    
//                    if(kt == 0){
//                        UIToast.makeText("គ្មានបទចំរៀង")
//                    }
                    
                }else{
                    print("khong co bai hat nao duoc chon")
                }
                
            }
            else if idChoose == 3 {
                self.removeFromSuperview()
                AppsSettings.backGroundViewPlayListID.removeFromSuperview()
                AppsSettings.listCheckbox = []
                AppsSettings.checkAll = false
        }
        
    }
    
    /***************************************************
     hàm parce api
     ****************************************************/
    func parceApi(){
        self.list_song = AppsSettings.list_song_download_subject
        if self.list_song.count > 0 {
            for i in 0  ..< self.list_song.count {
                self.song = self.list_song[i]
                
                if self.song.idSong != nil{
                    self.list_id_song.append(self.song.idSong)
                    AppsSettings.listCheckbox.append(false)
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
                
                if self.song.lyric != nil{
                    self.list_lyric_song.append(self.song.lyric)
                }else{
                    self.list_lyric_song.append("")
                }
                
                if self.song.linkUrl != nil{
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
        }
        
        self.tableViewList.reloadData()
    }
    
    /*****************************************
     Hàm tạo giao dien
     *****************************************/
    func createInterface(){
        var tit = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 15, y:ScreenSize.MUL_HEIGHT * 10, width: ScreenSize.MUL_WIDTH * 250, height: ScreenSize.MUL_HEIGHT * 21))
        tit.text = "ជ្រើសរើសបទទាញយក"
        tit.textColor = UIColor.white
        tit.textAlignment = .center
        tit.font = UIFont.font65Medium(15)
        
        titleChonTatCa = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 12, y:ScreenSize.MUL_HEIGHT * 50, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 21))
        titleChonTatCa.text = "ជ្រើសរើសទាំងអស់"
        titleChonTatCa.textColor = UIColor.white
        titleChonTatCa.font = UIFont.font65Medium(11)
        
        checkBox = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 232, y:ScreenSize.MUL_HEIGHT * 50, width: ScreenSize.MUL_HEIGHT * 17, height: ScreenSize.MUL_HEIGHT * 17))
        checkBox.setBackgroundImage(UIImage(named:"unchecked.png"), for: UIControlState())
        checkBox.addTarget(self, action: #selector(DataUIViewFormDownload.actionEven(_:)), for: UIControlEvents.touchUpInside)
        checkBox.tag = 1
        
        
        tableViewList = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 5, y:ScreenSize.MUL_HEIGHT * 80, width: ScreenSize.MUL_WIDTH * 250, height: ScreenSize.MUL_HEIGHT * 100))
        tableViewList.backgroundColor = UIColor.clear
        tableViewList.registerCellNib(DataTableViewCellListDownload.self)
        
        buttonDownload = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 45, y:ScreenSize.MUL_HEIGHT * 193, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 23))
        buttonDownload.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        buttonDownload.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        buttonDownload.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        buttonDownload.setTitle("ទាញយក", for: UIControlState())
        buttonDownload.backgroundColor = UIColor(hex: "E21D2B")
        buttonDownload.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        buttonDownload.addTarget(self, action: #selector(DataUIViewFormDownload.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonDownload.tag = 2
        
        buttonCancel = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 145, y:ScreenSize.MUL_HEIGHT * 193, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 23))
        buttonCancel.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        buttonCancel.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        buttonCancel.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        buttonCancel.setTitle("ថយក្រោយ", for: UIControlState())
        buttonCancel.backgroundColor = UIColor(hex: "E21D2B")
        buttonCancel.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        buttonCancel.addTarget(self, action: #selector(DataUIViewFormDownload.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCancel.tag = 3
        
        
        self.addSubview(tit)
        self.addSubview(tableViewList)
        self.addSubview(titleChonTatCa)
        self.addSubview(checkBox)
        self.addSubview(buttonDownload)
        self.addSubview(buttonCancel)
        
        tableViewList.delegate = self
        tableViewList.dataSource = self
    }
}

extension DataUIViewFormDownload : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 30
    }
}

extension DataUIViewFormDownload : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("-------------------" + String(list_id_song.count) + "-------------------")
        return list_id_song.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableViewList.dequeueReusableCell(withIdentifier: DataTableViewCellListDownload.identifier) as! DataTableViewCellListDownload
        let data = DataTableViewCellListDownloadData(name_Song: list_title_song[indexPath.row], name_Artist: list_artistName_song[indexPath.row],url_song: list_linkUrl_song[indexPath.row], indextPath: indexPath.row)
        cell.setData(data)
        print(AppsSettings.checkAll)
        if AppsSettings.listCheckbox[indexPath.row] == true
        {
            print("deo tin noi")
            cell.checkBox.setBackgroundImage(UIImage(named:"checkbox.png"), for: UIControlState())
        }
        else
        {
            cell.checkBox.setBackgroundImage(UIImage(named:"unchecked.png"), for: UIControlState())
        }
//        AppsSettings.ischecked?.append(cell.check)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Song " + list_linkUrl_song[indexPath.row])
        AppsSettings.position = indexPath.row
    }
    
}

