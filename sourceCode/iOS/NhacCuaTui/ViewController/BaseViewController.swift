//
//  BaseViewController.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/5/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit
import MediaPlayer
@available(iOS 8.0, *)
class BaseViewController: UIViewController {
    //var listPlayList: [PlayList]!
    var playList: PlayList!
    var video: VideoVideo!
    var song: Song!
    var artist: Artist!
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getListArtist()
        setupPlayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppsSettings.root = self
        getListPlayList()
        getListVideo()
        getListSong()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupPlayer() {
        AppsSettings.radioPlayer.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        AppsSettings.radioPlayer.view.sizeToFit()
        AppsSettings.radioPlayer.movieSourceType = MPMovieSourceType.streaming
        AppsSettings.radioPlayer.isFullscreen = false
        AppsSettings.radioPlayer.shouldAutoplay = true
        AppsSettings.radioPlayer.prepareToPlay()
        AppsSettings.radioPlayer.controlStyle = MPMovieControlStyle.none
    }
    
    func getListPlayList(){
        playList = PlayList()
        AccountService(viewController: self, isShowLoading: true).getPlayList("api/listplaylist",playList:playList, success: {(response) -> Void in
            AppsSettings.listPlayList = response.items
            print("this play list:" + String(AppsSettings.listPlayList.count))
            
            }) { (error) -> Void in
        }
    }
    
   
    
    func getListVideo(){
        video = VideoVideo()
        AccountService(viewController: self, isShowLoading: true).getListVideo("api/listvideo",video:video, success: {(response) -> Void in
            AppsSettings.listVideo = response.items
            print(AppsSettings.listVideo.count)
            }) { (error) -> Void in
        }
    }
    
    func getListSong(){
        song = Song()
        AccountService(viewController: self, isShowLoading: true).getListSong("api/listsong",song:song, success: {(response) -> Void in
            AppsSettings.listSong = response.items
            print("list song  " + String(AppsSettings.listSong.count))
            }) { (error) -> Void in
        }
    }
    
    func getListArtist(){
        artist = Artist()
        AccountService(viewController: self, isShowLoading: true).getLisArtist("api/listArtist",artist:artist, success: {(response) -> Void in
            AppsSettings.listArtist = response.items
            //print("Nghe si " + String(AppsSettings.listArtist.count))
            }) { (error) -> Void in
        }
    }
    

    func getListByIDPlayList(_ song: Song){
        var song = song
        song = Song()
        AccountService(viewController: self, isShowLoading: true).getListSong("api/findsongbyidplaylist",song:song, success: {(response) -> Void in
            AppsSettings.listSong = response.items
            print(AppsSettings.listVideo.count)
            }) { (error) -> Void in
        }
    }
    
    func updateturncountsong(_ song: Song){
        var song = song
        song = Song()
        AccountService(viewController: self, isShowLoading: true).getListSong("api/findsongbyidplaylist",song:song, success: {(response) -> Void in
            AppsSettings.listSong = response.items
            print(AppsSettings.listVideo.count)
        }) { (error) -> Void in
        }
    }
    func updatePlaylist(_ id:String){
        playList = PlayList()
        playList.idplaylist = id
        AccountService(viewController: self, isShowLoading: true).getCountPlayList("api/updatecounterplaylist", playList:playList, success: {(response) -> Void in
            print(response.message)
            print("da click duoc vao roi playlist!")
        }) { (error) -> Void in
        }
        
    }
    func updateVideo(_ id:String){
        video = VideoVideo()
        video.idVideo = id
        AccountService(viewController: self, isShowLoading: true).updateCountVideo("api/updatecountervideo", video:video, success: {(response) -> Void in
            print(response.message)
            print("da click duoc vao roi video!")
        }) { (error) -> Void in
        }
    }
//    func updateturncountsong(var song: Song){
//        song = Song()
//        AccountService(viewController: self, isShowLoading: true).getListSong("api/findsongbyidplaylist",song:song, success: {(response) -> Void in
//            AppsSettings.listSong = response.items
//            print(AppsSettings.listVideo.count)
//        }) { (error) -> Void in
//        }
//    }
// UC 1.1
    func updateCountSong(_ id:String){
        print("----------Đã gọi đến hàm được rồi")
        song = Song()
        song.idSong = id
        AccountService(viewController: self, isShowLoading: true).getListSong("api/updatecountersong",song:song, success: {(response) -> Void in
            AppsSettings.listSong = response.items
            print("----------Đã gọi được hàm updateCountSong trong BaseView")
        }) { (error) -> Void in
        }
    }
    
    func showActivityIndicator() {
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0)
        
        loadingView.frame = CGRect(x: 0, y: 0, width: ScreenSize.MUL_WIDTH*568, height: ScreenSize.MUL_HEIGHT*320)
        loadingView.center = view.center
        loadingView.backgroundColor = UIColorFromHex(0x555555, alpha: 0)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: ScreenSize.MUL_WIDTH*568, height: ScreenSize.MUL_HEIGHT*320);
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        activityIndicator.color = UIColor.red
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        view.addSubview(container)
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
        
    }
    
    func UIColorFromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    /******************************************
    Tạo form login
    *******************************************/
    static func createFormLogin(){
        
        
    }
}

