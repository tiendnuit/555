//
//  PlayVideoController.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/15/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit
import MediaPlayer
class PlayVideoController: BaseViewController {
    
    var thamsotruyen: UserDefaults!
    var linkUrlVideo: String!
    var moviePlayer:MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false // for navigation bar hide
        UIApplication.shared.isStatusBarHidden=false; // for status bar hide
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.bordered, target: self, action: #selector(PlayVideoController.back(_:)))
        self.navigationItem.leftBarButtonItem = newBackButton;
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "doneButtonClick:", name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        thamsotruyen = UserDefaults()
        linkUrlVideo = thamsotruyen.object(forKey: "linkUrlVideo") as! String
        let prString = linkUrlVideo.replacingOccurrences(of: " ", with: "%20", options:NSString.CompareOptions.literal, range: nil)
        print("video:  " + prString + "----------------")
        playVideo(prString)
    }
    
    func back(_ sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("check back video: " + String(AppsSettings.isCheckedButtonPlay))
        if AppsSettings.isCheckedButtonPlay == false{
            AppsSettings.isCheckedButtonPlay = true
            AppsSettings.playAudio?.play()
            
        }else {
            AppsSettings.isCheckedButtonPlay = false
            AppsSettings.playAudio?.pause()
            
        }
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)  ///< Don't forget this BTW!
        if let player = self.moviePlayer {
            player.play()
        }
    }
//    func doneButtonClick(sender:NSNotification?){
//        AppsSettings.playAudio?.play()
//    }
    func playVideo(_ URLVideo: String!){
        let url:URL = URL(string: URLVideo)!
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.view.frame = CGRect(x: 0, y: 0, width: ScreenSize.MUL_WIDTH * 568, height: ScreenSize.MUL_HEIGHT * 320)
        self.view.addSubview(moviePlayer.view)
        //moviePlayer.fullscreen = true
        moviePlayer.play()
        
        //moviePlayer.controlStyle = MPMovieControlStyle.Embedded
    }
}
