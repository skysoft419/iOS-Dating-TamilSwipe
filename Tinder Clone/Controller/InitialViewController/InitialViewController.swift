//
//  ViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import FBSDKLoginKit
import FBSDKCoreKit
import AccountKit
import RevealingSplashView
import SwiftyJSON
import MIAlertController
class InitialMainViewController: UIViewController,SliderCollectionViewDelegate,TTTAttributedLabelDelegate, LoginFromFBAssuranceDelegate,AKFViewControllerDelegate {
    
    
    @IBOutlet weak var scroll_view: UIScrollView!

    @IBOutlet weak var page_control: FXPageControl!
    private var allUserData:AllUserData=AllUserData()
    @IBOutlet weak var sliderview: SliderCollectionView!
    @IBOutlet weak var upper_wrapperview: UIView!
    @IBOutlet weak var centreview: UIView!
    @IBOutlet weak var Bottomview: UIView!
    @IBOutlet weak var FacebookBtn: UIButton!
    @IBOutlet weak var MobileNoBtn: UIButton!
    @IBOutlet weak var fbinfo: UIButton!
    @IBOutlet weak var logo: UILabel!
    var obj_Record:LoginRecord = LoginRecord()

    @IBOutlet weak var privacytext: TTTAttributedLabel!
    @IBOutlet var noOneLabelOutlet: UILabel!
    private let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo")!,iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    var upperActualypos:CGFloat = CGFloat()
    var CenterActualypos:CGFloat = CGFloat()
    var bottomActualypos:CGFloat = CGFloat()
 
