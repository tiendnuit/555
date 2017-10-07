//
//  DataUiViewFormLogin.swift
//  NhacCuaTui
//
//  Created by Nguyễn Hà on 1/18/16.
//  Copyright © 2016 Nguyễn Hà. All rights reserved.
//
import FBSDKLoginKit
import UIKit

class DataUiViewFormLogin: UIView, FBSDKLoginButtonDelegate, GPPSignInDelegate, UITextFieldDelegate {


    //khai bao UIview
    var titleForm: UILabel!
    var textUserName: UITextField!
    var textPassWord: UITextField!
    var buttonOk: UIButton!
    var buttonCancel: UIButton!
    var textHoac: UILabel!
    var btRegister: UIButton!
    var buttonFacebook: FBSDKLoginButton!
    var buttonGoogle: UIButton!
    let preferences = UserDefaults.standard
    var userIDFacebook: String!
    var checklogin: String! = ""
    
    var signInGoogle: GPPSignIn!
    var moveTextField:CGFloat! = 0
    
    //khai bao bien
    var idChoose: Int!
    var loginUser: LoginUser!
    
    var txtRegisEmail: UITextField!
    var txtRegisPass: UITextField!
    var btAcceptRegis: UIButton!
    override func awakeFromNib() {
        
        createInterface()
        buttonFacebook.delegate = self
        buttonFacebook.readPermissions = ["public_profile", "email", "user_friends"]
        signInGoogle = GPPSignIn.sharedInstance()
        signInGoogle.shouldFetchGooglePlusUser = true
        signInGoogle.shouldFetchGoogleUserEmail = true  // Uncomment to get the user's email
        signInGoogle.shouldFetchGoogleUserID = true
        signInGoogle.clientID = "469372234063-m4nbat60o8icqmu68f3a3k1o3cbfddmo.apps.googleusercontent.com"
        signInGoogle.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DataUiViewFormLogin.dismissKeyboard))
                self.addGestureRecognizer(tap)
        AppsSettings.dimBackgroundColor.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(DataUiViewFormLogin.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(DataUiViewFormLogin.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
    }

    
    /***************************************************
    ham xet su kien khi click vào các button
    ****************************************************/
    func actionEven(_ sender:UIButton){
        idChoose = sender.tag
        if idChoose == 1 { // xet su kien button đăng nhập
            AppsSettings.dimBackgroundColor.isHidden = true
            AppsSettings.formLogin.isHidden = true
            
        }else if idChoose == 2 { // xet sự kiện button thoát
            hideLoginUI()
        }
    }
    
    /***************************************************
    ham parce api login
    ****************************************************/
    func parceApiLogin(_ email: String , firstname: String , lastname: String){
        loginUser = LoginUser()
        loginUser.emailUser = email
        loginUser.firstnameUser = firstname
        loginUser.lastname = lastname
        AccountService(viewController: AppsSettings.root, isShowLoading: true).getIdUser("api/registerAndLogin", loginUser: loginUser, success: { (response) -> Void in
            let a = response
            print(String(a.idUser))
            
            let useridkey = "useridkey"
            let usernamekey = "usernamekey"
            
            let username = firstname
            AppsSettings.nameUserAvatar.text = username
            let userid = String(a.idUser)
            self.preferences.setValue(userid, forKey: useridkey)
            self.preferences.setValue(username, forKey: usernamekey)
            
            AppsSettings.dimBackgroundColor.isHidden = true
            AppsSettings.formLogin.isHidden = true
            //  Save to disk
            let didSave = self.preferences.synchronize()
            if !didSave {
                print("Error to check login")
            }
            }) { (error) -> Void in
                print("error")
        }
    }
    
    // dang nhap thuong 0
    func parceApiLoginNomarl(){
        buttonOk.isEnabled = false
        let register: Register = Register()
        register.username = textUserName.text
        register.password = textPassWord.text
        AccountService(viewController: AppsSettings.root, isShowLoading: true).register("api/login", register: register, success: { (response) -> Void in
            let a = response
            print(String(a.username))
            let useridkey = "useridkey"
            let usernamekey = "usernamekey"
            let checkloginkey = "checklogin"
            let username = a.username
   
            let userid = String(a.id)
            self.preferences.setValue(userid, forKey: useridkey)
            self.preferences.setValue(username, forKey: usernamekey)
            self.preferences.setValue(a.email, forKey: "useremailkey")
            self.preferences.set(1, forKey: checkloginkey)
            let didSave = self.preferences.synchronize()
            AppsSettings.dimBackgroundColor.isHidden = true
            AppsSettings.formLogin.isHidden = true
            AppsSettings.checklog = "1"
            AppsSettings.shit = true
            //thaydoi1.3
            AppsSettings.statusLoginNomal = true
            AppsSettings.saveNameLoginNomal = username
            self.textUserName.text = ""
            self.textPassWord.text = ""
            if !didSave {
                print("Error to check login")
            }
            
        }) { (error) -> Void in
            print("error")
            UIToast.makeText("ពត៍មានចូលគណនីមិនត្រឹមត្រូវ").show()
            self.buttonOk.isEnabled = true
        }
        
    }

    
    /***************************************************
    Khoi tao View
    ****************************************************/
    func createInterface(){
        titleForm = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 8, y:ScreenSize.MUL_HEIGHT * 10, width: ScreenSize.MUL_WIDTH * 234, height: ScreenSize.MUL_HEIGHT * 20))
        titleForm.textAlignment = .center
        titleForm.font = UIFont.font65Medium(15)
        titleForm.text = "ចូលគណនី"
        
        textUserName = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 29, y:ScreenSize.MUL_HEIGHT * 35, width: ScreenSize.MUL_WIDTH * 193, height: ScreenSize.MUL_HEIGHT * 23))
        textUserName.layer.borderColor = UIColor(hex: "000000").cgColor
        textUserName.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        textUserName.layer.cornerRadius = 3.0 * ScreenSize.MUL_WIDTH
        textUserName.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        textUserName.placeholder = "  ឈ្មោះចូលគណនី"
        textUserName.delegate = self
        
        textPassWord = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 29, y:ScreenSize.MUL_HEIGHT * 65, width: ScreenSize.MUL_WIDTH * 193, height: ScreenSize.MUL_HEIGHT * 23))
        textPassWord.layer.borderColor = UIColor(hex: "000000").cgColor
        textPassWord.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        textPassWord.layer.cornerRadius = 3.0 * ScreenSize.MUL_WIDTH
        textPassWord.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        textPassWord.placeholder = "  លេខសំងាត់"
        textPassWord.isSecureTextEntry = true
        textPassWord.delegate = self
        
        buttonOk = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 35, y:ScreenSize.MUL_HEIGHT * 100, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 23))
        buttonOk.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        buttonOk.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        buttonOk.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        buttonOk.setTitle("ចូលគណនី", for: UIControlState())
        buttonOk.backgroundColor = UIColor(hex: "E21D2B")
        buttonOk.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        buttonOk.addTarget(self, action: #selector(DataUiViewFormLogin.parceApiLoginNomarl), for: UIControlEvents.touchUpInside)
        buttonOk.tag = 1
        
        buttonCancel = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 135, y:ScreenSize.MUL_HEIGHT * 100, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 23))
        buttonCancel.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        buttonCancel.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        buttonCancel.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        buttonCancel.setTitle("ចាកចេញ", for: UIControlState())
        buttonCancel.backgroundColor = UIColor(hex: "E21D2B")
        buttonCancel.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        buttonCancel.addTarget(self, action: #selector(DataUiViewFormLogin.actionEven(_:)), for: UIControlEvents.touchUpInside)
        buttonCancel.tag = 2
        
        textHoac = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 20, y:ScreenSize.MUL_HEIGHT * 135, width: ScreenSize.MUL_WIDTH * 100, height: ScreenSize.MUL_HEIGHT * 20))
        textHoac.textAlignment = .center
        textHoac.font = UIFont.font65Medium(12)
        textHoac.text = "ផ្សេងៗ"
        buttonFacebook = FBSDKLoginButton()
        buttonFacebook.frame = CGRect(x: ScreenSize.MUL_WIDTH * 100, y:ScreenSize.MUL_HEIGHT * 130, width: ScreenSize.MUL_WIDTH * 25, height: ScreenSize.MUL_HEIGHT * 25)
        buttonFacebook.setBackgroundImage(UIImage(named:"btn_facebook.png"), for: UIControlState())
        buttonFacebook.tag = 3
        btRegister = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 135, y:ScreenSize.MUL_HEIGHT * 130, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 20))
        btRegister.setTitle("ចុះឈ្មោះ", for: UIControlState())
        btRegister.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT)
        btRegister.backgroundColor = UIColor(hex: "E21D2B")
        btRegister.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        btRegister.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        btRegister.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        btRegister.addTarget(self, action: #selector(DataUiViewFormLogin.formRegister), for: UIControlEvents.touchUpInside)
        
        
        self.addSubview(titleForm)
        self.addSubview(textUserName)
        self.addSubview(textPassWord)
        self.addSubview(buttonOk)
        self.addSubview(buttonCancel)
        self.addSubview(textHoac)
        self.addSubview(buttonFacebook)
        self.addSubview(btRegister)
    }
    
    
    func formRegister(){
        textUserName.removeFromSuperview()
        textPassWord.removeFromSuperview()
        buttonOk.removeFromSuperview()
        buttonCancel.removeFromSuperview()
        textHoac.removeFromSuperview()
        buttonFacebook.removeFromSuperview()
        btRegister.removeFromSuperview()
        titleForm.removeFromSuperview()
        
        titleForm = UILabel(frame: CGRect(x: ScreenSize.MUL_WIDTH * 8, y:ScreenSize.MUL_HEIGHT * 10, width: ScreenSize.MUL_WIDTH * 234, height: ScreenSize.MUL_HEIGHT * 20))
        titleForm.textAlignment = .center
        titleForm.font = UIFont.font65Medium(15)
        titleForm.text = "ចុះឈ្មោះ"
        textUserName = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 29, y:ScreenSize.MUL_HEIGHT * 35, width: ScreenSize.MUL_WIDTH * 193, height: ScreenSize.MUL_HEIGHT * 23))
        textUserName.layer.borderColor = UIColor(hex: "000000").cgColor
        textUserName.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        textUserName.layer.cornerRadius = 3.0 * ScreenSize.MUL_WIDTH
        textUserName.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        textUserName.placeholder = "  ឈ្មោះចូលគណនី"
        textUserName.delegate = self
        
        txtRegisEmail = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 29, y:ScreenSize.MUL_HEIGHT * 65, width: ScreenSize.MUL_WIDTH * 193, height: ScreenSize.MUL_HEIGHT * 23))
        txtRegisEmail.layer.borderColor = UIColor(hex: "000000").cgColor
        txtRegisEmail.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        txtRegisEmail.layer.cornerRadius = 3.0 * ScreenSize.MUL_WIDTH
        txtRegisEmail.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        txtRegisEmail.placeholder = "  អ៊ីម៉ែល"
