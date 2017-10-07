//
//  DataViewVideo.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewVideo: UIView {

    //khai bao bien UIView
    var textObject: UILabel!
    var textMoiAndHot: UIButton!
    var textNhacTre: UIButton!
    var textTruTinh: UIButton!
    var textDropdown: UIButton!
    var listVideoHorizontal: UICollectionView!
    var listTypeSongHorizontal: UICollectionView!
    
    //khai bao biến content
    var list_id_video: [String]! = []
    var list_image_video: [String]! = []
    var list_title_video: [String]! = []
    var list_author_video: [String]! = []
    var list_count_screen: [String]! = []
    var list_linkUrl_video: [String]! = []
    var list_counter_video: [String]! = []
    var list_artistName_video: [String]! = []
    
    var list_video: [VideoVideo]! = []
    var video: VideoVideo!
    var thamsotruyen:UserDefaults!
    var idChoose:Int!
    var checkOpen: Bool! = false
    override func awakeFromNib(){
        createInterface()
        
        listVideoHorizontal.delegate = self
        listVideoHorizontal.dataSource = self
        thamsotruyen = UserDefaults()
        textObject.text = AppsSettings.listType[0].nametype
        textObject.textColor = UIColor(hex: "00C8CD")
        parceApi(String(AppsSettings.listType[0].idtype))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(listTypeSongHorizontal != nil){
            listTypeSongHorizontal.isHidden = true
            listTypeSongHorizontal.isHidden = true
        }
    }
    
    /***************************************************
    ham parce api tất cả các video
    ****************************************************/
    func parceApi(){
        video = VideoVideo()
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListVideo("api/listvideo",video:video, success: {(response) -> Void in
            self.list_video = response.items
            if self.list_video.count > 0 {
                print("This video:  "  + String(describing: self.list_video))
                for i in 0..<self.list_video.count {
                    self.video = self.list_video[i]
                    self.list_id_video.append(self.video.idVideo)
                    if self.video.title != nil {
                        self.list_title_video.append(self.video.title)
                    }
                    if self.video.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "videos/tb/" + self.video.image
                        self.list_image_video.append(link_image)
                    }
                    if  self.video.linkUrl != nil && self.video.linkUrl != "" {
                        self.list_linkUrl_video.append(self.video.linkUrl!)
                    }else {
                        self.list_linkUrl_video.append(self.video.filepath)
                    }
                    if self.video.counter != nil {
                        self.list_counter_video.append(self.video.counter)
                    }
                    if self.video.artistname != nil {
                       self.list_artistName_video.append(self.video.artistname)
                    }else{
                        self.list_artistName_video.append("")
                    }
                    
                }
            }
            print("This video:  "  + String(describing: self.list_linkUrl_video))
            self.listVideoHorizontal.reloadData()
            }) { (error) -> Void in
                print("This video error")
        }
    }
    
    
    /***************************************************
    ham parce api video theo từng thể loại
    ****************************************************/
    func parceApi(_ idTypeVideo: String!){
        self.list_video.removeAll()
        self.list_id_video.removeAll()
        self.list_title_video.removeAll()
        self.list_image_video.removeAll()
        self.list_linkUrl_video.removeAll()
        self.list_counter_video.removeAll()
        self.list_artistName_video.removeAll()
        video = VideoVideo()
        video.idTypeVideo = idTypeVideo
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getListVideo("api/findvideobyidtype",video:video, success: {(response) -> Void in
            self.list_video = response.items
            if self.list_video.count > 0 {
                for i in 0..<self.list_video.count {
                    self.video = self.list_video[i]
                    self.list_id_video.append(self.video.idVideo)
                    if self.video.title != nil {
                        self.list_title_video.append(self.video.title)
                    }
                    if self.video.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "videos/tb/" + self.video.image
                        self.list_image_video.append(link_image)
                    }
                    if  self.video.linkUrl != nil && self.video.linkUrl != ""{
                        self.list_linkUrl_video.append(self.video.linkUrl!)
                    }else if self.video.filepath != nil {
                        self.list_linkUrl_video.append(self.video.filepath)
                    }
                    if self.video.counter != nil {
                        self.list_counter_video.append(self.video.counter)
                    }
                    if self.video.artistname != nil {
                        self.list_artistName_video.append(self.video.artistname)
                    }else {
                        self.list_artistName_video.append("")
                    }
                    
                }
            }
            self.listVideoHorizontal.reloadData()
            }) { (error) -> Void in
            self.listVideoHorizontal.reloadData()
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
            textTruTinh.setTitleColor(UIColor(hex: "00C8CD"), for: UIControlState())
            parceApi(String(AppsSettings.listType[2].idtype))
        }else if idChoose == 4 {
            if listTypeSongHorizontal != nil {
                listTypeSongHorizontal.removeFromSuperview()
            }
            if checkOpen == false{
                checkOpen = true
                createTableViewListChooseTypeVideo()
            }else{
                checkOpen = false
                listTypeSongHorizontal.removeFromSuperview()
            }
            
            
        }
    }
    
    
    /**********************************************
    hàm tao giao diện view chọn thể loại video
    **********************************************/
    func createTableViewListChooseTypeVideo(){
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
    Khoi tao View
    ****************************************************/
    func createInterface(){
        textObject = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y: ScreenSize.MUL_HEIGHT * 5, width: ScreenSize.MUL_WIDTH * 110, height: ScreenSize.MUL_HEIGHT * 18))
        textObject.font = UIFont.font65Medium(13)
        textObject.textColor = UIColor(hex: "FFFFFF")
        
        textMoiAndHot = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 156, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 73, height: ScreenSize.MUL_HEIGHT * 28))
        textMoiAndHot.setTitle(AppsSettings.listType[0].nametype, for: UIControlState())
        textMoiAndHot.setTitleColor(UIColor.white, for: UIControlState())
        textMoiAndHot.titleLabel?.font = UIFont.font65Medium(13)
        textMoiAndHot.addTarget(self, action: #selector(DataViewVideo.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textMoiAndHot.tag = 1
        
        textNhacTre = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 241, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 62, height: ScreenSize.MUL_HEIGHT * 28))
        textNhacTre.setTitle(AppsSettings.listType[1].nametype, for: UIControlState())
        textNhacTre.setTitleColor(UIColor.white, for: UIControlState())
        textNhacTre.titleLabel?.font = UIFont.font65Medium(13)
        textNhacTre.addTarget(self, action: #selector(DataViewVideo.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textNhacTre.tag = 2
        
        textTruTinh = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 311, y: ScreenSize.MUL_HEIGHT * 2, width: ScreenSize.MUL_WIDTH * 54, height: ScreenSize.MUL_HEIGHT * 28))
        textTruTinh.setTitle(AppsSettings.listType[2].nametype, for: UIControlState())
        textTruTinh.setTitleColor(UIColor.white, for: UIControlState())
        textTruTinh.titleLabel?.font = UIFont.font65Medium(13)
        textTruTinh.addTarget(self, action: #selector(DataViewVideo.actionEven(_:)), for: UIControlEvents.touchUpInside)
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
        textDropdown.addTarget(self, action: #selector(DataViewVideo.actionEven(_:)), for: UIControlEvents.touchUpInside)
        textDropdown.tag = 4
        
        
        //tao list play list scroll horizontal
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 100 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        self.listVideoHorizontal = UICollectionView(frame: CGRect(x: 0 , y: 35 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 230 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.listVideoHorizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.listVideoHorizontal.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.listVideoHorizontal.isPagingEnabled = true
        self.listVideoHorizontal.backgroundColor = UIColor.clear
        
        self.addSubview(textObject)
        self.addSubview(textMoiAndHot)
        self.addSubview(textNhacTre)
        self.addSubview(textTruTinh)
        self.addSubview(textDropdown)
        self.addSubview(listVideoHorizontal)
    }
}

extension DataViewVideo : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DataViewVideo : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if listVideoHorizontal == collectionView {
            return list_linkUrl_video.count
        } else {
            return AppsSettings.listType.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if listVideoHorizontal == collectionView {
            let cell = self.listVideoHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
            let data = DataUICollectionViewCellPlayListData(image_Song: list_image_video[indexPath.row], text_Count_Listen: list_counter_video[indexPath.row], text_Title_PlayList: list_title_video[indexPath.row], text_Author: list_artistName_video[indexPath.row])
            cell.setData(data)
            return cell
        }else {
            let cell = self.listTypeSongHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellType.identifier, for: indexPath) as! DataUICollectionViewCellType
            let data = DataUICollectionViewCellTypeData(name_Type: AppsSettings.listType[indexPath.row].nametype)
            cell.setData(data)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listVideoHorizontal == collectionView {
            AppsSettings.playAudio?.pause()
            AppsSettings.isCheckedButtonPlay = false
            print("vao day nhes em")
            print("Id cua video la: " + list_id_video[indexPath.row])
            AppsSettings.root.updateVideo(list_id_video[indexPath.row])
            list_counter_video[indexPath.row] = String(Int(list_counter_video[indexPath.row])! + 1)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let alertsAnFavoritesController = storyboard.instantiateViewController(withIdentifier: "PlayVideoController") as! PlayVideoController
            AppsSettings.root.navigationController?.pushViewController(alertsAnFavoritesController, animated: true)
            thamsotruyen.set(String(list_linkUrl_video[indexPath.row]), forKey: "linkUrlVideo")
            print("link url video" + list_linkUrl_video[indexPath.row])
            collectionView.reloadData()
        } else {
            print("vao day nhe anh")
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
