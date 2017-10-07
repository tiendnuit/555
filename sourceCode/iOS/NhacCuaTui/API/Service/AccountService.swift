//
//  LoginService.swift
//  sg.ownhome
//
//  Created by Delphinus on 8/19/15.
//  Copyright (c) 2015 Delphinus. All rights reserved.
//

import Foundation
@available(iOS 8.0, *)
class AccountService: BaseService {

    
    //ham get danh sach home 
    func getDataHome(_ api:String!, dataHome:DataHome , success:((ListDataHome)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: dataHome, success: { (responseEntity:ListDataHome?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    
    //ham get danh sach playList của tôi
    func getPlayList(_ api:String!, playList:PlayList , success:((ListPlayList)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: playList, success: { (responseEntity:ListPlayList?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //ham get danh sach playList yêu thích
    func getPlayListLike(_ api:String!, playList:PlayList , success:((ListPlayList)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: playList, success: { (responseEntity:ListPlayList?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //ham get danh sach video
    func getListVideo(_ api:String!, video:VideoVideo , success:((ListVideo)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: video, success: { (responseEntity:ListVideo?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //ham get danh sach song
    func getListSong(_ api:String!, song:Song , success:((ListSong)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: song, success: { (responseEntity:ListSong?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //ham get dang sach nghe si
    func getLisArtist(_ api:String!, artist:Artist , success:((ListArtist)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: artist, success: { (responseEntity:ListArtist?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //ham get dang sach chu de
    func getLisChuDe(_ api:String!, chuDe:ChuDe , success:((ListChuDe)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: chuDe, success: { (responseEntity:ListChuDe?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    
    //hàm get dang sach bảng xếp hạng
    func getBangXepHang(_ api:String!,bangXepHang:BangXepHang,success:((BangXepHang)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: bangXepHang, success: { (responseEntity:BangXepHang?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    
    //hàm xét giá trị thành công hay ko khi tạo playList
    func createPlayList(_ api:String!,playList:CreatePlayList,success:((CreatePlayList)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: playList, success: { (responseEntity:CreatePlayList?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //hàm get idUser khi login thành công
    func getIdUser(_ api:String!,loginUser:LoginUser,success:((LoginUser)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: loginUser, success: { (responseEntity:LoginUser?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    
    func register(_ api:String!,register:Register,success:((Register)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: register, success: { (responseEntity:Register?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    func getType(_ api:String!,type:TypeRelax,success:((TypeRelax)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: type, success: { (responseEntity:TypeRelax?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    func getRegion(_ api:String!,region:Region,success:((Region)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: region, success: { (responseEntity:Region?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
//UC 1
    //ham update luot nghe
    func updateCountSong(_ api:String!, song:Song , success:((ListSong)->Void)?, failure:((String)->Void)?){
        super.request(api , requestEntity: song, success: {
            (responseEntity:ListSong?) -> Void in
            success!(responseEntity!)
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    
    //ham update video
    func updateCountVideo(_ api:String!, video:VideoVideo , success:((ListVideo)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: video, success: { (responseEntity:ListVideo?) -> Void in
            success!(responseEntity!)
            print("update counter video")
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }
    //ham get danh sach playList của tôi
    func getCountPlayList(_ api:String!, playList:PlayList , success:((ListPlayList)->Void)?,failure:((String)->Void)?){
        super.request(api , requestEntity: playList, success: { (responseEntity:ListPlayList?) -> Void in
            success!(responseEntity!)
            print("update counter song sap xong roi !")
            }, failure: { (record,error) -> Void in
                failure!(error)
        })
    }

    //ham register
    
    
    
//    func getAboutAgency(api:String!,account:AboutAgency,success:((AboutAgency)->Void)?,failure:((String)->Void)?){
//        super.request(api , requestEntity: account, success: { (responseEntity:AboutAgency?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    // ham get list Advertisement cua page 3
//    func getAdvertisement(api:String!,favouries:Advertisement,success:((ListAdvertisement)->Void)?,failure:((String)->Void)?){
//        super.request(api ,requestEntity: favouries, success: { (responseEntity:ListAdvertisement?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    func getDetailedAdv(api:String!,account:DetaildAdv,success:((DetaildAdv)->Void)?,failure:((String)->Void)?){
//        super.request(api , requestEntity: account, success: { (responseEntity:DetaildAdv?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//                
//        })
//    }
//    
//    func getListImages(api:String!,favouries:Image,success:((ListImages)->Void)?,failure:((String)->Void)?){
//        super.request(api ,requestEntity: favouries, success: { (responseEntity:ListImages?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    
//    //ham get gia tri cua drop down
//    func getListContentDropDown(api:String!, dropdownContent: Dropdown,success:((ListDropdownContent)->Void)?,failure:((String)->Void)?){
//        super.request(api ,requestEntity: dropdownContent, success: { (responseEntity:ListDropdownContent?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    
//    //ham get gia tri cua email va telephone chung toan app
//    func getEmailInformation(api:String!,account:AboutInformation,success:((AboutInformation)->Void)?,failure:((String)->Void)?){
//        super.request(api , requestEntity: account, success: { (responseEntity:AboutInformation?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    // ham get gia tri page 3
//    func getPage3(api:String!, account:Page3,success:((Page3)->Void)?,failure:((String)->Void)?){
//        super.request(api , requestEntity: account, success: { (responseEntity:Page3?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    func getStarAndStopNotification(api:String!,pushNotification:PushNotification,success:((String)->Void)?,failure:((String)->Void)?){
//        super.request(api , requestEntity: pushNotification, success: { (responseEntity:PushNotification?) -> Void in
//            success!(responseEntity!.message)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
//    
//    func getInforAdmin(api:String!,inforAdmin:InforAdmin,success:((InforAdmin)->Void)?,failure:((String)->Void)?){
//        super.request(api , requestEntity: inforAdmin, success: { (responseEntity:InforAdmin?) -> Void in
//            success!(responseEntity!)
//            }, failure: { (record,error) -> Void in
//                failure!(error)
//        })
//    }
}