//        txtRegisEmail.secureTextEntry = true
        txtRegisEmail.delegate = self
        
        
        txtRegisPass = UITextField(frame: CGRect(x: ScreenSize.MUL_WIDTH * 29, y:ScreenSize.MUL_HEIGHT * 95, width: ScreenSize.MUL_WIDTH * 193, height: ScreenSize.MUL_HEIGHT * 23))
        txtRegisPass.layer.borderColor = UIColor(hex: "000000").cgColor
        txtRegisPass.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        txtRegisPass.layer.cornerRadius = 3.0 * ScreenSize.MUL_WIDTH
        txtRegisPass.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        txtRegisPass.placeholder = "  លេខសំងាត់"
        txtRegisPass.isSecureTextEntry = true
        txtRegisPass.delegate = self
        
        btAcceptRegis = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 35, y:ScreenSize.MUL_HEIGHT * 130, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 23))
        btAcceptRegis.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        btAcceptRegis.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        btAcceptRegis.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        btAcceptRegis.setTitle("ចុះឈ្មោះ", for: UIControlState())
        btAcceptRegis.backgroundColor = UIColor(hex: "E21D2B")
        btAcceptRegis.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        btAcceptRegis.addTarget(self, action: #selector(DataUiViewFormLogin.parseAPIRegister), for: UIControlEvents.touchUpInside)
        
        
        
        buttonCancel = UIButton(frame: CGRect(x: ScreenSize.MUL_WIDTH * 135, y:ScreenSize.MUL_HEIGHT * 130, width: ScreenSize.MUL_WIDTH * 80, height: ScreenSize.MUL_HEIGHT * 23))
        buttonCancel.layer.borderColor = UIColor(hex: "E21D2B").cgColor
        buttonCancel.layer.borderWidth = 0.5 * ScreenSize.MUL_WIDTH
        buttonCancel.layer.cornerRadius = 5.0 * ScreenSize.MUL_WIDTH
        buttonCancel.setTitle("ចាកចេញ", for: UIControlState())
        buttonCancel.backgroundColor = UIColor(hex: "E21D2B")
        buttonCancel.titleLabel?.font = UIFont(name: "Arial", size: 11 * ScreenSize.MUL_HEIGHT )
        buttonCancel.addTarget(self, action: #selector(DataUiViewFormLogin.hideFormRegister), for: UIControlEvents.touchUpInside)
        buttonCancel.tag = 2
        
        self.addSubview(titleForm)
        self.addSubview(textUserName)
        self.addSubview(txtRegisEmail)
        self.addSubview(txtRegisPass)
        self.addSubview(btAcceptRegis)
        self.addSubview(buttonCancel)
        //        btAcceptRegis.tag = 1
    }
    
    //validate email
    
    func isValidEmail(_ testStr:String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: testStr)
        
        return result
        
    }
    
    
    
    func hideFormRegister(){
        textUserName.removeFromSuperview()
        txtRegisEmail.removeFromSuperview()
        txtRegisPass.removeFromSuperview()
        btAcceptRegis.removeFromSuperview()
        buttonCancel.removeFromSuperview()
        titleForm.removeFromSuperview()
        createInterface()
    }
    func parseAPIRegister(){
        
        var entity: Register! = Register()
        if txtRegisPass.text != "" && txtRegisEmail.text != "" && textUserName.text != ""{
            if isValidEmail(txtRegisEmail.text!){
                entity.username = textUserName.text
                entity.email = txtRegisEmail.text
                entity.password = txtRegisPass.text
                AccountService(viewController: AppsSettings.root, isShowLoading: true).register("api/register", register: entity, success: { (response) -> Void in
                    let a = response
                    print("THis register:" + String(describing: response))
                    UIToast.makeText("ចុះឈ្មោះជោគជ័យ!").show()
                    self.hideFormRegister()
                }) { (error) -> Void in
                    print("error")
                    UIToast.makeText("ចុះឈ្មោះមិនជោគជ័យ!").show()
                }

            }else{
                UIToast.makeText("លេកអ្នកបញ្ចូលអ៊ីម៉ែលខុស!").show()
            }
        }else {
            UIToast.makeText("លោកអ្នកត្រូវតែបញ្ចូលពត៍មានអោយពេញលេញ!").show()
        }

    }
    
    func hideLoginUI(){
        AppsSettings.formLogin.isHidden = true
        AppsSettings.dimBackgroundColor.isHidden = true
    }
    
