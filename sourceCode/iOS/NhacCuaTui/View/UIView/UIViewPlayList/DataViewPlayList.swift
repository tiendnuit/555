//
//  DataViewPlayList.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewPlayList: UIView {
    
    
    //khai bao bien UIView
    var textObject: UILabel!
    var textMoiAndHot: UIButton!
    var textNhacTre: UIButton!
    var textTruTinh: UIButton!
    var textDropdown: UIButton!
    var listTypeSongHorizontal: UICollectionView!
    var playListHorizontal: UICollectionView!
    
    //khai bao bien playListByID
    var viewPlayListByID: DataViewPlayListByID!
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    
    //khai bao bien content
    var list_id_playList: [String]! = []
    var list_image_playList: [String]! = []
    var list_title_playList: [String]! = []
    var list_author_playList: [String]! = []
    var list_count_listen: [String]! = []
    
    var playList: PlayList!
    var list_PlayList: [PlayList]! = []
    var idChoose: Int!
    var checkOpen: Bool! = false
    var kt0 = 1
    var kt1 = 1
    var kt2 = 1
    var kt3 = 1
    var kt4 = 1
    override func awakeFromNib(){
                
        createInterface()
        playListHorizontal.delegate = self
        playListHorizontal.dataSource = self
        
        textObject.text = AppsSettings.listType[0].nametype
        textObject.textColor = UIColor(hex: "00C8CD")
        parceApi(String(AppsSettings.listType[0].idtype))
        
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
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(listTypeSongHorizontal != nil){
            listTypeSongHorizontal.removeFromSuperview()
            listTypeSongHorizontal.removeFromSuperview()
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
    
    
    /**********************************************
    hàm xet sự kiện khi click vào các nút button tren title
    **********************************************/
    func actionEven(_ sender:UIButton) {
        idChoose = sender.tag
        
        if idChoose == 1 {
            kt1 = 1
            kt2 = 1
            if kt0 == 1 {
                print("choose1")
                textObject.text = AppsSettings.listType[0].nametype
                textObject.textColor = UIColor(hex: "00C8CD")
                textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                //                            kt++
                parceApi(String(AppsSettings.listType[0].idtype))
                kt0 = 0
            }else{
                print("2 lan roi")
                playListHorizontal.reloadData()
                
                //                kt = 1
            }
            
        }
        if idChoose == 2 {
            kt0 = 1
            kt2 = 1
            if kt1 == 1{
                print("chóooos2")
                textObject.text = AppsSettings.listType[1].nametype
                textObject.textColor = UIColor(hex: "00C8CD")
                textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                kt1 = 0
                parceApi(String(AppsSettings.listType[1].idtype))
            }else {
                print("2 lan roi")
                playListHorizontal.reloadData()
            }
        }
        if idChoose == 3 {
            kt1 = 1
            kt0 = 1
            if kt2 == 1{
                print("choose3")
                textObject.text = AppsSettings.listType[2].nametype
                textObject.textColor = UIColor(hex: "00C8CD")
                textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
                kt2=0
                parceApi(String(AppsSettings.listType[2].idtype))
            }else{
                print("2 lan roi")
                playListHorizontal.reloadData()
            }
        }
        if idChoose == 4 {
            
            print("choose4")
            if listTypeSongHorizontal != nil {
                listTypeSongHorizontal.removeFromSuperview()
            }
            if checkOpen == false{
                checkOpen = true
                createTableViewListChooseTypeSong()
            }else{
                checkOpen = false
                self.listTypeSongHorizontal.removeFromSuperview()
            }
            
        }
    }
    
    
    /***************************************************
    ham parce api playList theo thể loại
    ****************************************************/
    func parceApi(_ idType: String!){
        list_PlayList.removeAll()
        list_title_playList.removeAll()
        list_count_listen.removeAll()
        list_image_playList.removeAll()
        list_id_playList.removeAll()
        playList = PlayList()
        playList.idType = idType
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getPlayList("api/getplaylistbyidtype",playList:playList, success: {(response) -> Void in
            self.list_PlayList = response.items
            if self.list_PlayList.count > 0 {
                for i in 0..<self.list_PlayList.count{
                    self.playList = self.list_PlayList[i]
                    if self.playList.title != nil {
                        self.list_title_playList.append(self.playList.title)
                    }else{
                        self.list_title_playList.append("")
                    }
                    if self.playList.counter != nil {
                        self.list_count_listen.append(String(self.playList.counter))
                    }else{
                        self.list_count_listen.append("")
                    }
                    if self.playList.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/" + self.playList.image
                        self.list_image_playList.append(link_image)
                    }else{
                        self.list_image_playList.append("")
                    }
                    if self.playList.idplaylist != nil {
                        self.list_id_playList.append(self.playList.idplaylist)
                    }
                }
                self.playListHorizontal.reloadData()
            }
            }) { (error) -> Void in
                self.playListHorizontal.reloadData()
        }
    }
    
    
    /***************************************************
    Hàm tao giao diện
    ****************************************************/
    func createInterface(){
        textObject = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y: ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 18))
        textObject.font = UIFont.font65Medium(13)
        textObject.textColor = UIColor(hex: "FFFFFF")
        
        textMoiAndHot = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 145, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 75, height: ScreenSize.MUL_HEIGHT * 28))
        textMoiAndHot.setTitle(AppsSettings.listType[0].nametype, for: UIControlState())
        textMoiAndHot.setTitleColor(UIColor.white, for: UIControlState())
        textMoiAndHot.titleLabel?.font = UIFont.font65Medium(12)
        textMoiAndHot.addTarget(self, action: #selector(DataViewPlayList.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textMoiAndHot.tag = 1
        
        textNhacTre = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 225, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 75, height: ScreenSize.MUL_HEIGHT * 28))
        textNhacTre.setTitle(AppsSettings.listType[1].nametype, for: UIControlState())
        textNhacTre.setTitleColor(UIColor.white, for: UIControlState())
        textNhacTre.titleLabel?.font = UIFont.font65Medium(12)
        textNhacTre.addTarget(self, action: #selector(DataViewPlayList.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textNhacTre.tag = 2
        
        textTruTinh = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 305, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 75, height: ScreenSize.MUL_HEIGHT * 28))
        textTruTinh.setTitle(AppsSettings.listType[2].nametype, for: UIControlState())
        textTruTinh.setTitleColor(UIColor.white, for: UIControlState())
        textTruTinh.titleLabel?.font = UIFont.font65Medium(12)
        textTruTinh.addTarget(self, action: #selector(DataViewPlayList.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textTruTinh.tag = 3
        
        
        let imageN = UIImage(named: "btn_choose.png") as UIImage?
        textDropdown = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 360, y: ScreenSize.MUL_HEIGHT * 1, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 28))
        textDropdown.titleLabel?.font = UIFont.font65Medium(12)
        textDropdown.setTitle("ផ្សេងៗ", for: UIControlState())
        textDropdown.titleEdgeInsets = UIEdgeInsetsMake(0.0, 10.0, -3.0, 0.0);
        textDropdown.setImage(imageN, for: UIControlState())
        textDropdown.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        textDropdown.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        textDropdown.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        textDropdown.addTarget(self, action: #selector(DataViewPlayList.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textDropdown.tag = 4
        
        
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 80 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        //layoutPlayList.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.playListHorizontal = UICollectionView(frame: CGRect(x: 0 , y: 35 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 230 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.playListHorizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.playListHorizontal.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.playListHorizontal.isPagingEnabled = true
        self.playListHorizontal.backgroundColor = UIColor.clear
        
        self.addSubview(textObject)
        self.addSubview(textMoiAndHot)
        self.addSubview(textNhacTre)
        self.addSubview(textTruTinh)
        self.addSubview(textDropdown)
        self.addSubview(playListHorizontal)
    }
    
    
    /**********************************************
    hàm tao giao diện view chọn thể loại bài hát
    **********************************************/
    func createTableViewListChooseTypeSong(){
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
    
    
    /***************************************************
    Hàm tao giao diện View playListID
    ****************************************************/
    func hideIndicator(){
        AppsSettings.root.hideActivityIndicator()
    }

    func createViewPlayListId(){
        //khoi tao view dim back ground
        print("o day la vao playlist nhe cung")
        self.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 250))
        dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        dimBackgroundColor.alpha=0.5
        
        buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 55, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
        buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewPlayList.actionEven as (DataViewPlayList) -> () -> ()), for: UIControlEvents.touchUpInside)
        
        viewPlayListByID = DataViewPlayListByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
        AppsSettings.root.showActivityIndicator()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(DataViewPlayList.hideIndicator), userInfo: nil, repeats: false)
    }
}

