//
//  DataViewBXH.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewBXH: UIView {

    @IBOutlet weak var scrollViewBXH: UIScrollView!
    @IBOutlet weak var nameCountry: UILabel!
    
    var lineBoder1: UIImageView!
    var backgroundNext1: UIImageView!
    var lineBoder2: UIImageView!
    var lineBoder3: UIImageView!
    var backgroundNext2: UIImageView!
    var lineBoder4: UIImageView!
    var lineBoder5: UIImageView!
    var backgroundNext3: UIImageView!
    var lineBoder6: UIImageView!
    var logoBaihat: UIButton!
    var logoPlaylist: UIButton!
    var logoVideo: UIButton!
    var titleBaiHat: UILabel!
    var titlePlayList: UILabel!
    var titleVideo: UILabel!
    
    //khai vao table list
    var tableListBaiHat: UITableView!
    var tableListPlayList: UITableView!
    var tableListVideo: UITableView!
    var tableListCountry: UITableView!
    
    //khai bao list
    var list_title_playList: [String]! = []
    var list_title_baihat: [String]! = []
    var list_title_video: [String]! = []
    var list_country: [String]! = []
    
    //khai bao doi tuong
    var listVideoBXH: [VideoVideo]! = []
    var listSongBXH: [Song]! = []
    var listPlayListBXH: [PlayList]! = []
    var songBXH: Song!
    var videoBXH: VideoVideo!
    var playListBXH: PlayList!
    var bangXepHang: BangXepHang!
    var idChoose: Int!
    
    //khai bao bien playListByID
    var viewPlayListByID: DataViewBxhID!
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    
    override func awakeFromNib() {
//        list_country = ["Việt Nam" , "Âu Mỹ" , "Châu Á"]
        
        createInterface()
        
        songBXH = Song()
        videoBXH = VideoVideo()
        playListBXH = PlayList()
        
        tableListBaiHat.delegate = self
        tableListBaiHat.dataSource = self
        tableListPlayList.delegate = self
        tableListPlayList.dataSource = self
        tableListVideo.delegate = self
        tableListVideo.dataSource = self
        tableListCountry.delegate = self
        tableListCountry.dataSource = self
        
        tableListCountry.isHidden = true
        
        parceApi(String(AppsSettings.listCountry[0].idCountry))
        
        AppsSettings.idCountryBXH = String(AppsSettings.listCountry[0].idCountry)
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(tableListCountry != nil){
            tableListCountry.isHidden = true
            tableListCountry.isHidden = true
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(tableListCountry != nil){
            tableListCountry.isHidden = true
            tableListCountry.isHidden = true
        }
    }
    
    
    @IBAction func actionDropTable(_ sender: AnyObject) {
        if tableListCountry.isHidden == false{
            tableListCountry.isHidden = true
        }else{
            tableListCountry.isHidden = false
        }
    }
    
    /**************************************
    Hàm xét sự kiện khi click vào logo (bài hát , playList , video)
    ***************************************/
    func actionEven(_ sender:UIButton){
        idChoose = sender.tag
        if idChoose == 1 { //su kien khi click vao bai hat
            print("Bai Hat cccc")
            AppsSettings.idTypeBXH = "1"
           
            createViewPlayListId()
        }else if idChoose == 2 { //su kien khi click vao playList
            print("PlayList")
            AppsSettings.idTypeBXH = "2"
            AppsSettings.checkClickMyPlaylist = true
            createViewPlayListId()
        }else if idChoose == 3 { //su kien khi click vao video
            print("Video")
            AppsSettings.idTypeBXH = "3"
            
            createViewPlayListId()
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
    
    

    
    /**************************************
    Hàm parce api
    ***************************************/
    func parceApi(_ idCountry: String!){
        
        self.list_title_playList.removeAll()
        self.list_title_baihat.removeAll()
        self.list_title_video.removeAll()
        bangXepHang = BangXepHang()
        bangXepHang.idCountry = idCountry
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getBangXepHang("api/BXH",bangXepHang: bangXepHang , success: { (response) -> Void in
            
            let a = response
            
            self.listSongBXH = a.listSong
            self.listVideoBXH = a.listVideo
            self.listPlayListBXH = a.listPlayList
            print(self.listSongBXH.count)
            if self.listSongBXH.count > 0 {
                if self.listSongBXH.count < 3
                {
                    for i in 0..<self.listSongBXH.count{
                        self.songBXH = self.listSongBXH[i]
                        self.list_title_baihat.append(self.songBXH.title)
                        
                    }
                }
                else{
                    for i in 0..<3 {
                        self.songBXH = self.listSongBXH[i]
                        self.list_title_baihat.append(self.songBXH.title)
                        
                    }
                }
            }
            
            if self.listVideoBXH.count > 0 {
                if self.listVideoBXH.count < 3
                {
                    for i in 0..<self.listVideoBXH.count {
                        self.videoBXH = self.listVideoBXH[i]
                        self.list_title_video.append(self.videoBXH.title)
                    }
                }
                else{
                    for i in 0..<3 {
                        self.videoBXH = self.listVideoBXH[i]
                        self.list_title_video.append(self.videoBXH.title)
                    }
                }
            }
            
            if self.listPlayListBXH.count > 0 {
                if self.listPlayListBXH.count < 3
                {
                for i in 0..<self.listPlayListBXH.count{
                    self.playListBXH = self.listPlayListBXH[i]
                    self.list_title_playList.append(self.playListBXH.title)
                }
                }
                else{
                    for i in 0..<3{
                        self.playListBXH = self.listPlayListBXH[i]
                        self.list_title_playList.append(self.playListBXH.title)
                    }
                }
            }
            
            self.tableListBaiHat.reloadData()
            self.tableListPlayList.reloadData()
            self.tableListVideo.reloadData()
            print("PlayList "  + String(self.listPlayListBXH.count))
            print("Video    " + String(self.listVideoBXH.count))
            print("Song     " + String(self.listSongBXH.count))
            }) { (error) -> Void in
                
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
        
        buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 55, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
        buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewBXH.actionEven as (DataViewBXH) -> () -> ()), for: UIControlEvents.touchUpInside)
//
        viewPlayListByID = DataViewBxhID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
//
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
        AppsSettings.root.showActivityIndicator()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(DataViewBXH.hideIndicator), userInfo: nil, repeats: false)
    }
    
    /***************************************
    Hàm tạo giao diện
    ****************************************/
    func hideIndicator(){
        AppsSettings.root.hideActivityIndicator()
    }
    func createInterface() {
        scrollViewBXH.contentSize.height = 300 * ScreenSize.MUL_HEIGHT
        //layout baihat
        lineBoder1 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 1, y: ScreenSize.MUL_HEIGHT * 10 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 1 ))
        lineBoder1.image = UIImage(named: "title_playlist.png")
        logoBaihat = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y: ScreenSize.MUL_HEIGHT * 10 , width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 80 ))
        logoBaihat.setBackgroundImage(UIImage(named:"down"), for: UIControlState())
        logoBaihat.addTarget(self, action: #selector(DataViewBXH.actionEven(_:)), for: UIControlEvents.touchUpInside)
        logoBaihat.tag = 1

        lineBoder2 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 1, y: ScreenSize.MUL_HEIGHT * 89 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 1 ))
        lineBoder2.image = UIImage(named: "title_playlist.png")
        backgroundNext1 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 425, y: ScreenSize.MUL_HEIGHT * 10 , width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 80 ))
        backgroundNext1.image = UIImage(named: "background_next.png")
        titleBaiHat = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y: ScreenSize.MUL_HEIGHT * 10 , width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 15 ))
        titleBaiHat.backgroundColor = UIColor(hex: "FF8F36")
        titleBaiHat.text = "  បទចំរៀង"
        titleBaiHat.font = UIFont.font65Medium(10)
        titleBaiHat.textColor = UIColor(hex: "12078B")
        
        tableListBaiHat = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 125, y: ScreenSize.MUL_HEIGHT * 10, width: ScreenSize.MUL_WIDTH * 350, height: ScreenSize.MUL_HEIGHT * 80))
        tableListBaiHat.backgroundColor = UIColor.clear
        self.tableListBaiHat.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableListBaiHat.registerCellNib(DataTableViewCellListBXH.self)
        
        
        //layout playList
        lineBoder3 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 1, y: ScreenSize.MUL_HEIGHT * 105 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 1 ))
        lineBoder3.image = UIImage(named: "title_playlist.png")
        logoPlaylist = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y: ScreenSize.MUL_HEIGHT * 105 , width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 80 ))
        logoPlaylist.setBackgroundImage(UIImage(named:"down"), for: UIControlState())
        logoPlaylist.addTarget(self, action: #selector(DataViewBXH.actionEven(_:)), for: UIControlEvents.touchUpInside)
        logoPlaylist.tag = 2

        lineBoder4 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 1, y: ScreenSize.MUL_HEIGHT * 184 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 1 ))
        lineBoder4.image = UIImage(named: "title_playlist.png")
        backgroundNext2 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 425, y: ScreenSize.MUL_HEIGHT * 105 , width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 80 ))
        backgroundNext2.image = UIImage(named: "background_next.png")
        titlePlayList = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y: ScreenSize.MUL_HEIGHT * 105 , width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 15 ))
        titlePlayList.backgroundColor = UIColor(hex: "9A9AD7")
        titlePlayList.text = "  បញ្ជីបទចំរៀង"
        titlePlayList.font = UIFont.font65Medium(10)
        titlePlayList.textColor = UIColor(hex: "12078B")
        
        tableListPlayList = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 125, y: ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 350, height: ScreenSize.MUL_HEIGHT * 80))
        tableListPlayList.backgroundColor = UIColor.clear
        self.tableListPlayList.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableListPlayList.registerCellNib(DataTableViewCellListBXH.self)
        
        
        //layout video
        lineBoder5 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 1, y: ScreenSize.MUL_HEIGHT * 200 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 1 ))
        lineBoder5.image = UIImage(named: "title_playlist.png")
        logoVideo = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y: ScreenSize.MUL_HEIGHT * 200 , width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 80 ))
        logoVideo.setBackgroundImage(UIImage(named:"down"), for: UIControlState())
        logoVideo.addTarget(self, action: #selector(DataViewBXH.actionEven(_:)), for: UIControlEvents.touchUpInside)
        logoVideo.tag = 3
        
        lineBoder6 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 1, y: ScreenSize.MUL_HEIGHT * 279 , width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 1 ))
        lineBoder6.image = UIImage(named: "title_playlist.png")
        backgroundNext3 = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 425, y: ScreenSize.MUL_HEIGHT * 200 , width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 80 ))
        backgroundNext3.image = UIImage(named: "background_next.png")
        titleVideo = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y: ScreenSize.MUL_HEIGHT * 200 , width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 15 ))
        titleVideo.backgroundColor = UIColor(hex: "56A054")
        titleVideo.text = "  វីឌីអូ"
        titleVideo.font = UIFont.font65Medium(10)
        titleVideo.textColor = UIColor(hex: "12078B")
        
        tableListVideo = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 125, y: ScreenSize.MUL_HEIGHT * 200, width: ScreenSize.MUL_WIDTH * 350, height: ScreenSize.MUL_HEIGHT * 80))
        tableListVideo.backgroundColor = UIColor.clear
        self.tableListVideo.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableListVideo.registerCellNib(DataTableViewCellListBXH.self)
        
        
        tableListCountry = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 390, y: ScreenSize.MUL_HEIGHT * 27, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 80))
        tableListCountry.backgroundColor = UIColor(hex: "000000")
        self.tableListCountry.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableListCountry.registerCellNib(DataTableViewCellCountry.self)
       
        
        self.scrollViewBXH.addSubview(lineBoder1)
        self.scrollViewBXH.addSubview(logoBaihat)
        self.scrollViewBXH.addSubview(lineBoder2)
        self.scrollViewBXH.addSubview(backgroundNext1)
        self.scrollViewBXH.addSubview(lineBoder3)
        self.scrollViewBXH.addSubview(logoPlaylist)
        self.scrollViewBXH.addSubview(lineBoder4)
        self.scrollViewBXH.addSubview(backgroundNext2)
        self.scrollViewBXH.addSubview(lineBoder5)
        self.scrollViewBXH.addSubview(logoVideo)
        self.scrollViewBXH.addSubview(lineBoder6)
        self.scrollViewBXH.addSubview(backgroundNext3)
        self.scrollViewBXH.addSubview(titleBaiHat)
        self.scrollViewBXH.addSubview(titlePlayList)
        self.scrollViewBXH.addSubview(titleVideo)
        
        self.scrollViewBXH.addSubview(tableListBaiHat)
        self.scrollViewBXH.addSubview(tableListPlayList)
        self.scrollViewBXH.addSubview(tableListVideo)
        self.addSubview(tableListCountry)
        
        
    }
}

