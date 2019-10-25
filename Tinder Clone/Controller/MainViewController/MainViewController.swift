//
//  MaintabbarControllerViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.

import UIKit
import MIAlertController
import MMLocalization
import Alamofire
import ReachabilitySwift

class MainViewController: RootBaseViewcontroller, SPSegmentControlCellStyleDelegate, SPSegmentControlDelegate,CallbackObj , ACTabScrollViewDelegate, ACTabScrollViewDataSource,OnChangeIcon{
    func onChangeIcon() {
        updateIcon()
    }
    private func updateIcon(){
        DispatchQueue.main.async {
            self.chatButton.setNeedsLayout()
            self.chatButton.layoutIfNeeded()
        }
    }
    func onClick() {
        DispatchQueue.main.async {
//            self.pageMenu?.moveToPage(0)
//            self.SelectedIndex(index: 0)
            self.changeToPage(index: 0)
            let viewcontroller=self.controllerArray[0] as! ProfileViewController
            viewcontroller.moveToSetting()
            
        }
    
    }
    
    var isfromcsc:Bool = Bool()
    var Globalindex:Int = Int()
    
    
    @IBOutlet weak var tabScrollView: ACTabScrollView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var scroll_View: UIScrollView!
    @IBOutlet weak var segmentedControl: SPSegmentedControl!

    @IBOutlet weak var prof_Btn: UIButton!
    private var isFirstImageUpload=true
    @IBOutlet weak var main_btn: UIButton!
    @IBOutlet weak var chat_Btn: UIButton!
    private var isFirst=false
    private let reachability = Reachability()!
//    var pageMenu : CAPSPageMenu?
    let gray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
    private let borderColor: UIColor = UIColor.lightGray.withAlphaComponent(0.7)
    
    private let backgroundColor: UIColor = UIColor(hue: 1, saturation: 0, brightness: 1, alpha: 0.08)
    var isFromFacebook:Bool = Bool()
    private var isLoad=false
   
    var controllerArray : [UIViewController] = []
    var contentViews: [UIView] = []
    var profButton = UIButton()
    var mainButton = UIButton()
    var chatButton = ChatBtn()
    
    @objc func appCameToForeground() {
        if StaticData.isHomeController{
        StaticData.updated=true
        loadChats()
        }
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
    
    override func viewDidLoad() {
        
        Themes.sharedIntance.chatButton = chatButton
//        var controllerArray : [UIViewController] = []
        super.viewDidLoad()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateToChat(notification:)), name: Notification.Name("NavigateToChat"), object: nil)
//        scroll_View.delegate = self

//        let ctr1 = AppStoryboard.Extra.viewController(viewControllerClass: ProfileViewController.self)
//        let ctr2 = AppStoryboard.Extra.viewController(viewControllerClass: HomeViewController.self)
//        ctr2.callbackss=self
//        let ctr3 = AppStoryboard.Extra.viewController(viewControllerClass: ChatTableViewController.self)
//        controllerArray.append(ctr1)
//        controllerArray.append(ctr2)
//        controllerArray.append(ctr3)
        
//        scroll_View.backgroundColor = UIColor.blue
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
//        let parameters: [CAPSPageMenuOption] = [
//            .menuItemSeparatorWidth(4.3),
//            .menuItemSeparatorPercentageHeight(0.1),.hideTopMenuBar(true)
//        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        //        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: CGFloat(0.0), y: CGFloat(70), width: CGFloat(view.frame.width), height: CGFloat(UIScreen.main.bounds.height-70)), pageMenuOptions: parameters)
        
        
//        if ((UIDevice.modelName == "iPhone X")||(UIDevice.modelName == "iPhone XR")||(UIDevice.modelName == "iPhone XS")||(UIDevice.modelName == "iPhone XS Max")||(UIDevice.modelName == "Simulator iPhone X")||(UIDevice.modelName == "Simulator iPhone XR")||(UIDevice.modelName == "Simulator iPhone XS")||(UIDevice.modelName == "Simulator iPhone XS Max")) {
//            pageMenu = CAPSPageMenu(viewControllers: controllerArray ,frame: CGRect(x:0.0, y:(self.navigationController?.navigationBar.frame.maxY)!+50, width:UIScreen.main.bounds.size.width, height:(UIScreen.main.bounds.size.height-(self.navigationController?.navigationBar.frame.maxY)!)-60), pageMenuOptions: parameters)
//        }
//        else {
//            pageMenu = CAPSPageMenu(viewControllers: controllerArray ,frame: CGRect(x:0.0, y:(self.navigationController?.navigationBar.frame.maxY)!+20, width:UIScreen.main.bounds.size.width, height:(UIScreen.main.bounds.size.height-(self.navigationController?.navigationBar.frame.maxY)!-20)), pageMenuOptions: parameters)
//        }
        
//        pageMenu = CAPSPageMenu(viewControllers: controllerArray ,frame: CGRect(x:0.0, y:0.0, width:0, height:0), pageMenuOptions: parameters)
//
//        pageMenu!.hideTopMenuBar = true
//        pageMenu!.delegate = self
//
//        // Lastly add page menu as subview of base view controller view
//        // or use pageMenu controller in you view hierachy as desired
//        self.addChildViewController(pageMenu!)
//
//        self.mainView.addSubview(pageMenu!.view)
//        pageMenu?.didMove(toParentViewController: self)
//
//        pageMenu?.moveToPage(1)
//
//        SelectedIndex(index: 1)
//        Globalindex = 1