    var isHideanimation:Bool = Bool()
    private var fbLoginManager : LoginManager = LoginManager()
    var DataSource:Array<Any>!
    var isReceivedEmailData:Bool = Bool()
    var isLoggedIn = Bool()
    var accountKit:AKFAccountKit!
    private var loadingAlert:UIAlertController?
    private var facebookRecord=LoginRecord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StaticData.allUserData=nil
        StaticData.updated=true
       
        
        self.view.addSubview(revealingSplashView)
        FacebookBtn.frame.size.height=49
        MobileNoBtn.frame.size.height=49
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        noOneLabelOutlet.isHidden = true
        upperActualypos = upper_wrapperview.frame.origin.y
        CenterActualypos = centreview.frame.origin.y
        bottomActualypos = Bottomview.frame.origin.y
        sliderview.Delegate = self
        if accountKit == nil{
            self.accountKit=AKFAccountKit(responseType: .accessToken)
        }
          // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: Constant.sharedinstance.PhoneVerfication, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.MovetoHome(notification:)), name: Constant.sharedinstance.Logincompleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.Movetoemail(notification:)), name: Constant.sharedinstance.PhoneVerfication, object: nil)
        isReceivedEmailData = false
        if(Themes.sharedIntance.CheckLogin())
        {
            (UIApplication.shared.delegate as! AppDelegate).MovetoRoot(status: "splash")
        
        }else{
            ConfigManager.getInstance().setFirst(value: "NO")
        }
     }
    
    @IBAction func didclickimage(_ sender: Any) {
        let imageData: NSData = UIImageJPEGRepresentation(#imageLiteral(resourceName: "sample1_l"), 0.9)! as NSData

        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)

     
        let param:[String:String] = ["image":strBase64]
        URLhandler.Sharedinstance.makeCall(url:"https://app.icedxb.net/users/upload/profile-ios/8", param: param, _method: .post, completionHandler: { (ResponseDict, error) in
            
           
            if((ResponseDict?.count)! > 0)
            {
               
           
                
            }
            else
            {
                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                
            }
        })

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
    @objc func MovetoHome(notification:Notification)
     {
        isReceivedEmailData = true
        isHideanimation = true
        obj_Record  = notification.object as! LoginRecord
      }
    
    func RegisterUser(objRecord:LoginRecord)
    {
        isReceivedEmailData = false

        self.present(loadingAlert!, animated: true, completion: {
            let image: UIImage = objRecord.imageRaw
            let imageData: NSData = UIImageJPEGRepresentation(image, 0.9)! as NSData
            let countryCode:String =  objRecord.country_code.replacingOccurrences(of: "+", with: "")
            let param:[String:String] = ["email_id":Themes.sharedIntance.CheckNullvalue(Str: objRecord.email_id as AnyObject),"password":Themes.sharedIntance.CheckNullvalue(Str: objRecord.password as AnyObject),"first_name":Themes.sharedIntance.CheckNullvalue(Str: objRecord.first_name as AnyObject),"last_name":objRecord.last_name,"dob":Themes.sharedIntance.CheckNullvalue(Str: objRecord.dob as AnyObject),"gender":Themes.sharedIntance.CheckNullvalue(Str: objRecord.gender as AnyObject),"verification_code":Themes.sharedIntance.CheckNullvalue(Str: objRecord.verification_code as AnyObject),"phone_number":Themes.sharedIntance.CheckNullvalue(Str: objRecord.phone_number as AnyObject),"country_code":countryCode]
            
            URLhandler.Sharedinstance.uploadImage(urlString: Constant.sharedinstance.Phonenumber_Signup as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
                    if(error == nil)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        _ = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        
                        if(status_code == "1")
                        {
                            let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_image_url") as AnyObject)
                            
                            let email = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                            
                            let first_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "first_name") as AnyObject)
                            
                            let last_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "last_name") as AnyObject)
                            let user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                            let access_token = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "access_token") as AnyObject)
                            let fullname = "\(first_name) \(last_name)"
                            let param:[String:String] = ["access_token":access_token,"email":email,"first_name":first_name,"full_name":fullname,"last_name":last_name,"signup_type":"fb","user_id":user_id,"user_image_url":user_image_url]
                            Themes.sharedIntance.saveUserID(userid: user_id)
                            Themes.sharedIntance.saveaccesstoken(userid:access_token)
                            DatabaseHandler.sharedinstance.insertDataForTable(tableName: Constant.sharedinstance.User_details, dictValues: param as NSDictionary)
                        
                            
                        }
                        else {
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: ResponseDict!["status_message"]! as! String)
                        }
                        
                    }
                    else
                    {
                        print(error?.localizedDescription as Any)
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
            
                
            }
        })
 
     }
    func verifyPhoneNumber(phonenumber:String,countrycode:String,access_token:String)
    {
        
        self.present(loadingAlert!, animated: true, completion: {
            let param:[String:Any] = ["phone_number":phonenumber,"country_code":countrycode,"access_token":access_token]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.Phonenumber_Verfication as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if(ResponseDict != nil)
                    {
                        if((ResponseDict?.count)! > 0)
                        {
                            let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                            let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                            
                            if(status_code == "1" || (status_code == "0" && status_message == "Message sending Failed,please try again.."))
                            {
                                
                                let userRecord:LoginRecord = LoginRecord()
                                userRecord.verification_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "otp") as AnyObject)
                                //                    self.otp = self.generateRandomDigits(6)
                                userRecord.already_user = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "already_user") as AnyObject)
                                userRecord.phone_number=phonenumber
                                userRecord.country_code=countrycode
                                self.login(objRecord: userRecord)
                                
                                //self.perform(#selector(self.MovetoEnterOTP), with: self, afterDelay: 2.0)
                                
                                
                            }
                            else
                            {
                                print(ResponseDict)
                                
                            }
                        }
                        else
                        {
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                        }
                    }
                    else
                    {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                })
            })
        })
    }
    func FbRegister(objRecord:LoginRecord)
    {
        let fbimgURL:String = "https://graph.facebook.com/\(objRecord.fb_id)/picture?type=large&return_ssl_resources=1"
        let param:[String:String] = ["fb_id":objRecord.fb_id,"first_name":objRecord.first_name,"last_name":objRecord.last_name,"user_image_url":fbimgURL,"email_id":objRecord.email_id,"signup_type":"fb","gender":objRecord.gender,"dob":objRecord.dob]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.FbSignUpUrl as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            
                if ResponseDict != nil{
                if((ResponseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    
                    if status_code == "1" && status_message == "New User"
                    {
                        
                        StaticData.isFirstSignUp=true
                        StaticData.isFirstTime=true
                        ConfigManager.getInstance().setFirstTap(value: "YES")
                        ConfigManager.getInstance().setFirstLike(value: "YES")
                       self.loadingAlert?.dismiss(animated: true, completion: {
                            Constant.sharedinstance.isFromFBLogin = true
                            Constant.sharedinstance.fbLoginRecords = objRecord
                            let inputState=UUID().uuidString
                            let viewController=self.accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
                            viewController.enableSendToFacebook=true
                            self.prepareLoginViewController(loginViewController: viewController)
                            self.present(viewController as! UIViewController, animated: true, completion: nil)
                        
                        
                        })
                        
                        
                    }
                    else if status_code == "1" && status_message != "New User" {
                        self.loadingAlert?.dismiss(animated: true, completion: {
                        let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_image_url") as AnyObject)
                        
                        let email = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                        
                        let first_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "first_name") as AnyObject)
                        
                        let last_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "last_name") as AnyObject)
                        let user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                        let access_token = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "access_token") as AnyObject)
                        let fullname = "\(first_name) \(last_name)"
                        let param:[String:String] = ["access_token":access_token,"email":email,"first_name":first_name,"full_name":fullname,"last_name":last_name,"signup_type":"fb","user_id":user_id,"user_image_url":user_image_url]
                        Themes.sharedIntance.saveUserImage(userid: user_image_url)
                        Themes.sharedIntance.saveUserID(userid: user_id)
                        Themes.sharedIntance.saveaccesstoken(userid:access_token)
                        DatabaseHandler.sharedinstance.insertDataForTable(tableName: Constant.sharedinstance.User_details, dictValues: param as NSDictionary)
                        self.getAllPlansData()
                        })
                        
                    }
                    else
                    {
                        self.loadingAlert?.dismiss(animated: true, completion: {
                            
                            if  status_message == "Sorry, your Facebook account does not meet the info we require for Facebook sign up. Please try signing up using phone number instead."{
                                let alertController = MIAlertController(
                                    title: "Oops",
                                    message: status_message
                                )
                                alertController.addButton(
                                    MIAlertController.Button(title: "OK", type: .destructive, action: {
                                       
                                        
                                    }))
                                
                                alertController.presentOn(self)
                            }else{
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                            }
                            })
                        
                    }
                }
                   
                else
                {
                    self.loadingAlert?.dismiss(animated: true, completion: {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    })
                }
                }
        })

    }
    
    @objc func Movetoemail(notification:Notification)
    {
        isHideanimation = true
        if !(Constant.sharedinstance.isFromFBLogin) {
            let objRecord:LoginRecord = notification.object as! LoginRecord
            if(objRecord.already_user == "true")
            {
                if !isLoggedIn {
                    isLoggedIn = true
                    self.PerformLogin(objRecord: objRecord)
                }
                
            }
            else
            {
                let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailDetailViewControllerID") as! EmailDetailViewController
                emailVC.objLogRecord = objRecord
                self.navigationController?.pushViewController(emailVC, animated: true)
              
            }
        }
        else {
            let fbRecord:LoginRecord = notification.object as! LoginRecord
            Constant.sharedinstance.fbLoginRecords.country_code = fbRecord.country_code
            Constant.sharedinstance.fbLoginRecords.phone_number = fbRecord.phone_number
            let fbimgURL:String = "https://graph.facebook.com/\(Constant.sharedinstance.fbLoginRecords.fb_id)/picture?type=large&return_ssl_resources=1"
            let param:[String:String] = ["fb_id":Constant.sharedinstance.fbLoginRecords.fb_id,"first_name":Constant.sharedinstance.fbLoginRecords.first_name,"last_name":Constant.sharedinstance.fbLoginRecords.last_name,"user_image_url":fbimgURL,"email_id":Constant.sharedinstance.fbLoginRecords.email_id,"signup_type":"fb","country_code":Constant.sharedinstance.fbLoginRecords.country_code,"phone_number":Constant.sharedinstance.fbLoginRecords.phone_number,"fb_token":AccessToken.current!.tokenString]
            
            Themes.sharedIntance.ShowProgress(view: self.view)
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.fbPhoneSignUpUrl as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                if ResponseDict != nil{
                
                if((ResponseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    
                    if status_code == "1" {
                        
                        let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_image_url") as AnyObject)
                        
                        let email = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                        
                        let first_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "first_name") as AnyObject)
                        
                        let last_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "last_name") as AnyObject)
                        let user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                        let access_token = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "access_token") as AnyObject)
                        let fullname = "\(first_name) \(last_name)"
                        let param:[String:String] = ["access_token":access_token,"email":email,"first_name":first_name,"full_name":fullname,"last_name":last_name,"signup_type":"fb","user_id":user_id,"user_image_url":user_image_url]
                        Themes.sharedIntance.saveUserID(userid: user_id)
                        Themes.sharedIntance.saveaccesstoken(userid:access_token)
                        DatabaseHandler.sharedinstance.insertDataForTable(tableName: Constant.sharedinstance.User_details, dictValues: param as NSDictionary)
                        self.getAllPlansData()

                        
                    }
                    else
                    {
                        
                        
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        
                    }
                }
                else
                {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
                }
            })
        }
        
        
    }
    
    func PerformLogin(objRecord:LoginRecord)
    {
        self.present(loadingAlert!, animated: true, completion: {
            let param:[String:Any] = ["phone_number":objRecord.phone_number,"country_code":objRecord.country_code]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.login as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                    if ResponseDict != nil{
                    if((ResponseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        if(status_code == "1")
                        {
                            
                            
                            
                            let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_image_url") as AnyObject)
                            
                            let email = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                            
                            let first_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "first_name") as AnyObject)
                            
                            let last_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "last_name") as AnyObject)
                            let user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                            let access_token = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "access_token") as AnyObject)
                            let fullname = "\(first_name) \(last_name)"
                            let param:[String:String] = ["access_token":access_token,"email":email,"first_name":first_name,"full_name":fullname,"last_name":last_name,"signup_type":"fb","user_id":user_id,"user_image_url":user_image_url]
                            Themes.sharedIntance.removeUserImage()
                            Themes.sharedIntance.saveUserImage(userid: user_image_url)
                            Themes.sharedIntance.saveUserID(userid: user_id)
                            Themes.sharedIntance.saveaccesstoken(userid:access_token)
                            DatabaseHandler.sharedinstance.insertDataForTable(tableName: Constant.sharedinstance.User_details, dictValues: param as NSDictionary)
                           self.getAllPlansData()
                        }
                        else
                        {
                            
                            
                        }
                    }
                    else
                    {
                        
                    }
                    }else{
                        let err=error as? NSError
                        if err?.code == 401{
                        let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        }
                    }
            
            })
        })
    }

    func IndexforPageControl(index: Int) {
        self.page_control.currentPage = index;

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.SetAttributedText()
         if(isHideanimation == false)
        {
        self.SetFrameUpwards(view: upper_wrapperview)
        self.SetFrameUpwards(view: centreview)
        self.SetFrameUpwards(view: Bottomview)
        self.logo.isHidden = true
        self.logo.alpha = 0.0
        
        UIView.animate(withDuration: 1.0, animations: {
            self.logo.alpha = 1.0

        }) { (iscompleted) in
          self.ReloadData()
          }
        }
        if(isReceivedEmailData)
        {
            //self.RegisterUser(objRecord: obj_Record)
        }
        if StaticData.fromFacebook{
            if StaticData.facebookEmail != nil{
                facebookRecord.email_id=StaticData.facebookEmail!
            }
            if StaticData.facebookDob != nil{
                facebookRecord.dob=StaticData.facebookDob!
            }
            FbRegister(objRecord: facebookRecord)
        }
    }
    func ReloadData()
    {
        DataSource = [Any]()
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.splashUrl as NSString, param: [:], _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
            if((responseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                
                if(status_code == "1")
                {
                    
                    SharedVariables.sharedInstance.minimumAge = Int((responseDict?.object(forKey: "minimum_age") as! NSString).intValue)
                    SharedVariables.sharedInstance.maximumAge = Int((responseDict?.object(forKey: "maximum_age") as! NSString).intValue)
                    
                    if Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "is_appstore_otp") as AnyObject).count > 0 && Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "is_appstore_otp") as AnyObject) == "1" {
                        SharedVariables.sharedInstance.isToShowOTPPage = false
                    }
                    else {
                        SharedVariables.sharedInstance.isToShowOTPPage = true
                    }
                    
                    let tinder_plus_slidersArr: [[String:AnyObject]] = responseDict?.object(forKey: "login_sliders") as!  [[String:AnyObject]]
                    if(tinder_plus_slidersArr.count > 0)
                    {
                        for Dict in tinder_plus_slidersArr
                        {
                            let Splash_Record:SplashRecord = SplashRecord()
                            
                            Splash_Record.id = Themes.sharedIntance.CheckNullvalue(Str: Dict["id"] as AnyObject)
                            Splash_Record.title = Themes.sharedIntance.CheckNullvalue(Str:Dict["title"] as AnyObject)
                            Splash_Record.image = Themes.sharedIntance.CheckNullvalue(Str: Dict["image"] as AnyObject)
                            self.DataSource.append(Splash_Record)
                        }
                        self.revealingSplashView.startAnimation(){
                           
                            self.initialiseCollectionView()
                            self.AnimatetooriginalPostion()
                            self.SetAttributedText()
                          
                        }
                        


                    }
                    
                }
                else
                {
                    self.revealingSplashView.startAnimation(){
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        self.AnimatetooriginalPostion()
                        self.SetAttributedText()
                    }
                    
                }
            }
            else
            {
                
            }
            }
        })
    }
    override func viewDidLayoutSubviews() {
        Themes.sharedIntance.AddBorder(view: MobileNoBtn, borderColor: UIColor.lightGray, borderWidth: 1.0, cornerradius: MobileNoBtn.frame.size.height / 2)
       Themes.sharedIntance.AddBorder(view: FacebookBtn, borderColor: UIColor.lightGray, borderWidth: 1.0, cornerradius: MobileNoBtn.frame.size.height / 2)
        SetAttributedText()

    }
    func SetAttributedText()
    {
        privacytext.textColor = UIColor.lightGray;
        privacytext.font = UIFont.systemFont(ofSize: 14)
        privacytext.text = "By signing in,you agree to our Terms and Privacy Policy"
        let range:Range = ((privacytext.text as! String).range(of: "Privacy Policy"))!
        let covertedrandge:NSRange = ((privacytext.text as! String).nsRange(from: range))!
        
        let range2:Range = ((privacytext.text as! String).range(of: "Terms"))!
        let covertedrandge2:NSRange = ((privacytext.text as! String).nsRange(from: range2))!
       
        var linkAttributes = [AnyHashable: Any]()
        linkAttributes[kCTUnderlineStyleAttributeName] = NSUnderlineStyle.styleSingle.rawValue
        linkAttributes[kCTForegroundColorAttributeName] = UIColor.lightGray
        linkAttributes[kCTBackgroundColorAttributeName] = UIColor.clear
        privacytext.linkAttributes = linkAttributes

        privacytext.addLink(to: URL(string:"\(k_PrivacyPolicyURL)"), with: covertedrandge)
        privacytext.addLink(to: URL(string:"\(k_TermsAndConditionsURL)"), with: covertedrandge2)
        
        privacytext.delegate = self
    }
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        
        let webVC:WebViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebViewControllerID") as! WebViewController
        isHideanimation = true
        webVC.URl = url.absoluteString
        if(url.absoluteString == "\(k_TermsAndConditionsURL)")
        {
            webVC.HeaderStr = "Terms"
        }
        else
        {
            webVC.HeaderStr = "Privacy Policy"

        }
        self.navigationController?.present(webVC, animated: true, completion: nil)
     }
    
    func AnimatetooriginalPostion()
    {
        
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.SetFirstviewtoorginal()
             self.SetSecondviewtoorginal()
              self.SetThirdviewtoorginal()
            self.logo.isHidden = true
            self.revealingSplashView.isHidden=true

         }) { _ in
            
 
            
         
        }

    }
    func initialiseCollectionView()
    {
        let imageArr:Array=["splash1","splash2","splash3","samp5"]
        let HeaderSliderArray:NSMutableArray = NSMutableArray()
        for ObjRecord:SplashRecord in DataSource as! [SplashRecord]
        {
             let objRecord:SliderRecord=SliderRecord(imageName: ObjRecord.image, LogoimageName: "", DetailText: ObjRecord.title,subtext:"")
            HeaderSliderArray.add(objRecord)
            
        }
        sliderview.Header_Data_Source = NSMutableArray(array: HeaderSliderArray)
           sliderview.Slidercat = .header
           sliderview.Paging_Enabled=true
           sliderview.ReloadSlider()
        page_control.numberOfPages = NSMutableArray(array: HeaderSliderArray).count
        page_control.defersCurrentPageDisplay = true;
        self.page_control.selectedDotColor = Themes.sharedIntance.ReturnThemeColor();
        self.page_control.dotColor = UIColor.lightGray
        self.page_control.currentPage = 0;
        page_control.selectedDotSize = 8.0;
        page_control.dotSpacing = 15.0
        page_control.dotSize = 5.0


    }
    func SetFrameUpwards(view:UIView)
    {
        view.frame.origin.y = 0-view.frame.size.height
    }
    func SetFirstviewtoorginal()
    {
        upper_wrapperview.frame.origin.y = upperActualypos
        upper_wrapperview.alpha = 1.0
      


    }
    func SetSecondviewtoorginal()
    {
        centreview.frame.origin.y = CenterActualypos
        centreview.alpha = 1.0
    }
    func SetThirdviewtoorginal()
    {
        Bottomview.frame.origin.y = bottomActualypos
        Bottomview.alpha = 1.0
    }
    override func viewWillLayoutSubviews() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Loginmobileno(_ sender: Any) {
        
        /*
        let mobVC:MobileLoginViewcontroller = self.storyboard?.instantiateViewController(withIdentifier: "MobileLoginViewcontrollerID") as! MobileLoginViewcontroller
        self.navigationController?.pushViewController(mobVC, animated: true)
 */
        

//        let inputState=UUID().uuidString
//        let viewController=accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
//        viewController.enableSendToFacebook=true
//        self.prepareLoginViewController(loginViewController: viewController)
//        self.present(viewController as! UIViewController, animated: true, completion: nil)
        
        //by ping
        let logRecord:LoginRecord = LoginRecord()
        logRecord.country_code = "CN"
        logRecord.phone_number = "18692835877"
        logRecord.verification_code = "5239177"
        //        logRecord.already_user = already_user
        
        let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailDetailViewControllerID") as! EmailDetailViewController
        emailVC.objLogRecord = logRecord
        self.navigationController?.pushViewController(emailVC, animated: true)

    }
    private func facebookLogin(countryCode:String,phonenumber:String){
        Constant.sharedinstance.fbLoginRecords.country_code = countryCode
        Constant.sharedinstance.fbLoginRecords.phone_number = phonenumber
        let fbimgURL:String = "https://graph.facebook.com/\(Constant.sharedinstance.fbLoginRecords.fb_id)/picture?type=large&return_ssl_resources=1"
        let param:[String:String] = ["fb_id":facebookRecord.fb_id,"first_name":facebookRecord.first_name,"last_name":facebookRecord.last_name,"user_image_url":fbimgURL,"email_id":facebookRecord.email_id,"signup_type":"fb","country_code":Constant.sharedinstance.fbLoginRecords.country_code,"phone_number":Constant.sharedinstance.fbLoginRecords.phone_number,"gender":facebookRecord.gender,"dob":facebookRecord.dob,"fb_token":AccessToken.current!.tokenString]
        
        self.present(self.loadingAlert!, animated: true, completion: {
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.fbPhoneSignUpUrl as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                self.fbLoginManager.logOut()
                    if ResponseDict != nil{
                    if((ResponseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        
                        if status_code == "1" {
                            
                            let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_image_url") as AnyObject)
                            
                            let email = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                            
                            let first_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "first_name") as AnyObject)
                            
                            let last_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "last_name") as AnyObject)
                            let user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                            let access_token = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "access_token") as AnyObject)
                            let fullname = "\(first_name) \(last_name)"
                            let param:[String:String] = ["access_token":access_token,"email":email,"first_name":first_name,"full_name":fullname,"last_name":last_name,"signup_type":"fb","user_id":user_id,"user_image_url":user_image_url]
                            Themes.sharedIntance.saveUserImage(userid: user_image_url)
                            Themes.sharedIntance.saveUserID(userid: user_id)
                            Themes.sharedIntance.saveaccesstoken(userid:access_token)
                            DatabaseHandler.sharedinstance.insertDataForTable(tableName: Constant.sharedinstance.User_details, dictValues: param as NSDictionary)
                            self.getAllPlansData()
                        }
                    }
                    }
            
            })
        })
    }
     func login(objRecord:LoginRecord)
    {
        isHideanimation = true
        if !(Constant.sharedinstance.isFromFBLogin) {
            if(objRecord.already_user == "true")
            {
                if !isLoggedIn {
                    isLoggedIn = true
                    self.PerformLogin(objRecord: objRecord)
                }
                
            }
            else
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailDetailViewControllerID") as! EmailDetailViewController
                    emailVC.objLogRecord = objRecord
                    self.navigationController?.pushViewController(emailVC, animated: true)
                }
               
            
            }
        }
        
        
        
    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
       /* accountKit.requestAccount {
            (account, error) -> Void in
            print(error)
            let countrycode=account?.phoneNumber?.countryCode
            let phonenumber=account?.phoneNumber?.phoneNumber
            let token=code
            print(phonenumber)
            self.verifyPhoneNumber(phonenumber: "54654564", countrycode: "545", access_token: token!)
            */
        //}
    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
       
        accountKit.requestAccount {
            (account, error) -> Void in
            print(error)
            let countrycode=account?.phoneNumber?.countryCode
            let phonenumber=account?.phoneNumber?.phoneNumber
            let token=accessToken.tokenString
            print(phonenumber)
            print(token)
            if Constant.sharedinstance.isFromFBLogin{
              self.facebookLogin(countryCode: countrycode!, phonenumber: phonenumber!)
            }else{
                
            self.verifyPhoneNumber(phonenumber: phonenumber!, countrycode: countrycode!, access_token: token)
            }
            
        }
        
        
    }
   
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        print(error)
    }
    func prepareLoginViewController(loginViewController:AKFViewController){
        loginViewController.delegate=self
        loginViewController.setAdvancedUIManager(nil)
        
        let theme=AKFTheme.default()
        theme.headerBackgroundColor=#colorLiteral(red: 0.9607843757, green: 0.9607843757, blue: 0.9607842565, alpha: 1)
        theme.headerTextColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.inputTextColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.inputBorderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
        theme.titleColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        theme.textColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.buttonTextColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        theme.buttonBorderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
        theme.buttonBackgroundColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
        theme.buttonTextColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        theme.iconColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
        theme.buttonDisabledTextColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        theme.buttonDisabledBorderColor=#colorLiteral(red: 1, green: 0.9215685725, blue: 0.9333332777, alpha: 1)
        theme.buttonDisabledBackgroundColor=#colorLiteral(red: 1, green: 0.9215685725, blue: 0.9333332777, alpha: 1)
        theme.inputBackgroundColor=#colorLiteral(red: 1, green: 0.9215685725, blue: 0.9333332777, alpha: 1)
        theme.headerButtonTextColor=#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        loginViewController.setTheme(theme)
    }
    @IBAction func loginFb(_ sender: Any) {
        isHideanimation = true
        fbLoginManager.logIn(permissions: ["email","user_birthday","user_gender","user_photos"], from: self) { (fbloginresult, error) in
            if (error == nil){
                if (fbloginresult?.grantedPermissions != nil) {
                    if(fbloginresult?.grantedPermissions.contains("email"))!
                    {
                        self.getFBUserData()
                        //self.getFBAlbumID()
                        
                    }
                }
                
            }
        }

       

    }
    
    func getFBUserData(){
        self.present(self.loadingAlert!, animated: true, completion: {
            if((AccessToken.current) != nil){
                GraphRequest(graphPath: "me", parameters: ["fields": "id, name , first_name, last_name, email,gender,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil){
                        //let value=result as! NSArray
                        //print(value)
                        let dict:NSDictionary = result as! NSDictionary
                        print(dict)
                        let myDateFormatter: DateFormatter = DateFormatter()
                        myDateFormatter.dateFormat = "MM/dd/yyyy"
                        let d=Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "birthday") as AnyObject)
                        let date=myDateFormatter.date(from: d )
                        myDateFormatter.dateFormat = "dd-MM-yyyy"
                        let objRecord:LoginRecord = LoginRecord()
                        objRecord.dob=myDateFormatter.string(from: date!)
                        objRecord.email_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "email") as AnyObject)
                        objRecord.first_name = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "first_name") as AnyObject)
                        objRecord.fb_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "id") as AnyObject)
                        objRecord.gender = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "gender") as AnyObject)
                        if objRecord.gender == "male" {
                            objRecord.gender = "Men"
                        }else{
                            objRecord.gender = "Women"
                        }
                        objRecord.last_name = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "last_name") as AnyObject)
                        objRecord.full_name = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "name") as AnyObject)
                       /* let request:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/\(objRecord.fb_id)", parameters: nil, httpMethod: "GET")
                        request.start(completionHandler: { (connection, result, error) in
                            if(error == nil)
                            {
                                print(result!)
                            }
                            else
                            {
                                print(error?.localizedDescription as Any)
                            }
                        })
                        */
                    if !objRecord.dob.isEmpty && !objRecord.email_id.isEmpty{
                        self.facebookRecord=objRecord
                        print(self.facebookRecord.dob)
                        print(self.facebookRecord.gender)
                        self.FbRegister(objRecord: objRecord)
                        }else{
                        self.facebookRecord=objRecord
                            StaticData.fromFacebook=true
                            if objRecord.dob.isEmpty && objRecord.email_id.isEmpty{
                                StaticData.facebookIsDob=true
                                self.loadingAlert?.dismiss(animated: true, completion: {
                                    let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailDetailViewControllerID") as! EmailDetailViewController
                                    emailVC.objLogRecord = objRecord
                                    self.navigationController?.pushViewController(emailVC, animated: true)
                                })
                                
                                
                            }else if objRecord.email_id.isEmpty{
                                self.loadingAlert!.dismiss(animated: true, completion: {
                                    let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailDetailViewControllerID") as! EmailDetailViewController
                                    emailVC.objLogRecord = objRecord
                                    self.navigationController?.pushViewController(emailVC, animated: true)
                                })
                                
                            }else{
                                self.loadingAlert!.dismiss(animated: true, completion: {
                                    let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
                                    profVC.profType = .birthday
                                    profVC.objLogRecord = objRecord
                                    self.navigationController?.pushViewController(profVC, animated: true)
                                })
                                
                            }
                        }
                    
                        print(result as Any )
                    }
                    else
                    {
                       
                    }
                })
            }
        })
        
        

        
    }
    
    @IBAction func fbinfo(_ sender: Any) {
        
        let fbVC = self.storyboard!.instantiateViewController(withIdentifier: "FBAssuranceViewControllerSID") as! FBAssuranceViewController
        isHideanimation = true
        fbVC.delegate = self
        self.navigationController?.present(fbVC, animated:true, completion: nil)
        
    }
    
    func loginType(type: String) {
        print(type)
        if type == "Facebook" {
            loginFb("")
        }
        else {
            Loginmobileno("")
        }
    }
    private func getData(){
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.user_data as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    
                    print(responseDict)
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    print(responseDict)
                    if(status_code == "1") {
                        //Profile Data
                        
                        ConfigManager.getInstance().setData(value:StaticData.UserData! )
                        self.convertDictionary(responseDict: responseDict)
                        
                        
                    }else {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    }
                }else {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }else{
                let  err=error as? NSError
                if err?.code == 401{
                    let dit=ConfigManager.getInstance().getData()
                    if dit != nil{
                        do{
                            let responseDicts = try JSONSerialization.jsonObject(
                                
                                with: dit!,
                                
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            self.convertDictionary(responseDict: responseDicts)
                        }catch{
                            
                        }
                    }
                }
            }
        })
    }
    private func getAllPlansData(){
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.all_plans_data as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            print(responseDict)
            print(error)
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    
                    
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1") {
                        ConfigManager.getInstance().setPlans(value:StaticData.UserData!)
                        self.plansConvert(responseDict: responseDict)
                    }else {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    }
                }else {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }else{
                let  err=error as? NSError
                if err?.code == 401{
                    let dit=ConfigManager.getInstance().getPlans()
                    if dit != nil{
                        do{
                            let responseDicts = try JSONSerialization.jsonObject(
                                
                                with: dit!,
                                
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            self.plansConvert(responseDict: responseDicts)
                        }catch{
                            
                        }
                    }
                }
            }
        })
    }
    private func plansConvert(responseDict:NSDictionary?){
        let goldPlan=responseDict!["super_gold"] as! NSDictionary
        self.allUserData.goldImageDict = goldPlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.goldPlansDetails = goldPlan["plan_detail"] as! [[String:Any]]
        let plusPlan=responseDict!["super_plus"] as! NSDictionary
        self.allUserData.plusImageDict = plusPlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.plusPlansDetails = plusPlan["plan_detail"] as! [[String:Any]]
        //
        let boostPlan=responseDict!["boosts"] as! NSDictionary
        self.allUserData.boostImageDict = boostPlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.boostPlansDetail = boostPlan["plan_detail"] as! [[String:Any]]
        //
        let likePlan=responseDict!["super_like"] as! NSDictionary
        self.allUserData.superImageDict = likePlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.superPlansDetails = likePlan["plan_detail"] as! [[String:Any]]
        self.getData()
    }
    private func convertDictionary(responseDict:NSDictionary?){
        self.allUserData.jobTitle=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "job_title") as AnyObject)
        self.allUserData.college=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "college") as AnyObject)
        self.allUserData.gender=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "gender") as AnyObject)
        self.allUserData.about = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "about") as AnyObject)
        self.allUserData.distanceInvisible=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_invisible") as AnyObject)
        self.allUserData.pin=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email_otp") as AnyObject)
        StaticData.pin=self.allUserData.pin
        self.allUserData.showMyAge=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "show_my_age") as AnyObject)
        self.allUserData.kilometer=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "kilometer") as AnyObject)
        self.allUserData.remainingBoost = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "remaining_boost_count") as AnyObject)
        self.allUserData.remianingLikes = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "remaining_slikes_count") as AnyObject)
        self.allUserData.name=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "name") as AnyObject)
        self.allUserData.age=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "age") as AnyObject)
        self.allUserData.remianingLikes=Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "remaining_slikes_count") as AnyObject)
        self.allUserData.unreadCount=Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
        self.allUserData.work = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "work") as AnyObject)
        if ((responseDict?.object(forKey: "image_url") as AnyObject) as? NSArray) != nil {
            
            let imgArrayDict = (responseDict?.object(forKey: "image_url") as AnyObject) as! NSArray
            
            for imgDict:NSDictionary in imgArrayDict as! [NSDictionary] {
                
                let imgStr = Themes.sharedIntance.CheckNullvalue(Str: imgDict.object(forKey: "image") as AnyObject)
                let imgStrID = Themes.sharedIntance.CheckNullvalue(Str: imgDict.object(forKey: "image_id") as AnyObject)
                self.allUserData.imageList.append(imgStr)
                self.allUserData.imageId.append(imgStrID)
            }
        }
        //Reasons
        let unmatchReasonsArray = (responseDict?.object(forKey: "unmatch_reasons") as AnyObject) as! NSArray
        for unmatch:NSDictionary in unmatchReasonsArray as! [NSDictionary] {
            let reason:Reason=Reason()
            reason.reason_id=unmatch["reason_id"] as! Int
            reason.reason_message=unmatch["reason_message"] as! String
            self.allUserData.unmatchReasons.append(reason)
        }
        let reportReasonsArray = (responseDict?.object(forKey: "report_reasons") as AnyObject) as! NSArray
        for report:NSDictionary in reportReasonsArray as! [NSDictionary] {
            let reason:Reason=Reason()
            reason.reason_id=report["reason_id"] as! Int
            reason.reason_message=report["reason_message"] as! String
            self.allUserData.reportReasons.append(reason)
        }
        let deleteReasonsArray = (responseDict?.object(forKey: "delete_reasons") as AnyObject) as! NSArray
        for delete:NSDictionary in deleteReasonsArray as! [NSDictionary] {
            let reason:Reason=Reason()
            reason.reason_id=delete["reason_id"] as! Int
            reason.reason_message=delete["reason_message"] as! String
            self.allUserData.deleteReasons.append(reason)
        }
        // Setting Data
        let objRecord:SettingRecord = SettingRecord()
        objRecord.email=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email") as AnyObject)
        StaticData.email=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email") as AnyObject)
        StaticData.phonenumber=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_number") as AnyObject)
        StaticData.phonecode=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_code") as AnyObject)
        objRecord.phoneNumber=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_number") as AnyObject)
        objRecord.countryCode=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_code") as AnyObject)
        objRecord.community_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "community_url") as AnyObject)
        objRecord.distance_type = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_type") as AnyObject)
        objRecord.distance_unit = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_unit") as AnyObject)
        objRecord.help_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "help_url") as AnyObject)
        //                       self.objRecord.location = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "location") as AnyObject)
        if Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "location") as AnyObject).count > 0 {
            objRecord.locationDictArray = responseDict?.object(forKey: "location") as! [[String:Any]]
        }
        objRecord.max_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "max_age") as AnyObject)
        
        objRecord.max_distance = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "max_distance") as AnyObject)
        objRecord.minimum_distance = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "minimum_distance") as AnyObject)
        objRecord.maximum_distance = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "maximum_distance") as AnyObject)
        objRecord.plan_type = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "plan_type") as AnyObject)
        objRecord.message_likes = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "message_likes") as AnyObject)
        objRecord.min_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "min_age") as AnyObject)
        objRecord.minimum_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "minimum_age") as AnyObject)
        objRecord.maximum_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "maximum_age") as AnyObject)
        objRecord.new_match = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "new_match") as AnyObject)
        objRecord.privacy_policy_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "privacy_policy_url") as AnyObject)
        objRecord.profile_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "profile_url") as AnyObject)
        objRecord.receiving_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "receiving_message") as AnyObject)
        objRecord.safety_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "safety_url") as AnyObject)
        objRecord.show_me = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "show_me") as AnyObject)
        objRecord.gender = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "matching_profile") as AnyObject)
        if objRecord.gender == "Both" {
            objRecord.gender = "Men and Women"
        }
        objRecord.super_likes = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "super_likes") as AnyObject)
        objRecord.verifyEmail=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email_verify") as AnyObject)
        objRecord.terms_of_service_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "terms_of_service_url") as AnyObject)
        objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "user_id") as AnyObject)
        objRecord.username = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "username") as AnyObject)
        objRecord.username = objRecord.username.removingWhitespaces()
        objRecord.city=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "city") as AnyObject)
        
        // Get Chat History
        let unread_count = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
        Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
        self.allUserData.setting=objRecord
        let conversation_not_started_array:NSArray =  responseDict?.object(forKey: "conversation_not_started_array") as! NSArray
        
        if(conversation_not_started_array.count > 0)
        {
            for i in 0..<conversation_not_started_array.count
            {
                let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                let objRecords:matchProfileRecord = matchProfileRecord()
                objRecords.isgoldLike = false
                
                objRecords.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                objRecords.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                objRecords.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                
                objRecords.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                objRecords.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                objRecords.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                
                objRecords.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                
                objRecords.age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "age") as AnyObject)
                objRecords.college = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "college") as AnyObject)
                objRecords.distance_type = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "distance_type") as AnyObject)
                objRecords.kilometer = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "kilometer") as AnyObject)
                objRecords.work = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "work") as AnyObject)
                
                let arrDict=ResponseDict["all_images"] as! [String]
                for var arr in arrDict{
                    objRecords.all_images.append(arr as! String)
                }
                
                objRecords.plan_type = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "plan_type") as AnyObject)
                
                self.allUserData.conservationNotStarteds.append(objRecords)
                
            }
        }
        //                    self.CollectionView.reloadData()
        
        
        
        let conversation_started_array:NSArray =  responseDict?.object(forKey: "conversation_started_array") as! NSArray
        
        if(conversation_started_array.count > 0)
        {
            print(conversation_started_array)
            for i in 0..<conversation_started_array.count
            {
                let ResponseDict:NSDictionary = conversation_started_array[i] as! NSDictionary
                let objRecords:matchProfileRecord = matchProfileRecord()
                objRecords.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                objRecords.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                objRecords.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                
                objRecords.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                objRecords.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                objRecords.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                objRecords.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                objRecords.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                objRecords.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                self.allUserData.conservationStarteds.append(objRecords)
                
            }
            
        }
        DispatchQueue.main.async {
            self.revealingSplashView.startAnimation(){
                
                StaticData.allUserData=self.allUserData
                
                (UIApplication.shared.delegate as! AppDelegate).MovetoRoot(status: "home")
            }
        }
        
    }

}
extension String {
//    func nsRange(from range: Range<Index>) -> NSRange {
//        let lower = UTF16View.Index(range.lowerBound, within: utf16)
//        let upper = UTF16View.Index(range.upperBound, within: utf16)
//        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower!.distance(to: upper))
//    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange? {
        let utf16view = self.utf16
        if let from = range.lowerBound.samePosition(in: utf16view), let to = range.upperBound.samePosition(in: utf16view) {
            return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        }
        return nil
    }

}


