//
//  PhoneNumberViewController.swift
//  Ello.ie
//
//  Created by Rana Asad on 14/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import AccountKit
class PhoneNumberViewController: UIViewController,AKFViewControllerDelegate {

    @IBOutlet weak var texfiled: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var firstView: UIView!
    private var accountKit:AKFAccountKit!
    private var isFirstCall=false
    override func viewDidLoad() {
        super.viewDidLoad()
        if accountKit == nil{
            self.accountKit=AKFAccountKit(responseType: .accessToken)
        }
        secondView.isUserInteractionEnabled=true
        label.isUserInteractionEnabled=true
        firstView.layer.borderColor=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        firstView.layer.borderWidth=0.3
        secondView.layer.borderColor=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        secondView.layer.borderWidth=0.3 
        texfiled.text=StaticData.phonecode!+StaticData.phonenumber!
        let tapView = UITapGestureRecognizer(target: self, action: #selector(verifyNumber))
        secondView.addGestureRecognizer(tapView)
        label.addGestureRecognizer(tapView)
        //NotificationCenter.default.addObserver(self, selector: #selector(loadChats), name:Notification.Name("NewMessageReceived"), object: nil)
    }
    @objc func loadChats(){
        if isFirstCall == false{
            self.isFirstCall=true
            StaticData.allUserData!.conservationStarted.removeAll()
            StaticData.allUserData!.conservationNotStarted.removeAll()
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.match_details as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                if responseDict != nil{
                    if((responseDict?.count)! > 0)
                    {
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
                                    
                                    StaticData.allUserData?.conservationNotStarted.removeAll()
                                    StaticData.allUserData?.conservationNotStarted.append(objRecord)
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
                                    StaticData.allUserData?.conservationStarted.removeAll()
                                    StaticData.allUserData?.conservationStarted.append(objRecord)
                                    self.isFirstCall=false
                                }
                                
                            }
                            
                            
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
    }
    @objc func verifyNumber(){
        changePhoneNumber()
    }
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        accountKit.requestAccount {
            (account, error) -> Void in
            print(error)
            let countrycode=account?.phoneNumber?.countryCode
            let phonenumber=account?.phoneNumber?.phoneNumber
            let token=accessToken.tokenString
            StaticData.phonenumber=phonenumber!
            StaticData.phonecode=countrycode!
            StaticData.from=1
            StaticData.allUserData!.setting!.phoneNumber=phonenumber!
            StaticData.allUserData!.setting!.countryCode=countrycode!
            self.navigationController?.popToRootViewController(animated: true)
            
            
        }
        
        
    }
    func changePhoneNumber(){
        let inputState=UUID().uuidString
        let viewController=accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook=true
        self.prepareLoginViewController(loginViewController: viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
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

}
