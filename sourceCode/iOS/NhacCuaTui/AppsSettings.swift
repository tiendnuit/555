//
//  SizeScreen.swift
//  IMMO
//
//  Created by Nguyễn Hà on 03/12/2015.
//  Copyright © Năm 2015 Nguyễn Hà. All rights reserved.
//
import AVFoundation
import CoreMedia
import AVKit
import Foundation
import UIKit


class AppsSettings: BaseViewController {
    
    static var listCheckbox:[Bool]! = []
    
    static var checkAll:Bool! = false
    static var check_song_isplay:String! = ""
    static var list_title_customDownload:[String]! = []
    static var list_url_custom_download:[String]! = []
    static var btnDownloadMusic:UIButton!
    static var saveNameLoginNomal:String! = ""
    static var statusLoginNomal = false
    static var shit = false
    //Bien Download
    static var tittle_Song_Drive: String! = ""
    
    
    
    //Test
    static var list_tittle_NCT:[String]! = []
    static var flagNCT = false
    static var flag:Int = 0
    //    static var keykey:Int = 2
    static var list_song_download_subject: [Song]! = []
    static var root:BaseViewController!
    static var checkClickListLeft: Bool! = false
    static var checkflag: Bool! = false
    static var checkflagok: Bool! = false
    static var ischecked: [Bool]? = []
    
    //    static var durationSong: Double! = 0
    static var durationSongLeft: Double!
    
    static var listPlayList: [PlayList]! = []
    static var listVideo: [VideoVideo]! = []
    static var listSong: [Song]! = []
    static var listArtist: [Artist]! = []
    
    static var textNameSong: UILabel!
    static var linkUrlSong: String!
    static var formLogin: DataUiViewFormLogin!
    
    //khai bao bien static cho bai hat
    static var list_id_song: [String]! = []
    static var list_url_song: [String]! = []
    static var list_title_song: [String]! = []
    static var position: Int!
    static var imageSong: UIImageView!
    static var list_song_object: [Song]! = []
    
    
    //khai bao bien static cho play music
    static var sliderSong: UISlider!
    static var radioPlayer = Player.radio
    static var player : AVAudioPlayer! = nil
    static var imageButtonPlay: UIButton!
    static var dimBackgroundColor: UIView!
    static var nameUserAvatar: UILabel!
    
    
    //khai bao bien static playList
    static var idPlayList: String!
    static var titlePlayList: String!
    static var imagePlayList: String!
    static var checkListenLocal : Bool! = true
    static var longTimeSong: UILabel!
    static var longTimeSongRun: UILabel!
    static var turncount: String!
    
    //khai bao biet static NgheSi
    static var idArtist: String!
    static var titleArtist: String!
    static var imageArtits: String!
    static var descriptionArtist: String!
    
    //khai bao bien static cho BXH
    static var idCountryBXH: String!
    static var idTypeBXH: String!
    static var idSong: String!
    
    static var originTime = Timer()
    static var backGroundViewPlayListID: UIView!
    static var idUserFacebook: String!
    static var time: Double!
    static var checkRandomSong: Int! = 0
    static var checkClickPlaylist: Int! = 0
    static var playAudio: AVPlayer?
    static var playAudioItem:AVPlayerItem?
    static var songURL:URL!
    static var timeStop: CMTime!
    
    static var linkSong2: String! = ""
    static var linkSong: String! = ""
    static var checklog: String! = ""
    static var listType: [Type] = []
    static var listCountry: [Country] = []
    
    static var checkClickMyPlaylist: Bool! = false
    static var checkPlaySong:Bool! = false
    
