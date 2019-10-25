//
//  Constant.swift
//  Tinder Clone
//
//  Created by Vaigunda Anand M on 8/19/17.
//  Copyright © 2017 Anonymous. All rights reserved.
//

import UIKit

var BaseUrl = "http://orla.ie/api/"
var k_TermsAndConditionsURL = "http://orla.ie/page/terms_of_use"
var k_PrivacyPolicyURL = "http://orla.ie/page/privacy_policy"

//var BaseUrl = "http://igniter.trioangle.com/api/"
//var k_TermsAndConditionsURL = "http://igniter.trioangle.com/page/terms_of_use"
//var k_PrivacyPolicyURL = "http://igniter.trioangle.com/page/privacy_policy"

//var BaseUrl = "http://orla.ie/api/"
//var k_TermsAndConditionsURL = "http://orla.ie/page/terms_of_use"
//var k_PrivacyPolicyURL = "http://orla.ie/page/privacy_policy"



let k_Application_Name = "Ello"
let k_GoogleAPI_Key = "AIzaSyBcGTz2EbBDjDvTEFbHO0J8SaRbQrEWjlU"



class Constant: NSObject {
//    var MainUrl = "http://demo.trioangle.com/smash/igniter/"
    var MainUrl = "http://smash.trioangle.com/smash/igniter/"
    static let sharedinstance = Constant()
    var isFromFBLogin = Bool()
    var fbLoginRecords = LoginRecord()
    var Phonenumberlimit:Int = 10;
    let Logincompleted = Notification.Name("Logincompleted")
    let PhoneVerfication = Notification.Name("PhoneVerfication")
     let ChangeIndex = Notification.Name("Changeindex")
     let splashUrl:String = "\(BaseUrl)login_slider"
    let FbSignUpUrl:String = "\(BaseUrl)socialsignup"
    let fbPhoneSignUpUrl = "\(BaseUrl)fb_phone_signup"
    let Phonenumber_Verfication = "\(BaseUrl)phone_number_verification"
    let Phonenumber_Signup = "\(BaseUrl)signup"
    let errorMessage = "Unable to connect"
    let User_details:String = "User_details"
    let SettingPage:String = "\(BaseUrl)user_settings"
    let username_claim:String = "\(BaseUrl)username_claim"
    let edit_settings:String = "\(BaseUrl)edit_settings"
    let update_settings:String="\(BaseUrl)update_profile_and_settings"
    let home_page:String = "\(BaseUrl)home_page"
    let updatelocation:String = "\(BaseUrl)insertlocation"
    let defaultLocaion:String = "\(BaseUrl)defaultLocaion"
    let update_device = "\(BaseUrl)update_device"
    let matching_profiles:String = "\(BaseUrl)matching_profiles"
    let logout:String = "\(BaseUrl)logout"
    let login:String = "\(BaseUrl)login"
    let swipe_profiles:String = "\(BaseUrl)swipe_profiles"
    let liked_users_details:String = "\(BaseUrl)liked_users_details"
    let other_profile_view:String = "\(BaseUrl)other_profile_view"
    let own_profile_view:String = "\(BaseUrl)own_profile_view"
    let match_details:String = "\(BaseUrl)match_details"
    let message_conversation:String = "\(BaseUrl)message_conversation"
//    let message_conversation:String = "\(BaseUrl)message_conversation_grouped"
    let send_message:String = "\(BaseUrl)send_message"
    let profileView:String = "\(BaseUrl)own_profile_view"
    let EditprofileView:String = "\(BaseUrl)edit_profile"
    let reason_delete:String="\(BaseUrl)reasons_delete"
    let unmatch_delete:String="\(BaseUrl)unmatch_details"
    let updateProfileView:String = "\(BaseUrl)update_profile"
    var iconfontname:String = "tinder-clone"
    let uploadProfileImageUrl:String = "\(BaseUrl)upload_profile_image"
    
    let unmatch_details:String = "\(BaseUrl)unmatch_details"
    let report_details:String = "\(BaseUrl)report_details"
    let unmatch_account:String = "\(BaseUrl)unmatch_account"
    let report_account:String = "\(BaseUrl)report_account"
    
    let boost_plan_slider:String = "\(BaseUrl)boost_plan_slider"
    let super_gold_details:String = "\(BaseUrl)super_gold_details"
    let plan_slider:String = "\(BaseUrl)plan_slider"
    let update_first_image = "\(BaseUrl)update_profile_image"
    
    let remove_profile_image:String = "\(BaseUrl)remove_profile_image"
    let after_payment:String = "\(BaseUrl)after_payment"
    let add_user_boost:String = "\(BaseUrl)add_user_boost"
    let verify_receipt = "\(BaseUrl)verify_receipt"
    let delete_account="\(BaseUrl)delete_account"
    let change_email="\(BaseUrl)send_email_otp"
    let verify_email="\(BaseUrl)verify_email_otp"
    let user_data="\(BaseUrl)user_data"
    let all_plans_data="\(BaseUrl)plans"

//    static let k_Application_Name = "Igniter"
    static let k_GoldColorCode = UIColor(red: 218.0/255.0, green: 165.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    
    static let k_CurrencyCode = "₹"

 
 }
