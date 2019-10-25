//
//  SplashViewController.swift
//  Igniter
//
//  Created by Rana Asad on 23/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import RevealingSplashView
class SplashViewController: UIViewController {
    private var allUserData:AllUserData=AllUserData()
    private let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo")!,iconInitialSize: CGSize(width: 80, height: 80), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    override func viewDidLoad() {
        super.viewDidLoad()
        StaticData.allUserData=nil
        StaticData.updated=true
        if ConfigManager.getInstance().getFirstTap() != nil{
        if ConfigManager.getInstance().getFirstTap() == "YES"{
            StaticData.isFirstSignUp=true
        }
        }
        if ConfigManager.getInstance().getFirstLike() != nil{
        if ConfigManager.getInstance().getFirstLike() == "YES"{
            StaticData.isFirstTime=true
        }
        }
        self.view.addSubview(revealingSplashView)
        if ConfigManager.getInstance().getImageUpload() != nil{
            if ConfigManager.getInstance().getImageUpload() == "Yes"{
                StaticData.imageUpload=ConfigManager.getInstance().imageForKey()
            }
        }
        
        self.getData()
        (UIApplication.shared.delegate as! AppDelegate).notificationPermission()

        // Do any additional setup after loading the view.
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
        
        // Get Chat History from here
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
