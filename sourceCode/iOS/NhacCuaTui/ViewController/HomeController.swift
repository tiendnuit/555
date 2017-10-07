//
//  HomeController.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/5/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//
import FBSDKLoginKit
import UIKit
import MediaPlayer
import AVFoundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@available(iOS 8.0, *)
class HomeController: BaseViewController , AVAudioPlayerDelegate {
    //khai bao UIView
    var background: UIImageView!
    var avatarUser: UIImageView!
    var nameUser: UILabel!
    
    var tableViewLeft: UITableView!
    var listImageIcon: [String]!
    var listTextTile: [String]!
    
    var imageButtonBack: UIButton!
    var imageButtonNext: UIButton!
    var imageButtonAdd: UIButton!
    var imageButtonShare: UIButton!
    var imageButtonDownload: UIButton!
    var imageButtonRanDom: UIButton!
    var imageButtonMute: UIButton!
    var imageButtonListSong: UIButton!
    //var longTimeSong: UILabel!
    
    //khai bao nhung UIView con
    var imageViewHome: DataViewHome!
    var imageViewSearch: DataViewSearch!
    var imageViewBXH: DataViewBXH!
    var imageViewBaiHat: DataViewBaiHat!
    var imageViewPlayList: DataViewPlayList!
    var imageViewVideo: DataViewVideo!
    var imageViewChuDe: DataViewChuDe!
    var imageViewNgheSi: DataViewNgheSi!
    var imageViewNCT: DataViewNCT!
    var imageViewContentSong: DataViewContentSong!
    var imageViewPlayListRight: DataViewPlayListRight!
    var imageViewUser: DataViewUser!
    
    let preferences = UserDefaults.standard
    var userIDFacebook: String! = ""
    var checklogin: String! = ""
    var usernames: String! = ""
    var userids: String! = ""
    let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
    
    //doi tuong view create playList
    var imageBackground: UIImageView!
    var buttonCloseView: UIButton!
    var titleCreatePlayList: UILabel!
    var namePlayList: UITextField!
    var buttonCreate: UIButton!
    var tablePlayListName: UITableView!
    var createNewPlayList: CreatePlayList!
    
    //khai bao media player
    var idChoose: Int!
    var radioPlayer: MPMoviePlayerController!
    var notesArray:NSMutableArray!
    var plistPath:String!
    
    //khai bao bien play list local
    var list_id_playList: [String]! = []
    var list_title_playList: [String]! = []
    var playListLocal: PlayList!
    var list_PlayList: [PlayList]! = []
    
    var countChoose: Int! = 0
    
    var wrapperView: UIView!
    var checkClickVolume: Int! = 0
    