extension DataViewPlayList : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DataViewPlayList : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if playListHorizontal == collectionView {
            return list_id_playList.count
        }else{
            return AppsSettings.listType.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if playListHorizontal == collectionView {
            let cell = self.playListHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
            let data = DataUICollectionViewCellPlayListData(image_Song: list_image_playList[indexPath.row], text_Count_Listen: list_count_listen[indexPath.row], text_Title_PlayList: list_title_playList[indexPath.row], text_Author: "")
            cell.setData(data)
            return cell
        }else{
            let cell = self.listTypeSongHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellType.identifier, for: indexPath) as! DataUICollectionViewCellType   
            let data = DataUICollectionViewCellTypeData(name_Type: AppsSettings.listType[indexPath.row].nametype)
            cell.setData(data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AppsSettings.checkClickPlaylist = 1
        if playListHorizontal == collectionView {
            print("PlayList " + list_image_playList[indexPath.row])
            AppsSettings.originTime.invalidate()
            AppsSettings.idPlayList = list_id_playList[indexPath.row]
            AppsSettings.imagePlayList = list_image_playList[indexPath.row]
            AppsSettings.titlePlayList = list_title_playList[indexPath.row]
            AppsSettings.checkClickMyPlaylist = true
            AppsSettings.turncount = list_count_listen[indexPath.row]
            
            //Update counter Playlist
            AppsSettings.root.updatePlaylist(list_id_playList[indexPath.row])
            list_count_listen[indexPath.row] = String(Int(list_count_listen[indexPath.row])! + 1)
            collectionView.reloadData()
            createViewPlayListId()
        }else{
            textObject.text = AppsSettings.listType[indexPath.row].nametype
            textObject.textColor = UIColor(hex: "00C8CD")
            textMoiAndHot.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textNhacTre.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            textTruTinh.setTitleColor(UIColor(hex: "FFFFFF"), for: UIControlState())
            parceApi(String(AppsSettings.listType[indexPath.row].idtype))
            listTypeSongHorizontal.removeFromSuperview()
        }
        
    }
}
