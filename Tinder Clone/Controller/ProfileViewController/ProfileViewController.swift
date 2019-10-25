//
//  ProfileViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import SDWebImage
import StoreKit
import ReachabilitySwift
import SwiftMessages
import CropViewController
class ProfileViewController: RootBaseViewcontroller,SliderCollectionViewDelegate,SKProductsRequestDelegate, SKPaymentTransactionObserver,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CropViewControllerDelegate {
    
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var plus_Btn: UIButton!
    @IBOutlet weak var page_control: FXPageControl!
     @IBOutlet weak var slider_collectionview: SliderCollectionView!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var detail2_Lbl: UILabel!
    @IBOutlet weak var detail1_Lbl: UILabel!
    @IBOutlet weak var name_Lbl: UILabel!
    @IBOutlet weak var prof_image: UIImageView!
    @IBOutlet weak var edit_Btn: UIButton!
    @IBOutlet weak var setting_Btn: UIButton!
    @IBOutlet weak var shadow: UIView!
    private var isFirstCall=false
    private var cropViewController:CropViewController?
    @IBOutlet var afterPurchaseView: UIView!
    @IBOutlet weak var superLikeCountLabel: UILabel!
    @IBOutlet weak var boostCountLabel: UILabel!
    private var picker = UIImagePickerController()
    @IBOutlet weak var superLikeTapView: UIView!
    @IBOutlet weak var boostTapView: UIView!
    @IBOutlet weak var upgradeTapView: UIView!
    @IBOutlet weak var boostSuperLikeView: UIView!
    private let reachability = Reachability()!
    private var currentImage:UIImage?
    private var isSetting=false
    
    var name:String = ""
    var profimageYpos:CGFloat!
    var nameYpos:CGFloat!
    
