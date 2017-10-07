//
//  DataViewUser.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/29/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class DataViewUser: UIView , UITextFieldDelegate{

    @IBOutlet weak var varButtonSetting: UIButton!
   
    
    var list_id_playList: [String]! = []
    var list_title_playList: [String]! = []
    var list_id_playList_yeuthich: [String]! = []
    var list_image_playList_yeuthich: [String]! = []
    var list_title_playList_yeuthich: [String]! = []
    var list_setting: [String]! = ["ចាកចេញ"] //,"Góp ý","Thông tin","Đánh giá"
    var idChoose: Int!
    var createNewPlayList: CreatePlayList!
    var preferences = UserDefaults.standard
    var playList: PlayList!
    var playList_yeuthich: PlayList!
    var list_PlayList: [PlayList]! = []
    var list_PlayList_yeuthich: [PlayList]! = []
    
    //doi tuong view create playList
    var tablePlayList: UICollectionView!
    var tablePlayListYeuThich: UICollectionView!
    var imageBackground: UIImageView!
    var buttonCloseView: UIButton!
    var titleCreatePlayList: UILabel!
    var namePlayList: UITextField!
    var buttonCreate: UIButton!
    var tableListSetting: UITableView!
    var avatarUser: UIImageView!
    
    //khai bao bien playListByID
    var viewPlayListByID: DataViewPlayListByID!
    var buttonOpenOrClose: UIButton!
    var dimBackgroundColor = UIView()
    var lbUathich: UILabel!
    var checkShowSetting: Int! = 0
    var btNhacYeu: UIButton!
    var lbUsername: UILabel!
    var lbEmail: UILabel!
    var buttonCreatePlayList: UIButton!
    var moveTextField:CGFloat! = 0
    
    
    override func awakeFromNib(){
        createInterface()
        tablePlayList.delegate = self
        tablePlayList.dataSource = self
        
        tablePlayListYeuThich.delegate = self
        tablePlayListYeuThich.dataSource = self
        
        tableListSetting.delegate = self
        tableListSetting.dataSource = self
        tableListSetting.isHidden = true
        
        varButtonSetting.addTarget(self, action: #selector(DataViewUser.actionEven(_:)), for: UIControlEvents.touchUpInside)
        varButtonSetting.tag = 1
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewUser.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(DataViewUser.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        if preferences.object(forKey: "useridkey") != nil {
            let idUser = preferences.string(forKey: "useridkey")
            parceApiGetPlayList(idUser)
            parceApiGetPlayListYeuThich(idUser)
        }
        
       
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

    /******************************************
    hàm parce api tạo play list
    *******************************************/
    func parceApiCreatePlayList(_ idUser: String! , namePlaylist: String!){
        createNewPlayList = CreatePlayList()
        createNewPlayList.idUser = idUser
        createNewPlayList.namePlayList = namePlaylist
        AccountService(viewController: AppsSettings.root, isShowLoading: true).createPlayList("api/updateplaylist", playList: createNewPlayList, success: { (response) -> Void in
            let a = response
             print(a.mMessage)
             UIToast.makeText("បង្កើតបានជោគជ័យ").show()
            }) { (error) -> Void in
              print("error")
            self.parceApiGetPlayList(idUser)
        }
    }
    
    /******************************************
    hàm parce api láy danh sách playList của tôi
    *******************************************/
    func parceApiGetPlayList(_ idUser: String!){
        playList = PlayList()
        playList.idUser = idUser
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getPlayList("api/getPlaylistUser",playList:playList, success: {(response) -> Void in
            self.list_PlayList = response.items
            if self.list_PlayList.count > 0 {
                for i in 0..<self.list_PlayList.count {
                    self.playList = self.list_PlayList[i]
                    if self.playList.title != nil {
                        self.list_title_playList.append(self.playList.title)
                    }else{
                        self.list_title_playList.append("")
                    }
                    if self.playList.idplaylist != nil {
                        self.list_id_playList.append(self.playList.idplaylist)
                    }
                }
                self.tablePlayList.reloadData()
                print("Tong play List của tôi  " + String(self.list_id_playList.count))
            }
            }) { (error) -> Void in
        }
    }
    
    /******************************************
    hàm parce api láy danh sách playList yêu thích
    *******************************************/
    func parceApiGetPlayListYeuThich(_ idUser: String!){
        playList_yeuthich = PlayList()
        playList_yeuthich.idUser = idUser
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getPlayListLike("api/getPlaylistLike",playList:playList_yeuthich, success: {(response) -> Void in
            self.list_PlayList_yeuthich = response.items
            if self.list_PlayList_yeuthich.count > 0 {
                for i in 0..<self.list_PlayList_yeuthich.count {
                    self.playList_yeuthich = self.list_PlayList_yeuthich[i]
                    if self.playList_yeuthich.title != nil {
                        self.list_title_playList_yeuthich.append(self.playList_yeuthich.title)
                    }else{
                        self.list_title_playList_yeuthich.append("")
                    }
                    if self.playList_yeuthich.idplaylist != nil {
                        self.list_id_playList_yeuthich.append(self.playList_yeuthich.idplaylist)
                    }
                    if self.playList_yeuthich.image != nil {
                        let link_image = AppsSettings.Static.BASE_IMAGE_URL + "playlists/tb/" + self.playList_yeuthich.image
                        self.list_image_playList_yeuthich.append(link_image)
                    }
                }
                self.tablePlayListYeuThich.reloadData()
            }
            }) { (error) -> Void in
        }
    }
    
    
    /***************************************************
    xet su kien khi click vao button đóng mở playList ID
    ****************************************************/
    func actionEven(){
        if isCheckedOpenOrClose == false {
            self.dimBackgroundColor.isHidden = false
            viewPlayListByID.isHidden = false
            buttonOpenOrClose.removeFromSuperview()
            buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 52, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
            buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
            buttonOpenOrClose.addTarget(self, action: #selector(DataViewUser.actionEven as (DataViewUser) -> () -> ()), for: UIControlEvents.touchUpInside)
            self.addSubview(buttonOpenOrClose)
            isCheckedOpenOrClose = true
        }else{
            self.dimBackgroundColor.isHidden = true
            viewPlayListByID.isHidden = true
            buttonOpenOrClose.removeFromSuperview()
            buttonOpenOrClose = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 430, y:ScreenSize.MUL_HEIGHT * 105, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 37))
            buttonOpenOrClose.setBackgroundImage(UIImage(named:"btn_back.png"), for: UIControlState())
            buttonOpenOrClose.addTarget(self, action: #selector(DataViewUser.actionEven as (DataViewUser) -> () -> ()), for: UIControlEvents.touchUpInside)
            self.addSubview(buttonOpenOrClose)
            isCheckedOpenOrClose = false
        }
    }
    
    
    /******************************************
    Xét sự kiện khi click vào các nút button
    *******************************************/
    func actionEven(_ sender:UIButton){
        idChoose = sender.tag
        if idChoose == 1 {
            //xét sự kiện khi ấn vào button setting
            if tableListSetting.isHidden == true{
                tableListSetting.isHidden = false
            }else{
                tableListSetting.isHidden = true
            }
        }else if idChoose == 2 {   //xét sự kiện khi ấn vào button create PlayList
            print("create play list")
            createPlayList()
        }else if idChoose == 3 {   //xét sự kiện khi ấn vào button close form playList
            AppsSettings.dimBackgroundColor.removeFromSuperview()
            imageBackground.removeFromSuperview()
            buttonCloseView.removeFromSuperview()
            titleCreatePlayList.removeFromSuperview()
            namePlayList.removeFromSuperview()
            buttonCreate.removeFromSuperview()
        }else if idChoose == 4 {   //xét sự kiện khi ấn vào button tạo playList
            let whitespaceSet = CharacterSet.whitespaces
            if namePlayList.text!.trimmingCharacters(in: whitespaceSet) != "" {
                
                if preferences.object(forKey: "useridkey") != nil{
                    parceApiCreatePlayList(preferences.string(forKey: "useridkey") , namePlaylist: namePlayList.text)
                    
                    list_title_playList.removeAll()
                    list_id_playList.removeAll()
                    AppsSettings.dimBackgroundColor.removeFromSuperview()
                    imageBackground.removeFromSuperview()
                    buttonCloseView.removeFromSuperview()
                    titleCreatePlayList.removeFromSuperview()
                    namePlayList.removeFromSuperview()
                    buttonCreate.removeFromSuperview()
                }
            }else{
                dismissKeyboard()
                UIToast.makeText("ឈ្មោះបញ្ជីចាក់មិនត្រឹមត្រូវ").show()
            }
            
            
            
        }
    }
    
    
    /******************************************
    Hàm tạo giao diện create playList
    *******************************************/
    func createPlayList(){
        AppsSettings.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * -110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        AppsSettings.dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        AppsSettings.dimBackgroundColor.alpha=0.5
        
        imageBackground = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 90, y:ScreenSize.MUL_HEIGHT * 100, width: ScreenSize.MUL_WIDTH * 200, height: ScreenSize.MUL_HEIGHT * 90))
        imageBackground.image = UIImage(named: "background_createPlayList.png")
        
        buttonCloseView = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 280, y:ScreenSize.MUL_HEIGHT * 95, width: ScreenSize.MUL_HEIGHT * 17, height: ScreenSize.MUL_HEIGHT * 17))
        buttonCloseView.setBackgroundImage(UIImage(named:"btn_close.png"), for: UIControlState())
        buttonCloseView.addTarget(self, action: #selector(DataViewUser.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCloseView.tag = 3
        
        titleCreatePlayList = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 100, y:ScreenSize.MUL_HEIGHT * 110, width: ScreenSize.MUL_HEIGHT * 180, height: ScreenSize.MUL_HEIGHT * 23))
        titleCreatePlayList.text = "បញ្ចូលឈ្មោះបញ្ជីថ្មី"
        titleCreatePlayList.font = UIFont.font65Medium(15)
        titleCreatePlayList.textAlignment = .center
        
        namePlayList = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 152, width: ScreenSize.MUL_HEIGHT * 100, height: ScreenSize.MUL_HEIGHT * 23))
        namePlayList.placeholder = "ឈ្មោះបញ្ជីថ្មី"
        namePlayList.font = UIFont.font65Medium(12)
        namePlayList.delegate = self
        
        buttonCreate = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 232, y:ScreenSize.MUL_HEIGHT * 152, width: ScreenSize.MUL_HEIGHT * 55, height: ScreenSize.MUL_HEIGHT * 20))