        //        let origImage1 = #imageLiteral(resourceName: "profile")
        //        let tintedImage = origImage1.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //
        //        let origImage2 = #imageLiteral(resourceName: "gear")
        //        let tintedImage2 = origImage2.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //
        //        let origImage3 = #imageLiteral(resourceName: "chat")
        //        let tintedImage3 = origImage3.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        //
        //        prof_Btn.setImage(tintedImage, for: .normal)
        //        prof_Btn.tintColor = UIColor.lightGray
        //
        //        main_btn.setImage(tintedImage2, for: .normal)
        //        main_btn.tintColor = Themes.sharedIntance.ReturnThemeColor()
        //
        //        chat_Btn.setImage(tintedImage3, for: .normal)
        //        chat_Btn.tintColor = UIColor.lightGray
        //
        chat_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        
        main_btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
        prof_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        
//        segmentedControl?.layer.borderColor = self.borderColor.cgColor
//        segmentedControl?.backgroundColor = self.backgroundColor
//        segmentedControl?.styleDelegate = self
//        segmentedControl?.delegate = self
//
        
//        let xFirstCell = self.createCell(
//            text: "",
//            image: self.createImage(withName: "gear")
//        )
//        let xSecondCell = self.createCell(
//            text: "",
//            image: self.createImage(withName: "user_group")
//        )
//
//        for cell in [xFirstCell, xSecondCell] {
//            cell.layout = .textWithImage
//            self.segmentedControl.add(cell: cell)
//        }
        
//        if(isFromFacebook)
//        {
//            main_btn.isHidden = false
//            segmentedControl.isHidden = true
//        }
//        else
//        {
//            main_btn.isHidden = false
//            segmentedControl.isHidden = true
//
//        }
        
//        let menuHeight = scroll_View.frame.size.height - UIApplication.shared.statusBarFrame.height
//        if ((UIDevice.modelName == "iPhone X")||(UIDevice.modelName == "iPhone XR")||(UIDevice.modelName == "iPhone XS")||(UIDevice.modelName == "iPhone XS Max")||(UIDevice.modelName == "Simulator iPhone X")||(UIDevice.modelName == "Simulator iPhone XR")||(UIDevice.modelName == "Simulator iPhone XS")||(UIDevice.modelName == "Simulator iPhone XS Max")){
//            menuView.translatesAutoresizingMaskIntoConstraints = false;
//            menuView.heightAnchor.constraint(equalToConstant: 130).isActive = true
//            menuView.layoutIfNeeded()
//            menuView.setNeedsLayout()
//        }
//
//        scroll_View.backgroundColor = UIColor.green
//
//        self.view.invalidateIntrinsicContentSize()
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollToMatchPage), name: Notification.Name("ScrollToMatchPage"), object: nil)
        
        receiptValidation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.isLoadChats(msgDict:)), name:Notification.Name("NewMessageReceiveds"), object: nil)
        
