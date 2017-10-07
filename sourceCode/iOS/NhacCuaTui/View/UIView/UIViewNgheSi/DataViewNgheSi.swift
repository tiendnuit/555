//
//  DataViewNgheSi.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewNgheSi: UIView {

    var ngheSiHorizontal: UICollectionView!
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    var viewPlayListByID: DataViewArtistByID!
    
    var list_image_artist: [String]! = []
    var list_title_artist: [String]! = []
    var list_author_artist: [String]! = []
    var list_count_listen: [String]! = []
    var list_id_artist: [String]! = []
    
    var artist: Artist!
    var list_artist: [Artist]! = []
    override func awakeFromNib(){
        artist = Artist()
        createInterface()
        ngheSiHorizontal.delegate = self
        ngheSiHorizontal.dataSource = self
        
        parceApi()
        
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
    ham parce api
    ****************************************************/
    func parceApi(){
        artist = Artist()
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getLisArtist("api/listArtist",artist:artist, success: {(response) -> Void in
            self.list_artist = response.items
            if self.list_artist.count > 0 {
                for i in 0..<self.list_artist.count{
                    self.artist = self.list_artist[i]
                    if self.artist.idArtist != nil {
                        self.list_id_artist.append(String(self.artist.idArtist))
                    }
                    
                    if self.artist.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "artists/tb/" + self.artist.image
                        self.list_image_artist.append(link_image)
                    }
                    
                    if self.artist.artistname != nil {
                        self.list_title_artist.append(self.artist.artistname)
                    }
                    
                    if self.artist.descriPtion != nil {
                        self.list_author_artist.append(self.artist.descriPtion)
                    }
                }
            }
            self.ngheSiHorizontal.reloadData()
            }) { (error) -> Void in
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
    
    
    /***************************************************
    Khoi tao View
    ****************************************************/
    func createInterface(){
        //tao list play list scroll horizontal
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 80 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        //layoutPlayList.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.ngheSiHorizontal = UICollectionView(frame: CGRect(x: 0 , y: 35 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 230 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.ngheSiHorizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.ngheSiHorizontal.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.ngheSiHorizontal.isPagingEnabled = true
        self.ngheSiHorizontal.backgroundColor = UIColor.clear
        
        self.addSubview(ngheSiHorizontal)
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
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewNgheSi.actionEven), for: UIControlEvents.touchUpInside)

        viewPlayListByID = DataViewArtistByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
    }
}

extension DataViewNgheSi : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DataViewNgheSi : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list_id_artist.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.ngheSiHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
        cell
        let data = DataUICollectionViewCellPlayListData(image_Song: list_image_artist[indexPath.row], text_Count_Listen: "", text_Title_PlayList: list_title_artist[indexPath.row], text_Author: "")
        cell.setData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("PlayList " + list_image_artist[indexPath.row ])
        AppsSettings.idArtist = list_id_artist[indexPath.row]
        AppsSettings.titleArtist = list_title_artist[indexPath.row]
        AppsSettings.imageArtits = list_image_artist[indexPath.row]
        AppsSettings.descriptionArtist = list_author_artist[indexPath.row]
        createViewPlayListId()
    }

}