extension DataViewBXH : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tableListCountry {
            return ScreenSize.MUL_HEIGHT * 30
        }else{
            return DataTableViewCellListBXH.height()
        }
    }
}

extension DataViewBXH : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableListBaiHat {
            return self.list_title_baihat.count
        } else if tableView == tableListPlayList {
            return self.list_title_playList.count
        } else if tableView == tableListVideo{
            return self.list_title_video.count
        } else {
            return AppsSettings.listCountry.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableListBaiHat {
            let cell = self.tableListBaiHat.dequeueReusableCell(withIdentifier: DataTableViewCellListBXH.identifier) as! DataTableViewCellListBXH
            let data = DataTableViewCellListBXHData(title_Song: list_title_baihat[indexPath.row], stt_text: String(indexPath.row + 1)+".")
            cell.setData(data)
            return cell
        }else if tableView == tableListPlayList {
            let cell = self.tableListPlayList.dequeueReusableCell(withIdentifier: DataTableViewCellListBXH.identifier) as! DataTableViewCellListBXH
            let data = DataTableViewCellListBXHData(title_Song: list_title_playList[indexPath.row], stt_text: String(indexPath.row + 1)+".")
            cell.setData(data)
            return cell
        } else if tableView == tableListVideo{
            let cell = self.tableListVideo.dequeueReusableCell(withIdentifier: DataTableViewCellListBXH.identifier) as! DataTableViewCellListBXH
            let data = DataTableViewCellListBXHData(title_Song: list_title_video[indexPath.row], stt_text: String(indexPath.row + 1)+".")
            cell.setData(data)
            return cell
        } else{
            let cell = self.tableListCountry.dequeueReusableCell(withIdentifier: DataTableViewCellCountry.identifier) as! DataTableViewCellCountry
            let data = DataTableViewCellListCountryData(title_Country: AppsSettings.listCountry[indexPath.row].nameCountry)
            cell.setData(data)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableListBaiHat {
            print("Bai hat abcccc" + String(indexPath.row))
        } else if tableView == tableListPlayList {
            print("PlayList " + String(indexPath.row))
        } else if tableView == tableListVideo {
            print("Video " + String(indexPath.row))
        } else {
            tableListCountry.isHidden = true
            nameCountry.text = AppsSettings.listCountry[indexPath.row].nameCountry
            AppsSettings.idCountryBXH = String(AppsSettings.listCountry[indexPath.row].idCountry)
            parceApi(String(AppsSettings.listCountry[indexPath.row].idCountry))
        }
    }
    
}