//        let menuSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeMenu))
//        scroll_View.panGestureRecognizer.require(toFail: menuSwipe!);

        tabScrollView.defaultPage = 1
        tabScrollView.arrowIndicator = false
        tabScrollView.tabSectionHeight = 70
        setActiveTab(index: tabScrollView.defaultPage)

        //        tabScrollView.tabSectionBackgroundColor = UIColor.whiteColor()
        //        tabScrollView.contentSectionBackgroundColor = UIColor.whiteColor()
        //        tabScrollView.tabGradient = true
        //        tabScrollView.pagingEnabled = true
        //        tabScrollView.cachedPageLimit = 3
        
        tabScrollView.delegate = self
        tabScrollView.dataSource = self
        
        let ctr1 = AppStoryboard.Extra.viewController(viewControllerClass: ProfileViewController.self)
        let ctr2 = AppStoryboard.Extra.viewController(viewControllerClass: HomeViewController.self)
        ctr2.callbackss=self
        ctr2.onChangeIconCallback=self
        let ctr3 = AppStoryboard.Extra.viewController(viewControllerClass: ChatTableViewController.self)
        controllerArray.append(ctr1)
        controllerArray.append(ctr2)
        controllerArray.append(ctr3)
        
        addChildViewController(ctr1)
        contentViews.append(ctr1.view)
        
        addChildViewController(ctr2)
        contentViews.append(ctr2.view)
        
        addChildViewController(ctr3)
        contentViews.append(ctr3.view)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func isLoadChats(msgDict: Notification){
        if tabScrollView.currentPageIndex() != 2 {
            Themes.sharedIntance.saveUnreadCount(unread_count: 1)
            updateIcon()
            StaticData.updated=true
            let msgsDict = convertToDictionary(text: ((msgDict.object! as! [String:Any])["custom"] as! String))!
            print(msgDict)
            let chat=msgsDict.object(forKey: "chat_status") as? NSDictionary
            
            if chat != nil{
                StaticData.allUserData!.conservationNotStarteds=[]
                StaticData.allUserData!.conservationStarteds=[]
                let conversation_not_started_array:NSArray =  chat?.object(forKey: "conversation_not_started") as! NSArray
                
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
                
                
                
                let conversation_started_array:NSArray =  chat?.object(forKey: "conversation_started") as! NSArray
                
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
            }else{
                let chat=msgsDict.object(forKey: "match_status") as? NSDictionary
                if chat != nil{
                    StaticData.allUserData!.conservationNotStarteds=[]
                    StaticData.allUserData!.conservationStarteds=[]
                    let conversation_not_started_array:NSArray =  chat?.object(forKey: "conversation_not_started") as! NSArray
                    print(conversation_not_started_array)
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
                    
                    
                    
                    let conversation_started_array:NSArray =  chat?.object(forKey: "conversation_started") as! NSArray
                    print(conversation_started_array)
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
            }
        }
    
    }
    
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    @objc func navigateToChat(notification: Notification) {
        StaticData.updated=false
        //        let dict = convertToDictionary(text: diction.description)
        StaticData.allUserData?.conservationNotStarteds=[]
        StaticData.allUserData?.conservationStarteds=[]
        let masterDict:NSDictionary = notification.object as! NSDictionary
        print(masterDict)
        if let dict = masterDict["chat_status"] as? NSDictionary {
            let conversation_not_started_array:NSArray =  dict.object(forKey: "conversation_not_started") as! NSArray
            
            if(conversation_not_started_array.count > 0)
            {   print(conversation_not_started_array)
                for i in 0..<conversation_not_started_array.count
                {
                    let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                    let objRecord:matchProfileRecord = matchProfileRecord()
                    objRecord.isgoldLike = false
                    
                    objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                    objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                    objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                    
                    objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                    objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                    objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                    
                    objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                    
                    StaticData.allUserData?.conservationNotStarteds.append(objRecord)
                }
            }
            //                    self.CollectionView.reloadData()
            
            
            
            let conversation_started_array:NSArray =  dict.object(forKey: "conversation_started") as! NSArray
            
            if(conversation_started_array.count > 0)
            {
                print(conversation_started_array)
                for i in 0..<conversation_started_array.count
                {
                    let ResponseDict:NSDictionary = conversation_started_array[i] as! NSDictionary
                    let objRecord:matchProfileRecord = matchProfileRecord()
                    objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                    objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                    objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                    
                    objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                    objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                    objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                    objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                    objRecord.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                    objRecord.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                    StaticData.allUserData?.conservationStarteds.append(objRecord)
                    
                }
                
            }
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
            var value=false
            var  newChatVC:ConservationViewController?
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    
                    if viewController.isKind(of: ConservationViewController.self) {
                        value=true
                        newChatVC=viewController as? ConservationViewController
                        break
                    }
                    else{
                        value=false
                        
                    }
                }
            }
            if value{
                newChatVC?.userRecord=objRecord
                newChatVC?.setObject()
            }else{
                newChatVC = AppStoryboard.Extra.initialViewController() as! ConservationViewController
                newChatVC?.userRecord =  objRecord
                self.navigationController?.pushViewController(newChatVC!, animated: true)
            }
            
            
        }
        else if let dict = masterDict["match_status"] as? NSDictionary {
            
            let conversation_not_started_array:NSArray =  dict.object(forKey: "conversation_not_started") as! NSArray
            
            if(conversation_not_started_array.count > 0)
            {   print(conversation_not_started_array)
                for i in 0..<conversation_not_started_array.count
                {
                    let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                    let objRecord:matchProfileRecord = matchProfileRecord()
                    objRecord.isgoldLike = false
                    
                    objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                    objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                    objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                    
                    objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                    objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                    objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                    
                    objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                    
                    
                    StaticData.allUserData?.conservationNotStarteds.append(objRecord)
                }
            }
            //                    self.CollectionView.reloadData()
            
            
            
            let conversation_started_array:NSArray =  dict.object(forKey: "conversation_started") as! NSArray
            
            if(conversation_started_array.count > 0)
            {
                print(conversation_started_array)
                for i in 0..<conversation_started_array.count
                {
                    let ResponseDict:NSDictionary = conversation_started_array[i] as! NSDictionary
                    let objRecord:matchProfileRecord = matchProfileRecord()
                    objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                    objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                    objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                    
                    objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                    objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                    objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                    objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                    objRecord.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                    objRecord.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                    StaticData.allUserData?.conservationStarteds.append(objRecord)
                    
                }
                
            }
            let objRecord:matchProfileRecord = matchProfileRecord()
            objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "like_status") as AnyObject)
            objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "read_status") as AnyObject)
            objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "status_message") as AnyObject)
            
            objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "user_id") as AnyObject)
            objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "user_image_url") as AnyObject)
            objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "match_id") as AnyObject)
            objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: dict.object(forKey: "match_user_name") as AnyObject)
            var value=false
            var  newChatVC:ConservationViewController?
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    
                    if viewController.isKind(of: ConservationViewController.self) {
                        value=true
                        newChatVC=viewController as? ConservationViewController
                        break
                    }
                    else{
                        value=false
                        
                    }
                }
            }
            if value{
                newChatVC?.userRecord=objRecord
                newChatVC?.setObject()
            }else{
                newChatVC = AppStoryboard.Extra.initialViewController() as! ConservationViewController
                newChatVC?.userRecord =  objRecord
                self.navigationController?.pushViewController(newChatVC!, animated: true)
            }
        }
    }
    
    func containsViewController(ofKind kind: AnyClass) -> Bool
    {
        return self.navigationController!.viewControllers.contains(where: { $0.isKind(of: kind) })
    }
    
    @objc func loadChats(){
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.match_details as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    StaticData.allUserData?.conservationStarteds=[]
                    StaticData.allUserData?.conservationNotStarteds=[]
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    
                    if(status_code == "1")
                    {
                        let unread_count = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
                        Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
                        
                        let conversation_not_started_array:NSArray =  responseDict?.object(forKey: "conversation_not_started_array") as! NSArray
                        
                        if(conversation_not_started_array.count > 0)
                        {   print(conversation_not_started_array)
                            for i in 0..<conversation_not_started_array.count
                            {
                                let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                                let objRecord:matchProfileRecord = matchProfileRecord()
                                objRecord.isgoldLike = false
                                
                                objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                                objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                                objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                                
                                objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                                objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                                objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                                
                                objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                                
                                StaticData.allUserData?.conservationNotStarteds.append(objRecord)
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
                                let objRecord:matchProfileRecord = matchProfileRecord()
                                objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                                objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                                objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                                
                                objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                                objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                                objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                                objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                                objRecord.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                                objRecord.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                                StaticData.allUserData?.conservationStarteds.append(objRecord)
                                
                            }
                            
                        }
                        // self.pageMenu?.moveToPage(3)
                        self.isLoad=false
                        
                        
                    }
                    else
                    {
                        
                    }
                    
                }
                else
                {
                    
                }
            }
        })
    }
    
    @objc func scrollToMatchPage() {
//        pageMenu?.moveToPage(2)
//        SelectedIndex(index: 2)
        changeToPage(index: 2)
    }
    