    var volumeView: MPVolumeView!
    
    
    
    
    var checkSelectedView: Int! = 0
    var checkClickRightList: Bool! = false
    override func didReceiveMemoryWarning() {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true // for navigation bar hide
        UIApplication.shared.isStatusBarHidden = true;
        if (AppsSettings.checkflag == true)
        {
            print("vao o day la tot")
        }
    }
    var listImageIconChoose : [String] = []
    var listColor: [String] = ["5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
    
    override func viewDidLoad() {
        //        checkNetworth()
        //
        //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        //        view.addGestureRecognizer(tap)
        
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            print("AVAudioSession Category Playback OK")
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                print("AVAudioSession is Active")
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        getRegion()
        getType()
        
        let idfacebookkey = "idfacebook"
        let checkloginkey = "checklogin"
        let usernamekeys = "usernamekey"
        let useridkeys = "useridkey"
        
        
        listImageIcon = ["ic_homeclick.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-6.png"]
        listTextTile = ["ទំព័រដើម" , " ស្វែងរក" , " ចំណាត់ថ្នាក់" , " បទចំរៀង" , " បញ្ជីបទចំរៀង" , " វីឌីអូ" , "ប្រធានបទ" , " អក្នចំរៀង" , "បទចំរៀងរបស់ខ្ញុំ"]
        
        
        if preferences.object(forKey: checkloginkey) != nil{
            checklogin = preferences.string(forKey: checkloginkey)
            AppsSettings.checklog = checklogin
            usernames = preferences.string(forKey: usernamekeys)
            userids = preferences.string(forKey: useridkeys)
        }
        
        
        if preferences.object(forKey: idfacebookkey) != nil && preferences.object(forKey: usernamekeys) != nil && preferences.object(forKey: useridkeys) != nil{
            userIDFacebook = preferences.string(forKey: idfacebookkey)
            usernames = preferences.string(forKey: usernamekeys)
            userids = preferences.string(forKey: useridkeys)
            AppsSettings.idUserFacebook = userIDFacebook
        }
        //Login 1.1
        creatInterface()
        tableViewLeft.delegate = self
        tableViewLeft.dataSource = self
        
        //        imageViewHome.hidden = false
        //        imageViewSearch.hidden = true
        //        imageViewBXH.hidden = true
        //        imageViewBaiHat.removeFromSuperview()
        //        imageViewPlayList.hidden = true
        //        imageViewVideo.hidden = true
        //        imageViewChuDe.hidden = true
        //        imageViewNgheSi.hidden = true
        
        if usernames != nil{
            if usernames.isEmpty == false {
                AppsSettings.nameUserAvatar.text = usernames
            }
        }
        
        var timer:Timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomeController.listenChangeFlag(_:)), userInfo: nil, repeats: true)
        var timer2:Timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HomeController.shit(_:)), userInfo: nil, repeats: true)
    }
    // dau cong 3
    func listenChangeFlag(_ sender: AnyObject) {
        if(AppsSettings.flag == 1){
            test()
            
        }
    }
    //thaydoi1
    func shit(_ sender: AnyObject) {
        if(AppsSettings.shit == true){
            changeViewController(0)
            AppsSettings.shit = false
        }
        if(AppsSettings.checklog == "0"){
            AppsSettings.nameUserAvatar.text = ""
            avatarUser.image = UIImage(named: "avatar_user.png")
        }
        if(AppsSettings.statusLoginNomal == true){
            AppsSettings.nameUserAvatar.text = AppsSettings.saveNameLoginNomal
            AppsSettings.statusLoginNomal = false
        }
    }
    
    //get list type
    func getType(){
        var typeRelax = TypeRelax()
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getType("api/listtype", type: typeRelax, success: { (response) -> Void in
            AppsSettings.listType = response.listType
            
        }) { (error) -> Void in
            print("error")
            //UIToast.makeText("Success").show()
            
        }
    }
    
    //get region and country
    func getRegion(){
        var region = Region()
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getRegion("api/listcountry", region:region, success: { (response) -> Void in
            AppsSettings.listCountry = response.listCountry
            
        }) { (error) -> Void in
            print("error")
            //UIToast.makeText("Success").show()
            
        }
    }
    
    /***********************************************
     su kien khi click vào các button trong man hinh
     ************************************************/
    func actionEven(_ sender:UIButton) {
        idChoose = sender.tag
        if idChoose == 1 {     //su kien back music
            if AppsSettings.list_url_song.count > 0 {
                if AppsSettings.checkRandomSong == 0 {
                    AppsSettings.originTime.invalidate()
                    if(AppsSettings.position > 0){
                        AppsSettings.position = AppsSettings.position - 1
                        if AppsSettings.checkListenLocal == false {
                            
                            AppsSettings.playMusicLocal(AppsSettings.list_url_song[AppsSettings.position], titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }
                        else {
                            AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }
                    }else{
                        AppsSettings.position = AppsSettings.list_url_song.count - 1
                        if AppsSettings.checkListenLocal == false {
                            AppsSettings.playMusicLocal(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }
                        else {
                            AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }
                    }
                }else if AppsSettings.checkRandomSong == 1 {
                    AppsSettings.radioPlayer.stop()
                    AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                }else if AppsSettings.checkRandomSong == 2 {
                    AppsSettings.radioPlayer.stop()
                    AppsSettings.position = Int(arc4random_uniform(UInt32(AppsSettings.list_url_song.count - 1)) + 1)
                    print(AppsSettings.position)
                    AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                } else if AppsSettings.checkRandomSong == 3 {
                    AppsSettings.radioPlayer.stop()
                    AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                }
            }
        }else if idChoose == 2 {  //su kien play music
            print("clicked")
            if AppsSettings.list_url_song.count > 0 {
                if AppsSettings.isCheckedButtonPlay == true {
                    AppsSettings.isCheckedButtonPlay = false
                    AppsSettings.playAudio!.pause()
                    AppsSettings.checkPlaySong = true
                } else {
                    AppsSettings.checkPlaySong = false
                    AppsSettings.timeStop = AppsSettings.playAudio?.currentTime()
                    if AppsSettings.checkListenLocal == true {
                        AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position]  , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        AppsSettings.isCheckedButtonPlay = true
                    }else{
                        AppsSettings.playMusicLocal(AppsSettings.list_url_song[AppsSettings.position]  , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        AppsSettings.isCheckedButtonPlay = true
                    }
                    print(AppsSettings.list_url_song[AppsSettings.position])
                }
            }
        }else if idChoose == 3 { //su kien next music
            if AppsSettings.list_url_song.count > 0 {
                if AppsSettings.checkRandomSong == 0 {
                    AppsSettings.originTime.invalidate()
                    if(AppsSettings.position < (AppsSettings.list_url_song.count - 1)){
                        AppsSettings.position = AppsSettings.position + 1
                        if AppsSettings.checkListenLocal == true {
                            AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }else{
                            AppsSettings.playMusicLocal(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }
                    }else if AppsSettings.position == (AppsSettings.list_url_song.count - 1) {
                        AppsSettings.position = 0 - 1
                        AppsSettings.position = AppsSettings.position + 1
                        if AppsSettings.checkListenLocal == true {
                            AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }else{
                            AppsSettings.playMusicLocal(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                        }
                    }
                } else if AppsSettings.checkRandomSong == 1 {
                    AppsSettings.playAudio?.pause()
                    AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                } else if AppsSettings.checkRandomSong == 2 {
                    AppsSettings.position = Int(arc4random_uniform(UInt32(AppsSettings.list_url_song.count - 1)) + 1)
                    print(AppsSettings.position)
                    AppsSettings.playAudio?.pause()
                    AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                } else if AppsSettings.checkRandomSong == 3 {
                    AppsSettings.playAudio?.pause()
                    AppsSettings.playMusic(AppsSettings.list_url_song[AppsSettings.position] , titleSong: AppsSettings.list_title_song[AppsSettings.position])
                }
                
            }
            //Dau cong 1
        }else if idChoose == 4 {  //su kien khi click vao dau cong
            print("-------idSong 1: \(AppsSettings.idSong)")
            //            print("idsong2:\(AppsSettings.list_id_song[AppsSettings.position])")
            if AppsSettings.linkSong != "" {
                print("-----l")
                if checklogin == "1" ||  AppsSettings.checklog == "1"{
                    if preferences.object(forKey: "useridkey") != nil {
                        let idUser = preferences.string(forKey: "useridkey")
                        AppsSettings.root.showActivityIndicator()
                        //                        AppsSettings.keykey = 1
                        preferences.set("1", forKey: "keykey")
                        parceApiGetPlayList(idUser)
                    }
                }else {
                    UIToast.makeText("លោកអ្នកត្រូវតែចូលគណនី!").show()
                }
            }else{
                UIToast.makeText("គ្មានបទចំរៀង").show()
            }
            
        }else if idChoose == 5 { //xét sự kiện khi click vào button share
            print("lai day di cung")
            if AppsSettings.linkSong != ""{
                if checklogin == "1"{
                    if AppsSettings.linkSong.range(of: "googledrive.com") == nil
                    {
                        content.contentURL = URL(string: AppsSettings.linkSong)
                        content.contentDescription = AppsSettings.textNameSong.text
                        content.imageURL = URL(string: AppsSettings.linkSong)
                        FBSDKShareDialog.show(from: self, with: content, delegate: nil)
                    }
                    else
                    {
                        UIToast.makeText("កំហុស").show()
                    }
                } else
                {
                    UIToast.makeText("លោកអ្នកត្រូវតែចូលគណនី!").show()
                }
            }else{
                UIToast.makeText("គ្មានបទចំរៀង").show()
            }
        }else if idChoose == 6 { //xét sự kiện khi click vào button download
            
            if AppsSettings.linkSong != "" {
                UIToast.makeText("កំពុងទាញយក").show()
                
                let prString = AppsSettings.linkSong.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
                
                if AppsSettings.linkSong.range(of: "docs.google.com") != nil {
                    Downloader.loadSong(prString)
                    UIToast.makeText("ទាញយកបទចំរៀងមិនជោគជ័យ!").show()
                }else{
                    let url = URL(string: prString)
                    print(String(describing: url) + "------------------")
                    Downloader().loadFileAsync(url!, completion:{(path:String, error:NSError!) in
                        UIToast.makeText("ទាញយកបទចំរៀងមិនជោគជ័យ!").show()
                    })
                }
                
                
            }else{
                UIToast.makeText("គ្មានបទចំរៀង").show()
            }
        }else if idChoose == 7 { //xet sự kiện xáo trộn bài hát
            if countChoose < 3 {
                countChoose = countChoose + 1
                if countChoose == 1 {
                    imageButtonRanDom.setBackgroundImage(UIImage(named:"no-repeat.png"), for: UIControlState())
                    AppsSettings.checkRandomSong = 1
                }else if countChoose == 2 {
                    imageButtonRanDom.setBackgroundImage(UIImage(named:"random.png"), for: UIControlState())
                    AppsSettings.checkRandomSong = 2
                } else if countChoose == 3 {
                    imageButtonRanDom.setBackgroundImage(UIImage(named:"repeat_1.png"), for: UIControlState())
                    AppsSettings.checkRandomSong = 3
                }
            } else {
                countChoose = 0
                imageButtonRanDom.setBackgroundImage(UIImage(named:"repeat_all.png"), for: UIControlState())
                AppsSettings.checkRandomSong = 0
            }
            
        }else if idChoose == 8 { //set sự kiện volume
            wrapperView = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 180, y: ScreenSize.MUL_HEIGHT * 50, width: ScreenSize.MUL_WIDTH * 220, height: ScreenSize.MUL_HEIGHT * 15))
            if checkClickVolume == 0{
                checkClickVolume = 1
                self.view.backgroundColor = UIColor.clear
                self.view.addSubview(wrapperView)
                volumeView = MPVolumeView(frame: wrapperView.bounds)
                wrapperView.addSubview(volumeView)
                
                Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(HomeController.autoHideVolume), userInfo: nil, repeats: false)
                
            }else {
                print("this check click: " + String(checkClickVolume))
                checkClickVolume = 0
                wrapperView.isHidden = true
                self.wrapperView.removeFromSuperview()
                volumeView.removeFromSuperview()
            }
            
            
        }else if idChoose == 9 { //xét sự kiện khi mở list danh sách nhạc trong playList
            print("clicked")
            if AppsSettings.list_url_song.count > 0 {
                print(checkClickRightList)
                if checkClickRightList == false{
                    self.imageViewPlayListRight = DataViewPlayListRight.loadNib()
                    imageViewPlayListRight.frame = CGRect(x: ScreenSize.MUL_WIDTH * 390, y:ScreenSize.MUL_HEIGHT * 60, width: ScreenSize.MUL_WIDTH * 170, height: ScreenSize.MUL_HEIGHT * 220)
                    self.view.addSubview(imageViewPlayListRight)
                    checkClickRightList = true
                }else{
                    imageViewPlayListRight.removeFromSuperview()
                    checkClickRightList = false
                }
                
            } else
            {
                UIToast.makeText("មិនទាន់មានបទចំរៀង").show()
            }
        }else if idChoose == 10 { //xét sự kiện khi click vào slider
            //            let timeleft = AppsSettings.durationSong - Double(AppsSettings.sliderSong.value)
            //            AppsSettings.isCheckedButtonPlay = false
            AppsSettings.longTimeSongRun.text = Double(AppsSettings.sliderSong.value).minuteSecondMS + " /"
            print("this time seek: " + String(describing: CMTimeMake(Int64(AppsSettings.sliderSong.value), 1)))
            AppsSettings.playAudio?.seek(to: CMTimeMake(Int64(AppsSettings.sliderSong.value), 1))
            print("thisssss check:" + String(AppsSettings.isCheckedButtonPlay))
            //            AppsSettings.playAudio?.pause()
            if AppsSettings.isCheckedButtonPlay == false{
                AppsSettings.playAudio?.pause()
                //                AppsSettings.isCheckedButtonPlay = true
            }else{
                AppsSettings.playAudio?.play()
                //                AppsSettings.isCheckedButtonPlay = false
            }
            
            
            //timer =  NSTimer.scheduledTimerWithTimeInterval(timeleft, target: self, selector: "autoNextsongs", userInfo: nil, repeats: false)
        } else if idChoose == 11 { //xét sự kiện khi click button close view playList
            AppsSettings.dimBackgroundColor.removeFromSuperview()
            imageBackground.removeFromSuperview()
            buttonCloseView.removeFromSuperview()
            titleCreatePlayList.removeFromSuperview()
            namePlayList.removeFromSuperview()
            buttonCreate.removeFromSuperview()
        } else if idChoose == 12 {   //xét sự kiện khi click button create playList
            if namePlayList.text?.length > 0 {
                if preferences.object(forKey: "useridkey") != nil {
                    let idUser = preferences.string(forKey: "useridkey")
                    parceApiCreatePlayList(idUser, namePlaylist: namePlayList.text)
                    AppsSettings.dimBackgroundColor.removeFromSuperview()
                    imageBackground.removeFromSuperview()
                    buttonCloseView.removeFromSuperview()
                    titleCreatePlayList.removeFromSuperview()
                    namePlayList.removeFromSuperview()
                    buttonCreate.removeFromSuperview()
                }
            }else{
                UIToast.makeText("សូមបញ្ចូលឈ្មោះបញ្ជីបទចំរៀង").show()
            }
            
        } else if idChoose == 13 { //xét sự kiện khi click button của list chọn playList
            AppsSettings.dimBackgroundColor.removeFromSuperview()
            imageBackground.removeFromSuperview()
            buttonCloseView.removeFromSuperview()
            titleCreatePlayList.removeFromSuperview()
            tablePlayListName.removeFromSuperview()
        }
        
    }
    
    func hideControllVolume(){
        view.removeFromSuperview()
        
    }
    
    func listenVolumeButton(){
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        audioSession.addObserver(self, forKeyPath: "outputVolume", options: NSKeyValueObservingOptions.new, context: nil)
        //If you want to hide Volume HUD view
        
        
    }
    
    /******************************************
     Hàm xét sự kiện khi click vào menu bên trái
     *******************************************/
    func changeViewController(_ position: Int) {
        switch position {
        case 0:
            
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewHome != nil {
                imageViewHome.removeFromSuperview()
            }
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            
            self.view.addSubview(imageViewHome)
            
            listImageIcon = ["ic_homeclick.png" , "ic_search.png" ,
                             "ic_rank.png" , "ic_song.png" , "ic_playlist.png" ,
                             "ic_video.png" , "ic_sub.png" , "ic_artist.png" ,
                             "Untitled-6.png"]
            listColor = ["5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
            checkSelectedView = 0
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
        case 1:
            
            
            imageViewHome.removeFromSuperview()
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewSearch != nil {
                imageViewSearch.removeFromSuperview()
            }
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewSearch = DataViewSearch.loadNib()
            imageViewSearch.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewSearch.backgroundColor = UIColor.clear
            self.view.addSubview(imageViewSearch)
            
            listImageIcon = ["ic_home.png" , "ic_searchclick.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
            checkSelectedView = 1
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
        case 2:
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewBXH != nil {
                imageViewBXH.removeFromSuperview()
            }
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewBXH = DataViewBXH.loadNib()
            imageViewBXH.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewBXH.backgroundColor = UIColor.clear
            
            self.view.addSubview(imageViewBXH)
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rankclick.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","FFFFFF","5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
            checkSelectedView = 2
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
        case 3:
            
            
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            
            if imageViewBaiHat != nil {
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewBaiHat = DataViewBaiHat.loadNib()
            imageViewBaiHat.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewBaiHat.backgroundColor = UIColor.clear
            
            
            self.view.addSubview(self.imageViewBaiHat)
            //            imageViewBaiHat.reloadInputViews()
            
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_songclick.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
            checkSelectedView = 3
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
        case 4:
            
            
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            
            if imageViewPlayList != nil {
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewPlayList = DataViewPlayList.loadNib()
            imageViewPlayList.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewPlayList.backgroundColor = UIColor.clear
            
            
            self.view.addSubview(imageViewPlayList)
            
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlistclick.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","FFFFFF","5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
            checkSelectedView = 4
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
        case 5:
            
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewVideo != nil {
                imageViewVideo.removeFromSuperview()
            }
            
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewVideo = DataViewVideo.loadNib()
            imageViewVideo.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewVideo.backgroundColor = UIColor.clear
            
            
            
            self.view.addSubview(imageViewVideo)
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_videoclick.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","5BF8FD","FFFFFF","FFFFFF","FFFFFF"]
            checkSelectedView = 5
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
        case 6:
            
            
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewChuDe != nil {
                imageViewChuDe.removeFromSuperview()
            }
            
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewChuDe = DataViewChuDe.loadNib()
            imageViewChuDe.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewChuDe.backgroundColor = UIColor.clear
            
            
            
            self.view.addSubview(imageViewChuDe)
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_subclick.png" , "ic_artist.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","5BF8FD","FFFFFF","FFFFFF"]
            checkSelectedView = 6
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
        case 7:
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewNgheSi != nil {
                imageViewNgheSi.removeFromSuperview()
            }
            
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            self.imageViewNgheSi = DataViewNgheSi.loadNib()
            imageViewNgheSi.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewNgheSi.backgroundColor = UIColor.clear
            
            
            
            self.view.addSubview(imageViewNgheSi)
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artistclick.png" , "Untitled-6.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","5BF8FD","FFFFFF"]
            checkSelectedView = 7
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
            
        case 8:
            
            imageViewHome.removeFromSuperview()
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewPlayList != nil {
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            if AppsSettings.formLogin != nil{
                AppsSettings.formLogin.removeFromSuperview()
            }
            //            if AppsSettings.dimBackgroundColor != nil {
            //                AppsSettings.dimBackgroundColor.removeFromSuperview()
            //                AppsSettings.formLogin.removeFromSuperview()
            //            }
            
            //            AppsSettings.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
            //            AppsSettings.dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
            //            AppsSettings.dimBackgroundColor.alpha=0.5
            //            AppsSettings.formLogin = DataUiViewFormLogin.loadNib()
            //            AppsSettings.formLogin.frame = CGRect(x: ScreenSize.MUL_WIDTH * 170, y:ScreenSize.MUL_HEIGHT * 79, width: ScreenSize.MUL_WIDTH * 250, height: ScreenSize.MUL_HEIGHT * 162)
            
            self.imageViewNCT = DataViewNCT.loadNib()
            imageViewNCT.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewNCT.backgroundColor = UIColor.clear
            
            self.view.addSubview(self.imageViewNCT)
            //            view.addSubview(AppsSettings.dimBackgroundColor)
            //            view.addSubview(AppsSettings.formLogin)
            
            AppsSettings.dimBackgroundColor.isHidden = true
            //            AppsSettings.formLogin.hidden = true
            
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-5.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","5BF8FD"]
            checkSelectedView = 8
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
            
            
        default:
            break
        }
        
        tableViewLeft.reloadData()
    }
    
    
    
    func hideIndicator(){
        AppsSettings.root.hideActivityIndicator()
    }
    //Login 0
    /***********************************************
     Hàm xét sự kiện khi click vào avatar để login
     ************************************************/
    func imageTapped(_ img: AnyObject)
    {
        
        print("----------------------------------\(AppsSettings.checklog)")
        if AppsSettings.checklog == "1"{
            imageViewHome.removeFromSuperview()
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewUser != nil {
                imageViewUser.removeFromSuperview()
            }
            
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            listImageIcon = ["ic_home.png" , "ic_search.png" ,
                             "ic_rank.png" , "ic_song.png" , "ic_playlist.png" ,
                             "ic_video.png" , "ic_sub.png" , "ic_artist.png" ,
                             "Untitled-6.png"]
            listColor = ["5BF8FD","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF"]
            
            tableViewLeft.reloadData()
            createViewUser()
            AppsSettings.root.showActivityIndicator()
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(HomeController.hideIndicator), userInfo: nil, repeats: false)
        }else {
            imageViewHome.removeFromSuperview()
            if imageViewPlayList != nil{
                imageViewPlayList.removeFromSuperview()
            }
            if imageViewSearch != nil{
                imageViewSearch.removeFromSuperview()
            }
            if imageViewBXH != nil{
                imageViewBXH.removeFromSuperview()
            }
            if imageViewBaiHat != nil{
                imageViewBaiHat.removeFromSuperview()
            }
            if imageViewVideo != nil{
                imageViewVideo.removeFromSuperview()
            }
            if imageViewChuDe != nil{
                imageViewChuDe.removeFromSuperview()
            }
            if imageViewNgheSi != nil{
                imageViewNgheSi.removeFromSuperview()
            }
            if imageViewNCT != nil {
                imageViewNCT.removeFromSuperview()
            }
            if imageViewPlayListRight != nil{
                imageViewPlayListRight.removeFromSuperview()
            }
            
            
            //thaydoi1.1
            AppsSettings.formLogin = DataUiViewFormLogin.loadNib()
            AppsSettings.formLogin.frame = CGRect(x: ScreenSize.MUL_WIDTH * 170, y:ScreenSize.MUL_HEIGHT * 79, width: ScreenSize.MUL_WIDTH * 250, height: ScreenSize.MUL_HEIGHT * 162)
            //            AppsSettings.dimBackgroundColor.hidden = false
            //            AppsSettings.formLogin.hidden = false
            //
            AppsSettings.formLogin.buttonCancel.addTarget(self, action: #selector(HomeController.okLogin(_:)), for: UIControlEvents.touchUpInside)
            view.addSubview(AppsSettings.formLogin)
            AppsSettings.checklog = "0"
        }
        if AppsSettings.checklog == "0" {
            //        AppsSettings.formLogin.removeFromSuperview()
        }
    }
    
    func okLogin(_ sender: UIButton!){
        print("click button")
        if checkSelectedView == 0{
            
            self.view.addSubview(imageViewHome)
            tableViewLeft.reloadData()
        }else if checkSelectedView == 1{
            self.view.addSubview(imageViewSearch)
            tableViewLeft.reloadData()
        }else if checkSelectedView == 2{
            self.view.addSubview(imageViewBXH)
            tableViewLeft.reloadData()
        }else if checkSelectedView == 3{
            self.view.addSubview(self.imageViewBaiHat)
        }else if checkSelectedView == 4{
            self.view.addSubview(imageViewPlayList)
            
            tableViewLeft.reloadData()
        }else if checkSelectedView == 5{
            
            
            self.view.addSubview(imageViewVideo)
            
            tableViewLeft.reloadData()
        }else if checkSelectedView == 6{
            
            
            self.view.addSubview(imageViewChuDe)
            
            tableViewLeft.reloadData()
        }else if checkSelectedView == 7{
            
            self.view.addSubview(imageViewNgheSi)
            
            tableViewLeft.reloadData()
        }else if checkSelectedView == 8{
            
            self.view.addSubview(self.imageViewNCT)
            
            
            AppsSettings.dimBackgroundColor.isHidden = true
            AppsSettings.formLogin.isHidden = true
            
            listImageIcon = ["ic_home.png" , "ic_search.png" , "ic_rank.png" , "ic_song.png" , "ic_playlist.png" , "ic_video.png" , "ic_sub.png" , "ic_artist.png" , "Untitled-5.png"]
            listColor = ["FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","FFFFFF","5BF8FD"]
            tableViewLeft.reloadData()
        }
        
        AppsSettings.dimBackgroundColor.isHidden = true
        AppsSettings.formLogin.isHidden = true
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
            UIToast.makeText("បង្កើតបានជោគជ័យ").show()
            self.parceApiGetPlayList(idUser)
        }
    }
    
    
    /******************************************
     hàm parce api add song vào playList
     *******************************************/
    func parceApiAddSongToPlayList(_ idPlayList: String! , idSong: String!){
        createNewPlayList = CreatePlayList()
        createNewPlayList.idPlayList = idPlayList
        createNewPlayList.idSong = idSong
        AccountService(viewController: AppsSettings.root, isShowLoading: true).createPlayList("api/InsertSongToplaylist", playList: createNewPlayList, success: { (response) -> Void in
            let a = response
            print(a.mMessage)
            UIToast.makeText("បន្ថែមបទចំរៀងបានជោគជ័យ!").show()
        }) { (error) -> Void in
            print("error")
            UIToast.makeText("បន្ថែមជោគជ័យ!").show()
            //self.parceApiGetPlayList(idUser)
        }
    }
    
    func test(_ idUser: String!){
        playListLocal = PlayList()
        playListLocal.idUser = idUser
        self.list_title_playList = []
        self.list_id_playList = []
        self.list_PlayList = []
        AccountService(viewController: self, isShowLoading: true).getPlayList("api/getPlaylistUser",playList:playListLocal, success: {(response) -> Void in
            self.list_PlayList = response.items
            if self.list_PlayList.count > 0 {
                for i in 0...self.list_PlayList.count - 1 {
                    self.playList = self.list_PlayList[i]
                    if self.playList.title != nil || self.playList.title != ""{
                        self.list_title_playList.append(self.playList.title)
                    }else{
                        self.list_title_playList.append("")
                    }
                    if self.playList.idplaylist != nil {
                        self.list_id_playList.append(self.playList.idplaylist)
                    }
                }
                AppsSettings.root.hideActivityIndicator()
                if self.list_id_playList.count > 0 {
                    self.createTableNamePlayList()
                    self.tablePlayListName.reloadData()
                }else{
                    self.createPlayList()
                }
            } else
            {
                UIToast.makeText("គ្មានបញ្ជីចាក់").show()
            }
        }) { (error) -> Void in
            AppsSettings.root.hideActivityIndicator()
        }
    }
    
    //Dau cong 1.1
    /******************************************
     hàm parce api láy danh sách playList
     *******************************************/
    func parceApiGetPlayList(_ idUser: String!){
        playListLocal = PlayList()
        playListLocal.idUser = idUser
        self.list_title_playList = []
        self.list_id_playList = []
        self.list_PlayList = []
        AccountService(viewController: self, isShowLoading: true).getPlayList("api/getPlaylistUser",playList:playListLocal, success: {(response) -> Void in
            self.list_PlayList = response.items
            if self.list_PlayList.count > 0 {
                for i in 0...self.list_PlayList.count - 1 {
                    self.playList = self.list_PlayList[i]
                    if self.playList.title != nil || self.playList.title != ""{
                        self.list_title_playList.append(self.playList.title)
                    }else{
                        self.list_title_playList.append("")
                    }
                    if self.playList.idplaylist != nil {
                        self.list_id_playList.append(self.playList.idplaylist)
                    }
                }
                AppsSettings.root.hideActivityIndicator()
                if self.list_id_playList.count > 0 {
                    self.createTableNamePlayList()
                    self.tablePlayListName.reloadData()
                }else{
                    self.createPlayList()
                }
            } else
            {
                UIToast.makeText("គ្មានបញ្ជីចាក់").show()
            }
        }) { (error) -> Void in
            AppsSettings.root.hideActivityIndicator()
        }
        
        print("-------idSong 1.1: \(AppsSettings.idSong)")
    }
    //Dau cong 2.1
    //    Test
    func test(){
        AppsSettings.flag = 0
        let idUser = preferences.string(forKey: "useridkey")
        playListLocal = PlayList()
        playListLocal.idUser = idUser
        self.list_title_playList = []
        self.list_id_playList = []
        self.list_PlayList = []
        AccountService(viewController: self, isShowLoading: true).getPlayList("api/getPlaylistUser",playList:playListLocal, success: {(response) -> Void in
            self.list_PlayList = response.items
            if self.list_PlayList.count > 0 {
                for i in 0...self.list_PlayList.count - 1 {
                    self.playList = self.list_PlayList[i]
                    if self.playList.title != nil || self.playList.title != ""{
                        self.list_title_playList.append(self.playList.title)
                    }else{
                        self.list_title_playList.append("")
                    }
                    if self.playList.idplaylist != nil {
                        self.list_id_playList.append(self.playList.idplaylist)
                    }
                }
                AppsSettings.root.hideActivityIndicator()
                if self.list_id_playList.count > 0 {
                    self.createTableNamePlayList()
                    self.tablePlayListName.reloadData()
                }else{
                    self.createPlayList()
                }
            } else
            {
                UIToast.makeText("គ្មានបញ្ជីចាក់").show()
            }
        }) { (error) -> Void in
            AppsSettings.root.hideActivityIndicator()
        }
        
        print("-------idSong 2.1: \(AppsSettings.idSong)")
    }
    
    
    /******************************************
     Hàm tạo giao diện create playList
     *******************************************/
    func createPlayList(){
        AppsSettings.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        AppsSettings.dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        AppsSettings.dimBackgroundColor.alpha=0.5
        
        imageBackground = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 190, y:ScreenSize.MUL_HEIGHT * 100, width: ScreenSize.MUL_WIDTH * 200, height: ScreenSize.MUL_HEIGHT * 90))
        imageBackground.image = UIImage(named: "background_createPlayList")
        
        buttonCloseView = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 380, y:ScreenSize.MUL_HEIGHT * 95, width: ScreenSize.MUL_HEIGHT * 17, height: ScreenSize.MUL_HEIGHT * 17))
        buttonCloseView.setBackgroundImage(UIImage(named:"btn_close"), for: UIControlState())
        buttonCloseView.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCloseView.tag = 11
        
        titleCreatePlayList = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 200, y:ScreenSize.MUL_HEIGHT * 110, width: ScreenSize.MUL_HEIGHT * 180, height: ScreenSize.MUL_HEIGHT * 23))
        titleCreatePlayList.text = "បញ្ចូលឈ្មោះបញ្ជីថ្មី"
        titleCreatePlayList.font = UIFont.font65Medium(15)
        titleCreatePlayList.textAlignment = .center
        
        namePlayList = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 210, y:ScreenSize.MUL_HEIGHT * 152, width: ScreenSize.MUL_HEIGHT * 100, height: ScreenSize.MUL_HEIGHT * 23))
        namePlayList.placeholder = "ឈ្មោះបញ្ជីថ្មី"
        namePlayList.font = UIFont.font65Medium(12)
        
        buttonCreate = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 334, y:ScreenSize.MUL_HEIGHT * 152, width: ScreenSize.MUL_HEIGHT * 50, height: ScreenSize.MUL_HEIGHT * 20))
        buttonCreate.setBackgroundImage(UIImage(named:"btn_create.png"), for: UIControlState())
        buttonCreate.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCreate.tag = 12
        
        
        self.view.addSubview(AppsSettings.dimBackgroundColor)
        self.view.addSubview(imageBackground)
        self.view.addSubview(buttonCloseView)
        self.view.addSubview(titleCreatePlayList)
        self.view.addSubview(namePlayList)
        self.view.addSubview(buttonCreate)
        
        print("-----Chay xuong duoi me no roi")
    }
    
    //Dau cong 1.1.1
    //Dau cong 2.1.1
    /******************************************
     Hàm tạo giao diện table playList
     *******************************************/
    func createTableNamePlayList(){
        AppsSettings.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        AppsSettings.dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        AppsSettings.dimBackgroundColor.alpha=0.5
        
        imageBackground = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 230, y:ScreenSize.MUL_HEIGHT * 60, width: ScreenSize.MUL_WIDTH * 150, height: ScreenSize.MUL_HEIGHT * 200))
        imageBackground.image = UIImage(named: "background_login")
        
        buttonCloseView = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 370, y:ScreenSize.MUL_HEIGHT * 55, width: ScreenSize.MUL_HEIGHT * 17, height: ScreenSize.MUL_HEIGHT * 17))
        buttonCloseView.setBackgroundImage(UIImage(named:"btn_close.png"), for: UIControlState())
        buttonCloseView.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCloseView.tag = 13
        
        titleCreatePlayList = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 225, y:ScreenSize.MUL_HEIGHT * 65, width: ScreenSize.MUL_HEIGHT * 160, height: ScreenSize.MUL_HEIGHT * 23))
        titleCreatePlayList.text = "ជ្រើសរើសបញ្ជីបទចំរៀង"
        titleCreatePlayList.font = UIFont.font65Medium(13)
        titleCreatePlayList.textAlignment = .center
        
        tablePlayListName = UITableView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 230, y: ScreenSize.MUL_HEIGHT * 90, width: ScreenSize.MUL_WIDTH * 150, height: ScreenSize.MUL_HEIGHT * 170))
        tablePlayListName.backgroundColor = UIColor.white
        //self.tablePlayListName.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tablePlayListName.registerCellNib(DataTableViewCellCountry.self)
        
        self.view.addSubview(AppsSettings.dimBackgroundColor)
        self.view.addSubview(imageBackground)
        self.view.addSubview(buttonCloseView)
        self.view.addSubview(titleCreatePlayList)
        self.view.addSubview(tablePlayListName)
        
        tablePlayListName.delegate = self
        tablePlayListName.dataSource = self
        
        print("-------idSong 1.1.1: \(AppsSettings.idSong)")
        print("-------idSong 2.1.1: \(AppsSettings.idSong)")
        
    }
    
    /***********************************************
     ham tao giao dien UIView màn hình chính
     ************************************************/
    func creatInterface(){
        background = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        background.image = UIImage(named: "backgroundhome.png")
        
        avatarUser = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 15, y: ScreenSize.MUL_HEIGHT * 10, width: ScreenSize.MUL_HEIGHT * 60, height: ScreenSize.MUL_HEIGHT * 60))
        avatarUser.image = UIImage(named: "avatar_user.png")
        avatarUser.layer.cornerRadius = ScreenSize.MUL_HEIGHT * 60 / 2
        avatarUser.clipsToBounds = true
        
        if userIDFacebook.length > 0 {
            load_image("http://graph.facebook.com/" + userIDFacebook + "/picture?type=large")
            print("-------" +  "http://graph.facebook.com/" + userIDFacebook + "/picture?type=large")
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(HomeController.imageTapped(_:)))
        avatarUser.isUserInteractionEnabled = true
        avatarUser.addGestureRecognizer(tapGestureRecognizer)
        
        AppsSettings.nameUserAvatar = UILabel(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 74, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 15))
        //nameText.text = "Nhóc Siêu Quậy"
        AppsSettings.nameUserAvatar.font = UIFont.font65Medium(10)
        AppsSettings.nameUserAvatar.textAlignment = .center
        AppsSettings.nameUserAvatar.textColor = UIColor.black
        
        //        nameUser = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 80, y: ScreenSize.MUL_HEIGHT * 10, width: ScreenSize.MUL_HEIGHT * 10, height: ScreenSize.MUL_HEIGHT * 60))
        //        nameUser.textColor = UIColor.blackColor()
        //        nameUser.text = usernames
        
        if DeviceType.IS_IPHONE_4_OR_LESS{
            tableViewLeft = UITableView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 90, width: ScreenSize.MUL_WIDTH * 120, height: ScreenSize.MUL_HEIGHT * 150))
        }else{
            tableViewLeft = UITableView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 90, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 150))
        }
        tableViewLeft.backgroundColor = UIColor.clear
        self.tableViewLeft.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableViewLeft.registerCellNib(DataTableViewCellLeft.self)
        
        AppsSettings.imageSong = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 8, y: ScreenSize.MUL_HEIGHT * 235, width: ScreenSize.MUL_HEIGHT * 75, height: ScreenSize.MUL_HEIGHT * 75))
        AppsSettings.imageSong.image = UIImage(named: "music.png")
        AppsSettings.imageSong.layer.cornerRadius = ScreenSize.MUL_HEIGHT * 75 / 2
        AppsSettings.imageSong.clipsToBounds = true
        let tapGestureImageSong = UITapGestureRecognizer(target:self, action:#selector(HomeController.actionImage(_:)))
        AppsSettings.imageSong.isUserInteractionEnabled = true
        AppsSettings.imageSong.addGestureRecognizer(tapGestureImageSong)
        
        
        imageButtonBack = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 86, y: ScreenSize.MUL_HEIGHT * 280, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 28))
        imageButtonBack.setBackgroundImage(UIImage(named:"btn_previous.png"), for: UIControlState())
        imageButtonBack.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonBack.tag = 1
        
        
        AppsSettings.imageButtonPlay = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 115, y: ScreenSize.MUL_HEIGHT * 276, width: ScreenSize.MUL_WIDTH * 35, height: ScreenSize.MUL_HEIGHT * 35))
        AppsSettings.imageButtonPlay.setBackgroundImage(UIImage(named:"play.png"), for: UIControlState())
        AppsSettings.imageButtonPlay.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        AppsSettings.imageButtonPlay.tag = 2
        
        imageButtonNext = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 152, y: ScreenSize.MUL_HEIGHT * 280, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 28))
        imageButtonNext.setBackgroundImage(UIImage(named:"btn_next.png"), for: UIControlState())
        imageButtonNext.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonNext.tag = 3
        
        
        AppsSettings.textNameSong = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 200, y: ScreenSize.MUL_HEIGHT * 267, width: ScreenSize.MUL_WIDTH * 160, height: ScreenSize.MUL_HEIGHT * 17))
        //AppsSettings.textNameSong.text = "Anh nhớ mùa đông ấy - The Men"
        AppsSettings.textNameSong.font = UIFont.font65Medium(11)
        AppsSettings.textNameSong.textColor = UIColor.white
        
        AppsSettings.longTimeSongRun = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 282, y: ScreenSize.MUL_HEIGHT * 280, width: ScreenSize.MUL_WIDTH * 35, height: ScreenSize.MUL_HEIGHT * 17))
        AppsSettings.longTimeSongRun.font = UIFont.font65Medium(11)
        AppsSettings.longTimeSongRun.text = "--:-- / "
        AppsSettings.longTimeSongRun.textColor = UIColor.white
        
        AppsSettings.longTimeSong = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 315, y: ScreenSize.MUL_HEIGHT * 280, width: ScreenSize.MUL_WIDTH * 30, height: ScreenSize.MUL_HEIGHT * 17))
        AppsSettings.longTimeSong.font = UIFont.font65Medium(11)
        AppsSettings.longTimeSong.text = " --:--"
        AppsSettings.longTimeSong.textColor = UIColor.white
        
        
        AppsSettings.sliderSong = UISlider(frame: CGRect(x: ScreenSize.MUL_WIDTH * 200, y: ScreenSize.MUL_HEIGHT * 290, width: ScreenSize.MUL_WIDTH * 250, height: ScreenSize.MUL_HEIGHT * 15))
        AppsSettings.sliderSong.tintColor = UIColor(hex: "8DB457")
        AppsSettings.sliderSong.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        
        AppsSettings.sliderSong.setThumbImage(UIImage(named: "sliderthumb")!, for: UIControlState())
        AppsSettings.sliderSong.tag = 10
        
        imageButtonAdd = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 370, y: ScreenSize.MUL_HEIGHT * 267, width: ScreenSize.MUL_WIDTH * 17, height: ScreenSize.MUL_HEIGHT * 17))
        imageButtonAdd.setBackgroundImage(UIImage(named:"ic_plus_white.png"), for: UIControlState())
        imageButtonAdd.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonAdd.tag = 4
        
        imageButtonShare = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 400, y: ScreenSize.MUL_HEIGHT * 267, width: ScreenSize.MUL_WIDTH * 17, height: ScreenSize.MUL_HEIGHT * 17))
        imageButtonShare.setBackgroundImage(UIImage(named:"ic_share_white.png"), for: UIControlState())
        imageButtonShare.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonShare.tag = 5
        
        imageButtonDownload = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 430, y: ScreenSize.MUL_HEIGHT * 267, width: ScreenSize.MUL_WIDTH * 17, height: ScreenSize.MUL_HEIGHT * 17))
        imageButtonDownload.setBackgroundImage(UIImage(named:"ic_download_white.png"), for: UIControlState())
        imageButtonDownload.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonDownload.tag = 6
        
        imageButtonRanDom = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 460, y: ScreenSize.MUL_HEIGHT * 282, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 28))
        imageButtonRanDom.setBackgroundImage(UIImage(named:"repeat_all.png"), for: UIControlState())
        imageButtonRanDom.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonRanDom.tag = 7
        
        imageButtonMute = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 490, y: ScreenSize.MUL_HEIGHT * 280, width: ScreenSize.MUL_WIDTH * 30, height: ScreenSize.MUL_HEIGHT * 30))
        imageButtonMute.setBackgroundImage(UIImage(named:"Untitled-10.png"), for: UIControlState())
        
        imageButtonMute.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        
        imageButtonMute.tag = 8
        
        
        
        imageButtonListSong = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 523, y: ScreenSize.MUL_HEIGHT * 280, width: ScreenSize.MUL_WIDTH * 28, height: ScreenSize.MUL_HEIGHT * 28))
        imageButtonListSong.setBackgroundImage(UIImage(named:"Untitled-9.png"), for: UIControlState())
        imageButtonListSong.addTarget(self, action: #selector(HomeController.actionEven(_:)), for: UIControlEvents.touchUpInside)
        imageButtonListSong.tag = 9
        
        self.imageViewHome = DataViewHome.loadNib()
        if DeviceType.IS_IPHONE_4_OR_LESS{
            imageViewHome.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 240)
        }else {
            imageViewHome.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 250)
        }
        
        imageViewHome.backgroundColor = UIColor.clear
        
        
        
        
        
        
        
        
        
        AppsSettings.dimBackgroundColor = UIView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320))
        AppsSettings.dimBackgroundColor.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        AppsSettings.dimBackgroundColor.alpha=0.5
        //        AppsSettings.formLogin = DataUiViewFormLogin.loadNib()
        //        AppsSettings.formLogin.frame = CGRect(x: ScreenSize.MUL_WIDTH * 170, y:ScreenSize.MUL_HEIGHT * 79, width: ScreenSize.MUL_WIDTH * 250, height: ScreenSize.MUL_HEIGHT * 162)
        
        
        //view.addSubview(nameUser)
        view.addSubview(background)
        view.addSubview(avatarUser)
        view.addSubview(AppsSettings.nameUserAvatar)
        view.addSubview(tableViewLeft)
        
        self.view.addSubview(self.imageViewHome)
        //
        view.addSubview(AppsSettings.dimBackgroundColor)
        
        AppsSettings.dimBackgroundColor.isHidden = true
        //        AppsSettings.formLogin.hidden = true
        
        view.addSubview(AppsSettings.imageSong)
        view.addSubview(imageButtonBack)
        view.addSubview(AppsSettings.imageButtonPlay)
        view.addSubview(imageButtonNext)
        view.addSubview(AppsSettings.textNameSong)
        view.addSubview(AppsSettings.sliderSong)
        view.addSubview(AppsSettings.longTimeSong)
        view.addSubview(AppsSettings.longTimeSongRun)
        view.addSubview(imageButtonAdd)
        view.addSubview(imageButtonShare)
        view.addSubview(imageButtonDownload)
        view.addSubview(imageButtonAdd)
        view.addSubview(imageButtonRanDom)
        view.addSubview(imageButtonMute)
        view.addSubview(imageButtonListSong)
        
        
    }
    
    
    /******************************************
     Hàm tạo giao diện màn hình view user
     *******************************************/
    func createViewUser(){
        if imageViewUser != nil {
            imageViewUser.removeFromSuperview()
            self.imageViewUser = DataViewUser.loadNib()
            imageViewUser.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewUser.backgroundColor = UIColor.clear
            self.view.addSubview(self.imageViewUser)
        }else{
            self.imageViewUser = DataViewUser.loadNib()
            imageViewUser.frame = CGRect(x: ScreenSize.MUL_WIDTH * 110, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 460, height: ScreenSize.MUL_HEIGHT * 250)
            imageViewUser.backgroundColor = UIColor.clear
            self.view.addSubview(self.imageViewUser)
        }
    }
    
    /***************************************************************
     Hàm xét sự kiện khi click vào ảnh bài hát để ra nội dung bài hát
     ****************************************************************/
    func actionImage(_ img: AnyObject){
        if AppsSettings.list_url_song.count > 0 {
            //            if imageViewContentSong != nil {
            //                imageViewContentSong.removeFromSuperview()
            //                self.imageViewContentSong = DataViewContentSong.loadNib()
            //                imageViewContentSong.frame = CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320)
            //                self.view.addSubview(imageViewContentSong)
            //            }else{
            //                self.imageViewContentSong = DataViewContentSong.loadNib()
            //                imageViewContentSong.frame = CGRect(x: ScreenSize.MUL_WIDTH * 0, y:ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320)
            //                self.view.addSubview(imageViewContentSong)
            //            }
            
        }
        
    }
    func autoHideVolume(){
        checkClickVolume = 0
        self.wrapperView.removeFromSuperview()
        
    }
    
    func checkNetworth(){
        if CheckNetworth.isConnectedToNetwork() == true {
            
        } else {
            //            UIToast.makeText("មិនអាចភ្ជាប់ជាមួយអ៊ីនធឺណិត ។ សូមសាកល្បងម្តងទៀត!").show()
        }
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}

