//
//  SettingViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import AFMActionSheet
import RangeSeekSlider
import TOWebViewController
import SCLAlertView
import AccountKit
import  Alamofire
import ReachabilitySwift
import SwiftMessages
class SettingViewController: UIViewController,GenderListViewControllerDelegate,RangeSeekSliderDelegate,SettingTableViewCellDelegate, AfterPurchaseDelegate, ShowPlusFromBoostDelegate,AKFViewControllerDelegate
{
    
    
    
    
  
    @IBOutlet weak var plusIcon: UIImageView!
    @IBOutlet weak var goldIcon: UIImageView!
    @IBOutlet weak var tinderplusView: UIView!
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var delete_account: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var getSuperLikeView: UIView!
    @IBOutlet weak var getBoostView: UIView!
    @IBOutlet weak var tindergoldView: UIView!
    var NotificationArr:[String] = [String]()
    @IBOutlet weak var bottom_wrapperView: UIView!
    @IBOutlet weak var boost_btn: UIButton!
    @IBOutlet weak var superLike_Btn: UIButton!
    @IBOutlet weak var goldSymbolImage: UIImageView!
    @IBOutlet weak var plusSymbolImage: UIImageView!
    @IBOutlet weak var goldTitleLabel: UILabel!
    @IBOutlet weak var plusTitleLabel: UILabel!
    @IBOutlet weak var versionLabelOutlet: UILabel!
    private var locationName:String?
    private var isFirst=true
    
    let LoginactionSheet = AFMActionSheetController(style: .actionSheet, transitioningDelegate: AFMActionSheetTransitioningDelegate())
    var objRecord:SettingRecord?
    let appDel = UIApplication.shared.delegate as! AppDelegate
    var isFromGenderPage = Bool()
    var isGenderChanged = Bool()
    var accountKit:AKFAccountKit!
    var status:Bool=false
    private let reachability = Reachability()!
    private var loadingAlert:UIAlertController?
    private var isFirstCall=false
    
    func navigationCustom() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "Settings"
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(SettingViewController.doneSelected))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem?.tintColor = Themes.sharedIntance.ReturnThemeColor()
        self.navigationItem.backBarButtonItem?.tintColor = Themes.sharedIntance.ReturnThemeColor()
        navigationController?.navigationBar.tintColor = Themes.sharedIntance.ReturnThemeColor()
        
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delete_account.layer.borderWidth=0.3
        delete_account.layer.borderColor=#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        /*
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X"){
            superLike_Btn.frame=CGRect(x:superLike_Btn.frame.origin.x-10,y:superLike_Btn.frame.origin.y,width:60,height:60)
            boost_btn.frame=CGRect(x:boost_btn.frame.origin.x-10,y:boost_btn.frame.origin.y,width:60,height:60)
             goldIcon.frame=CGRect(x:goldIcon.frame.origin.x-10,y:goldIcon.frame.origin.y+10,width:28,height:28)
             plusIcon.frame=CGRect(x:plusIcon.frame.origin.x-10,y:plusIcon.frame.origin.y+15,width:28,height:28)
        
        }*/
        if accountKit == nil{
            self.accountKit=AKFAccountKit(responseType: .accessToken)
        }
        navigationCustom()
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")

        //goldTitleLabel.text = "\(k_Application_Name) gold"
        //plusTitleLabel.text = "\(k_Application_Name) +"
        
//        ScrollView.setContentOffset(CGPoint(x: 0, y: -ScrollView.contentInset.top), animated: false)
        ScrollView.setContentOffset(CGPoint(x: 0, y: -33.0), animated: false)