//    private func createCell(text: String, image: UIImage) -> SPSegmentedControlCell {
//        let cell = SPSegmentedControlCell.init()
//        cell.label.text = text
//        cell.label.font = UIFont(name: "Avenir-Medium", size: 13.0)!
//        cell.imageView.image = image
//        return cell
//    }
    
//    private func createImage(withName name: String) -> UIImage {
//        return UIImage.init(named: name)!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//    }
//
//    func selectedState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
//        SPAnimation.animate(0.1, animations: {
//            segmentControlCell.imageView.tintColor = UIColor.white
//
//        })
//
//        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
//            segmentControlCell.label.textColor = UIColor.black
//        }, completion: nil)
//
//        NotificationCenter.default.post(name: Constant.sharedinstance.ChangeIndex, object: index)
//    }
//
//    func normalState(segmentControlCell: SPSegmentedControlCell, forIndex index: Int) {
//        SPAnimation.animate(0.1, animations: {
//            segmentControlCell.imageView.tintColor = UIColor.lightGray
//        })
//
//        UIView.transition(with: segmentControlCell.label, duration: 0.1, options: [.transitionCrossDissolve, .beginFromCurrentState], animations: {
//            segmentControlCell.label.textColor = UIColor.white
//        }, completion: nil)
//        NotificationCenter.default.post(name: Constant.sharedinstance.ChangeIndex, object: index)
//
//    }
    
