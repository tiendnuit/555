//
//  LoadingController.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/5/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class LoadingController: BaseViewController {
    
    var imageLogo: UIImageView!
    var imageLoading: UIImageView!
    var timeRedirecto: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatInterface()
        timeRedirecto = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(LoadingController.RedirectoAds(_:)), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.fade)
        navigationController?.navigationBar.isHidden = true // for navigation bar hide
        UIApplication.shared.isStatusBarHidden=true; // for status bar hide

    }
    
    @available(iOS 8.0, *)
    func RedirectoAds(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let subContentsVC = storyboard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(subContentsVC, animated: true)
    }
    
    func creatInterface(){
        imageLogo = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 475, y: ScreenSize.MUL_HEIGHT * 225, width: ScreenSize.MUL_WIDTH * 82, height: ScreenSize.MUL_HEIGHT * 82))
        imageLogo.image = UIImage(named: "logo.png")
        
        imageLoading = UIImageView(frame: CGRect(x: ScreenSize.MUL_WIDTH * 250, y: ScreenSize.MUL_HEIGHT * 200, width: ScreenSize.MUL_WIDTH * 320, height: ScreenSize.MUL_HEIGHT * 130))
        imageLoading.image = PPSwiftGifs.animatedImageWithGIFNamed("loading_2")
        
        view.addSubview(imageLogo)
        view.addSubview(imageLoading)
        
    }

    
    
    
}
