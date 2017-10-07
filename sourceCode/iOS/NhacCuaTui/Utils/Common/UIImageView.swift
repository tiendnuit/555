//
//  UIImageView.swift
//  IMMO
//
//  Created by mac01 on 21/12/15.
//  Copyright © 2015 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView {
    public func imageFromUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = Foundation.URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let imageData = data as Data? {
                    self.image = UIImage(data: imageData)
                }
            })
        }
    }
}
extension UIButton{
    public func setBackgroundFromUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = Foundation.URLRequest(url: url)
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if(data != nil){
                    self.setBackgroundImage(UIImage(data: data!), for: UIControlState())
                }
            })
        }
    }
}