//        self.navigationController.
        delete_account.isHidden = false
        tableView.register(UINib(nibName: "SettingTableViewCell", bundle: nil), forCellReuseIdentifier: "SettingTableViewCellID")
        NotificationArr = ["New Match","Messages","Message Likes","Super likes","In-app vibrations","In-app Sounds"]
        LoginactionSheet.title = "Are you sure you want to log out?You will continue to be seen by compatible users in your last known location."
        LoginactionSheet.add(titleLabelWith: "Are you sure you want to log out?")
        
        let action1 = AFMAction(title: "LOG OUT", enabled: true) { (action: AFMAction) -> Void in
            print(action.title)
            weak var weakself = self
            weakself?.Logout()
        }
        
        let action3 = AFMAction(title: "CANCEL", handler: nil)
        LoginactionSheet.add(action1)
        LoginactionSheet.add(cancelling: action3)
        reachability.whenUnreachable={reachability in
            SwiftMessages.hide()
            
        }
        
        
        
        
        // GetSettignData()
        /*
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.goldPlanTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        tindergoldView.addGestureRecognizer(tapGesture)
        
        let plusTapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.plusPlanTapped(_:)))
        plusTapGesture.numberOfTapsRequired = 1
        plusTapGesture.numberOfTouchesRequired = 1
        tinderplusView.addGestureRecognizer(plusTapGesture)
        
        let boostTapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.getBoostTapped(_:)))
        boostTapGesture.numberOfTapsRequired = 1
        boostTapGesture.numberOfTouchesRequired = 1
        getBoostView.addGestureRecognizer(boostTapGesture)
        
        let superLikesTapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.getSuperLikesTapped(_:)))
        superLikesTapGesture.numberOfTapsRequired = 1
        superLikesTapGesture.numberOfTouchesRequired = 1
        getSuperLikeView.addGestureRecognizer(superLikesTapGesture)
        
        goldSymbolImage.frame = CGRect(x: goldTitleLabel.frame.origin.x - goldSymbolImage.frame.size.width - 2, y: goldSymbolImage.frame.origin.y, width:  goldSymbolImage.frame.size.width, height: goldSymbolImage.frame.size.height)
        
        plusSymbolImage.frame = CGRect(x: plusTitleLabel.frame.origin.x - plusSymbolImage.frame.size.width - 5, y: plusSymbolImage.frame.origin.y, width:  plusSymbolImage.frame.size.width, height: plusSymbolImage.frame.size.height)
        
        versionLabelOutlet.text = "Version \(String(describing: Bundle.main.infoDictionary!["CFBundleShortVersionString"]!))"
        self.tindergoldView.removeFromSuperview()
        self.tinderplusView.removeFromSuperview()
        self.getBoostView.removeFromSuperview()
        self.getSuperLikeView.removeFromSuperview()
 */

        // Do any additional setup after loading the view.
    }
 
    func showAlert() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        

        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Saved")
        })
        
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Deleted")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func goldPlanTapped(_:UIGestureRecognizer) {
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isGold = true
        destController.delegate = self
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    @objc func plusPlanTapped(_:UIGestureRecognizer) {
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isGold = false
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    @objc func getBoostTapped(_:UIGestureRecognizer) {
       let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isBoost = true
        destController.plusDelegate = self
        if self.objRecord!.plan_type == "Gold" || self.objRecord!.plan_type == "Plus" {
            destController.isPurchased = true
        }
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    @objc func getSuperLikesTapped(_:UIGestureRecognizer) {
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "GetBoostSuperLikeViewControllerID") as! GetBoostSuperLikeViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isBoost = false
        destController.plusDelegate = self
        if self.objRecord!.plan_type == "Gold" || self.objRecord!.plan_type == "Plus" {
            destController.isPurchased = true
        }
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    private func showLogoutAlert(){
        let optionMenuController = UIAlertController(title: nil, message: "Are you sure you want to log out? You will continue to be seen by compatible users in your last known location.", preferredStyle: .actionSheet)
        
        // Create UIAlertAction for UIAlertController
        
        let logoutAction = UIAlertAction(title: "LOG OUT", style: .destructive, handler: {
            (alert: UIAlertAction!) -> Void in
            if self.reachability.currentReachabilityStatus == .notReachable{
                self.showInternetError()
            }else{
            self.Logout()
            }
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        // Add UIAlertAction in UIAlertController
        
        optionMenuController.addAction(logoutAction)
        optionMenuController.addAction(cancelAction)
    
        
        // Present UIAlertController with Action Sheet
        
        self.present(optionMenuController, animated: true, completion: nil)

    }
    
    func Logout()
    {
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.logout as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                self.ScrollView.isHidden = false
                if ResponseDict != nil{
                    if((ResponseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1")
                        {
                            DatabaseHandler.sharedinstance.truncateDataForTable(tableName: Constant.sharedinstance.User_details)
                            Themes.sharedIntance.ClearUSerDetails()
                            self.appDel.MovetoRoot(status: "login")
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
                    let alert = UIAlertController(title: "Oops", message: "Please check you internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler:{action in
                        self.Logout()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                })
    }
    private func showInternetError(){
        let view: CustomInternet = try! SwiftMessages.viewFromNib()
        var successConfig = SwiftMessages.defaultConfig
        successConfig.duration = .forever
        successConfig.presentationStyle = .bottom
        view.configureBackgroundView(width: 8.0)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(config: successConfig, view: view)
    }
    @objc func tryAgainClicked(){
        if reachability.currentReachabilityStatus != .notReachable{
            self.ScrollView.isHidden=false
            self.navigationItem.rightBarButtonItem?.isEnabled=true
            self.GetSettignData()
            SwiftMessages.hide()
        }else{
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.objRecord=StaticData.allUserData!.setting
        StaticData.phonecode=StaticData.allUserData!.setting!.countryCode!
        StaticData.phonenumber=StaticData.allUserData!.setting!.phoneNumber!
        StaticData.emailVerified=StaticData.allUserData!.setting!.verifyEmail!
        StaticData.email=StaticData.allUserData!.setting!.email!
        StaticData.max=Int((objRecord?.maximum_age)!)
        StaticData.min=Int((objRecord?.minimum_age)!)
        if !isFromGenderPage && StaticData.email != nil && status == false{
                self.navigationItem.rightBarButtonItem?.isEnabled=true
            self.loadSettingData()
            
        }
        else {
            isFromGenderPage = false
        }
        if status == true{
            status == false
        }
        if StaticData.from == 1{
            objRecord=StaticData.allUserData!.setting!
           self.Reloadtable()
        }
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func loadSettingData(){
        /*
        if self.objRecord!.plan_type == "Gold" {
            self.tindergoldView.isHidden = true
            self.tinderplusView.isHidden = true
            self.getBoostView.frame = CGRect(x: self.tindergoldView.frame.origin.x, y: self.tindergoldView.frame.origin.y, width: self.getBoostView.frame.size.width, height: self.getBoostView.frame.size.height)
            self.getSuperLikeView.frame = CGRect(x: self.getSuperLikeView.frame.origin.x, y: self.tindergoldView.frame.origin.y, width: self.getSuperLikeView.frame.size.width, height: self.getSuperLikeView.frame.size.height)
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.getSuperLikeView.frame.origin.y + self.getSuperLikeView.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        }
        else if self.objRecord!.plan_type == "Plus" {
            //                    if self.objRecord.plan_type == "Gold" {
            self.tinderplusView.isHidden = true
            self.getBoostView.frame = CGRect(x: self.tinderplusView.frame.origin.x, y: self.tinderplusView.frame.origin.y, width: self.getBoostView.frame.size.width, height: self.getBoostView.frame.size.height)
            self.getSuperLikeView.frame = CGRect(x: self.getSuperLikeView.frame.origin.x, y: self.tinderplusView.frame.origin.y, width: self.getSuperLikeView.frame.size.width, height: self.getSuperLikeView.frame.size.height)
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.getSuperLikeView.frame.origin.y + self.getSuperLikeView.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        }*/
        self.locationName=objRecord!.city
        Reloadtable()
    }
    
    func GetSettignData()
    {
        /*
        ScrollView.isHidden = true
        self.present(self.loadingAlert!, animated: true, completion: {
        
        //Themes.sharedIntance.ShowProgress(view: self.view)
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.SettingPage as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
           // Themes.sharedIntance.RemoveProgress(view: self.view)
                if(ResponseDict != nil)
                {
                    if((ResponseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1")
                        {   self.objRecord.email=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                            StaticData.email=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                            StaticData.phonenumber=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "phone_number") as AnyObject)
                            StaticData.phonecode=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "phone_code") as AnyObject)
                            self.objRecord.phoneNumber=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "phone_number") as AnyObject)
                            self.objRecord.countryCode=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "phone_code") as AnyObject)
                            self.objRecord.community_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "community_url") as AnyObject)
                            self.objRecord.distance_type = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "distance_type") as AnyObject)
                            self.objRecord.distance_unit = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "distance_unit") as AnyObject)
                            self.objRecord.help_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "help_url") as AnyObject)
                            //                       self.objRecord.location = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "location") as AnyObject)
                            if Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "location") as AnyObject).count > 0 {
                                self.objRecord.locationDictArray = ResponseDict?.object(forKey: "location") as! [[String:Any]]
                            }
                            self.objRecord.max_age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "max_age") as AnyObject)
                            
                            self.objRecord.max_distance = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "max_distance") as AnyObject)
                            self.objRecord.minimum_distance = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "minimum_distance") as AnyObject)
                            self.objRecord.maximum_distance = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "maximum_distance") as AnyObject)
                            self.objRecord.plan_type = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "plan_type") as AnyObject)
                            self.objRecord.message_likes = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "message_likes") as AnyObject)
                            self.objRecord.min_age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "min_age") as AnyObject)
                            self.objRecord.minimum_age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "minimum_age") as AnyObject)
                            self.objRecord.maximum_age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "maximum_age") as AnyObject)
                            self.objRecord.new_match = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "new_match") as AnyObject)
                            self.objRecord.privacy_policy_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "privacy_policy_url") as AnyObject)
                            self.objRecord.profile_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "profile_url") as AnyObject)
                            self.objRecord.receiving_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "receiving_message") as AnyObject)
                            self.objRecord.safety_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "safety_url") as AnyObject)
                            self.objRecord.show_me = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "show_me") as AnyObject)
                            self.objRecord.gender = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "matching_profile") as AnyObject)
                            if self.objRecord.gender == "Both" {
                                self.objRecord.gender = "Men and Women"
                            }
                            self.objRecord.super_likes = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "super_likes") as AnyObject)
                            self.objRecord.verifyEmail=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email_verify") as AnyObject)
                            StaticData.emailVerified=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email_verify") as AnyObject)
                            self.objRecord.terms_of_service_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "terms_of_service_url") as AnyObject)
                            self.objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                            self.objRecord.username = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "username") as AnyObject)
                            self.objRecord.username = self.objRecord.username.removingWhitespaces()
                            self.locationName=Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "city") as AnyObject)
                            if self.objRecord.plan_type == "Gold" {
                                self.tindergoldView.isHidden = true
                                self.tinderplusView.isHidden = true
                                self.getBoostView.frame = CGRect(x: self.tindergoldView.frame.origin.x, y: self.tindergoldView.frame.origin.y, width: self.getBoostView.frame.size.width, height: self.getBoostView.frame.size.height)
                                self.getSuperLikeView.frame = CGRect(x: self.getSuperLikeView.frame.origin.x, y: self.tindergoldView.frame.origin.y, width: self.getSuperLikeView.frame.size.width, height: self.getSuperLikeView.frame.size.height)
                                self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.getSuperLikeView.frame.origin.y + self.getSuperLikeView.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
                            }
                            else if self.objRecord.plan_type == "Plus" {
                                //                    if self.objRecord.plan_type == "Gold" {
                                self.tinderplusView.isHidden = true
                                self.getBoostView.frame = CGRect(x: self.tinderplusView.frame.origin.x, y: self.tinderplusView.frame.origin.y, width: self.getBoostView.frame.size.width, height: self.getBoostView.frame.size.height)
                                self.getSuperLikeView.frame = CGRect(x: self.getSuperLikeView.frame.origin.x, y: self.tinderplusView.frame.origin.y, width: self.getSuperLikeView.frame.size.width, height: self.getSuperLikeView.frame.size.height)
                                self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.getSuperLikeView.frame.origin.y + self.getSuperLikeView.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
                            }
                                self.loadingAlert?.dismiss(animated: true, completion: {
                                    let loc=self.locationName
                                    self.Reloadtable()
                                    self.ScrollView.isHidden = false
                                })
                            
                            
                        }
                        else
                        {
                            
                            self.ScrollView.isHidden = false
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                            
                        }
                    }
                    else
                    {   self.ScrollView.isHidden = false
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                }
                else
                {
                    self.ScrollView.isHidden = false
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
        })
    })*/
    }
    func Reloadtable()
    {
        tableView.dataSource = self
        tableView.delegate = self

        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.frame.size.height = tableView.contentSize.height
        bottom_wrapperView.frame.origin.y = tableView.frame.origin.y + tableView.frame.size.height
        ScrollView.contentSize.height = bottom_wrapperView.frame.origin.y+bottom_wrapperView.frame.size.height
    }
    override func viewDidLayoutSubviews() {
        /*
        Themes.sharedIntance.addshadowtoView(view: tinderplusView,radius:7.0,ShadowColor:UIColor.lightGray)
        Themes.sharedIntance.addshadowtoView(view: getSuperLikeView,radius:7.0,ShadowColor:UIColor.lightGray)
        Themes.sharedIntance.addshadowtoView(view: tindergoldView,radius:7.0,ShadowColor:UIColor.lightGray)
        
        Themes.sharedIntance.addshadowtoView(view: tinderplusView,radius:7.0,ShadowColor:UIColor.lightGray)
        Themes.sharedIntance.addshadowtoView(view: getBoostView,radius:7.0,ShadowColor:UIColor.lightGray)

  //Themes.sharedIntance.addshadowtoView(view: delete_account,radius:7.0,ShadowColor:UIColor.lightGray)
Themes.sharedIntance.AddBorder(view: boost_btn, borderColor: nil, borderWidth:0.0 , cornerradius: boost_btn.frame.size.width/2)
        Themes.sharedIntance.AddBorder(view: superLike_Btn, borderColor: nil, borderWidth:0.0 , cornerradius: boost_btn.frame.size.width/2)
 */
        

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func DidclickDone(_ sender: Any) {
            if self.objRecord!.gender == "Guys and Girls" || self.objRecord!.gender == "Men and Women" {
                self.objRecord!.gender = "Both"
            }else if objRecord!.gender == "Guys"{
                self.objRecord!.gender = "Men"
            }else if self.objRecord!.gender == "Girls"{
                self.objRecord!.gender = "Women"
            }
            if StaticData.email != nil{
                self.objRecord!.email=StaticData.email!
                StaticData.email=nil
            }
            StaticData.allUserData?.setting=self.objRecord!
            print(StaticData.allUserData!.conservationNotStarted.count)
            self.navigationController?.dismiss(animated: true, completion: nil)
        if reachability.currentReachabilityStatus == .notReachable{
            StaticData.isPushed=true
        }else{
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"matching_profile":self.objRecord!.gender,"distance_type":self.objRecord!.distance_type,"distance":self.objRecord!.max_distance,"min_age":self.objRecord!.min_age,"max_age":self.objRecord!.max_age,"show_me":self.objRecord!.show_me,"new_matches":self.objRecord!.new_match,"messages":self.objRecord!.receiving_message,"message_likes":self.objRecord!.message_likes,"super_likes":self.objRecord!.super_likes,"latitude":"","longitude":"","email":self.objRecord!.email!,"phone_number":StaticData.phonenumber!,"phone_code":StaticData.phonecode!]
            
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.edit_settings as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
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
                }else{
                    let err=error as? NSError
                    if err?.code==401{
                    StaticData.isPushed=true
                    }
                }
                
        })
        }
    }
    
    @objc func doneSelected() {
        DidclickDone("")
    }
    
    func ShowLoginActionSheet()
    {
//        showAlert()
        self.present(LoginactionSheet, animated: true, completion: nil)

    }
    
    @IBAction func DidclickDelete(_ sender: Any) {
        let vc=AppStoryboard.Extra.viewController(viewControllerClass: DeleteAccountTableViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
extension SettingViewController:UITableViewDataSource,UITableViewDelegate

{
    func numberOfSections(in tableView: UITableView) -> Int {
        if(objRecord == nil)
        {
            return 0
        }
//        return 10
//        return 3
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        if(section == 1)
        {
            return 4
        }
        else if(section == 1)
        {
            return 1
        }
        else if(section == 2)
        {
            return 1
        }
        else if(section == 3)
        {
            return 1

        }
        else if(section == 4)
        {
//            return 6
            return 2

        }
        else if(section == 5)
        {
            return 1
        }
        else if(section == 6)
        {
            return 1
        }
        else if(section == 7)
        {
            return 1
        }
        else if(section == 8)
        {
            return 2
        }
        else if(section == 9)
        {
            return 3
        }
        else if(section == 10)
        {
            return 1
        }
        return 0

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "ACCOUNT SETTINGS"
        }
        else if( section == 1)
        {
            return "DISCOVERY SETTINGS"

        }
        else if(section == 4)
        {
            return "LEGAL"
        }
//       else  if( section == 2)
//        {
//            return "WEB PROFILE"
//
//        }
//        else  if( section == 3)
//        {
//            return "NOTIFICATION"
//
//        }
        else if(section == 3)
        {
            return "CONTACT US"
        }

//         else if(section == 6)
//         {
//            return "CONTACT US"
//         }
         else if(section == 8)
         {
            return "COMMUNITY"
         }
         else if(section == 9)
         {
            return "LEGAL"
        }
        return ""

    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.font = UIFont.boldSystemFont(ofSize: 14.0)
        }
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if section == 0{
        if let header = view as? UITableViewHeaderFooterView {
            if objRecord!.verifyEmail != nil{
                if objRecord!.verifyEmail == "0"{
            header.textLabel!.textColor = #colorLiteral(red: 0.9568628669, green: 0.2627450228, blue: 0.2117646933, alpha: 1)
                }else{
                   header.textLabel!.textColor = #colorLiteral(red: 0.380392164, green: 0.3803921342, blue: 0.3803921342, alpha: 1)
                }
        }
        }
    }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if( section == 2)
        {
            return "While turned off, you will not be shown in the card stack. You can still see your match and chat with them."
            
        }else if section == 0{
            if objRecord!.verifyEmail != nil{
                if objRecord!.verifyEmail == "0"{
                    return "Verify email to help secure your account."
                }else{
                    return "A verified phone number and email help secure your account."
                }
                }
            }
        
//        if( section == 2)
//        {
//            return "Create a public username. Share your username. Have people all over the world swipe your tinder"
//
//        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 40
        }
        else if(indexPath.section == 1)
        {
            if(indexPath.row == 0)
            {
                return 80

            }
            else if(indexPath.row == 1)
            {
                return 80
                
            }
               
                else if(indexPath.row == 3)
                {
                    return 80

                }
        }
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if( section == 2)
        {
            return 50

        }
        else if section == 0{
            return 40
        }
//        if( section == 2)
//        {
//            return 60
//
//        }
        return 10

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var SettingCell:SettingTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCellID") as? SettingTableViewCell
        let switchview = UISwitch(frame: CGRect.zero)
        SettingCell?.main_TxtLbl.textAlignment = .left
        switchview.onTintColor = Themes.sharedIntance.ReturnThemeColor()
        if(SettingCell == nil)
        {
            SettingCell = UITableViewCell(style: .value1, reuseIdentifier: "SettingTableViewCellID") as? SettingTableViewCell
        }
        SettingCell?.accessoryType = .none
        SettingCell?.detailTextLabel?.textColor = UIColor.darkGray

        SettingCell?.Detail_Lbl.isHidden = true
        SettingCell?.Slider.isHidden = true
        SettingCell?.DoubleSlider.isHidden = true
        SettingCell?.subtitleLbl.isHidden = true
        SettingCell?.main_TxtLbl.isHidden = false
        SettingCell?.textDetail.isHidden = true
        if indexPath.section == 0{
            if indexPath.row == 0{
            SettingCell?.main_TxtLbl.text = "Phone Number"
            SettingCell?.accessoryType = .disclosureIndicator
            SettingCell?.subtitleLbl.isHidden = false
                print(self.objRecord!.countryCode)
                if StaticData.phonenumber != nil && StaticData.phonecode != nil{
                    SettingCell?.subtitleLbl.text = "+"+StaticData.phonecode!+StaticData.phonenumber!}

                else{ SettingCell?.subtitleLbl.text = "+"+self.objRecord!.countryCode!+self.objRecord!.phoneNumber!}
            }else{
                SettingCell?.main_TxtLbl.text = "Email"
                SettingCell?.accessoryType = .disclosureIndicator
                SettingCell?.subtitleLbl.isHidden = false
                if StaticData.email != nil{
                    SettingCell?.subtitleLbl.text = StaticData.email!
                }else{
                SettingCell?.subtitleLbl.text = self.objRecord!.email!
                }
                StaticData.email=self.objRecord!.email!
                
            }
        }
        else if(indexPath.section == 1)
        {


            if(indexPath.row == 0)
            {
                var location:String?
                SettingCell?.Detail_Lbl.isHidden = false
                
                SettingCell?.textDetail.text = "Location"
                SettingCell?.Detail_Lbl.text = "My current location"
//                SettingCell?.subtitleLbl.text = objRecord.location
                for locationDict in objRecord!.locationDictArray {
                    if (locationDict["default"] != nil){
                        print(locationDict["default"])
                    if (locationDict["default"] as? String) == "Active" {
                        location = (locationDict["location"]! as! String)
                    }else{
                        location="Home"
                        }
                    }else{
                        location="Home"
                    }
                }
                let loc=location
                print(location)
                if location != "My Current Location" && location != nil{
                    SettingCell?.subtitleLbl.text=location!
                }else{
                    SettingCell?.subtitleLbl.text=self.locationName!
                }
                //SettingCell?.accessoryType = .disclosureIndicator
                SettingCell?.Slider.isHidden = true
                SettingCell?.subtitleLbl.isHidden = false
                SettingCell?.main_TxtLbl.isHidden = true
                SettingCell?.textDetail.isHidden = false


             }
           else if(indexPath.row == 1)
            {
                SettingCell?.Detail_Lbl.isHidden = false
                
                SettingCell?.textDetail.text = "Maximum Distance"
                SettingCell?.Detail_Lbl.text = "\(objRecord!.max_distance) \(objRecord!.distance_unit)"
                SharedVariables.sharedInstance.distanceUnit = "\(objRecord!.distance_unit)"
                SettingCell?.Slider.minimumValue = (objRecord!.minimum_distance as NSString).floatValue
                SettingCell?.Slider.maximumValue  = (objRecord!.maximum_distance as NSString).floatValue
                SettingCell?.Slider.value = Float(objRecord!.max_distance)!
                SettingCell?.Slider.isHidden = false
                SettingCell?.subtitleLbl.isHidden = true
                SettingCell?.main_TxtLbl.isHidden = true
                SettingCell?.textDetail.isHidden = false
                SettingCell?.Slider.addTarget(self, action: #selector(self.DistanceChaged(Slider:)), for: .valueChanged)

                
            }
           else if(indexPath.row == 2)
            {
 
                SettingCell?.main_TxtLbl.text = "Show Me"
                SettingCell?.accessoryType = .disclosureIndicator
                SettingCell?.subtitleLbl.isHidden = false
                if self.objRecord!.gender == "Both"{
                    SettingCell?.subtitleLbl.text = "Guys and Girls"
                }else{
                    if self.objRecord!.gender == "Men"{
                SettingCell?.subtitleLbl.text = "Guys"
                    }else if self.objRecord!.gender == "Women"{
                        SettingCell?.subtitleLbl.text = "Girls"
                    }else if self.objRecord!.gender == "Men and Women"{
                        SettingCell?.subtitleLbl.text = "Guys and Girls"
                    } else{
                        SettingCell?.subtitleLbl.text = objRecord!.gender
                    }
                
                }
            }
           else if(indexPath.row == 3)
            {
                SettingCell?.Detail_Lbl.isHidden = false
                 SettingCell?.textDetail.text = "Age Range"
                
                if self.objRecord!.max_age == objRecord!.maximum_age {
                    SettingCell?.Detail_Lbl.text = "\(self.objRecord!.min_age)-\(self.objRecord!.max_age)+"
                }
                else {
                    SettingCell?.Detail_Lbl.text = "\(self.objRecord!.min_age)-\(self.objRecord!.max_age)"
                }
                
                SettingCell?.textDetail.isHidden = false
                SettingCell?.Slider.isHidden = true
                SettingCell?.subtitleLbl.isHidden = true
                SettingCell?.main_TxtLbl.isHidden = true
                SettingCell?.DoubleSlider.isHidden = false
                 let min = NumberFormatter().number(from: objRecord!.min_age)
                SettingCell?.delegate = self
                let max = NumberFormatter().number(from: objRecord!.max_age)
                SettingCell?.endMaxValue = Int((objRecord!.maximum_age as NSString).intValue)
                
                let minSeek = NumberFormatter().number(from: objRecord!.minimum_age)
                SettingCell?.delegate = self
                let maxSeek = NumberFormatter().number(from: objRecord!.maximum_age)
                if #available(iOS 12, *) {
                SettingCell?.DoubleSlider.minimumValue = CGFloat(minSeek!)-3.5
                }else{
                    SettingCell?.DoubleSlider.minimumValue = CGFloat(minSeek!)
                }
                var systemVersion = UIDevice.current.systemVersion
                if #available(iOS 12, *) {
                SettingCell?.DoubleSlider.maximumValue = CGFloat(maxSeek!)+3.5
                }else{
                    SettingCell?.DoubleSlider.maximumValue = CGFloat(maxSeek!)
                }
                SettingCell?.DoubleSlider.value = [CGFloat(min!),CGFloat(max!)]
                
                
              }

        }
      else if(indexPath.section == 2)
        {
            
            SettingCell?.main_TxtLbl.text = "Show me on \(k_Application_Name)"
            switchview.isOn = (objRecord!.show_me == "yes") ? true:false
             SettingCell?.accessoryView = switchview
                switchview.addTarget(self, action: #selector(showMeClicked), for: .valueChanged)
                
            

         }
         

//         else if(indexPath.section == 2)
//         {
//            SettingCell?.Detail_Lbl.frame.origin.y = 31
//            SettingCell?.main_TxtLbl.text = "\(objRecord.username)"
//            SettingCell?.Detail_Lbl.isHidden = false
//            SettingCell?.Detail_Lbl.text = "Claim yours"
//            SettingCell?.accessoryType = .disclosureIndicator
//        }
//         else if(indexPath.section == 3)
//         {
//            SettingCell?.main_TxtLbl.text = NotificationArr[indexPath.row]
//
//            SettingCell?.accessoryType = .disclosureIndicator
//            if(indexPath.row == 0)
//            {
//                switchview.isOn = (objRecord.new_match == "yes") ? true:false
//
//            }
//            else  if(indexPath.row == 1)
//            {
//                switchview.isOn = (objRecord.receiving_message == "yes") ? true:false
//
//            }
//         else if(indexPath.row == 2)
//            {
//                switchview.isOn = (objRecord.message_likes == "yes") ? true:false
//
//            }
//          else  if(indexPath.row == 3)
//            {
//                switchview.isOn = (objRecord.super_likes == "yes") ? true:false
//
//            }
//            switchview.addTarget(self, action: #selector(NotificationChanged(_switch:)), for: .valueChanged)
//
//           switchview.tag = indexPath.row
//            SettingCell?.accessoryView = switchview
//
//
//
//         }
         else if(indexPath.section == 3)
         {
            
            SettingCell?.main_TxtLbl.text = "Help & support"
            
            SettingCell?.accessoryType = .disclosureIndicator
            
         }
         else if(indexPath.section == 4)
         {
            if(indexPath.row == 0)
            {
                SettingCell?.main_TxtLbl.text = "Privacy Policy"
                
            }
            if(indexPath.row == 1)
            {
                SettingCell?.main_TxtLbl.text = "Terms of Service"
                
            }
            if(indexPath.row == 2)
            {
                SettingCell?.main_TxtLbl.text = "Licenses"
                
            }
            SettingCell?.accessoryType = .disclosureIndicator
            
            
         }
         
         
            
//         else if(indexPath.section == 3)
//         {
//            SettingCell?.main_TxtLbl.text = "Log out"
//            SettingCell?.main_TxtLbl.textAlignment = .center
//
//
//         }
/*
        else if(indexPath.section == 4)
         {
            SettingCell?.main_TxtLbl.text = "Restore Purchase"
            SettingCell?.main_TxtLbl.textAlignment = .center
        }
 */
         else if(indexPath.section == 7)
         {
            SettingCell?.main_TxtLbl.text = "Delete My Account"
            SettingCell?.main_TxtLbl.textAlignment = .center
            SettingCell?.main_TxtLbl.textColor=#colorLiteral(red: 0.9568628669, green: 0.2627450228, blue: 0.2117646933, alpha: 1)
            
            
            
            
            
         }
      /*
         else if(indexPath.section == 5)
         {
            SettingCell?.main_TxtLbl.text = "Share Tinder"
            SettingCell?.main_TxtLbl.textAlignment = .center

        }
 */
         else if(indexPath.section == 5)
         {
            SettingCell?.main_TxtLbl.text = "Log out"
            SettingCell?.main_TxtLbl.textAlignment = .center
            


        }

         else if(indexPath.section == 8)
         {
            SettingCell?.main_TxtLbl.text = "Help & support"
            
            SettingCell?.accessoryType = .disclosureIndicator
            
            

            
        }
         else if(indexPath.section == 9)
         {
            if(indexPath.row == 0)
            {
                SettingCell?.main_TxtLbl.text = "Community Guidelines"
                
            }
            if(indexPath.row == 1)
            {
                SettingCell?.main_TxtLbl.text = "Safety tips"
                
            }
            SettingCell?.accessoryType = .disclosureIndicator
            
            

            
        }
         else if(indexPath.section == 10)
         {
            if(indexPath.row == 0)
            {
                SettingCell?.main_TxtLbl.text = "Privacy Policy"
                
            }
            if(indexPath.row == 1)
            {
                SettingCell?.main_TxtLbl.text = "Terms of Service"
                
            }
            if(indexPath.row == 2)
            {
                SettingCell?.main_TxtLbl.text = "Licenses"
                
            }
            SettingCell?.accessoryType = .disclosureIndicator
            
            

            
         }else if indexPath.section == 11{
            SettingCell?.main_TxtLbl.text = "Log out"
            SettingCell?.main_TxtLbl.textAlignment = .center
        }
        
        return SettingCell!
    }
    
   
    func NotificationChanged(_switch:UISwitch)
    {
        if(_switch.tag == 0)
        {
            objRecord!.new_match = (_switch.isOn == true) ? "yes":"no"
        }
        if(_switch.tag == 1)
        {
            objRecord!.receiving_message = (_switch.isOn == true) ? "yes":"no"

        }
        if(_switch.tag == 2)
        {
            objRecord!.message_likes = (_switch.isOn == true) ? "yes":"no"

        }
        if(_switch.tag == 3)
        {
            objRecord!.super_likes = (_switch.isOn == true) ? "yes":"no"

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
                accountKit.logOut()
                let vc=AppStoryboard.Extra.viewController(viewControllerClass: PhoneNumberViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc=AppStoryboard.Extra.viewController(viewControllerClass: EmailVerificationViewController.self)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if(indexPath.section == 1)
        {
            
            
            if(indexPath.row == 0)
            {/*
                let locVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewControllerID") as! LocationViewController
                locVC.addressDictArray = objRecord!.locationDictArray
                locVC.planType = self.objRecord!.plan_type
                self.navigationController?.pushViewController(locVC, animated: true)*/

            }
            else if(indexPath.row == 2)
            {
                
                let LocVC = self.storyboard?.instantiateViewController(withIdentifier: "GenderListViewControllerID") as! GenderListViewController
                  LocVC.Delegate = self
                let gender=objRecord!.gender
                if objRecord!.gender == "Both"{
                    LocVC.Choosenname = "Guys and Girls"
                }else{
                    if objRecord!.gender == "Men"{
               LocVC.Choosenname = "Guys"
                    }else if objRecord!.gender == "Women"{
                        LocVC.Choosenname="Girls"
                    }else if objRecord!.gender == "Men and Women"{
                        LocVC.Choosenname="Guys and Girls"
                    }else{
                        LocVC.Choosenname=self.objRecord!.gender
                    }
                }
                self.navigationController?.pushViewController(LocVC, animated: true)

                
            }
        }
        else if(indexPath.section == 3)
        {
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            let webViewController = TOWebViewController(url: URL(string: objRecord!.help_url)!)
            self.navigationController?.pushViewController(webViewController, animated: true)
            
            
        }
//        else if(indexPath.section == 3)
//        {
//
////                let LocVC = self.storyboard?.instantiateViewController(withIdentifier: "UsernameViewControllerID") as! UsernameViewController
////                   LocVC.user_name = objRecord.username
////                self.navigationController?.pushViewController(LocVC, animated: true)
//            ShowLoginActionSheet()
//
//         }
        else if(indexPath.section == 4)
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
            if(indexPath.row == 0)
            {
                let webViewController = TOWebViewController(url: URL(string: objRecord!.privacy_policy_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)
                
                
            }
            if(indexPath.row == 1)
            {
                let webViewController = TOWebViewController(url: URL(string: objRecord!.terms_of_service_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)
                
                
            }
            if(indexPath.row == 2)
            {
                let webViewController = TOWebViewController(url: URL(string: objRecord!.terms_of_service_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)
                
            }

        }
        else if(indexPath.section == 7)
        {
            let vc=AppStoryboard.Extra.viewController(viewControllerClass: DeleteAccountTableViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if(indexPath.section == 5)
        {
            self.showLogoutAlert()
            
        }

            
        
            
            else if(indexPath.section == 6)
        {
            let text = "Check out \(k_Application_Name) ...it shows you who likes you nearby! \(Constant.sharedinstance.MainUrl)"
              let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
             self.present(activityViewController, animated: true, completion: nil)

        }
         else if(indexPath.section == 10)
        {
            ShowLoginActionSheet()
        }
//        else if(indexPath.section == 6)
//        {
//
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//
//            let webViewController = TOWebViewController(url: URL(string: objRecord.help_url)!)
//            self.navigationController?.pushViewController(webViewController!, animated: true)
//
//
//        }
            
        else if(indexPath.section == 8)
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            if(indexPath.row == 0)
            {
                let webViewController = TOWebViewController(url: URL(string: objRecord!.community_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)


            }
            if(indexPath.row == 1)
            {
                 let webViewController = TOWebViewController(url: URL(string: objRecord!.safety_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)


                
            }
 
            
        }
        else if(indexPath.section == 9)
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)

            if(indexPath.row == 0)
            {
                let webViewController = TOWebViewController(url: URL(string: objRecord!.privacy_policy_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)


            }
            if(indexPath.row == 1)
            {
                 let webViewController = TOWebViewController(url: URL(string: objRecord!.terms_of_service_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)

                
            }
            if(indexPath.row == 2)
            {
                let webViewController = TOWebViewController(url: URL(string: objRecord!.terms_of_service_url)!)
                self.navigationController?.pushViewController(webViewController, animated: true)

            }
            
            
        }
        
    }
    func SliderValue(minValue: CGFloat, maxValue: CGFloat) {
        let min = Int(round(minValue))
        let max = Int(round(maxValue))
        objRecord!.min_age = "\(min)"
        objRecord!.max_age = "\(max)"
    }
 
    
    @objc func DistanceChaged(Slider:UISlider)    {
    
    let Distance = Int(round(Slider.value)) // x is Int         self.Detail_Lbl.text = "\(Distance) KM"
    
    objRecord!.max_distance = "\(Distance)"
    }
    func ReturnChoosenname(Str: String, isFromGender:Bool) {
       objRecord!.gender = Str
        isFromGenderPage = isFromGender
        isGenderChanged = isFromGender
         tableView.reloadData()
    }
    
    func purchaseDone() {
//        let alert = UIAlertController(title: "Transaction Success!!", message: "Thank you for purchasing, Start enjoying with new features", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: ()))
        
        let alertController = UIAlertController(title: "Transaction Success!!", message: "Thank you for purchasing, Start enjoying with new features", preferredStyle: .alert)
        
        // Create the action
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.DidclickDone(_:"")
        }
        
        // Add the actions
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showPlusView() {
        
        let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
        destController.modalTransitionStyle = .crossDissolve
        destController.isGold = false
        self.navigationController?.present(destController, animated: true, completion: nil)
    }
    
    @objc func showMeClicked(switchValue: UISwitch) {
        
        if switchValue.isOn {
            objRecord!.show_me = "yes"
        }
        else {
            objRecord!.show_me = "no"
        }
    }
    
    func getProducts() {
        
        
        
//        if (SKPaymentQueue.canMakePayments()) {
//            SKPaymentQueue.default().restoreCompletedTransactions()
//        }

        
        Subscribtion.store.requestProducts{success, products in
            if success {
                
                print("Products List:")
                for p in products! {
                    print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
//                    self.productList.append(p)
                }
            }
            else {
                
            }
        }
    }
    
    
}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

