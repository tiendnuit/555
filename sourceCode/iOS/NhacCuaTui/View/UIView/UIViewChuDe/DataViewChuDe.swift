//
//  DataViewChuDe.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/7/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewChuDe: UIView {

    var listChuDeHorizontal: UICollectionView!
    var viewPlayListByID: DataViewPlayListByID!
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    
    
    
    var list_id_chude: [String]! = []
    var list_image_chude: [String]! = []
    var list_title_chude: [String]! = []
    var list_description_chude: [String]! = []
    var list_count_listen: [String]! = []
    
    var chude: ChuDe!
    var list_ChuDe: [ChuDe] = []
    
    override func awakeFromNib(){
        
        createInterface()
        listChuDeHorizontal.delegate = self
        listChuDeHorizontal.dataSource = self
        
        parceApi()
    }
    
    
    
    /***************************************************
    ham parce api
    ****************************************************/
    func parceApi(){
        chude = ChuDe()
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getLisChuDe("api/listsubject",chuDe:chude, success: {(response) -> Void in
            self.list_ChuDe = response.items
            if self.list_ChuDe.count > 0 {
                for i in 0..<self.list_ChuDe.count {
                    self.chude = self.list_ChuDe[i]
                    if self.chude.idsubject != nil {
                        self.list_id_chude.append(String(self.chude.idsubject))
                    }
                    
                    if self.chude.image != nil {
                        
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "subjects/tb/" + self.chude.image
                        self.list_image_chude.append(link_image)
                    }
                    
                    if self.chude.subname != nil {
                        self.list_title_chude.append(self.chude.subname)
                    }
                    
                    if self.chude.descriPtion != nil {
                        self.list_description_chude.append(self.chude.descriPtion)
                    }
                }
            }
            self.listChuDeHorizontal.reloadData()
            }) { (error) -> Void in
        }

    }

//A9 1
    /***************************************************
    xet su kien khi click vao button
    ****************************************************/
    func createInterface(){
        //tao list play list scroll horizontal
      
        print("-------createInterface")
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 100 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        //layoutPlayList.scrollDirection = UICollectionViewScrollDirection.Horizontal
        self.listChuDeHorizontal = UICollectionView(frame: CGRect(x: 0 , y: 35 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 230 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.listChuDeHorizontal.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.listChuDeHorizontal.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.listChuDeHorizontal.isPagingEnabled = true
        self.listChuDeHorizontal.backgroundColor = UIColor.clear
        
        self.addSubview(listChuDeHorizontal)
    }
    
    func hideIndicator(){
        AppsSettings.root.hideActivityIndicator()
    }
    /***************************************************
    xet su kien khi click vao button
    ****************************************************/
    func actionEven(){
        self.dimBackgroundColor.removeFromSuperview()
        viewPlayListByID.removeFromSuperview()
        buttonOpenOrClose.removeFromSuperview()
        AppsSettings.imagePlayList = nil
        AppsSettings.titlePlayList = nil
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
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewChuDe.actionEven), for: UIControlEvents.touchUpInside)
        
        viewPlayListByID = DataViewPlayListByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
        AppsSettings.root.showActivityIndicator()
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(DataViewChuDe.hideIndicator), userInfo: nil, repeats: false)
    }
    
}

extension DataViewChuDe : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DataViewChuDe : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list_id_chude.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.listChuDeHorizontal.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
        let data = DataUICollectionViewCellPlayListData(image_Song: list_image_chude[indexPath.row], text_Count_Listen: "", text_Title_PlayList: list_title_chude[indexPath.row], text_Author: list_description_chude[indexPath.row])
        cell.setData(data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("---------------------------------")
        print("PlayList " + String(indexPath.row))
        for i in 0 ..< list_ChuDe.count{
            print(list_id_chude[i])
        }
        AppsSettings.idPlayList = list_id_chude[indexPath.row]
        print("-------------\(AppsSettings.idPlayList)")
        
        AppsSettings.imagePlayList = list_image_chude[indexPath.row]
        AppsSettings.titlePlayList = list_title_chude[indexPath.row]
        createViewPlayListId()
    }

}