//Login 1
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if(error != nil){
            print(error.localizedDescription)
            return
        }
        if let userToken = result.token{
            let token:FBSDKAccessToken = result.token
            print("Token = \(FBSDKAccessToken.current().tokenString)")
            print("Token = \(FBSDKAccessToken.current().userID)")
            //AppSetting.UseridFacebook = FBSDKAccessToken.currentAccessToken().userID
            
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: userToken.tokenString, version: nil, httpMethod: "GET")
            req?.start(completionHandler: { (_, result, error) in
                if error == nil, let data = result as? [String:Any]
                {
                    let userEmail = data["email"] as! String!
                    //print("email hoang ha: " + userEmail)
                    let name = data["name"] as! String!
                    //print("name hoang ha: " + name)
                    self.preferences.setValue(name, forKey: "usernamekey")
                    self.preferences.setValue(userEmail, forKey: "useremailkey")
                    if userEmail != nil
                    {
                        self.parceApiLogin(userEmail!, firstname: name ?? "", lastname: "test")
                    }
                    else
                    {
                        self.parceApiLogin("", firstname: name ?? "", lastname: "test")
                    }
                }
                else
                {
                    print("error \(error)")
                }
            })
            
            let checkloginkey = "checklogin"
            let idfacebooks = "idfacebook"
            let idfacebook = FBSDKAccessToken.current().userID
            print("this id facebook: " + idfacebook!)
            let loginkey = 1
            preferences.set(loginkey, forKey: checkloginkey)
            preferences.setValue(idfacebook, forKey: idfacebooks)
            //  Save to disk
            let didSave = preferences.synchronize()
            if !didSave {
                print("Error to check login")
            }
            AppsSettings.checklog = "1"
            AppsSettings.shit = true
            //thaydoi1.2
            AppsSettings.formLogin.removeFromSuperview()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!){
    }
    
    
    func finished(withAuth auth: GTMOAuth2Authentication!, error: Error!) {
        if (GPPSignIn.sharedInstance().userID != nil) {
            let user = GPPSignIn.sharedInstance().googlePlusUser
            print("user name: " + (user?.name.jsonString())! + "\nemail: ")
            if (user?.emails != nil){
                print((user?.emails.first as AnyObject).jsonString() ?? "no email")
            } else {
                print("no email")
            }
        } else {
            print("User ID is nil")
        }
    }
    func signGoogle(_ sender: AnyObject?){
        signInGoogle.authenticate()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == textUserName){ moveTextField = 10}
        else { moveTextField = 10}
        
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
        self.frame.origin.y = +25
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }

}