//        buttonCreate.setBackgroundImage(UIImage(named:"btn_create.png"), forState: UIControlState.Normal)
        buttonCreate.addTarget(self, action: #selector(DataViewUser.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCreate.tag = 4
        buttonCreate.backgroundColor = UIColor.red
        buttonCreate.setTitle("បង្កើតមី", for: UIControlState())
        buttonCreate.titleLabel?.font = UIFont(name: "Arial", size: 11)
        buttonCreate.setTitleColor(UIColor.white, for: UIControlState())
        
        
        
        self.addSubview(AppsSettings.dimBackgroundColor)
        self.addSubview(imageBackground)
        self.addSubview(buttonCloseView)
        self.addSubview(titleCreatePlayList)
        self.addSubview(namePlayList)
        self.addSubview(buttonCreate)
        
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
        buttonOpenOrClose.addTarget(self, action: #selector(DataViewUser.actionEven as (DataViewUser) -> () -> ()), for: UIControlEvents.touchUpInside)
        isCheckedOpenOrClose = true
        
        viewPlayListByID = DataViewPlayListByID.loadNib()
        viewPlayListByID.frame = CGRect(x: ScreenSize.MUL_WIDTH * 80, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 410, height: ScreenSize.MUL_HEIGHT * 250)
        viewPlayListByID.buttonLike.removeFromSuperview()
        self.addSubview(dimBackgroundColor)
        self.addSubview(buttonOpenOrClose)
        self.addSubview(viewPlayListByID)
    }
    
    /******************************************
    Hàm tạo giao diện
    *******************************************/
    func createInterface(){
        //tao list play list scroll horizontal
        let layoutPlayList: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayList.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayList.itemSize = CGSize(width: 100 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        layoutPlayList.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.tablePlayList = UICollectionView(frame: CGRect(x: 0 , y: 155 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 105 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayList)
        self.tablePlayList.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayList=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.tablePlayList.register(nipNamePlayList, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.tablePlayList.isPagingEnabled = true
        self.tablePlayList.backgroundColor = UIColor.clear
        
        let layoutPlayListYeuThich: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutPlayListYeuThich.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutPlayListYeuThich.itemSize = CGSize(width: 100 * ScreenSize.MUL_WIDTH , height: 110 * ScreenSize.MUL_HEIGHT)
        layoutPlayListYeuThich.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        
        self.tablePlayListYeuThich = UICollectionView(frame: CGRect(x: 0 , y: 30 * ScreenSize.MUL_HEIGHT, width: 450 * ScreenSize.MUL_WIDTH, height: 105 * ScreenSize.MUL_HEIGHT), collectionViewLayout: layoutPlayListYeuThich)
        self.tablePlayListYeuThich.register(UICollectionViewCell.self, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        let nipNamePlayListYeuThich=UINib(nibName: "DataUICollectionViewCellPlayList", bundle:nil)
        self.tablePlayListYeuThich.register(nipNamePlayListYeuThich, forCellWithReuseIdentifier: DataUICollectionViewCellPlayList.identifier)
        self.tablePlayListYeuThich.isPagingEnabled = true
        self.tablePlayListYeuThich.backgroundColor = UIColor.clear
        
        tableListSetting = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 370, y: ScreenSize.MUL_HEIGHT * 27, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 45))
        tableListSetting.backgroundColor = UIColor(hex: "000000")
        self.tableListSetting.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableListSetting.registerCellNib(DataTableViewCellCountry.self)
        
        avatarUser = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 10, y: ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 80))
        
        avatarUser.layer.cornerRadius = ScreenSize.MUL_HEIGHT * 10
        avatarUser.clipsToBounds = true
        if preferences.object(forKey: "idfacebook") != nil{
            if preferences.string(forKey: "idfacebook")!.length > 0 {
                load_image("http://graph.facebook.com/" + preferences.string(forKey: "idfacebook")! + "/picture?type=large")
                print("-------" +  "http://graph.facebook.com/" + preferences.string(forKey: "idfacebook")! + "/picture?type=large")
            }
        }
        buttonCreatePlayList = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 370, y: ScreenSize.MUL_HEIGHT * 110, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 15))
        buttonCreatePlayList.addTarget(self, action: #selector(DataViewUser.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCreatePlayList.backgroundColor = UIColor.red
        buttonCreatePlayList.setTitle("បង្កើតបញ្ជីបទចំរៀង", for: UIControlState())
        buttonCreatePlayList.titleLabel?.font = UIFont.systemFont(ofSize: ScreenSize.MUL_HEIGHT * 11)
        buttonCreatePlayList.tag = 2
        buttonCreatePlayList.layer.cornerRadius = ScreenSize.MUL_HEIGHT * 3
        
        lbUathich = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 380, y: ScreenSize.MUL_HEIGHT * 90, width: ScreenSize.MUL_WIDTH * 60, height: ScreenSize.MUL_HEIGHT * 15))
        lbUathich.text = "បទចំរៀងពេញនិយម"
        lbUathich.font = UIFont.systemFont(ofSize: ScreenSize.MUL_HEIGHT * 11)
        lbUathich.textColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.00)
        
        
        btNhacYeu = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 360, y: ScreenSize.MUL_HEIGHT * 40, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 50))
        btNhacYeu.setBackgroundImage(UIImage(named: "lovemusic"),for: UIControlState())
        btNhacYeu.addTarget(self, action: #selector(DataViewUser.showlistyeuthich(_:)), for: UIControlEvents.touchUpInside)
        lbEmail = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 110, y: ScreenSize.MUL_HEIGHT * 80, width: ScreenSize.MUL_WIDTH * 200, height: ScreenSize.MUL_HEIGHT * 15))
        if preferences.object(forKey: "useremailkey") != nil{
            lbEmail.text = preferences.string(forKey: "useremailkey")
        }
        
        lbEmail.textColor = UIColor.white
        lbEmail.font = UIFont.systemFont(ofSize: ScreenSize.MUL_HEIGHT * 12)
        
        lbUsername = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 110, y: ScreenSize.MUL_HEIGHT * 60, width: ScreenSize.MUL_WIDTH * 200, height: ScreenSize.MUL_HEIGHT * 15))
        if preferences.object(forKey: "usernamekey") != nil{
        lbUsername.text = preferences.string(forKey: "usernamekey")
        }
        lbUsername.textColor = UIColor.white
        lbUsername.font = UIFont.systemFont(ofSize: ScreenSize.MUL_HEIGHT * 12)
        
        
        self.addSubview(avatarUser)
        self.addSubview(btNhacYeu)
        self.addSubview(tablePlayList)
        self.addSubview(buttonCreatePlayList)
        self.addSubview(tableListSetting)
        self.addSubview(lbUathich)
        self.addSubview(lbEmail)
        self.addSubview(lbUsername)
    }
        
    func load_image(_ urlString:String){
        let imgURL: URL = URL(string: urlString)!
        let request: Foundation.URLRequest = Foundation.URLRequest(url: imgURL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    self.avatarUser.image = UIImage(data: data!)
                }
                
                DispatchQueue.main.async(execute: display_image)
            }
            
        })
        
        task.resume()
    }

    func showlistyeuthich(_ sender: UIButton!){
        self.addSubview(tablePlayListYeuThich)
//        print("this list:" + list_title_playList[0] + list_image_playList_yeuthich[0])
        avatarUser.removeFromSuperview()
        lbUathich.removeFromSuperview()
        lbUsername.removeFromSuperview()
        lbEmail.removeFromSuperview()
        btNhacYeu.removeFromSuperview()
        tablePlayList.removeFromSuperview()
        buttonCreatePlayList.removeFromSuperview()
    }
    }