    var productIDs: Array<String> = []
    var productsArray: Array<SKProduct> = []
    var transactionInProgress = false
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        dismiss(animated:true, completion: {
            self.cropViewController=CropViewController(image: chosenImage)
            self.cropViewController?.aspectRatioPreset = TOCropViewControllerAspectRatioPreset.presetSquare
            //self.cropViewController?.aspectRatioLockEnabled=true
            self.cropViewController?.cropView.cropBoxResizeEnabled=false
            self.cropViewController?.rotateButtonsHidden=true
            self.cropViewController?.aspectRatioPickerButtonHidden=true
            self.cropViewController?.resetButtonHidden=true
            self.cropViewController?.delegate = self
            self.present(self.cropViewController!, animated: true, completion: nil)
        }) //5
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let image: UIImage = UIImage(data: imageData!)!
        self.cropViewController?.dismiss(animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          
                self.uploadImage(imgPath: image)
            
        }
    }
    private func showSucess(){
        let view: CustomCardView = try! SwiftMessages.viewFromNib()
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        view.configureDropShadow()
        view.customView.layer.cornerRadius=6
        view.userimage?.layer.cornerRadius=4
        view.userimage?.clipsToBounds=true
        view.userimage?.image=currentImage!
        view.configureBackgroundView(width: 8.0)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(config: successConfig, view: view)
    }
    func uploadImage(imgPath:UIImage) {
        currentImage=imgPath
        if reachability.currentReachabilityStatus != .notReachable{
            let imageData: NSData = UIImageJPEGRepresentation(imgPath, 0.9)! as NSData
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.imageUpload(urlString: Constant.sharedinstance.uploadProfileImageUrl as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
                if(error == nil) {
                   
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let successMsg = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1") {
                        self.showSucess()
                        let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "image_url") as AnyObject)
                        
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
                self.uploadImage(imgPath: imgPath)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func onClickedButton(_ sender: UIButton) {
        if StaticData.allUserData!.imageList.count != 9{
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
        }else{
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Main", bundle: nil)
            let VC1 = mainView.instantiateViewController(withIdentifier: "ProfileDisplayViewControllerSID") as! ProfileDisplayViewController
            //        let navController = UINavigationController(rootViewController: VC1)
            //        navController.navigationBar.isHidden = true
            VC1.isToEditProfile = true
            
            self.navigationController?.present(VC1, animated:true, completion: nil)
        }
    }
    
    @IBAction func plusButton(_ sender: UIButton) {
        if StaticData.allUserData!.imageList.count != 9{
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }else{
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Main", bundle: nil)
            let VC1 = mainView.instantiateViewController(withIdentifier: "ProfileDisplayViewControllerSID") as! ProfileDisplayViewController
            //        let navController = UINavigationController(rootViewController: VC1)
            //        navController.navigationBar.isHidden = true
            VC1.isToEditProfile = true
            
            self.navigationController?.present(VC1, animated:true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate=self
        //self.viewButton.layer.cornerRadius=12
        addShadowToProfile()
        reachability.whenReachable={reachability in
            if StaticData.isPushed != nil{
            if StaticData.isPushed!{
                self.updateAllData()
            }
            }
            
        }
        do{
            try reachability.startNotifier()
        }catch{
            
        }
        productIDs.append("iapdemo_extra_colors_col1")
        productIDs.append("iapdemo_extra_colors_col2")
        
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
        
        //slider_collectionview.Delegate = self
        //initialiseCollectionView()
        // bottom_view.setBottomCurve()
//        Themes.sharedIntance.AddBorder(view: edit_Btn, borderColor: nil, borderWidth: nil, cornerradius: edit_Btn.frame.size.width/2)
//        Themes.sharedIntance.AddBorder(view: setting_Btn, borderColor: nil, borderWidth: nil, cornerradius: setting_Btn.frame.size.width/2)
        Themes.sharedIntance.AddBorder(view: prof_image, borderColor: nil, borderWidth: nil, cornerradius: prof_image.frame.size.width/2)
        //Themes.sharedIntance.AddBorder(view: plus_Btn, borderColor: nil, borderWidth: nil, cornerradius: 24.0)
         Timer.scheduledTimer(timeInterval: 2.5, target:self, selector: #selector(slideShowImages(_:)), userInfo: nil, repeats: true)

        //Themes.sharedIntance.addshadowtoView(view: plus_Btn,radius:22.0,ShadowColor:UIColor.lightGray)
        
        //plus_Btn.tag = 0
        //plus_Btn.setTitle("GET \(k_Application_Name.uppercased()) GOLD", for: .normal)
        //plus_Btn.titleLabel?.textColor = Themes.sharedIntance.ReturnGoldenColor()
        
        if(Themes.sharedIntance.CheckLogin())
        {
            let userDetail_arr:NSArray = DatabaseHandler.sharedinstance.fetchTableAllData(tableName: Constant.sharedinstance.User_details) as NSArray
            if(userDetail_arr.count > 0)
            {
                for i in 0..<userDetail_arr.count
                {
                    let manaObj:NSManagedObject = userDetail_arr[i] as! NSManagedObject
                    let dict = manaObj.dictionaryWithValues(forKeys: Array(manaObj.entity.attributesByName.keys))
                    print(dict)
                    
                    name_Lbl.text = (manaObj.value(forKey: "first_name") as! String)
//                    prof_image.sd_setImage(with: URL(string:((manaObj.value(forKey: "user_image_url")! as! [String])[0])), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
                    name = (manaObj.value(forKey: "first_name") as! String)
                    detail2_Lbl.text = ""
                    detail1_Lbl.text = ""
                }
            }
        }
        prof_image.isUserInteractionEnabled=true
        let profileTap:UITapGestureRecognizer =  UITapGestureRecognizer(target: self, action: #selector(self.didSelectProfileImage(_:)))
        prof_image.addGestureRecognizer(profileTap)
        

        profimageYpos = prof_image.frame.origin.y
        nameYpos = name_Lbl.frame.origin.y
        
        let boostTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.getBoostTapped(_:)))
        boostTapView.addGestureRecognizer(boostTapGesture)
        
        let superLikesTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.getSuperLikesTapped(_:)))
        superLikeTapView.addGestureRecognizer(superLikesTapGesture)
        
        let upgradeToGoldTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.upgradeToGoldTapped(_:)))
        upgradeTapView.addGestureRecognizer(upgradeToGoldTapGesture)

        // Do any additional setup after loading the view.
    }
    private func addShadowToProfile(){
        shadow.layer.cornerRadius = 75
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = CGSize(width:0,height:2)
        shadow.layer.shadowOpacity = 1
        shadow.backgroundColor = UIColor.white
    }
    func moveToSetting(){
    
        
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                var mainView: UIStoryboard!
                mainView = UIStoryboard(name: "Main", bundle: nil)
                let VC1 = mainView.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController
                let navController = UINavigationController(rootViewController: VC1)
                //        navController.navigationBar.isHidden = false
                navController.navigationItem.title = "Settings"
                self.present(navController, animated:true, completion: nil)
                StaticData.pageNumber = -1
                
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        loadProfileData()
        requestProductInfo()
        
        
        
        
    }
    private func updateAllData(){
        var str=""
        var first=true
        for img in StaticData.allUserData!.imageId{
            if first{
                str=img
                first=false
            }else{
                str=str+","+img
            }
        }
        let objRecord=StaticData.allUserData!.setting!
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"order_images":str,"gender":StaticData.allUserData!.gender!,"about":StaticData.allUserData!.about!,"college":StaticData.allUserData!.college!,"job_title":StaticData.allUserData!.jobTitle!,/*"instagram_id":Themes.sharedIntance.CheckNullvalue(Str: instagramID as AnyObject),*/"distance_invisible":StaticData.allUserData!.distanceInvisible!,"show_my_age":StaticData.allUserData!.showMyAge!,"work":StaticData.allUserData!.work!,"matching_profile":objRecord.gender,"distance_type":objRecord.distance_type,"distance":objRecord.max_distance,"min_age":objRecord.min_age,"max_age":objRecord.max_age,"show_me":objRecord.show_me,"new_matches":objRecord.new_match,"messages":objRecord.receiving_message,"message_likes":objRecord.message_likes,"super_likes":objRecord.super_likes,"latitude":"","longitude":"","email":objRecord.email!,"phone_number":StaticData.phonenumber!,"phone_code":StaticData.phonecode!]
        
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.update_settings as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            if ResponseDict != nil{
            if((ResponseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                if(status_code == "1")
                {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "k_DonePressed"), object: nil)
                    StaticData.isPushed=false
                    
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
    @objc func didSelectProfileImage(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)
        let VC1 = mainView.instantiateViewController(withIdentifier: "ProfileDisplayViewControllerSID") as! ProfileDisplayViewController
        //        let navController = UINavigationController(rootViewController: VC1)
        //        navController.navigationBar.isHidden = true
        VC1.isToEditProfile = false
        
        self.navigationController?.present(VC1, animated:true, completion: nil)
        
    }
    private func loadProfileData(){
        if StaticData.allUserData!.work! != nil && StaticData.allUserData!.jobTitle != nil {
            if StaticData.allUserData!.work!.count > 0 && StaticData.allUserData!.jobTitle!.count > 0{
            self.detail1_Lbl.text = StaticData.allUserData!.jobTitle! + " at " +  StaticData.allUserData!.work!
            }else if StaticData.allUserData!.work!.count>0{
                self.detail1_Lbl.text = StaticData.allUserData!.work!
            }else if StaticData.allUserData!.jobTitle!.count > 0{
                self.detail1_Lbl.text = StaticData.allUserData!.jobTitle!
            }
        }else if StaticData.allUserData!.work != nil{
            if StaticData.allUserData!.work!.count > 0{
                self.detail1_Lbl.text = StaticData.allUserData!.work!
            }
        }else{
            if StaticData.allUserData!.jobTitle!.count > 0{
                self.detail1_Lbl.text = StaticData.allUserData!.jobTitle!
            }
        }
        if StaticData.allUserData!.college != nil{
            self.detail2_Lbl.text = StaticData.allUserData!.college!
        }
        
        if StaticData.imageUpload != nil{
            self.prof_image.image=StaticData.imageUpload!
        }else{
            self.prof_image.sd_setImage(with: URL(string:(StaticData.allUserData!.imageList[0])), placeholderImage: #imageLiteral(resourceName: "gold_like"),completed: { (image, error, cache, url) in
                if error != nil {
                    self.prof_image.image = #imageLiteral(resourceName: "gold_like")
                }
            })
        }
        
        
        self.name_Lbl.text = "\(StaticData.allUserData!.name!), \(StaticData.allUserData!.age!)"
        /*
        let unread_count = StaticData.allUserData!.unreadCount!
        let remainingBoostCount = StaticData.allUserData!.remainingBoost!
        let remainingLikesCount = StaticData.allUserData!.remianingLikes!
        self.boostCountLabel.text = "\(remainingBoostCount)"
        self.superLikeCountLabel.text = "\(remainingLikesCount)"
        
        SharedVariables.sharedInstance.boostCount = remainingBoostCount
        SharedVariables.sharedInstance.superLikesCount = remainingLikesCount
        
        Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
        
        SharedVariables.sharedInstance.planType = StaticData.allUserData!.setting!.plan_type
        if SharedVariables.sharedInstance.planType.count > 0 && SharedVariables.sharedInstance.planType == "Gold" {
            //self.plus_Btn.isHidden = true
            //self.slider_collectionview.isHidden = true
            //self.page_control.isHidden = true
            
            self.view.addSubview(self.afterPurchaseView)
            //self.afterPurchaseView.frame = CGRect(x:(self.view.frame.size.width - //self.afterPurchaseView.frame.size.width) / 2, y:self.slider_collectionview.frame.origin.y, width: self.afterPurchaseView.frame.size.width, height: self.afterPurchaseView.frame.size.height)
            self.upgradeTapView.isHidden = true
            self.boostSuperLikeView.frame.origin.x = (self.afterPurchaseView.frame.size.width - self.boostSuperLikeView.frame.size.width) / 2
            //elf.plus_Btn.setTitle("MY \(k_Application_Name.uppercased()) GOLD", for: .normal)
        }
        else if SharedVariables.sharedInstance.planType.count > 0 && SharedVariables.sharedInstance.planType == "Plus" {
            //self.plus_Btn.isHidden = true
            //self.slider_collectionview.isHidden = true
            //self.page_control.isHidden = true
            
            self.view.addSubview(self.afterPurchaseView)
            //self.afterPurchaseView.frame = CGRect(x:(self.view.frame.size.width - //self.afterPurchaseView.frame.size.width) / 2, y:self.slider_collectionview.frame.origin.y, width: self.afterPurchaseView.frame.size.width, height: self.afterPurchaseView.frame.size.height)
            //self.plus_Btn.setTitle("MY \(k_Application_Name.uppercased()) PLUS", for: .normal)
        }
        else {
            /*
            //self.plus_Btn.isHidden = false
            if self.slider_collectionview.isHidden {
                self.afterPurchaseView.removeFromSuperview()
                //self.slider_collectionview.isHidden = false
                //self.page_control.isHidden = false
                //self.plus_Btn.setTitle("GET \(k_Application_Name.uppercased()) PLUS", for: .normal)
            }*/
        }
 */
    }
    
    
    @IBAction func slideShowImages(_ sender:AnyObject?){
        /*
        if(self.page_control.currentPage+1 > 5)
        {
        let indexPath:IndexPath = IndexPath(item: 0, section: 0)
         slider_collectionview.scrollToItem(at:indexPath , at: .left, animated: true)
        }
        else
        {
            let indexPath:IndexPath = IndexPath(item: self.page_control.currentPage+1, section: 0)
            slider_collectionview.scrollToItem(at:indexPath , at: .left, animated: true)
        }*/
    }
   
    func initialiseCollectionView()
    {
        let imageArr:Array=["tinder logo icon","skip_no_bg","superlike_no_bg","marker_blue","rewind_no_bg","like_no_bg"]
        
        let titleArr:Array=["Get \(k_Application_Name)  Gold","Boost your profile","Stand out with super likes","Swipe around the world","I meant to swipe right","Increase your chances"]
        let subtitleArr:Array=["See who like you & more","Get a free boost every month!","You're 3 times more likely to get a match","Passport to anywhere with \(k_Application_Name) plus","Get unlimited rewinds with  \(k_Application_Name) plus","Get unlimited likes with  \(k_Application_Name) plus"]


        let HeaderSliderArray:NSMutableArray = NSMutableArray()
        for i in 0..<imageArr.count
        {
            let objRecord:SliderRecord=SliderRecord(imageName: imageArr[i], LogoimageName: "", DetailText: titleArr[i] ,subtext:subtitleArr[i] )
            HeaderSliderArray.add(objRecord)
            
            
        }
        /*
        slider_collectionview.List_data_source = NSMutableArray(array: HeaderSliderArray)
        slider_collectionview.Slidercat = .list
        slider_collectionview.Paging_Enabled=true
        slider_collectionview.ReloadSlider()
        page_control.numberOfPages = imageArr.count
        page_control.defersCurrentPageDisplay = true;
        self.page_control.selectedDotColor = Themes.sharedIntance.ReturnThemeColor();
        self.page_control.dotColor = UIColor.lightGray
        self.page_control.currentPage = 0;
        page_control.selectedDotSize = 8.0;
        page_control.dotSpacing = 15.0
        page_control.dotSize = 5.0
        */
        
    }
    
    func IndexforPageControl(index: Int) {
       /*
        if !slider_collectionview.isHidden {
            //self.page_control.currentPage = index;
            if(index == 0)
            {
                //plus_Btn.titleLabel?.textColor = Themes.sharedIntance.ReturnGoldenColor()
                //plus_Btn.tag = 0
                //plus_Btn.setTitle("GET \(k_Application_Name.uppercased()) GOLD", for: .normal)
                
            }
            else
            {
                //plus_Btn.titleLabel?.textColor = Themes.sharedIntance.ReturnThemeColor()
                
                //plus_Btn.tag = 1
                
                //plus_Btn.setTitle("GET \(k_Application_Name.uppercased()) PLUS", for: .normal)
                
            }
        }
        */
        
    }

    override func viewDidLayoutSubviews() {

    }
    @IBAction func DidclickEdit(_ sender: Any) {
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)
        let VC1 = mainView.instantiateViewController(withIdentifier: "ProfileDisplayViewControllerSID") as! ProfileDisplayViewController
