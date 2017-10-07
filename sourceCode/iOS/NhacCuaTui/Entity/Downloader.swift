//
//  Downloader.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/21/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Downloader : NSObject {
    
    var documentsUrl: URL!
    var destinationUrl: URL!
    
    class func loadFileSync(_ url: URL, completion:(_ path:String, _ error:NSError?) -> Void) {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        let destinationUrl = documentsUrl?.appendingPathComponent(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl!.path) {
            print("file already exists [\(destinationUrl?.path)]")
            completion(destinationUrl!.path, nil)
        } else if let dataFromURL = try? Data(contentsOf: url){
            if (try? dataFromURL.write(to: destinationUrl!, options: [.atomic])) != nil {
                print("file saved [\(destinationUrl?.path)]")
                completion(destinationUrl!.path, nil)
            } else {
                print("error saving file")
                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                completion(destinationUrl!.path, error)
            }
        } else {
            let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
            completion(destinationUrl!.path, error)
        }
    }
    
    func loadFileAsync(_ url: URL, completion:@escaping (_ path:String, _ error:NSError?) -> Void) {
        documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
        destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("file already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                if (error == nil) {
                    if let response = response as? HTTPURLResponse {
                        print("response=\(response)")
                        if response.statusCode == 200 {
                            if (try? data!.write(to: self.destinationUrl, options: [.atomic])) != nil {
                                print("file saved [\(self.destinationUrl.path)]")
                                completion(self.destinationUrl.path, error as! NSError)
                            } else {
                                print("error saving file")
                                let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                completion(self.destinationUrl.path, error)
                            }
                        }
                    }
                }
                else {
                    print("Failure: \(error!.localizedDescription)");
                    completion(self.destinationUrl.path, error as! NSError)
                }
            })

            task.resume()
        }
    }
    
    class func loadSong(_ url:String) {
        if let audioUrl = URL(string: url) {
            // then lets create your document folder url
            let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL!
            
            // lets create your destination file url
            let destinationUrl = documentsUrl?.appendingPathComponent("\(AppsSettings.tittle_Song_Drive).mp3")
            print(destinationUrl)
            
            // to check if it exists before downloading it
            if FileManager().fileExists(atPath: destinationUrl!.path) {
                print("The file already exists at path")
                
                // if the file doesn't exist
            } else {
                
                //  just download the data from your url
                if let myAudioDataFromUrl = try? Data(contentsOf: audioUrl){
                    
                    // after downloading your data you need to save it to your destination url
                    if (try? myAudioDataFromUrl.write(to: destinationUrl!, options: [.atomic])) != nil {
                        print("file saved")
                    } else {
                        print("error saving file")
                    }
                }
            }
        }
    }
    class func deletefile(_ nameSong:String) {
        do {
            let fileManager = FileManager.default
            let documentDirectoryURLs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            
            if let filePath = documentDirectoryURLs.first?.appendingPathComponent(nameSong).path {
                try fileManager.removeItem(atPath: filePath)
                print("delete: \(nameSong)")
            }
            
        } catch let error as NSError {
            print("ERROR: \(error)")
        }
    }
    class func deleteSong(_ nameSong: String){
        let fm = FileManager.default
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let folderPath = documentsDirectory
            let pathSong = "\(folderPath)\(nameSong)"
            let myString = pathSong as NSString
            try fm.removeItem(atPath: myString.substring(with: NSRange(location: 7, length: pathSong.length - 7)))
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
    }
}
extension String
{
    func substringWithRange(_ start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let range = (self.characters.index(self.startIndex, offsetBy: start) ..< self.characters.index(self.startIndex, offsetBy: end))
        return self.substring(with: range)
    }
    
    func substringWithRange(_ start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            print("end index \(start + location) out of bounds")
            return ""
        }
        let range = (self.characters.index(self.startIndex, offsetBy: start) ..< self.characters.index(self.startIndex, offsetBy: start + location))
        return self.substring(with: range)
    }
}
