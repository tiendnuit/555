//
//  DataViewNCT.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/21/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//

import UIKit

class DataViewNCT: UIView, UIScrollViewDelegate {

    var tableListSong: UITableView!
    var list_title_song: [String]! = []
    var list_tile_author: [String]! = []
    var idChoose: Int!
    var txtSearch:UITextFieldSearch!
    var filtered:[String] = []
    var items:[String] = []
    var searchActive : Bool = false
    
    override func awakeFromNib(){
        createInterface()
        
        tableListSong.delegate = self
        tableListSong.dataSource = self
        tableListSong.reloadData()
        getAllSong()
    }
    
    
    @IBAction func actionPlayAll(_ sender: AnyObject) {
    }
    
    @IBAction func actionSearch(_ sender: AnyObject) {
    }

    
    /**********************************************
    hàm tao giao diện
    **********************************************/
    func createInterface(){
        print("a day roi search")
        if DeviceType.IS_IPHONE_4_OR_LESS{
            txtSearch = UITextFieldSearch(frame: CGRect(x: ScreenSize.MUL_WIDTH * 110, y: ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 330, height: ScreenSize.MUL_HEIGHT * 30))
        }else{
            txtSearch = UITextFieldSearch(frame: CGRect(x: ScreenSize.MUL_WIDTH * 90, y: ScreenSize.MUL_HEIGHT * 0, width: ScreenSize.MUL_WIDTH * 330, height: ScreenSize.MUL_HEIGHT * 30))
        }
        //txtSearch.delegate = self
//        txtSearch.placeholder = "Search"
        txtSearch.textColor = UIColor.white
        self.addSubview(txtSearch)
        self.tableListSong = UITableView(frame: CGRect(x: 0, y: ScreenSize.MUL_HEIGHT * 29, width: ScreenSize.MUL_WIDTH * 450, height: ScreenSize.MUL_HEIGHT * 230))
        self.tableListSong.registerCellNib(DataTableViewCellListNCT.self)
        self.tableListSong.backgroundColor = UIColor(hex: "D3D3D3")
        
        txtSearch.addTarget(self, action: #selector(DataViewNCT.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    
        self.addSubview(txtSearch)
        self.addSubview(tableListSong)
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        //your code
        if txtSearch.text != ""{
            searchData(txtSearch.text!)
        }else{
            searchActive = false
        }
            tableListSong.reloadData()
        
    }
    /**********************************************
    hàm lấy danh sach bài hát có trong máy
    **********************************************/
    func getAllSong(){
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print(directoryContents)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        // if you want to filter the directory contents you can do like this:
        do {
            let directoryUrls = try  FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
            print(directoryUrls)
            list_title_song = directoryUrls.filter{ $0.pathExtension == "mp3" }.map{ $0.lastPathComponent }
            //print("MP3 FILES:\n" + list_title_song.description)
            AppsSettings.list_tittle_NCT = list_title_song
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    /**********************************************
    hàm xét sự kiện xóa bài hát
    **********************************************/
    func deleteSongLocal(_ sender:UIButton){
        if list_title_song[sender.tag] == AppsSettings.check_song_isplay {
            print("bai hat dang play k xoa dc")
            UIToast.makeText("បទចម្រៀងនេះត្រូវបានគេលេង").show()
        }else{
        idChoose = sender.tag
        print(list_title_song[idChoose])
        Downloader.deletefile(list_title_song[idChoose])
        getAllSong()
        tableListSong.reloadData()
        }
    }
    
    
    
        
        func searchData(_ searchText: String){
            filtered = list_title_song.filter({ (text) -> Bool in
                let tmp: NSString = text as NSString
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            print("this filter: " + String(filtered.count))
            if(filtered.count != 0){
                items = []
                for i in 0...filtered.count - 1{
                    for j in 0...list_title_song.count - 1{
                        if(filtered[i] == list_title_song[j] ){
                            items.append(list_title_song[j])
                        }
                    }
                }
                searchActive = true;
            }else if filtered.count == 0{
                searchActive = true
                 print("this filter - 0: " + String(filtered.count))
                items = []
                    }
            // tbView = UITableView(frame: CGRectMake(MulWidth*5, MulHeight*65 ,MulWidth*365, 612 * MulHeight))
            
            tableListSong.reloadData()
    }
   
    
}
extension DataViewNCT : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ScreenSize.MUL_HEIGHT * 37
    }
}

extension DataViewNCT : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countItem: Int! = 0
        if searchActive == true{
            countItem = items.count
        }else if searchActive == false{
            countItem = list_title_song.count
        }
        return countItem
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableListSong.dequeueReusableCell(withIdentifier: DataTableViewCellListNCT.identifier) as! DataTableViewCellListNCT
        if searchActive == true{
            print("this item count: " + String(items.count))
            let data = DataTableViewCellListNCTData(title_Song: items[indexPath.row], title_Author: "")
            cell.buttonDelete.addTarget(self, action: #selector(DataViewNCT.deleteSongLocal(_:)), for: UIControlEvents.touchUpInside)
            cell.buttonDelete.tag = indexPath.row
            cell.setData(data)
        }else if searchActive == false{
        let data = DataTableViewCellListNCTData(title_Song: list_title_song[indexPath.row], title_Author: "")
            cell.buttonDelete.addTarget(self, action: #selector(DataViewNCT.deleteSongLocal(_:)), for: UIControlEvents.touchUpInside)
            cell.buttonDelete.tag = indexPath.row
            cell.setData(data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive == true{
            AppsSettings.list_url_song.removeAll()
            AppsSettings.list_title_song.removeAll()
            AppsSettings.checkListenLocal = false
            AppsSettings.position = indexPath.row
            AppsSettings.list_url_song = list_title_song
            AppsSettings.list_title_song = list_title_song
            AppsSettings.isCheckedButtonPlay = true
            let titlesong = items[indexPath.row]
            
            AppsSettings.playMusicLocal(items[indexPath.row] , titleSong: titlesong)
            
        }else {
            AppsSettings.list_url_song.removeAll()
            AppsSettings.list_title_song.removeAll()
            AppsSettings.checkListenLocal = false
            AppsSettings.position = indexPath.row
            AppsSettings.list_url_song = list_title_song
            AppsSettings.list_title_song = list_title_song
            AppsSettings.isCheckedButtonPlay = true
            AppsSettings.playMusicLocal(list_title_song[indexPath.row] , titleSong: list_title_song[indexPath.row])
            AppsSettings.check_song_isplay = list_title_song[indexPath.row]
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.dismissKeyboard()
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        self.endEditing(true)
    }
}