//        let navController = UINavigationController(rootViewController: VC1)
//        navController.navigationBar.isHidden = true
        VC1.isToEditProfile = true
        
        self.navigationController?.present(VC1, animated:true, completion: nil)
    }

    @IBAction func DidclickSetting(_ sender: Any) {
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)
        
        let VC1 = mainView.instantiateViewController(withIdentifier: "SettingViewControllerID") as! SettingViewController
        let navController = UINavigationController(rootViewController: VC1)
//        navController.navigationBar.isHidden = false
        navController.navigationItem.title = "Settings"
        self.present(navController, animated:true, completion: nil)

    }
    
    @IBAction func subscribeButtonAction(_ sender: Any) {
        
//        if transactionInProgress {
//            return
//        }
//
//        let actionSheetController = UIAlertController(title: Themes.sharedIntance.GetAppName(), message: "What do you want to do?", preferredStyle: UIAlertControllerStyle.actionSheet)
//
//        let buyAction = UIAlertAction(title: "Buy", style: UIAlertActionStyle.default) { (action) -> Void in
//
//            let payment = SKPayment(product: self.productsArray[0] as SKProduct)
//            SKPaymentQueue.default().add(payment)
//            self.transactionInProgress = true
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
//
//        }
//
//        actionSheetController.addAction(buyAction)
//        actionSheetController.addAction(cancelAction)
//
//        present(actionSheetController, animated: true, completion: nil)
        
        if SharedVariables.sharedInstance.planType.count == 0 {
            let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
            destController.modalTransitionStyle = .crossDissolve
            /*
            if plus_Btn.titleLabel?.text == "GET \(k_Application_Name.uppercased()) GOLD" {
                destController.isGold = true
            }
            else {
                destController.isGold = false
            }*/
            self.navigationController?.present(destController, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getBoostTapped(_:UIGestureRecognizer) {
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isBoost = true
        if SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus" {
            destController.isPurchased = true
        }
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    @objc func getSuperLikesTapped(_:UIGestureRecognizer) {
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isBoost = false
        if SharedVariables.sharedInstance.planType == "Gold" || SharedVariables.sharedInstance.planType == "Plus" {
            destController.isPurchased = true
        }
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    @objc func upgradeToGoldTapped(_:UIGestureRecognizer) {
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isGold = true
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = NSSet(array: productIDs)
            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    //MARK:- SKProduct Request Delegates
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count != 0 {
            for product in response.products {
                productsArray.append(product)
            }
        }
        else {
            print("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            print(response.invalidProductIdentifiers.description)
        }
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
//                delegate.didBuyColorsCollection(selectedProductIndex)
                
                
            case SKPaymentTransactionState.failed:
                print("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                
            default:
                print(transaction.transactionState.rawValue)
            }
        }
        
    }

}
extension UIView {
    func setTopCurve(){
        let offset = CGFloat(self.frame.size.height/4)
        let bounds = self.bounds
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height/2  , width:  bounds.size.width, height: bounds.size.height / 2)
        let rectPath = UIBezierPath(rect: rectBounds)
        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
}

class curvedView: UIView {
    
    override func draw(_ rect: CGRect) {
        let y:CGFloat = 0
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: 0, y: y))
        myBezier.addQuadCurve(to: CGPoint(x: rect.width, y: y), controlPoint: CGPoint(x: rect.width / 2, y: rect.height / 3))
        myBezier.addLine(to: CGPoint(x: rect.width, y: rect.height))
        myBezier.addLine(to: CGPoint(x: 0, y: rect.height))
        myBezier.close()
        UIColor(red:0.95, green:0.97, blue:0.98, alpha:1.0).setFill()
        myBezier.fill()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        
    }
}