    static func playMusic(_ linkUrl: String! , titleSong: String!){
        let linkUrl = linkUrl
        //        linkUrl = linkSong
        
        
        if originTime != Timer() {
            originTime.invalidate()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        AppsSettings.textNameSong.text = titleSong
        let prString = linkUrl?.replacingOccurrences(of: " ", with: "%20", options: NSString.CompareOptions.literal, range: nil)
        songURL = URL(string: prString!)
        //        radioPlayer.loadState
        //        radioPlayer.play()
        AppsSettings.linkSong = linkUrl
        let url = URL(string: prString!)
        print("this url:" + String(describing: url))
        
        playAudioItem = AVPlayerItem(url: url!)
        playAudio=AVPlayer(playerItem: playAudioItem!)
        let playerLayer=AVPlayerLayer(player: playAudio!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 300, height: 50)
        //        self.layer.addSublayer(playerLayer)
        //        if AppsSettings.isCheckedButtonPlay == true{
        //            print("play == true")
        //            playAudio?.play()
        //        }else{
        //            print("play else ")
        //            playAudio?.seekToTime(AppsSettings.timeStop)
        //            playAudio?.play()
        //        }
        if(checkPlaySong == true){
            playAudio?.play()
        }else
            if AppsSettings.isCheckedButtonPlay == true{
                playAudio?.play()
            }else{
                playAudio?.seek(to: AppsSettings.timeStop)
                playAudio?.play()
                
        }
        
        time = CMTimeGetSeconds((playAudio?.currentItem?.asset.duration)!)
        
        AppsSettings.longTimeSong.text = String(time.minuteSecondMS)
        //        print("this time chay2: " + time.minuteSecondMS)
        
        sliderSong.maximumValue = Float(time)
        
        originTime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AppsSettings.updateSliderProgress), userInfo: nil, repeats: true)
        isCheckedButtonPlay = true
    }
    static func playMusicLocal(_ linkUrl: String! , titleSong: String!){
        if originTime != Timer() {
            originTime.invalidate()
        }
        AppsSettings.textNameSong.text = titleSong
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let trimmedSoundFileURL = documentsDirectory.appendingPathComponent(linkUrl)
        print(trimmedSoundFileURL.absoluteString)
        playAudioItem = AVPlayerItem(url: URL(string: trimmedSoundFileURL.absoluteString)!)
        playAudio=AVPlayer(playerItem: playAudioItem!)
        let playerLayer=AVPlayerLayer(player: playAudio!)
        playerLayer.frame=CGRect(x: 0, y: 0, width: 300, height: 50)
        //        self.layer.addSublayer(playerLayer)
        if(checkPlaySong == true){
            playAudio?.play()
        }else
            if AppsSettings.isCheckedButtonPlay == true{
                playAudio?.play()
            }else{
                playAudio?.seek(to: AppsSettings.timeStop)
                playAudio?.play()
                
        }
        
        print("this duration: " + String(describing: playAudio?.currentItem?.asset.duration))
        
        time = CMTimeGetSeconds((playAudio?.currentItem?.asset.duration)!)
        
        
        AppsSettings.longTimeSong.text = time.minuteSecondMS
        sliderSong.maximumValue = Float(time)
        
        originTime = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(AppsSettings.updateSliderProgressLocal), userInfo: nil, repeats: true)
        isCheckedButtonPlay = true
    }
    
    static func autoNextsong(){
        if originTime != Timer() {
            originTime.invalidate()
        }
        if checkListenLocal == true {
            if checkRandomSong == 0 {
                if(position < (list_url_song.count - 1)){
                    position = position + 1
                    playMusic(list_url_song[position] , titleSong: list_title_song[position])
                    print(list_url_song[position])
                }else if position == (list_url_song.count - 1) {
                    position = 0 - 1
                    position = position + 1
                    playMusic(list_url_song[position] , titleSong: list_title_song[position])
                }
            } else if checkRandomSong == 1 {
                //                radioPlayer.stop()
            } else if checkRandomSong == 2 {
                position = Int(arc4random_uniform(UInt32(list_url_song.count - 1)) + 1)
                playMusic(list_url_song[position] , titleSong: list_title_song[position])
            } else if checkRandomSong == 3 {
                playMusic(list_url_song[position] , titleSong: list_title_song[position])
                print(list_url_song[position])
            }
        }else{
            if checkRandomSong == 0 {
                if(position < (list_url_song.count - 1)){
                    position = position + 1
                    playMusicLocal(list_url_song[position] , titleSong: list_title_song[position])
                    print(list_url_song[position])
                }else if position == (list_url_song.count - 1) {
                    position = 0 - 1
                    position = position + 1
                    playMusicLocal(list_url_song[position] , titleSong: list_title_song[position])
                }
            } else if checkRandomSong == 1 {
                radioPlayer.stop()
            } else if checkRandomSong == 2 {
                position = Int(arc4random_uniform(UInt32(list_url_song.count - 1)) + 1)
                playMusicLocal(list_url_song[position] , titleSong: list_title_song[position])
            } else if checkRandomSong == 3 {
                playMusicLocal(list_url_song[position] , titleSong: list_title_song[position])
            }
        }
    }
    
    
    
    static func updateSliderProgress(){
        sliderSong.value = Float(CMTimeGetSeconds(playAudio!.currentTime()))
        let timerun = CMTimeGetSeconds(playAudio!.currentTime())
        AppsSettings.longTimeSongRun.text = timerun.minuteSecondMS + " /"
        
        //        let asset = AVURLAsset(URL: songURL, options: nil)
        time = CMTimeGetSeconds((playAudio?.currentItem?.asset.duration)!)
        //  print("this time chay: " + String(Int(timerun)) + "time goc: " + String(time))
        if Int(time) - 1 == Int(timerun){
            autoNextsong()
        }
        
        //print("This duration slide song: " + String(radioPlayer.currentPlaybackTime))
    }
    static func updateSliderProgressLocal(){
        sliderSong.value = Float(CMTimeGetSeconds(playAudio!.currentTime()))
        let timerun = CMTimeGetSeconds(playAudio!.currentTime())
        AppsSettings.longTimeSongRun.text = timerun.minuteSecondMS + " /"
        time = CMTimeGetSeconds((playAudio?.currentItem?.asset.duration)!)
        if Int(time) - 1 == Int(timerun) {
            autoNextsong()
        }
        
    }
    
    
    //check sự kiện khi click vào các nút check
    static var isCheckedButtonPlay: Bool = false {
        didSet{
            if isCheckedButtonPlay == true {
                self.imageButtonPlay.setBackgroundImage(UIImage(named:"btn_pause.png"), for: UIControlState())
            } else {
                self.imageButtonPlay.setBackgroundImage(UIImage(named:"play.png"), for: UIControlState())
                originTime.invalidate()
            }
        }
    }
    
    
    struct Static {
        /*********************************************************************************************************************************
         *Client MODULE
         
         */
        static let OAUTH1_PARAMETERS                             = [
            //"baseURL"           : "http://222.255.46.7:8080/nhaccuatui_ws/web/app_dev.php/",
            "baseURL"           : "http://api.uni555.xyz/web/app_dev.php/",
            "signatureMethod"   : "HMAC-SHA1",
            "requestTokenPath"  : "oauth/request_token",
            "accessTokenPath"   : "oauth/access_token",
            "authorizePath"     : "oauth/authorize",
            "consumerKey"       : "admin",
            "consumerSecret"    : "123456"
        ]
        /*
         *   color
         */
        static var BLUE_HEADER         = UIColor(red: 239/255.0, green: 239/255.0, blue: 244/255.0, alpha: 1.0)
        static var MAIN_COLOR          = UIColor(red: 0/255.0,green: 181/255.0,blue: 175/255.0,alpha: 1.0)
        static var LIGHT_GRAY_COLOR    = UIColor(red: 236/255.0,green: 236/255.0,blue: 236/255.0,alpha: 1.0)
        static var GRAY_COLOR          = UIColor(red: 243/255.0,green: 243/255.0,blue: 244/255.0,alpha: 1.0)
        static var GRAY_TEXT_COLOR     = UIColor(red: 142/255.0,green: 142/255.0,blue: 146/255.0,alpha: 1.0)
        
        static var GREEN_COLOR         = UIColor(red: 7/255.0,green: 185/255.0,blue: 78/255.0,alpha: 1.0)
        static var BLUE_COLOR          = UIColor(red: 80/255.0,green: 210/255.0,blue: 194/255.0,alpha: 1.0)
        static var ORANGE_COLOR        = UIColor(red: 252/255.0,green: 171/255.0,blue: 83/255.0,alpha: 1.0)
        static var LIGHT_BLUE_COLOR    = UIColor(red: 80/255.0,green: 210/255.0,blue: 194/255.0,alpha: 1.0)
        static var SPECIAL_BLUE_COLOR  = UIColor(red: 25/255.0,green: 149/255.0,blue: 236/255.0,alpha: 1.0)
        /*
         *   declare API
         */
        
        static var BASE_URL                                       = "http://wsdev.betteradvice.com/index.php"
        static var BASE_IMAGE_URL                                 = "http://uni555.xyz/public/media/"
        
        static var APP_NAME:String                                      = "com.betteradvice.client"
        
        static var ScreenWidth:CGFloat                                  = UIScreen.main.bounds.width
        static var ScreenHeight:CGFloat                                 = UIScreen.main.bounds.height
        static var MulWidth:CGFloat                                     = ScreenWidth / 375.0
        static var MulHeight:CGFloat                                    = ScreenHeight / 667.0
        
        static var AvenirBook:String                                  = "AvenirLTStd-Book"
        static var AvenirMedium:String                                = "AvenirLTStd-Medium"
        static var AvenirRoman:String                                 = "AvenirLTStd-Roman"
        static var AvenirLight                                        = "AvenirLTStd-Light"
        static var AvenirBlack                                        = "AvenirLTStd-Black"
        static var HelveticaNeueRoman:String                          = "HelveticaNeueLTStd-Roman"
        static var HelveticaNeueMedium:String                         = "helveticaneue-medium"
    }
    
}
extension TimeInterval {
    var minuteSecondMS: String {
        return String(format:"%0d:%02d", minute, second)
    }
    var minute: Int {
        return Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(self.truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000) )
    }
}
