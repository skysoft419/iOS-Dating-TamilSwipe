//
//  HomeViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import Pulsator
import Koloda
import pop
import CoreLocation
import UserNotifications
import SDWebImage
import FirebaseMessaging
import PopBounceButton
import ReachabilitySwift
import MIAlertController
private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

enum Click:String {
    
    case like = "Like", dislike = "Dislike", superlike = "Superlike"
    
}

class HomeViewController: UIViewController,YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource,CLLocationManagerDelegate,User_DetailViewControllerDelegate,MatchViewControllerDelegate, ShowPlusFromBoostDelegate,CallBack  {
    func clicked() {
        reportUsers()
    }
    private func reportUsers(){
        self.report=1
        let conservationController=AppStoryboard.Extra.viewController(viewControllerClass: ReportTableViewController.self)
        conservationController.user_id=user_id!
        conservationController.user_image=self.user_img!
        self.navigationController?.pushViewController(conservationController, animated: true)
    }
    var report=0
    var user_id:String?
    var user_img:String?
    @IBOutlet weak var group_view: UIView!
    @IBOutlet weak var cardWholeView: UIView!
    @IBOutlet var buttonWrapperView: UIView!
    @IBOutlet weak var card_view: UIView!
    private var isNewRequest:Bool=false
    private var isFirstImageUpload=true
    public var onChangeIconCallback:OnChangeIcon?
    var actualArr:NSMutableArray = NSMutableArray()
    private let reachability = Reachability()!
    let yourAttributes : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
        NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.8946250081, green: 0.3806622028, blue: 0.3167798817, alpha: 1),
        NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue]
    let yourAttributess : [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14),
        NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)]

    @IBOutlet weak var rewind_Btn: UIButton!
    let pulsator = Pulsator()
    var container:YSLDraggableCardContainer = YSLDraggableCardContainer()
    //@IBOutlet weak var skip_Btn: PopBounceButton!
    @IBOutlet weak var like_Btn: PopBounceButton!
    @IBOutlet weak var dislike_Btn: PopBounceButton!
    @IBOutlet weak var profile_img: SpringImageView!
    @IBOutlet weak var super_like: PopBounceButton!
 
    @IBOutlet weak var user_image: UIImageView!
    @IBOutlet weak var noUsersLabel: UILabel!
    let views=Bundle.main.loadNibNamed("LocationEnableView", owner: self, options: nil)![0] as! EnableLocationView

     let discoveryView=Bundle.main.loadNibNamed("CustomDiscoveryView", owner: self, options: nil)![0] as! EnableDiscoveryView
    
    var Datasource:NSMutableArray = NSMutableArray()
    var isfromfacebook:Bool = Bool()
    var locationManager: CLLocationManager!
    var latitude:String = String()
    var longitude:String = String()
    var buttonClicked:String?
    var defaultBottomViewFrame = CGRect()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var lastSwipedRecord = UserRecord()
    var lastSwipeStatus = String()
    var usedSubscriptionID = String()
    var superLikeCount = Int()
    private var isMakeCall:Bool=true
    private var isFirstCall=true
    private var statusInternet:String?
    private var userRecordInternet:UserRecord?
    private var isFirstLocation=true
    private var isFirstTime=true
    private var isAlready=false
    private var isFirstCallChat=false
    private var isDoneClicked=false
    private var message = NSMutableAttributedString()
    public var callbackss:CallbackObj?
    private var firstLayout=false
    private var oldArray=NSMutableArray()
    override func viewWillAppear(_ animated: Bool)
    {
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.isNavigationBarHidden = true
        isFirstCall=true
        isMakeCall=true
        isAlready=false
        requestLocation()
        
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if firstLayout == false{
            firstLayout=true
            SetLayout()
        }
        if report == 1{
            self.report=0
            if StaticData.reportedUser == 1{
                StaticData.reportedUser=0
                StaticData.fromHome=0
                self.reportedUser()
            }
        }
        if StaticData.allUserData!.setting!.show_me == "yes"{
            self.cardWholeView.isHidden=false
            self.views.isHidden=true
            self.discoveryView.isHidden=true
            self.profile_img.isHidden=false
        }else{
            self.cardWholeView.isHidden=true
            self.views.isHidden=true
            self.discoveryView.isHidden=false
        }
        if actualArr.count  == 0{
            ShowPulse()
        }
        profile_img.image=nil
            profile_img.contentMode = .scaleAspectFill
            profile_img.sd_setImage(with: URL(string:StaticData.allUserData!.imageList[0]),placeholderImage: #imageLiteral(resourceName: "logo") ,completed: { (image, error, cache, url) in
                let size=image?.size
                if error != nil {
                    self.profile_img.image = #imageLiteral(resourceName: "logo")
                }
            })
        
    }
    
    @objc func clickOpenSettings(){
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString + Bundle.main.bundleIdentifier!) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings)
            }
        }
    }
    @objc func showSetting(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let VC1 = storyboard.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController
        let navController = UINavigationController(rootViewController: VC1)
        //        navController.navigationBar.isHidden = false
        navController.navigationItem.title = "Settings"
        self.present(navController, animated:true, completion: nil)
    }
    @objc func appCameToForeground() {
        if StaticData.isHomeController{
        isFirstCall=true
        isAlready=false
        if Datasource.count == 0{
            ShowPulse()
            GetHomeData()
        }
        requestLocation()
        }
    }
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        StaticData.pageNumber = -2
        callbackss?.onClick()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        whiteBorderToProfileImage()
        StaticData.isHomeController=true
        self.container.backgroundColor = .clear
        let attributeString = NSMutableAttributedString(string: "'Search Criteria'",
                                                        attributes: yourAttributes)
        let attributeStrings = NSMutableAttributedString(string: "Expand your  ",
                                                         attributes: yourAttributess)
        let attributeStringss = NSMutableAttributedString(string: "  to see more people.",
                                                          attributes: yourAttributess)
        if StaticData.allUserData!.remianingLikes! > 0{
            self.super_like.setImage(#imageLiteral(resourceName: "superlike"), for: .normal)
            self.super_like.isUserInteractionEnabled=true
        }else{
            self.super_like.setImage(#imageLiteral(resourceName: "superlike_inactive"), for: .normal)
            self.super_like.isUserInteractionEnabled=false
        }
        message.append(attributeStrings)
        message.append(attributeString)
        message.append(attributeStringss)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        noUsersLabel.isUserInteractionEnabled = true
        noUsersLabel.addGestureRecognizer(tap)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        self.discoveryView.enableDiscoveryButton.layer.borderColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
        self.discoveryView.enableDiscoveryButton.layer.borderWidth=1
        self.discoveryView.enableDiscoveryButton.layer.cornerRadius=self.discoveryView.enableDiscoveryButton.frame.size.height/2
        self.views.settingButton.layer.borderColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
        self.views.settingButton.layer.borderWidth=1
        self.views.settingButton.addTarget(self, action: #selector(self.clickOpenSettings), for: .touchUpInside)
        self.discoveryView.enableDiscoveryButton.addTarget(self, action: #selector(self.showSetting), for: .touchUpInside)
        self.views.settingButton.layer.cornerRadius=self.views.settingButton.frame.size.height/2
        self.views.frame=self.view.frame
        self.discoveryView.frame=self.view.frame
        self.view.addSubview(views)
        self.view.addSubview(discoveryView)
        self.views.isHidden=true
        self.discoveryView.isHidden=true
        // Do any additional setup after loading the view.
        profile_img.layer.cornerRadius=user_image.frame.size.height/2
        profile_img.clipsToBounds=true
        Messaging.messaging().fcmToken
        // print(Messaging.messaging().fcmToken)
        noUsersLabel.isHidden = true
        self.ShowPulse()
        profile_img.isHidden = true
        defaultBottomViewFrame = buttonWrapperView.frame
        
        
        
        
        like_Btn.addTarget(self, action: #selector(self.DidClickLike(sender:)), for: .touchUpInside)
        dislike_Btn.addTarget(self, action: #selector(self.DidclickDislike(sender:)), for: .touchUpInside)
        group_view.isHidden = true
        cardWholeView.isHidden = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.doneClicked), name:NSNotification.Name(rawValue: "k_DonePressed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.GetIndex(not:)), name:Constant.sharedinstance.ChangeIndex, object: nil)
        cardWholeView.isHidden = false
        group_view.isHidden = true
        let userDetail_arr:NSArray = DatabaseHandler.sharedinstance.fetchTableAllData(tableName: Constant.sharedinstance.User_details)
        var imageUrl:String?
        if(userDetail_arr.count > 0)
        {
            print(userDetail_arr)
            for i in 0..<userDetail_arr.count                {
                let manaObj:NSManagedObject = userDetail_arr[i] as! NSManagedObject
                user_image.sd_setImage(with: URL(string:(manaObj.value(forKey: "user_image_url") as! String)), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
                imageUrl=manaObj.value(forKey: "user_image_url") as! String
                // profile_img.sd_setImage(with: URL(string:(manaObj.value(forKey: "user_image_url") as! String)), placeholderImage: #imageLiteral(resourceName: "logo"))
            }
            
        }
        
        //profile_img.sd_setImage(with: URL(string:Themes.sharedIntance.getUserImage()!), placeholderImage: #imageLiteral(resourceName: "logo"))
        
        //        skip_Btn.isUserInteractionEnabled = false
        like_Btn.isUserInteractionEnabled = false
        dislike_Btn.isUserInteractionEnabled = false
        super_like.isUserInteractionEnabled = false
        //rewind_Btn.isUserInteractionEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.Getpermission()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateToChat(notification:)), name: Notification.Name("NavigateToChat"), object: nil)
        
        
        updateDeviceID()
    }
    private func whiteBorderToProfileImage(){
        profile_img.layer.borderColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        profile_img.layer.borderWidth=3
    }
    private func updateButtons(){
        if StaticData.allUserData!.remianingLikes! > 0{
            self.super_like.setImage(#imageLiteral(resourceName: "superlike"), for: .normal)
            self.super_like.isUserInteractionEnabled=true
        }else{
            self.super_like.setImage(#imageLiteral(resourceName: "superlike_inactive"), for: .normal)
            self.super_like.isUserInteractionEnabled=false
        }
    }
    private func requestLocation(){
        //noUsersLabel.isHidden = true
        if !(UIDevice.modelName == "iPhone X") && !(UIDevice.modelName == "Simulator iPhone X"){
            buttonWrapperView.frame.size.height = defaultBottomViewFrame.size.height
        }
        //self.ShowPulse()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted:
                print("No access")
                break
            case .authorizedAlways, .authorizedWhenInUse:
                if(self.actualArr.count == 0 ) {
                    like_Btn.isUserInteractionEnabled = false
                    dislike_Btn.isUserInteractionEnabled = false
                    super_like.isUserInteractionEnabled = false
                    // rewind_Btn.isUserInteractionEnabled = false
                    // self.rewind_Btn.setImage(UIImage(named:"rewindDeselected.png"), for: .normal)
                    self.dislike_Btn.setImage(#imageLiteral(resourceName: "dislike_inactive"), for: .normal)
                    self.like_Btn.setImage(#imageLiteral(resourceName: "like_inactive"), for: .normal)
                    self.super_like.setImage(#imageLiteral(resourceName: "superlike_inactive"), for: .normal)
                    if locationManager == nil{
                        self.locationManager = CLLocationManager()
                        self.locationManager.delegate = self
                        self.locationManager.requestWhenInUseAuthorization()
                        self.locationManager.startUpdatingLocation()
                    }
                }
                DispatchQueue.main.async {
                    if StaticData.allUserData!.setting!.show_me == "yes"{
                        self.views.isHidden=true
                        self.cardWholeView.isHidden=false
                        self.discoveryView.isHidden=true
                        
                    }else{
                        self.views.isHidden=true
                        self.cardWholeView.isHidden=true
                        self.discoveryView.isHidden=false
                        
                    }
                }
                break
            case .denied:
                DispatchQueue.main.async {
                    self.views.isHidden=false
                    self.discoveryView.isHidden=true
                    self.cardWholeView.isHidden=true
                    
                }
                break
            }
        }else{
            DispatchQueue.main.async {
                
                self.views.isHidden=false
                self.cardWholeView.isHidden=true
                self.discoveryView.isHidden=true
                
                
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @objc func reloadCards() {
        self.Datasource = NSMutableArray()
        self.actualArr = NSMutableArray()
        ReloadContainer()
    }
    @objc func  doneClicked(){
        noUsersLabel.isHidden=true
        isDoneClicked=true
        isMakeCall=true
        self.Datasource = NSMutableArray()
        self.actualArr = NSMutableArray()
        GetHomeData()
    }
    
    @objc func navigateToChat(notification: Notification) {
        
        //        let dict = convertToDictionary(text: diction.description)
        
        print(notification)
        
        let masterDict:NSDictionary = notification.object as! NSDictionary
        
        if let dict = masterDict["chat_status"] as? NSDictionary {
            
            let objRecord:matchProfileRecord = matchProfileRecord()
            objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "like_status") as AnyObject)
            objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "read_status") as AnyObject)
            objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "status_message") as AnyObject)
            
            objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "sender_id") as AnyObject)
            objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "sender_image_url") as AnyObject)
            objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "match_id") as AnyObject)
            objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "sender_name") as AnyObject)
            
            //        let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "NewChatViewControllerID") as! NewChatViewController
            //        chatVC.userRecord =  objRecord
            //        self.navigationController?.pushViewController(chatVC, animated: true)
            
            
        }
        else if let dict = masterDict["match_status"] as? NSDictionary {
            
            print(dict)
            
            // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ScrollToMatchPage"), object: nil)
            
        }
        
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = (manager.location?.coordinate)!
        if(locValue.latitude != 0.0 && locValue.latitude != 0.0)
        {
            latitude = "\(locValue.latitude)"
            longitude = "\(locValue.longitude)"
            print(StaticData.pageNumber)
            SharedVariables.sharedInstance.currentCoordinates = locValue
            if  self.isMakeCall==true  && StaticData.pageNumber == 1 && self.isDoneClicked == false{
                if self.reachability.currentReachabilityStatus != .notReachable
                {
                    self.isMakeCall=false
                    self.isFirstCall=false
                    self.isAlready=true
                    self.UpdateLocation()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 60.0) {
                        self.isMakeCall=true
                    }
                }else{
                    self.ShowPulse()
                    self.noUsersLabel.isHidden = false
                    self.noUsersLabel.text="Please check your internet"
                }
                
            }
            
        }
    }
    
    func UpdateLocation()
    {
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"latitude":latitude,"longitude":longitude, "type":"update"]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.updatelocation as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            if ResponseDict != nil{
                if((ResponseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1")
                    {
                        self.GetHomeData()
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
    
    
    func updateDeviceID()
    {
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"device_type":"1","device_id":Themes.sharedIntance.getDeviceID()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.update_device as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            if ResponseDict != nil{
                if ResponseDict != nil{
                    if((ResponseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1")
                        {
                            //self.GetHomeData()
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
            }else{
                let err=error as? NSError
                if err?.code == 401{
                    self.ShowPulse()
                    self.noUsersLabel.isHidden = false
                    self.noUsersLabel.text="Please check your internet"
                }
            }
        })
    }
    
    func GetHomeData()
    {
        if StaticData.allUserData!.setting!.show_me == "yes"{
            guard latitude.count > 0 && longitude.count > 0 else {
                return
            }
            oldArray=NSMutableArray()
            oldArray=Datasource
            StaticData.latitude=latitude
            StaticData.langitude=longitude
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"latitude":latitude,"longitude":longitude]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.matching_profiles as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                if responseDict != nil{
                    if((responseDict?.count)! > 0)
                    {
                    
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1")
                        {
                            
                           let unreadCount=Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
                            if unreadCount != nil{
                                Themes.sharedIntance.saveUnreadCount(unread_count: unreadCount)
                                self.onChangeIconCallback!.onChangeIcon()
                            }
                            StaticData.allUserData!.setting?.city=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "city") as AnyObject)
                            let city=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "city") as AnyObject)
                            let matching_profile:NSArray = responseDict?.object(forKey: "matching_profile") as! NSArray
                            print(matching_profile)
                            SharedVariables.sharedInstance.likesCount = responseDict?.object(forKey: "remaining_likes_count") as! Int
                            SharedVariables.sharedInstance.superLikesCount = responseDict?.object(forKey: "remaining_slikes_count") as! Int
                            SharedVariables.sharedInstance.boostCount = responseDict?.object(forKey: "remaining_boost_count") as! Int
                            if responseDict?.object(forKey: "is_likes_limited") as! String == "Yes" {
                                SharedVariables.sharedInstance.isLikeLimited = true
                            }
                            else {
                                SharedVariables.sharedInstance.isLikeLimited = false
                            }
                            if(matching_profile.count > 0) {
                                self.Datasource = NSMutableArray()
                                self.actualArr = NSMutableArray()
                                
                                for i in 0..<matching_profile.count {
                                    
                                    let dict:NSDictionary = matching_profile[i] as! NSDictionary
                                    let userrecord:UserRecord = UserRecord()
                                    userrecord.age = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "age") as AnyObject)
                                    userrecord.college = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "college") as AnyObject)
                                    userrecord.images = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "images") as AnyObject)
                                    userrecord.distance_Type = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "distance_type") as AnyObject)
                                    userrecord.kilometer = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "kilometer") as AnyObject)
                                    userrecord.name = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "name") as AnyObject)
                                    userrecord.work = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "work") as AnyObject)
                                    userrecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "user_id") as AnyObject)
                                    SharedVariables.sharedInstance.planType = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "plan_type") as AnyObject)
                                    
                                    let arrDict=dict["all_images"] as! [String]
                                    for var arr in arrDict{
                                        userrecord.imagesArray.append(arr as! String)
                                    }
                                    self.Datasource.add(userrecord)
                                    self.actualArr.add(userrecord)
                                }
                                
                                //self.skip_Btn.isUserInteractionEnabled = true
                                self.like_Btn.isUserInteractionEnabled = true
                                self.dislike_Btn.isUserInteractionEnabled = true
                                self.super_like.isUserInteractionEnabled = true
                                
                                self.dislike_Btn.setImage(#imageLiteral(resourceName: "dislike"), for: .normal)
                                self.like_Btn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                                self.super_like.setImage(#imageLiteral(resourceName: "superlike"), for: .normal)
                                if self.Datasource.count != self.oldArray.count{
                                self.oldArray=self.Datasource
                                self.ReloadContainer()
                                }
                                
                                let unread_count = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
                                Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
                                self.isAlready=false
                                self.isDoneClicked=false
                                self.updateButtons()
                            }
                            else {
                                self.isAlready=false
                                self.ShowPulse()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                    self.noUsersLabel.attributedText=self.message
                                    self.noUsersLabel.isHidden = false
                                }
                                
                                self.isDoneClicked=false
                            }
                        }
                        else
                        {
                            self.isAlready=false
                            self.isDoneClicked=false
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        }
                        
                    }
                    else
                    {
                        self.isAlready=false
                        self.isDoneClicked=false
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                        
                    }
                }else{
                    let err=error as? NSError
                    if err?.code == 401{
                        self.ShowPulse()
                        self.isAlready=false
                        self.isDoneClicked=false
                        self.noUsersLabel.isHidden = false
                        self.noUsersLabel.text="Please check your internet"
                    }
                }
                
            })
        }
    }
    
    func addSuperLikeUser(matchRecord: matchProfileRecord){
        if let lastRecord : UserRecord = self.Datasource.lastObject as? UserRecord, matchRecord.user_id == lastRecord.user_id{
            return;
        }
        
        let userrecord:UserRecord = UserRecord()
        userrecord.age = matchRecord.age
        userrecord.college = matchRecord.college
        userrecord.distance_Type = matchRecord.distance_type
        userrecord.kilometer = matchRecord.kilometer
        userrecord.name = matchRecord.user_name
        userrecord.work = matchRecord.work
        userrecord.user_id = matchRecord.user_id
        SharedVariables.sharedInstance.planType = matchRecord.plan_type
        let arrDict = matchRecord.all_images as! [String]
        
        for var arr in arrDict{
            userrecord.imagesArray.append(arr as! String)
        }
        self.Datasource.add(userrecord)
        self.actualArr.add(userrecord)
    
    
        //self.skip_Btn.isUserInteractionEnabled = true
        self.like_Btn.isUserInteractionEnabled = true
        self.dislike_Btn.isUserInteractionEnabled = true
        self.super_like.isUserInteractionEnabled = true
        
        self.dislike_Btn.setImage(#imageLiteral(resourceName: "dislike"), for: .normal)
        self.like_Btn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        self.super_like.setImage(#imageLiteral(resourceName: "superlike"), for: .normal)
        
        self.ReloadContainer()
        
        Themes.sharedIntance.saveUnreadCount(unread_count: Themes.sharedIntance.getUnreadCount()! + 1)
        self.isAlready=false
        self.isDoneClicked=false
        self.updateButtons()
    }
    
    func Getpermission()
    {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted:
                print("No access")
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
                break
            case .authorizedAlways, .authorizedWhenInUse:
                if StaticData.allUserData!.setting!.show_me == "yes"{
                    self.views.isHidden=true
                    self.cardWholeView.isHidden=false
                    self.discoveryView.isHidden=true
                    
                }else{
                    self.views.isHidden=true
                    self.cardWholeView.isHidden=true
                    self.discoveryView.isHidden=false
                    
                }
                
                break
            case .denied:
                self.views.isHidden=false
                self.discoveryView.isHidden=true
                self.cardWholeView.isHidden=true
                
                break
            }
        }
        else {
            DispatchQueue.main.async {
                
                self.views.isHidden=false
                self.cardWholeView.isHidden=true
                self.discoveryView.isHidden=true
                
                
            }
            
        }
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            
            switch setttings.soundSetting{
            case .enabled:
                print("enabled sound setting")
            case .disabled:
                print("setting has been disabled")
                
            case .notSupported:
                print("something vital went wrong here")
                if(self.appDel.isNotificationPer)
                {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let notificationVC = storyboard.instantiateViewController(withIdentifier: "NotificationViewControllerID") as! NotificationViewController
                    self.present(notificationVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if StaticData.allUserData!.setting!.show_me == "yes"{
                self.views.isHidden=true
                self.cardWholeView.isHidden=false
                
                self.discoveryView.isHidden=true
            }
            
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                    if(self.locationManager == nil) {
                        
                        self.locationManager = CLLocationManager()
                        self.locationManager.delegate = self
                    }
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                }
            }
        }
        else if(status == .denied) {
            
            self.views.isHidden=false
            self.cardWholeView.isHidden=true
            
        }
        
    }
    
    @objc func GetIndex(not:Notification) {
        
        let index:Int = not.object as! Int
        if(index == 0) {
            
            cardWholeView.isHidden = false
            group_view.isHidden = true
        }
        if(index == 1) {
            
            cardWholeView.isHidden = true
            group_view.isHidden = false
        }
    }
    
    //MARK:- Button Actions
    
    @IBAction func DidclickDislike(sender: UIButton) {
        if StaticData.isFirstTime{
            ConfigManager.getInstance().setFirstLike(value: "NO")
            StaticData.isFirstTime=false
        let alertController = MIAlertController(
            title: "Oh ello!",
            message: "Swipe left to Pass \u{2639}                             "
        )
        
        alertController.addButton(
            MIAlertController.Button(title: "Cancel", type: .destructive, action: {
            }))
        
        
        alertController.addButton(
            MIAlertController.Button(title: "PASS", type: .destructive, action: {
                let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
                view_?.nope_Btn.alpha = 1
                self.container.movePosition(with: .left, draggableView:view_, isAutomatic: true)
                
                let objuserrecord:UserRecord = self.Datasource[view_!.info_Btn!.tag] as! UserRecord
                self.Swipe(status: "nope", objuserrecord: objuserrecord)
                
                self.buttonClicked = Click.dislike.rawValue
            }))
            alertController.presentOn(self)
        }else{
                let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
                view_?.nope_Btn.alpha = 1
                self.container.movePosition(with: .left, draggableView:view_, isAutomatic: true)
                
                let objuserrecord:UserRecord = Datasource[view_!.info_Btn!.tag] as! UserRecord
                self.Swipe(status: "nope", objuserrecord: objuserrecord)
                
                buttonClicked = Click.dislike.rawValue
        }
        

 
    }
    
    @IBAction func DidClickLike(sender: UIButton) {
     /*
        if SharedVariables.sharedInstance.likesCount <= 0 && SharedVariables.sharedInstance.planType.count == 0 {
            
//            let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
//            destController.modalTransitionStyle = .crossDissolve
//            destController.isBoost = false
//            destController.plusDelegate = self
//            if (SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus") {
//                destController.isPurchased = true
//            }
//            self.navigationController?.present(destController, animated: true, completion: nil)
            
            let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isGold = false
            self.navigationController?.present(destController, animated: true, completion: nil)
        }*/
       // else {
        if StaticData.isFirstTime{
            ConfigManager.getInstance().setFirstLike(value: "NO")
            StaticData.isFirstTime=false
            let alertController = MIAlertController(
                title: "Oh ello!",
                message: "Swipe right to Keep!                           "
            )
            
            alertController.addButton(
                MIAlertController.Button(title: "Cancel", type: .destructive, action: {
                }))
            
            
            alertController.addButton(
                MIAlertController.Button(title: "KEEP", type: .destructive, action: {
                    let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
                    view_?.like_Btn.alpha = 1
                    self.container.movePosition(with: .right, draggableView:view_, isAutomatic: true)
                    let index=view_!.info_Btn.tag
                    let objuserrecord:UserRecord = self.Datasource[view_!.info_Btn!.tag] as! UserRecord
                    self.Swipe(status: "like", objuserrecord: objuserrecord)
                    self.buttonClicked = Click.like.rawValue
                }))
            alertController.presentOn(self)
        }else{
            let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
            view_?.like_Btn.alpha = 1
            self.container.movePosition(with: .right, draggableView:view_, isAutomatic: true)
            let index=view_!.info_Btn.tag
            let objuserrecord:UserRecord = Datasource[view_!.info_Btn!.tag] as! UserRecord
            self.Swipe(status: "like", objuserrecord: objuserrecord)
            buttonClicked = Click.like.rawValue
        }
      //  }

    }
    
    @IBAction func Didclickrewind(_ sender: Any) {
//         self.ShowBanner()
        if SharedVariables.sharedInstance.planType.count > 0 && (SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus") {
            
            self.Swipe(status: "rewind", objuserrecord: lastSwipedRecord)
            buttonClicked = nil
        }
        else {
            
            let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isGold = false
            self.navigationController?.present(destController, animated: true, completion: nil)
        }
        
    }
    func reportedUser(){
            let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
            view_?.reportedButton.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.container.movePosition(with: .up, draggableView:view_, isAutomatic: true)
            let objuserrecord:UserRecord = self.Datasource[view_!.info_Btn!.tag] as! UserRecord
            self.Swipe(status: "nope", objuserrecord: objuserrecord)
            self.buttonClicked = Click.dislike.rawValue
        }
        
    }
    @IBAction func DidclickSuper_Like(_ sender: Any) {
     /*
        if SharedVariables.sharedInstance.superLikesCount <= 0 {
            
            let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isBoost = false
            destController.plusDelegate = self
            if (SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus") {
                destController.isPurchased = true
            }
            self.navigationController?.present(destController, animated: true, completion: nil)
        }*/
      //  else {
        if StaticData.isFirstTime{
            StaticData.isFirstTime=false
            ConfigManager.getInstance().setFirstLike(value: "NO")
            let alertController = MIAlertController(
                title: "Oh ello",
                message: "Swipe up to Favourite \u{1F609}                                  "
            )
            
            alertController.addButton(
                MIAlertController.Button(title: "Cancel", type: .destructive, action: {
                }))
            
            
            alertController.addButton(
                MIAlertController.Button(title: "FAVOURITE", type: .destructive, action: {
                    
                    let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
                    view_?.superLike_Btn.alpha = 1
                    self.container.movePosition(with: .up, draggableView:view_, isAutomatic: true)
                    let objuserrecord:UserRecord = self.Datasource[view_!.info_Btn!.tag] as! UserRecord
                    self.Swipe(status: "super like", objuserrecord: objuserrecord)
                    self.buttonClicked = Click.superlike.rawValue
                }))
            alertController.presentOn(self)
        }else{
            let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
            view_?.superLike_Btn.alpha = 1
            self.container.movePosition(with: .up, draggableView:view_, isAutomatic: true)
            let objuserrecord:UserRecord = Datasource[view_!.info_Btn!.tag] as! UserRecord
            self.Swipe(status: "super like", objuserrecord: objuserrecord)
            buttonClicked = Click.superlike.rawValue
        }
       // }
    }
    
    
    @IBAction func didClickBoost(_ sender: Any) {
        
        if SharedVariables.sharedInstance.boostCount <= 0 {
            let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isBoost = true
            destController.plusDelegate = self
            if (SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus") {
                destController.isPurchased = true
            }
            self.navigationController?.present(destController, animated: true, completion: nil)
            return
        }
        else {
            doBoost()
//        }
//
//        if (self.planType.count > 0 && (self.planType == "Gold" || self.planType == "Plus")) || SharedVariables.sharedInstance.boostCount > 0 {
            
            
            
        }
//        else {
//            let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
//            destController.modalTransitionStyle = .crossDissolve
//            destController.isGold = false
//            self.navigationController?.present(destController, animated: true, completion: nil)
//        }
        
    }
    private func doBoost(){
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        
        
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.add_user_boost as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    
                    if(status_code == "1")
                    {
                        print(responseDict!)
                        Themes.sharedIntance.showSuccessMsg(view: self.view, withMsg: status_message)
                        SharedVariables.sharedInstance.boostCount -= 1
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
            }else{
                let err=error as? NSError
                if err?.code == 401{
                    let alert = UIAlertController(title: "Oops", message: "Please check you internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler:{action in
                        self.doBoost()
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{action in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    
    func SetLayout()
    { 
        user_image.layer.cornerRadius = user_image.frame.size.width/2
        user_image.clipsToBounds = true
        container.frame = card_view.frame
        container.backgroundColor = UIColor.clear
        container.dataSource = self;
        container.delegate = self;
        container.canDraggableDirection = YSLDraggableDirection.left.union( YSLDraggableDirection.right).union( YSLDraggableDirection.up)
        self.cardWholeView.addSubview(container)
        
        //        Themes.sharedIntance.AddBorder(view: rewind_Btn, borderColor: nil, borderWidth: nil, cornerradius: rewind_Btn.frame.size.width/2)
        //        Themes.sharedIntance.AddBorder(view: skip_Btn, borderColor: nil, borderWidth: nil, cornerradius: skip_Btn.frame.size.width/2)
        //        Themes.sharedIntance.AddBorder(view: like_Btn, borderColor: nil, borderWidth: nil, cornerradius: like_Btn.frame.size.width/2)
        //        Themes.sharedIntance.AddBorder(view: dislike_Btn, borderColor: nil, borderWidth: nil, cornerradius: dislike_Btn.frame.size.width/2)
        //        Themes.sharedIntance.AddBorder(view: super_like, borderColor: nil, borderWidth: nil, cornerradius: super_like.frame.size.width/2)
        //
        Themes.sharedIntance.AddBorder(view: profile_img, borderColor: nil, borderWidth: nil, cornerradius: profile_img.frame.size.width/2)
        
        
        profile_img.superview?.layer.insertSublayer(pulsator, below: profile_img.layer)
        pulsator.position=card_view.center
        pulsator.numPulse = 3
        pulsator.radius = 150.0
        pulsator.backgroundColor = UIColor(red: 251/255, green: 82/255, blue: 105/255, alpha: 0.8).cgColor
        pulsator.animationDuration = 5.0
        //self.container.bringSubview(toFront: self.buttonWrapperView)
        
        
    }
    func ReloadContainer() {
        
        self.profile_img.isHidden = true
        self.pulsator.stop()
        self.container.reload()
        self.container.isHidden=false
    }
    func ShowPulse() {
        
        self.container.isHidden = true
        self.profile_img.isHidden = false
        if !pulsator.isPulsating {
            pulsator.start()
        }
        profile_img.isHidden = false
        profile_img.animation = "pop"
        profile_img.animateFrom = false
        profile_img.curve = "easeIn"
        profile_img.duration = 10.0
        profile_img.animateToNext(completion: {
            
        })
        
    }
    //MARK:- YSL Datasource
    
    func cardContainerViewNextView(with index: Int) -> UIView {
        
        let view = UINib(nibName: "CustomLayout", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomOverlayView
        view.frame = CGRect(x: 0, y: 0, width: self.card_view.frame.size.width, height: self.card_view.frame.size.height)
        view.info_Btn.tag = index
        view.info_Btn.isUserInteractionEnabled=true
        view.info_Btn.addTarget(self, action: #selector(MovetoDetails(sender:)), for: .touchUpInside)
        let userRecord:UserRecord = Datasource[index] as! UserRecord
        if userRecord.age == "0" {
            view.name.text = "\(userRecord.name)"
        }
        else {
            view.name.text = "\(userRecord.name) \(userRecord.age)"
        }
        //view.user_image.sd_setImage(with: URL(string:userRecord.images), placeholderImage: #imageLiteral(resourceName: "ello- grey"))
        view.name.tag = index
        view.name.font=view.name.font.withSize(34)
        view.name.frame.origin.y=view.name.frame.origin.y-8
        view.name.sizeToFit()
        var distanceType:String=String()
        if userRecord.distance_Type != "" {
            view.locImageButton.isHidden = false
            
            var distanceType = String()
            
            if userRecord.distance_Type == "mi" {
                distanceType = "Mile"
            }
            else {
                distanceType = userRecord.distance_Type
            }
            if let distance = Float(userRecord.kilometer) {
                if distance < 1 {
                    view.locationLabel.text = "Less than a kilometer away"
                }else if distance == 1{
                    view.locationLabel.text = "\(userRecord.kilometer) kilometer away"
                }
                else {
                    view.locationLabel.text = "\(userRecord.kilometer) kilometers away"
                }
            }
            //            if (objRecord.kilometer == "0.00") ||  (objRecord.kilometer == "") || (objRecord.kilometer == "0"){
            //                loc_Lbl.text = "Less than a \(distanceType) Away"
            //            }
            //            else {
            //                loc_Lbl.text = "\(objRecord.kilometer) \(distanceType) Away"
            //            }
        }
        else {
            view.locImageButton.isHidden = true
            view.locationLabel.text = ""
        }
        let tapName:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(MovetoDetails(sender:)))
        view.name.addGestureRecognizer(tapName)
        let gradient = CAGradientLayer()
        //let views=UIView()
        gradient.frame = view.collection.frame
        //gradient.frame.size.height=100
        
        gradient.colors = [UIColor.clear.cgColor, UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor]
        
        gradient.locations = [0.0, 1.0]
        gradient.frame.size.width=self.card_view.frame.size.width
        view.wrapper_View.layer.insertSublayer(gradient, at: 0)
        view.images=userRecord.imagesArray
        StaticData.cardheight=view.frame.size.height
        StaticData.cardwidth=view.frame.size.width
        view.initialiseCollectionView()
        // view.user_image.addOverlay(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        return view
    }
    
    
    
    @objc func MovetoDetails(sender:Any) {
        var selectedIndex = Int()
        if (sender as AnyObject).tag == nil {
            selectedIndex = (sender as! UITapGestureRecognizer).view!.tag
        }
        else {
            selectedIndex = (sender as AnyObject).tag
        }
        let objuserrecord:UserRecord = Datasource[selectedIndex] as! UserRecord
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"user_id":objuserrecord.user_id]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.other_profile_view as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            
            if ResponseDict != nil{
                if((ResponseDict?.count)! > 0) {
                    
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    
                    if(status_code == "1") {
                        
                        let objRecord:otherUserRecord = otherUserRecord()
                        objRecord.college = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "college") as AnyObject)
                        objRecord.age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "age") as AnyObject)
                        objRecord.images =  ResponseDict?.object(forKey: "images") as! [String]
                        objRecord.job_title = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "job_title") as AnyObject)
                        objRecord.kilometer = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "kilometer") as AnyObject)
                        objRecord.name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "name") as AnyObject)
                        objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                        objRecord.work = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "work") as AnyObject)
                        objRecord.distanceType = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "distance_type") as AnyObject)
                        objRecord.about = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "about") as AnyObject)
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        StaticData.fromHome=1
                        let profVC = storyboard.instantiateViewController(withIdentifier: "User_DetailViewController") as! User_DetailViewController
                        profVC.callback=self
                        profVC.objRecord = objRecord
                        profVC.user_id=objRecord.user_id
                        self.user_img=objRecord.images[0]
                        self.user_id=objRecord.user_id
                        profVC.delegate = self
                        self.navigationController?.present(profVC, animated: true, completion: nil)
                    }
                    else {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    }
                }
                else {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }
        })
    }
    
    func SwipeAction(Status: String) {
        let objuserrecord:UserRecord = Datasource[0] as! UserRecord
        if(Status == "nope") {
            let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
            view_?.nope_Btn.alpha = 1
            self.container.movePosition(with: .left, draggableView:view_, isAutomatic: true)
            self.Swipe(status: "nope", objuserrecord: objuserrecord)
        }
            
        else if(Status == "like") {
            let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
            view_?.like_Btn.alpha = 1
            self.container.movePosition(with: .right, draggableView:view_, isAutomatic: true)
            self.Swipe(status: "like", objuserrecord: objuserrecord)
        }
        else if(Status == "super like") {
            let view_: CustomOverlayView? = self.container.getCurrentView() as? CustomOverlayView
            view_?.superLike_Btn.alpha = 1
            self.container.movePosition(with: .up, draggableView:view_, isAutomatic: true)
            self.Swipe(status: "super like", objuserrecord: objuserrecord)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func uploadImage() {
        
        if reachability.currentReachabilityStatus != .notReachable {
            let imageData: NSData = UIImageJPEGRepresentation(StaticData.imageUpload!, 0.3)! as NSData
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.imageUpload(urlString: Constant.sharedinstance.uploadProfileImageUrl as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
                if(error == nil) {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let successMsg = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1") {
                        StaticData.imageUpload=nil
                        let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "image_url") as AnyObject)
                        ConfigManager.getInstance().setImageUpload(value: "No")
                        if user_image_url.count > 0 {
                            
                            StaticData.allUserData!.imageList.removeAll()
                            StaticData.allUserData!.imageId.removeAll()
                            let imagesDictArray = ResponseDict!["image_url"] as! [Any]
                            for imageDict in imagesDictArray {
                                StaticData.allUserData!.imageId.append("\((imageDict as! [String:Any])["image_id"]!)")
                                StaticData.allUserData!.imageList.append((imageDict as! [String:Any])["image"] as! String)
                            }
                        }
                        
                        
                    }
                    else {
                        
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: successMsg)
                    }
                }
                else {
                    let err=error as? NSError
                    if err?.code == 401{
                        let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }else{
            let alert = UIAlertController(title: "Oops", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler:{action in
                self.uploadImage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func cardContainerViewNumberOfView(in index: Int) -> Int {
        return Datasource.count
    }
    
    func cardContainerView(_ cardContainerView: YSLDraggableCardContainer, didEndDraggingAt index: Int, draggableView: UIView, draggableDirection: YSLDraggableDirection) {
        let objuserrecord:UserRecord = Datasource[index] as! UserRecord
        
        //        let objuserrecord:UserRecord = Datasource[0] as! UserRecord
        
        if draggableDirection == YSLDraggableDirection.left {
            
            cardContainerView.movePosition(with: draggableDirection, draggableView:draggableView, isAutomatic: false)
            self.Swipe(status: "nope", objuserrecord: objuserrecord)
        }
        if draggableDirection == YSLDraggableDirection.right {
            /*
             if SharedVariables.sharedInstance.likesCount <= 0 && SharedVariables.sharedInstance.planType.count == 0 {
             cardContainerView.movePosition(with: draggableDirection, isAutomatic: false, undoHandler: {
             cardContainerView.movePosition(with: YSLDraggableDirection.init(rawValue: 0), isAutomatic: true)
             let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
             destController.modalTransitionStyle = .crossDissolve
             destController.isGold = false
             self.navigationController?.present(destController, animated: true, completion: nil)
             })
             }*/
            // else {
            cardContainerView.movePosition(with: draggableDirection, draggableView: draggableView, isAutomatic: false)
            self.Swipe(status: "like", objuserrecord: objuserrecord)
            
            // }
        }
        if draggableDirection == YSLDraggableDirection.up {
            if StaticData.allUserData!.remianingLikes! > 0{
                /*if SharedVariables.sharedInstance.superLikesCount <= 0 {
                 cardContainerView.movePosition(with: draggableDirection, isAutomatic: false, undoHandler: {
                 cardContainerView.movePosition(with: YSLDraggableDirection.init(rawValue: 0), isAutomatic: true)
                 let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
                 destController.modalTransitionStyle = .crossDissolve
                 destController.isBoost = false
                 destController.plusDelegate = self
                 if (SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus") {
                 destController.isPurchased = true
                 }
                 self.navigationController?.present(destController, animated: true, completion: nil)
                 })
                 }*/
                // else {
                
                cardContainerView.movePosition(with: draggableDirection, draggableView:draggableView, isAutomatic: false)
                self.Swipe(status: "super like", objuserrecord: objuserrecord)
            }else{
                cardContainerView.movePosition(with: draggableDirection, draggableView:draggableView, isAutomatic: false)
                self.dialog()
            }
        }
    }
    private func dialog(){
        let alertController = MIAlertController(
            title: "Oh, ello there...",
            message: "You get two favourites a day sparky. Use them wisely, meanwhile swipe that looker to the right!"
        )
        
        alertController.addButton(
            MIAlertController.Button(title: "Got it", type: .destructive, action: {
                self.navigationController?.popToRootViewController(animated: true)
                let view_: CustomOverlayView? = self.container.getPreviousView() as? CustomOverlayView
                view_?.nope_Btn.alpha = 0
                view_?.like_Btn.alpha = 0
                view_?.superLike_Btn.alpha = 0
                
                self.container.undoSwipeCardViewDirectionAnimation()
            }))
        
        alertController.presentOn(self)
    }
    override func viewDidDisappear(_ animated: Bool) {
    
    }
    func Swipe(status:String,objuserrecord:UserRecord)
    {   statusInternet=status
        userRecordInternet=objuserrecord
        
        if (status == "like") {
            SharedVariables.sharedInstance.likesCount -= 1
        }
        else if (status == "super like") {
            SharedVariables.sharedInstance.superLikesCount -= 1
            StaticData.allUserData!.remianingLikes! -= 1
            self.updateButtons()
        }
        
        if !(status == "rewind") {
            lastSwipedRecord = UserRecord()
            lastSwipedRecord = objuserrecord
            lastSwipeStatus = status
            //self.rewind_Btn.setImage(#imageLiteral(resourceName: "rewind"), for: .normal)
            //self.rewind_Btn.isUserInteractionEnabled = true
            //            self.Datasource.remove(objuserrecord)
            self.actualArr.remove(objuserrecord)
            print("Count is: \(self.Datasource.count)")
        }
        else {
            
            
            
            let view_: CustomOverlayView? = self.container.getPreviousView() as? CustomOverlayView
            view_?.nope_Btn.alpha = 0
            view_?.like_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
            
            container.undoSwipeCardViewDirectionAnimation()
            
            print("Count is: \(self.Datasource.count)")
            
            if self.container.isHidden {
                self.container.isHidden = false
            }
            
            if lastSwipeStatus == "like" {
                SharedVariables.sharedInstance.likesCount += 1
            }
            else if lastSwipeStatus == "super like" {
                SharedVariables.sharedInstance.superLikesCount += 1
            }
            
            lastSwipedRecord = UserRecord()
            lastSwipeStatus = String()
            //self.rewind_Btn.setImage(#imageLiteral(resourceName: "rewindDeselected.png"), for: .normal)
            //self.rewind_Btn.isUserInteractionEnabled = false
        }
        
        for datas in Datasource {
            print("IMAGE::::\((datas as! UserRecord).images)")
        }
        
        
        var param = [String:String]()
        
        if status == "rewind" {
            param = ["token":Themes.sharedIntance.getaccesstoken()!,"user_id":objuserrecord.user_id,"status":status, "used_subscription_id":usedSubscriptionID]
        }
        else {
            param = ["token":Themes.sharedIntance.getaccesstoken()!,"user_id":objuserrecord.user_id,"status":status]
        }
        if reachability.currentReachabilityStatus != .notReachable{
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.swipe_profiles as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                if ResponseDict != nil{
                    if((ResponseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        
                        if(status_code == "1") {
                            
                            let  objmatchProfileRecord:matchProfileRecord = matchProfileRecord()
                            objmatchProfileRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "like_status") as AnyObject)
                            objmatchProfileRecord.match_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "match_status") as AnyObject)
                            objmatchProfileRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "match_user_image_url") as AnyObject)
                            objmatchProfileRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "matched_user_id") as AnyObject)
                            objmatchProfileRecord.user_image_url = objuserrecord.images
                            objmatchProfileRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "users_like_id") as AnyObject)
                            self.usedSubscriptionID = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "used_subscription_id") as AnyObject)
                            objmatchProfileRecord.user_name = objuserrecord.name
                            if(objmatchProfileRecord.match_status == "Yes")
                            {
                                StaticData.updated=true
                                self.loadConversation(chat: ResponseDict!)
                                objmatchProfileRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "match_id") as AnyObject)
                                let viewControllerB = AppStoryboard.Extra.viewController(viewControllerClass: NewMatchViewController.self)
                                viewControllerB.objmatchProfileRecord = objmatchProfileRecord
                                viewControllerB.modalPresentationStyle = .overFullScreen
                                viewControllerB.delegate = self
                                self.present(viewControllerB, animated: true, completion: nil)
                            }
                        }
                        else {
                            //                     self.Datasource = self.actualArr
                            print(self.Datasource)
                            //                     self.container.reload()
                            //                      self.ReloadContainer()
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        }
                    }
                    else
                    {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                }else{
                    
                    let err=error as? NSError
                    if err?.code == 401{
                        let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                    
                }
            })
        }else{
            
            
            let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
            }))
            self.present(alert, animated: true, completion: nil)
            
            
        }
    }
    private func loadConversation(chat:NSDictionary){
        StaticData.allUserData!.conservationNotStarteds=[]
        StaticData.allUserData!.conservationStarteds=[]
        let conversation_not_started_array:NSArray =  chat.object(forKey: "conversation_not_started") as! NSArray
        
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
                
                StaticData.allUserData!.conservationNotStarteds.append(objRecords)
                
            }
        }
        //                    self.CollectionView.reloadData()
        
        
        
        let conversation_started_array:NSArray =  chat.object(forKey: "conversation_started") as! NSArray
        
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
                StaticData.allUserData!.conservationStarteds.append(objRecords)
                
            }
            
        }
    }
    func MovetoChat(objmatchProfileRecord:matchProfileRecord) {
        //    let newChatVC = self.storyboard?.instantiateViewController(withIdentifier: "NewChatViewControllerID") as! NewChatViewController
        //    newChatVC.userRecord =  objmatchProfileRecord
        //    self.navigationController?.pushViewController(newChatVC, animated: true)
        let newChatVC = AppStoryboard.Extra.initialViewController() as! ConservationViewController
        newChatVC.userRecord =  objmatchProfileRecord
        self.navigationController?.pushViewController(newChatVC, animated: true)
    }
    func cardContainderView(_ cardContainderView: YSLDraggableCardContainer, updatePositionWithDraggableView draggableView: UIView, draggableDirection: YSLDraggableDirection, widthRatio: CGFloat, heightRatio: CGFloat) {
        let view_: CustomOverlayView? = draggableView as? CustomOverlayView
        if draggableDirection.rawValue == 0 && (buttonClicked == nil) {
            view_?.nope_Btn.alpha = 0
            view_?.like_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
        }
        if draggableDirection == YSLDraggableDirection.left || buttonClicked == Click.dislike.rawValue {
            view_?.nope_Btn.alpha = widthRatio > 0.8 ? 0.8 : widthRatio
            view_?.like_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
        }
        if draggableDirection == YSLDraggableDirection.right || buttonClicked == Click.like.rawValue  {
            view_?.like_Btn.alpha = widthRatio > 0.8 ? 0.8 : widthRatio
            view_?.nope_Btn.alpha = 0
            view_?.superLike_Btn.alpha = 0
            
        }
        if draggableDirection == YSLDraggableDirection.up || buttonClicked == Click.superlike.rawValue {
            view_?.superLike_Btn.alpha = heightRatio > 0.8 ? 0.8 : heightRatio
            view_?.nope_Btn.alpha = 0
            view_?.like_Btn.alpha = 0
            
        }
        
        buttonClicked = nil
    }
    @IBAction func DidclickSwipeUp(_ sender: Any) {
        
        
    }
    
    func cardContainerViewDidCompleteAll(_ container: YSLDraggableCardContainer) {
        
        //    skip_Btn.isUserInteractionEnabled = false
        like_Btn.isUserInteractionEnabled = false
        dislike_Btn.isUserInteractionEnabled = false
        super_like.isUserInteractionEnabled = false
        //rewind_Btn.isUserInteractionEnabled = false
        
        self.dislike_Btn.setImage(#imageLiteral(resourceName: "dislike_inactive"), for: .normal)
        self.like_Btn.setImage(#imageLiteral(resourceName: "like_inactive"), for: .normal)
        self.super_like.setImage(#imageLiteral(resourceName: "superlike_inactive"), for: .normal)
        
        pulsator.stop()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.ShowPulse()
            self.GetHomeData()
        }
        
        
        
        //    DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
        //        self.ShowPulse()
        //
        //        if(self.locationManager == nil)
        //        {
        //            self.locationManager = CLLocationManager()
        //            self.locationManager.delegate = self
        //        }
        //        self.locationManager.startUpdatingLocation()
        //    }
        
        
    }
    func cardContainerView(_ cardContainerView: YSLDraggableCardContainer, didSelectAt index: Int, draggableView: UIView) {
        print("++ index : \(Int(index))")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func ShowBanner()
    {
        //        Themes.sharedIntance.ShowProgress(view: self.view)
        //         let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        //        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.boost_plan_slider as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
        //            Themes.sharedIntance.RemoveProgress(view: self.view)
        //
        //            if((ResponseDict?.count)! > 0)
        //            {
        //                let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
        //                let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
        //
        //                if(status_code == "1")
        //                {
        
        let appBanner = GLInAppPurchaseUI(title: "Get Tinder Gold", subTitle: "Be first in the queue", bannerBackGroundStyle: .transparentStyle)
        
        appBanner.displayContent(imageSetWithDescription:
            [
                UIImage(named:"gold_like")!:"Rewind Your Last Swipe##Go back and swipe again",
                UIImage(named:"IMG_2")!:"Rewind Your Last Swipe##Go back and swipe again",
                UIImage(named:"IMG_3")!:"Send More Super Likes##Let them know you are interested",
            ])
        appBanner.addButtonWith("BOOST ME", cancelTitle: "NO, THANKS") { (selectedTitle, isOptionSelected, selectedAction) in
            if isOptionSelected {  //Some Option have been selected
                print("Selected Price \(selectedAction.actionPrice!)")
            }
            if selectedTitle == "NO, THANKS" { //selectedButtonTitle
            }
            appBanner.dismissBanner()
        }
        
        appBanner.setBannerTheme([UIColor.white], headerTextColor: Themes.sharedIntance.ReturnGoldenColor(),isGoldBanner:false)
        appBanner.setButtomTheme([Themes.sharedIntance.ReturnGoldenColor(),UIColor(netHex:0xD4AF37)], buttonTextColor: UIColor.white)
        
        appBanner.addAction(GLInAppAction(title: "10", subTitle: "Boosts", price: "₹155.00/ea", handler: { (actin) in
            print("Completioxn handler called \(actin.actionSubTitle!) For \(actin.actionPrice!)")
        }))
        
        appBanner.addAction(GLInAppAction(title: "5", subTitle: "Boosts", price: "₹184.00/ea", handler: { (action) in
            print("Completion handler called \(action.actionSubTitle!) For \(action.actionPrice!)")
        }))
        
        appBanner.addAction(GLInAppAction(title: "1", subTitle: "Boosts", price: "₹250.00/ea", handler: { (action) in
            print("Completion handler called \(action.actionSubTitle!) For \(action.actionPrice!)")
        }))
        appBanner.addAction(GLInAppAction(title: "6", subTitle: "Boosts", price: "₹184.00/ea", handler: { (action) in
            print("Completion handler called \(action.actionSubTitle!) For \(action.actionPrice!)")
        }))
        appBanner.addAction(GLInAppAction(title: "7", subTitle: "Boosts", price: "₹250.00/ea", handler: { (action) in
            print("Completion handler called \(action.actionSubTitle!) For \(action.actionPrice!)")
        }))
        
        var animation: POPSpringAnimation? = self.pop_animation(forKey: "popAnimation") as? POPSpringAnimation
        
        appBanner.presentBanner()
        
        //                }
        //                else
        //                {
        //                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
        //                }
        //            }
        //            else
        //            {
        //                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
        //            }
        //        })
        
    }
    func showSimpleAlert(_ message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Completion Handler", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.navigationController?.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showPlusView() {
        
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isGold = false
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    //MARK:- Page menu delegate
    
    func willMoveToPage(_ controller: UIViewController, index: Int){
        if(index == 1){
            container.isHidden = false
        }else{
            container.isHidden = true
        }
    }
    
}



extension UIImageView {
    
    func addOverlay(color: UIColor) {
        
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        overlay.backgroundColor = color
        overlay.tag = 1
        
        // Check if overlay already exists before adding it
        if self.viewWithTag(1) == nil {
            self.addSubview(overlay)
        }
    }
    
}