//    func indicatorViewRelativPosition(position: CGFloat, onSegmentControl segmentControl: SPSegmentedControl) {
//        let percentPosition = position / (segmentControl.frame.width - position) / CGFloat(segmentControl.cells.count - 1) * 100
//        let intPercentPosition = Int(percentPosition)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        if isFirst == false{
            isFirst=true
        }else{
            if tabScrollView.currentPageIndex() == 0{
                setActiveTab(index: 0)
            }
        }
        navigationController?.setNavigationBarHidden(true, animated: animated)
//        if(Globalindex == 0)
//        {
//            scroll_View.setContentOffset(CGPoint(x:-(prof_Btn.frame.origin.x+self.scroll_View.center.x-prof_Btn.frame.size.width),y:scroll_View.contentOffset.y), animated: false)
//
//        }
//        else if(Globalindex == 1)
//        {
//            scroll_View.setContentOffset(CGPoint(x:0.0,y:scroll_View.contentOffset.y), animated: false)
//
//        }
//        else if(Globalindex == 2)
//        {
//            scroll_View.setContentOffset(CGPoint(x:chat_Btn.frame.origin.x/2,y:scroll_View.contentOffset.y), animated: false)
//
//        }
        
    }
    
    
//    func willMoveToPage(_ controller: UIViewController, index: Int){
//        StaticData.pageNumber=index
//
//    }
//
//    func didMoveToPage(_ controller: UIViewController, index: Int){
//        controller.viewWillAppear(true)
//        self.view.endEditing(true)
//
//        self.SelectedIndex(index: index)
//    }
    
