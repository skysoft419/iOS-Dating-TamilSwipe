//
//  Themes.swift
 //
//  Created by Vaigunda Anand M on 4/8/17.
 //

import UIKit
import SwiftMessages

import MMLocalization
import MBProgressHUD



class Themes: NSObject {
    
    static let sharedIntance = Themes()
    var Activity:MBProgressHUD = MBProgressHUD()
    var chatButton: UIButton = UIButton()

//    func ReturnThemeColor()->UIColor
//    {
//        return UIColor(red:0.99, green:0.31, blue:0.41, alpha:1.0)
//     }
    
    func ReturnThemeColor()->UIColor
    {
     
        return UIColor(red: 251/255, green: 82/255, blue: 105/255, alpha: 1.0)
        
    }
    func ReturnGoldenColor()->UIColor
    {
        return UIColor(red:1.00, green:0.87, blue:0.00, alpha:1.0)
    }
    
    func ReturnSecondryThemeColor()->UIColor
    {
        return UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.1)
    }
    
    func setChatGradientTopColor(topColor:String)
    {
        UserDefaults.standard.set(topColor, forKey: "topcolor")
    }
    
    func getChatGradientTopColor()->UIColor
    {
        if let color = UserDefaults.standard.value(forKey: "topcolor"){
            return UIColor(hex: color as! String)
        }else{
            return UIColor(hex: "#43cea2")
        }
    }
    
    func setChatGradientBottomColor(bottomColor:String)
    {
        UserDefaults.standard.set(bottomColor, forKey: "bottomcolor")
    }
    
    func getChatGradientBottomColor()->UIColor
    {
        if let color = UserDefaults.standard.value(forKey: "bottomcolor"){
            return UIColor(hex: color as! String)
        }else{
            return UIColor(hex: "#185a9d")
        }
    }
    
    func GetAppName()->String
    {
     return   Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

    }
    
    func addshadowtoView(view:AnyObject,radius:CGFloat,ShadowColor:UIColor)
    {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = radius
        // if you like rounded corners
        view.layer.shadowOffset = CGSize(width: CGFloat(-0.5), height: CGFloat(0.5))
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = 0.3
        view.layer.shadowColor = ShadowColor.cgColor
        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
     }
    
    func ShowActivity(view:UIView)
    {
 

        
    }
    
    func saveUserID(userid:String)
    {
        UserDefaults.standard.setValue(userid, forKey: "userid")

    }
    
    func getaccesstoken()->String?
    {
 return (UserDefaults.standard.value(forKey: "token") as? String)
    }
    
    func saveaccesstoken(userid:String)
    {
        UserDefaults.standard.setValue(userid, forKey: "token")
        
    }
    func saveUserImage(userid:String)
    {
        UserDefaults.standard.setValue(userid, forKey: "userimage")
        
    }
    func removeUserImage(){
        UserDefaults.standard.removeObject(forKey: "userimage")
    }
    func getUserImage()->String?
    {
        return (UserDefaults.standard.value(forKey: "userimage") as? String)
    }
    func getDeviceID()->String?
    {
        return (UserDefaults.standard.value(forKey: "DeviceID") as? String)
    }
    
    func saveDeviceID(deviceID:String)
    {
        UserDefaults.standard.setValue(deviceID, forKey: "DeviceID")
        
    }
    
    func getuserID()->String?
    {
        return (UserDefaults.standard.value(forKey: "userid") as? String)
    }
    
    func saveUsername(username:String)
    {
        UserDefaults.standard.setValue(username, forKey: "username")

        
    }
    
    func CheckLogin()->Bool
    {
        if(self.getuserID() == nil || self.getuserID() == "")
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    func getusername()->String?
    {
        return (UserDefaults.standard.value(forKey: "username") as? String)
    }
    
func saveUserpassword(password:String)
    {
        UserDefaults.standard.setValue(password, forKey: "password")

    }

    func getUnreadCount() -> Int?
    {
        return (UserDefaults.standard.value(forKey: "unread_count") as? Int)
    }
    
    func saveUnreadCount(unread_count: Int)
    {
        UserDefaults.standard.setValue(unread_count, forKey: "unread_count")
        let chatButton = self.chatButton
        
        print("Unread count: \(unread_count)");
//        if chatButton.imageView?.image == nil && unread_count > 0 {
//            chatButton.setImage(#imageLiteral(resourceName: "dot_icon"), for: .normal)
//        } else if chatButton.imageView?.image != nil && unread_count == 0 {
//            chatButton.setImage(nil, for: .normal)
//        }
        chatButton.imageView?.frame.size.height=24
        chatButton.imageView?.frame.size.width=24
        if unread_count > 0 {
            chatButton.setImage(#imageLiteral(resourceName: "dot_icon"), for: .normal)
        }
        else if unread_count == 0 {
            chatButton.setImage(nil, for: .normal)
        }
        
        
    }
    
func getuserpassword()->String?
{
    return (UserDefaults.standard.value(forKey: "password") as? String)
}
    
    
    func saveLCOstatus(password:String)
    {
        
        UserDefaults.standard.setValue(password, forKey: "lcostatus")
    }
    
    func GetLCOstatus()->String?
    {
        return (UserDefaults.standard.value(forKey: "lcostatus") as? String)
    }

    
    func saveActivationstatus(password:String)
    {
        UserDefaults.standard.setValue(password, forKey: "actstatus")
        
    }
    
    func getActivationstatus()->String?
    {
        return (UserDefaults.standard.value(forKey: "actstatus") as? String)
    }

    
    func saveUsermobileno(password:String)
    {
        UserDefaults.standard.setValue(password, forKey: "mobileno")
        
    }
    
    func getusermobileno()->String?
    {
        return (UserDefaults.standard.value(forKey: "mobileno") as? String)
    }
    func saveLoginDetails(loginDetails:NSDictionary!)
    {
        UserDefaults.standard.setValue(loginDetails, forKey: "loginDetails")
        
    }
    
    func getLoginDetails()->NSDictionary?
    {
        return (UserDefaults.standard.value(forKey: "loginDetails") as? NSDictionary)
    }
    
    
    
    
    
    func showErrorMsg(view:UIView, withMsg:String){
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.error)
        success.configureDropShadow()
        if(withMsg == "Can't able to reach the network")
        {
         }
        else
        {
            success.configureContent(title: k_Application_Name, body: withMsg)
            
        }
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        if(withMsg != "")
        {
        SwiftMessages.show(config: successConfig, view: success)
        }
    }
    func showSuccessMsg(view:UIView, withMsg:String){
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.success)
        success.configureDropShadow()
        success.configureContent(title: "Success !!", body: withMsg)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        SwiftMessages.show(config: successConfig, view: success)
     }
    
    func showSuccessMsgInBottom(view:UIView, withMsg:String){
        let success = MessageView.viewFromNib(layout: .cardView)
        success.configureTheme(.info)
        success.configureDropShadow()
        success.configureContent(title: "OTP", body: withMsg)
        success.button?.isHidden = true
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .bottom
        SwiftMessages.show(config: successConfig, view: success)
    }

    func CheckNullvalue(Str:AnyObject?)->String
    {
        var PassedValue:AnyObject? = Str!
        let x: AnyObject = NSNull()
        
        if(PassedValue == nil || PassedValue == x as! _OptionalNilComparisonType)
        {
            PassedValue = "" as String as AnyObject
        }
        else
        {
            PassedValue = "\(PassedValue!)" as AnyObject
        }
        if(String(describing:PassedValue!) == "<null>")
        {
           return ""
        }
        return PassedValue as! String
    }
    
    func CheckNullForString(Str:Any?)->String
    {
        var PassedValue:Any? = Str
        let x: Any = NSNull()
        
        if(PassedValue == nil || PassedValue == x as! _OptionalNilComparisonType)
        {
            PassedValue = "" as String as AnyObject
        }
        else
        {
            PassedValue = "\(PassedValue!)" as AnyObject
        }
        if(String(describing:PassedValue!) == "<null>")
        {
            return ""
        }
        return PassedValue as! String
    }
    
    func CheckNullForInt(input_value:Any?)->Int
    {
        if let int_value = input_value as? Int {
            return int_value
        }
        return 0
    }
    
    func isPaymentLive()->Bool
    {
        return true
    }
    
    func AddBorder(view:AnyObject,borderColor:UIColor?,borderWidth:CGFloat?,cornerradius:CGFloat?)
    {
        if(borderColor != nil)
        {
            view.layer.borderColor = borderColor!.cgColor
        }
        if(borderWidth != nil)
        {
            view.layer.borderWidth = borderWidth!
            
        }
        if(cornerradius != nil)
        {
        view.layer.cornerRadius=cornerradius!
        }
        view.layer.masksToBounds=true
        
    }
    func adjustFrame(array:NSArray){
        var previousControl:UIView=UIView()
        for i in 0..<array.count {
            
            let control = array.object(at: i) as! UIView
            
            if(i==0){
                
                previousControl = control
            }else{
                var spaceVal:CGFloat=15
                
                if(control.isKind(of: UIButton.self)){
                    spaceVal=20
                }
                
                let currentControl = array.object(at: i) as! UIView
                currentControl.frame=CGRect(x: currentControl.frame.origin.x, y: previousControl.frame.origin.y+previousControl.frame.size.height+spaceVal, width: currentControl.frame.size.width, height: currentControl.frame.size.height)
                previousControl = currentControl
                print(currentControl)
            }
        }

    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }
    
    func getCountryPhonceCode (_ country : String) -> String
    {
        var countryDictionary  = ["AF":"93",
                                  "AL":"355",
                                  "DZ":"213",
                                  "AS":"1",
                                  "AD":"376",
                                  "AO":"244",
                                  "AI":"1",
                                  "AG":"1",
                                  "AR":"54",
                                  "AM":"374",
                                  "AW":"297",
                                  "AU":"61",
                                  "AT":"43",
                                  "AZ":"994",
                                  "BS":"1",
                                  "BH":"973",
                                  "BD":"880",
                                  "BB":"1",
                                  "BY":"375",
                                  "BE":"32",
                                  "BZ":"501",
                                  "BJ":"229",
                                  "BM":"1",
                                  "BT":"975",
                                  "BA":"387",
                                  "BW":"267",
                                  "BR":"55",
                                  "IO":"246",
                                  "BG":"359",
                                  "BF":"226",
                                  "BI":"257",
                                  "KH":"855",
                                  "CM":"237",
                                  "CA":"1",
                                  "CV":"238",
                                  "KY":"345",
                                  "CF":"236",
                                  "TD":"235",
                                  "CL":"56",
                                  "CN":"86",
                                  "CX":"61",
                                  "CO":"57",
                                  "KM":"269",
                                  "CG":"242",
                                  "CK":"682",
                                  "CR":"506",
                                  "HR":"385",
                                  "CU":"53",
                                  "CY":"537",
                                  "CZ":"420",
                                  "DK":"45",
                                  "DJ":"253",
                                  "DM":"1",
                                  "DO":"1",
                                  "EC":"593",
                                  "EG":"20",
                                  "SV":"503",
                                  "GQ":"240",
                                  "ER":"291",
                                  "EE":"372",
                                  "ET":"251",
                                  "FO":"298",
                                  "FJ":"679",
                                  "FI":"358",
                                  "FR":"33",
                                  "GF":"594",
                                  "PF":"689",
                                  "GA":"241",
                                  "GM":"220",
                                  "GE":"995",
                                  "DE":"49",
                                  "GH":"233",
                                  "GI":"350",
                                  "GR":"30",
                                  "GL":"299",
                                  "GD":"1",
                                  "GP":"590",
                                  "GU":"1",
                                  "GT":"502",
                                  "GN":"224",
                                  "GW":"245",
                                  "GY":"595",
                                  "HT":"509",
                                  "HN":"504",
                                  "HU":"36",
                                  "IS":"354",
                                  "IN":"91",
                                  "ID":"62",
                                  "IQ":"964",
                                  "IE":"353",
                                  "IL":"972",
                                  "IT":"39",
                                  "JM":"1",
                                  "JP":"81",
                                  "JO":"962",
                                  "KZ":"77",
                                  "KE":"254",
                                  "KI":"686",
                                  "KW":"965",
                                  "KG":"996",
                                  "LV":"371",
                                  "LB":"961",
                                  "LS":"266",
                                  "LR":"231",
                                  "LI":"423",
                                  "LT":"370",
                                  "LU":"352",
                                  "MG":"261",
                                  "MW":"265",
                                  "MY":"60",
                                  "MV":"960",
                                  "ML":"223",
                                  "MT":"356",
                                  "MH":"692",
                                  "MQ":"596",
                                  "MR":"222",
                                  "MU":"230",
                                  "YT":"262",
                                  "MX":"52",
                                  "MC":"377",
                                  "MN":"976",
                                  "ME":"382",
                                  "MS":"1",
                                  "MA":"212",
                                  "MM":"95",
                                  "NA":"264",
                                  "NR":"674",
                                  "NP":"977",
                                  "NL":"31",
                                  "AN":"599",
                                  "NC":"687",
                                  "NZ":"64",
                                  "NI":"505",
                                  "NE":"227",
                                  "NG":"234",
                                  "NU":"683",
                                  "NF":"672",
                                  "MP":"1",
                                  "NO":"47",
                                  "OM":"968",
                                  "PK":"92",
                                  "PW":"680",
                                  "PA":"507",
                                  "PG":"675",
                                  "PY":"595",
                                  "PE":"51",
                                  "PH":"63",
                                  "PL":"48",
                                  "PT":"351",
                                  "PR":"1",
                                  "QA":"974",
                                  "RO":"40",
                                  "RW":"250",
                                  "WS":"685",
                                  "SM":"378",
                                  "SA":"966",
                                  "SN":"221",
                                  "RS":"381",
                                  "SC":"248",
                                  "SL":"232",
                                  "SG":"65",
                                  "SK":"421",
                                  "SI":"386",
                                  "SB":"677",
                                  "ZA":"27",
                                  "GS":"500",
                                  "ES":"34",
                                  "LK":"94",
                                  "SD":"249",
                                  "SR":"597",
                                  "SZ":"268",
                                  "SE":"46",
                                  "CH":"41",
                                  "TJ":"992",
                                  "TH":"66",
                                  "TG":"228",
                                  "TK":"690",
                                  "TO":"676",
                                  "TT":"1",
                                  "TN":"216",
                                  "TR":"90",
                                  "TM":"993",
                                  "TC":"1",
                                  "TV":"688",
                                  "UG":"256",
                                  "UA":"380",
                                  "AE":"971",
                                  "GB":"44",
                                  "US":"1",
                                  "UY":"598",
                                  "UZ":"998",
                                  "VU":"678",
                                  "WF":"681",
                                  "YE":"967",
                                  "ZM":"260",
                                  "ZW":"263",
                                  "BO":"591",
                                  "BN":"673",
                                  "CC":"61",
                                  "CD":"243",
                                  "CI":"225",
                                  "FK":"500",
                                  "GG":"44",
                                  "VA":"379",
                                  "HK":"852",
                                  "IR":"98",
                                  "IM":"44",
                                  "JE":"44",
                                  "KP":"850",
                                  "KR":"82",
                                  "LA":"856",
                                  "LY":"218",
                                  "MO":"853",
                                  "MK":"389",
                                  "FM":"691",
                                  "MD":"373",
                                  "MZ":"258",
                                  "PS":"970",
                                  "PN":"872",
                                  "RE":"262",
                                  "RU":"7",
                                  "BL":"590",
                                  "SH":"290",
                                  "KN":"1",
                                  "LC":"1",
                                  "MF":"590",
                                  "PM":"508",
                                  "VC":"1",
                                  "ST":"239",
                                  "SO":"252",
                                  "SJ":"47",
                                  "SY":"963",
                                  "TW":"886",
                                  "TZ":"255",
                                  "TL":"670",
                                  "VE":"58",
                                  "VN":"84",
                                  "VG":"284",
                                  "VI":"340"]
        if countryDictionary[country] != nil {
            return countryDictionary[country]!
        }
            
        else {
            return ""
        }
        
    }
    func ClearUSerDetails()
    {
        self.saveUserID(userid: "")
        saveUsername(username: "")
        saveUserpassword(password: "")
        saveLCOstatus(password: "")
        saveActivationstatus(password: "")
        saveUsermobileno(password: "")
        saveLoginDetails(loginDetails: nil)
        saveaccesstoken(userid: "")
        saveUnreadCount(unread_count: 0)
    }
    
    func ShowProgress(view:UIView)
    {
//MBProgressHUD.showAdded(to: view, animated: true)
      
        ACProgressHUD.shared.configureProgressHudStyle(withProgressText: "Loading", progressTextColor: UIColor.white,hudBackgroundColor: UIColor.black, shadowColor: UIColor.black, shadowRadius: 10, cornerRadius: 5, indicatorColor: UIColor.white, enableBackground: false, backgroundColor: UIColor.black, backgroundColorAlpha: 0.5, enableBlurBackground: false,showHudAnimation: .growIn,dismissHudAnimation: .growOut)
         ACProgressHUD.shared.showHUD()

     
    }
    func RemoveProgress(view:UIView)
    {
        ACProgressHUD.shared.hideHUD()
//        MBProgressHUD.hide(for: view, animated: true)
     }
    
}
class PaddinTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}