extension DataViewUser : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 30
    }
}

extension DataViewUser : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_setting.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableListSetting.dequeueReusableCell(withIdentifier: DataTableViewCellCountry.identifier) as! DataTableViewCellCountry
        let data = DataTableViewCellListCountryData(title_Country: list_setting[indexPath.row])
        cell.setData(data)
        return cell
    }
 //logout
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            tableListSetting.isHidden = true
            print("setting")
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            let checkloginkey = "checklogin"
            let idfacebooks = "idfacebook"
            let idfacebook = ""
            let loginkey = 0
            preferences.set(loginkey, forKey: checkloginkey)
            preferences.setValue(idfacebook, forKey: idfacebooks)
            preferences.setValue("", forKey: "useridkey")
            preferences.setValue("", forKey: "usernamekey")
            AppsSettings.checklog = "0"
            
            let didSave = preferences.synchronize()
            if !didSave {
                print("Error to check login")
            }
            print("----------------------------------\(AppsSettings.checklog)")
            AppsSettings.shit = true
        }
    }
}

extension DataViewUser : UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
extension DataViewUser : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tablePlayList {
            return list_id_playList.count
        }else {
            return list_id_playList_yeuthich.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tablePlayList {
            let cell = self.tablePlayList.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
            let data = DataUICollectionViewCellPlayListData(image_Song: "", text_Count_Listen: "" , text_Title_PlayList: list_title_playList[indexPath.row], text_Author: "")
            cell.setData(data)
            return cell
        }else{
            let cell = self.tablePlayListYeuThich.dequeueReusableCell(withReuseIdentifier: DataUICollectionViewCellPlayList.identifier, for: indexPath) as! DataUICollectionViewCellPlayList
           
            let data = DataUICollectionViewCellPlayListData(image_Song: list_image_playList_yeuthich[indexPath.row], text_Count_Listen: "" , text_Title_PlayList: list_title_playList_yeuthich[indexPath.row], text_Author: "")
            cell.setData(data)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        AppsSettings.idPlayList.removeAll()
//        AppsSettings.titlePlayList.removeAll()
        if collectionView == tablePlayList {
            //AppsSettings.originTime.invalidate()
            AppsSettings.imagePlayList = nil
            AppsSettings.idPlayList = list_id_playList[indexPath.row]
            AppsSettings.titlePlayList = list_title_playList[indexPath.row]
            AppsSettings.checkClickMyPlaylist = true
            print("thisss: " + String(AppsSettings.isCheckedButtonPlay))
            createViewPlayListId()
            
        }else{
            //AppsSettings.originTime.invalidate()
            AppsSettings.imagePlayList = list_image_playList_yeuthich[indexPath.row]
            AppsSettings.idPlayList = list_id_playList_yeuthich[indexPath.row]
            AppsSettings.titlePlayList = list_title_playList_yeuthich[indexPath.row]
            AppsSettings.checkClickMyPlaylist = true
            createViewPlayListId()
        }

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == namePlayList){ moveTextField = 30}
        else { moveTextField = 30}
        
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func keyboardWillShow(_ sender: Notification) {
        self.frame.origin.y = -moveTextField
    }
    
    func keyboardWillHide(_ sender: Notification) {
        self.frame.origin.y = 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

}