@available(iOS 8.0, *)
extension HomeController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableViewLeft == tableView {
            return DataTableViewCellLeft.height()
        }else{
            return ScreenSize.MUL_HEIGHT * 30
        }
        
    }
}

@available(iOS 8.0, *)
extension HomeController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewLeft == tableView {
            return self.listImageIcon.count
        } else {
            return self.list_id_playList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewLeft == tableView {
            let cell = self.tableViewLeft.dequeueReusableCell(withIdentifier: DataTableViewCellLeft.identifier) as! DataTableViewCellLeft
            let data = DataTableViewCellData(image_Url: listImageIcon[indexPath.row] , text_Title: listTextTile[indexPath.row], color: listColor[indexPath.row])
            cell.setData(data)
            return cell
        }else {
            let cell = self.tablePlayListName.dequeueReusableCell(withIdentifier: DataTableViewCellCountry.identifier) as! DataTableViewCellCountry
            cell.textNameCountry.textColor = UIColor.black
            let data = DataTableViewCellListCountryData(title_Country: list_title_playList[indexPath.row])
            cell.setData(data)
            return cell
        }
        
    }
    //Dau cong 1.1.1.1
    //Dau cong 2.1.1.1
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == listTextTile.count - 1){
            AppsSettings.flagNCT = true
            print("indext count: \(indexPath.row) va : \(listTextTile[indexPath.row])")
        }else{
            AppsSettings.flagNCT = false
            AppsSettings.list_tittle_NCT.removeAll()
            AppsSettings.check_song_isplay = ""
        }
        
        if tableViewLeft == tableView {
            changeViewController(indexPath.row)
            
        }else {
            print("asdsd222")
            print(list_id_playList[indexPath.row])
            //            print(AppsSettings.position)
            print(AppsSettings.list_id_song.count)
            let s = preferences.string(forKey: "keykey")
            if s == "2" {
                let idSong2 = preferences.string(forKey: "idsongtoadd")
                parceApiAddSongToPlayList(list_id_playList[indexPath.row], idSong: idSong2)
                AppsSettings.flag = 0
                
                
                print("-------idSong 2.1.1.1: \(AppsSettings.idSong)")
            } else if s == "1" {
                //                print("this id song: " + AppsSettings.list_id_song[AppsSettings.position])
                parceApiAddSongToPlayList(list_id_playList[indexPath.row], idSong: AppsSettings.idSong)
                
                print("-------idSong 1.1.1.1: \(AppsSettings.idSong)")
            }
            AppsSettings.dimBackgroundColor.removeFromSuperview()
            imageBackground.removeFromSuperview()
            buttonCloseView.removeFromSuperview()
            titleCreatePlayList.removeFromSuperview()
            tablePlayListName.removeFromSuperview()
        }
        
        print("-------idSong 1.1.1.2: \(AppsSettings.idSong)")
        print("-------idSong 2.1.1.2: \(AppsSettings.idSong)")
    }
    
    func load_image(_ urlString:String)
    {
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
}
func observeValueForKeyPath(_ keyPath: String, ofObject object: AnyObject,
                            change: [AnyHashable: Any], context: UnsafeMutableRawPointer) {
    if keyPath == "outputVolume"{
        print("got in here")
    }
    
    
}