//    func SelectedIndex(index:Int)
//    {
//        segmentedControl.isHidden = true
//        main_btn.isHidden = false
////        pageMenu?.moveToPage(index)
//        Globalindex = index
////        pageMenu?.controllerArray[index].viewWillAppear(true)
//        if(index == 0)
//        {
//
//            chat_Btn.setTitleColor(UIColor.lightGray, for: .normal)
//
//            main_btn.setTitleColor(UIColor.lightGray, for: .normal)
//            prof_Btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
//            prof_Btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 32)
//            //            main_btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 47)
//
//            main_btn.setImage(#imageLiteral(resourceName: "logoGray"), for: .normal)
//
//            chat_Btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 29)
//
//            print(prof_Btn.frame.origin.x+self.scroll_View.center.x)
//            scroll_View.setContentOffset(CGPoint(x:-(prof_Btn.frame.origin.x+self.scroll_View.center.x-prof_Btn.frame.size.width),y:scroll_View.contentOffset.y), animated: true)
//
//        }
//        if(index == 1)
//        {
//            //            prof_Btn.tintColor = UIColor.lightGray
//            //
//            //            main_btn.tintColor = Themes.sharedIntance.ReturnThemeColor()
//            //
//            //            chat_Btn.tintColor = UIColor.lightGray
//
//            chat_Btn.setTitleColor(UIColor.lightGray, for: .normal)
//
//            //            main_btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
//            main_btn.setImage(#imageLiteral(resourceName: "tinder logo icon"), for: .normal)
//
//            prof_Btn.setTitleColor(UIColor.lightGray, for: .normal)
//
//
//            if(isFromFacebook)
//            {
//                segmentedControl.isHidden = true
//                main_btn.isHidden = false
//
//            }
//            scroll_View.setContentOffset(CGPoint(x:0.0,y:scroll_View.contentOffset.y), animated: true)
//            prof_Btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 29)
//            main_btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 50)
//            chat_Btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 29)
//
//        }
//        if(index == 2)
//        {
//            print(chat_Btn.frame.origin.x)
//            scroll_View.setContentOffset(CGPoint(x:chat_Btn.frame.origin.x/2,y:scroll_View.contentOffset.y), animated: true)
//            chat_Btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
//            //             main_btn.setTitleColor(UIColor.lightGray, for: .normal)
//            main_btn.setImage(#imageLiteral(resourceName: "logoGray"), for: .normal)
//            prof_Btn.setTitleColor(UIColor.lightGray, for: .normal)
//            prof_Btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 29)
//            main_btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 47)
//
//            chat_Btn.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 32)
//
//
//            //            prof_Btn.tintColor = UIColor.lightGray
//            //
//            //            main_btn.tintColor = UIColor.lightGray
//            //
//            //            chat_Btn.tintColor = Themes.sharedIntance.ReturnThemeColor()
//
//        }
//
//    }
//
//
//
//
//    func SetDefaultTextColor(Lbl:UILabel)
//    {
//        Lbl.textColor = UIColor.black
//    }
//    func SetThemeTextColor(Lbl:UILabel)
//    {
//        Lbl.textColor = Themes.sharedIntance.ReturnThemeColor()
//    }
    
    
    func receiptValidation() {
        let SUBSCRIPTION_SECRET = "3fc6989cba0d42f3977f8f0c9dcf031a"
        let receiptPath = Bundle.main.appStoreReceiptURL?.path
        if FileManager.default.fileExists(atPath: receiptPath!){
            var receiptData:NSData?
            do{
                receiptData = try NSData(contentsOf: Bundle.main.appStoreReceiptURL!, options: NSData.ReadingOptions.alwaysMapped)
            }
            catch{
                print("ERROR: " + error.localizedDescription)
            }
            //let receiptString = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn)
            
            print(base64encodedReceipt!)
            
            
            //            let requestDictionary = ["receipt-data":base64encodedReceipt!,"password":SUBSCRIPTION_SECRET]
            let requestDictionary = ["receipt_data":base64encodedReceipt!]
            
            guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
            do {
                let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
                //                let validationURLString = "https://sandbox.itunes.apple.com/verifyReceipt"  // this works but as noted above it's best to use your own trusted server
                let validationURLString = Constant.sharedinstance.verify_receipt
                guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
                let session = URLSession(configuration: URLSessionConfiguration.default)
                var request = URLRequest(url: validationURL)
                request.httpMethod = "POST"
                request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
                let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                    if let data = data , error == nil {
                        do {
                            let appReceiptJSON = try JSONSerialization.jsonObject(with: data)
                            print("success. here is the json representation of the app receipt: \(appReceiptJSON)")
                            // if you are using your server this will be a json representation of whatever your server provided
                        } catch let error as NSError {
                            print("json serialization failed with error: \(String(describing: error))")
                        }
                    } else {
                        print("the upload task returned an error: \(String(describing: error))")
                    }
                }
                task.resume()
            } catch let error as NSError {
                print("json serialization failed with error: \(error)")
            }
            
            //            let param = ["receipt_data":base64encodedReceipt!]
            //            let param = ["receipt-data":base64encodedReceipt!,"password":SUBSCRIPTION_SECRET]
            //            let Header:HTTPHeaders = [:]
            //            Alamofire.request("https://sandbox.itunes.apple.com/verifyReceipt" as String, method: .post, parameters:param,headers:Header).responseJSON { response in
            //                    print(response)
            //
            //            }
            
            
            
            //            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.verify_receipt as NSString, param: param, _method: .post, completionHandler: { (responseDict, error) in
            //                if((responseDict?.count)! > 0)
            //                {
            
            //            Alamofire.request(Constant.sharedinstance.verify_receipt as String, method: .post, parameters:param,headers:Header).responseJSON { (response) in
            //                if(response.error == nil)
            //                {
            ////                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
            ////                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
            ////                    if(status_code == "1")
            ////                    {
            ////                        print(responseDict!)
            ////                    }
            ////                    else
            ////                    {
            ////                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
            ////                    }
            //                    print(response)
            //                }
            //                else
            //                {
            ////                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
            //                    print(response.error!.localizedDescription)
            //                }
            //            })
            
            
            
        }
        
    }


    @IBAction func DidclickMenu(_ sender: Any) {
//        SelectedIndex(index: (sender as AnyObject).tag)
        
     }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func DidclickMain(_ sender: Any) {
//        self.SelectedIndex(index: 1)
//        self.view.endEditing(true)
    }
    
    @IBAction func DidclickProf(_ sender: Any) {
//        self.SelectedIndex(index: 0)
//        self.view.endEditing(true)
    }
    

    @IBAction func Didclickchat(_ sender: Any) {
//        self.SelectedIndex(index: 2)
//        self.view.endEditing(true)
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func addSuperLikeUserOfHome(record:matchProfileRecord){
        let homeController = controllerArray[1] as! HomeViewController
        homeController.addSuperLikeUser(matchRecord: record)
    }
    
    func setActiveTab(index: Int){
        Globalindex=index
        if(index == 0){
            profButton.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
            mainButton.setImage(#imageLiteral(resourceName: "logoGray"), for: .normal)
            chatButton.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.8666666667, blue: 0.8941176471, alpha: 1), for: .normal)
            
        }else if(index == 1){
            profButton.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.8666666667, blue: 0.8941176471, alpha: 1), for: .normal)
            mainButton.setImage(#imageLiteral(resourceName: "tinder logo icon"), for: .normal)
            chatButton.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.8666666667, blue: 0.8941176471, alpha: 1), for: .normal)
            
        }else{
            profButton.setTitleColor(#colorLiteral(red: 0.8549019608, green: 0.8666666667, blue: 0.8941176471, alpha: 1), for: .normal)
            mainButton.setImage(#imageLiteral(resourceName: "logoGray"), for: .normal)
            chatButton.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)

        }
    
        self.view.endEditing(true)
    }
    
    @objc func tabButtonAction(sender: UIButton){
        changeToPage(index: sender.tag)
    }
    
    func changeToPage(index: Int){
        setActiveTab(index: index)
        tabScrollView.changePageToIndex(index, animated: true)
    }
    // MARK: ACTabScrollViewDelegate
    func tabScrollView(_ tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
        print(index)
        if Globalindex == 1{
            let vc=controllerArray[Globalindex]
            vc.viewWillDisappear(true)
        }
        let vc=controllerArray[index]
        vc.viewWillAppear(true)
        StaticData.pageNumber=index
        setActiveTab(index: index)
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
        if Globalindex == 1{
            let vc=controllerArray[Globalindex]
            vc.viewWillDisappear(true)
        }
        let vc=controllerArray[index]
        vc.viewWillAppear(true)
        setActiveTab(index: index)
    }
    
    // MARK: ACTabScrollViewDataSource
    func numberOfPagesInTabScrollView(_ tabScrollView: ACTabScrollView) -> Int {
        return 3
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
        
        let xPos : CGFloat = self.view.frame.width / 2 *  CGFloat(index)
        let view = UIView(frame: CGRect(x: xPos, y: 0, width: self.view.frame.width/2 - 40, height: tabScrollView.tabSectionHeight))
        if(index == 0)
        {
            profButton.frame = CGRect(x: (view.frame.width - tabScrollView.tabSectionHeight)/2, y: -2, width: tabScrollView.tabSectionHeight, height: tabScrollView.tabSectionHeight)
            profButton.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 32)
            profButton.setTitle("3", for: .normal)
            profButton.tag = 0
            profButton.addTarget(self, action: #selector(tabButtonAction(sender:)), for: .touchUpInside)
            view.addSubview(profButton)
            
        }else if(index == 1){
            mainButton.frame = CGRect(x: (view.frame.width - 47)/2, y: (tabScrollView.tabSectionHeight - 47)/2 - 2, width: 47, height: 47)
            mainButton.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 32)
            mainButton.setImage(#imageLiteral(resourceName: "tinder logo icon"), for: .normal)
            mainButton.tag = 1
            mainButton.addTarget(self, action: #selector(tabButtonAction(sender:)), for: .touchUpInside)
            view.addSubview(mainButton)

        }else{
            chatButton.frame = CGRect(x: (view.frame.width - tabScrollView.tabSectionHeight)/2, y: -2, width: tabScrollView.tabSectionHeight, height: tabScrollView.tabSectionHeight)
            chatButton.titleLabel?.font =  UIFont(name: Constant.sharedinstance.iconfontname, size: 32)
            chatButton.setTitle("1", for: .normal)
            chatButton.tag = 2
            chatButton.addTarget(self, action: #selector(tabButtonAction(sender:)), for: .touchUpInside)
            view.addSubview(chatButton)
            
            
        }
        
        return view
    }
    
    func tabScrollView(_ tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
        return contentViews[index]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    }
}

//extension MainViewController:UIScrollViewDelegate
//{
//    func scrollViewDidbeginScroll(_ xOffset: CGFloat, yOffset: CGFloat) {
//        print(xOffset)
//        //        scroll_View.contentOffset.x = xOffset
//
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(-(prof_Btn.frame.origin.x+self.scroll_View.center.x-prof_Btn.frame.size.width),chat_Btn.frame.origin.x/2)
//    }
//}

class ChatBtn: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
            if (imageView?.superview as! UIButton).titleLabel!.font.pointSize == 29.0 {
                imageView?.frame = CGRect(x: (imageView?.frame.origin.x)! + 2.5 , y: (imageView?.frame.origin.y)! + 2.5, width: (imageView?.frame.width)! - 2.5, height: (imageView?.frame.height)! - 2.5)
                self.bringSubview(toFront: imageView!)
            }
            else {
                imageView?.frame = CGRect(x: (imageView?.frame.origin.x)! + 2.5 , y: (imageView?.frame.origin.y)! + 2.5, width: (imageView?.frame.width)! - 5, height: (imageView?.frame.height)! - 5)
                self.bringSubview(toFront: imageView!)
            }
        }
    }
}
protocol OnChangeIcon {
    func onChangeIcon()
}
