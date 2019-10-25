//
//  EmailVerificationViewController.swift
//  Ello.ie
//
//  Created by Rana Asad on 14/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import Alamofire
class EmailVerificationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var pinLabel: UILabel!
    @IBOutlet weak var pinView: UIView!
    @IBOutlet weak var verificationLabel: UILabel!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var icon: UIButton!
    @IBOutlet weak var texfield: UITextField!
    @IBOutlet weak var firsView: UIView!
    private var loadingAlert:UIAlertController?
    private var isFirstCall=false
    override func viewDidLoad() {
        super.viewDidLoad()
        //NotificationCenter.default.addObserver(self, selector: #selector(loadChats), name:Notification.Name("NewMessageReceived"), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        pinView.isHidden=true
        secondView.isUserInteractionEnabled=true
        verificationLabel.isUserInteractionEnabled=true
        initThings()
    }
    func initThings(){
        texfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        let tapView = UITapGestureRecognizer(target: self, action: #selector(sendVerificationCode))
            secondView.addGestureRecognizer(tapView)
        let tapView1 = UITapGestureRecognizer(target: self, action: #selector(enterPinCode))
        let tapView2 = UITapGestureRecognizer(target: self, action: #selector(enterPinCode))
        pinLabel.addGestureRecognizer(tapView2)
        pinView.addGestureRecognizer(tapView2)
        secondView.addGestureRecognizer(tapView)
        verificationLabel.addGestureRecognizer(tapView)
        pinView.addGestureRecognizer(tapView1)
        pinLabel.addGestureRecognizer(tapView1)
        texfield.delegate=self
        firsView.layer.borderColor=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        firsView.layer.borderWidth=0.3
        secondView.layer.borderColor=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        secondView.layer.borderWidth=0.3
        pinView.layer.borderColor=#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        pinView.layer.borderWidth=0.3
        verificationLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
        texfield.delegate=self
        texfield.text=StaticData.email!
        if StaticData.emailVerified == "1"{
            icon.tintColor=#colorLiteral(red: 0.2627450824, green: 0.6274510026, blue: 0.278431356, alpha: 1)
            icon.setImage(UIImage(named: "checked"), for: .normal)
            descriptionLabel.textColor=#colorLiteral(red: 0.380392164, green: 0.3803921342, blue: 0.3803921342, alpha: 1)
            verificationLabel.textColor=#colorLiteral(red: 0.380392164, green: 0.3803921342, blue: 0.3803921342, alpha: 1)
            secondView.isUserInteractionEnabled=false
            verificationLabel.isUserInteractionEnabled=false
            descriptionLabel.text="Verified email."
        }else{
            if StaticData.pin == "1"{
                pinView.isUserInteractionEnabled=true
                pinView.isHidden=false
                pinLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            }
            secondView.isUserInteractionEnabled=true
            verificationLabel.isUserInteractionEnabled=true
            icon.tintColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            icon.setImage(UIImage(named: "danger-sign"), for: .normal)
            verificationLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            verificationLabel.text="Send Verification Code"
            descriptionLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            descriptionLabel.text="Email not verified. Tap below to request a verification email."
        }
        
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(isValidEmail(testStr: textField.text!))
        { if textField.text! == StaticData.email{
            if StaticData.emailVerified == "1"{
                icon.tintColor=#colorLiteral(red: 0.2627450824, green: 0.6274510026, blue: 0.278431356, alpha: 1)
                icon.setImage(UIImage(named: "checked"), for: .normal)
                descriptionLabel.textColor=#colorLiteral(red: 0.380392164, green: 0.3803921342, blue: 0.3803921342, alpha: 1)
                descriptionLabel.text="Verified email."
                secondView.isUserInteractionEnabled=false
                verificationLabel.isUserInteractionEnabled=false
                verificationLabel.textColor=#colorLiteral(red: 0.380392164, green: 0.3803921342, blue: 0.3803921342, alpha: 1)
                verificationLabel.text="Verified"
            }else{
                secondView.isUserInteractionEnabled=true
                verificationLabel.isUserInteractionEnabled=true
                pinLabel.isUserInteractionEnabled=true
                pinView.isUserInteractionEnabled=true
                pinView.isHidden=false
                icon.tintColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
                icon.setImage(UIImage(named: "danger-sign"), for: .normal)
                descriptionLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
                descriptionLabel.text="Email not verified. Tap below to request a verification email."
                verificationLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
                verificationLabel.text="Send Verification Code"
            }
        }else{
            pinView.isHidden=true
            secondView.isUserInteractionEnabled=true
            verificationLabel.isUserInteractionEnabled=true
            pinLabel.isUserInteractionEnabled=true
            pinView.isUserInteractionEnabled=true
            if ConfigManager.getInstance().isFirst() == "YES"{
                pinLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            }
            icon.tintColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            icon.setImage(UIImage(named: "danger-sign"), for: .normal)
            descriptionLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            descriptionLabel.text="Please verify email.."
            verificationLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            verificationLabel.text="Send Verification Code"
            }
            
        }
        else
        {
            icon.tintColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            icon.setImage(UIImage(named: "danger-sign"), for: .normal)
            verificationLabel.isUserInteractionEnabled=false
            secondView.isUserInteractionEnabled=false
            pinLabel.isUserInteractionEnabled=false
            pinView.isUserInteractionEnabled=false
            verificationLabel.textColor=#colorLiteral(red: 0.380392164, green: 0.3803921342, blue: 0.3803921342, alpha: 1)
            pinLabel.textColor=#colorLiteral(red: 0.7411764264, green: 0.7411764264, blue: 0.7411764264, alpha: 1)
            verificationLabel.text="Send Verification Code"
            descriptionLabel.textColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
            descriptionLabel.text="Please enter a valid email."
            
            
        }
        
    }
    @objc func enterPinCode(){
        StaticData.emailToVerified=self.texfield.text!
        let vc=AppStoryboard.Extra.viewController(viewControllerClass: VerifyEmailViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func sendVerificationCode(){
        sendCode()
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func sendCode()
    {
        StaticData.emailToVerified=self.texfield.text!
        StaticData.allUserData!.setting!.verifyEmail="0"
        StaticData.emailVerified="0"
        StaticData.email=StaticData.emailToVerified!
        StaticData.allUserData!.setting!.email=StaticData.emailToVerified!
        StaticData.pin="1"
        StaticData.allUserData?.pin="1"
        let vc=AppStoryboard.Extra.viewController(viewControllerClass: VerifyEmailViewController.self)
        self.navigationController?.pushViewController(vc, animated: true)
                let param:[String:Any] = ["token":Themes.sharedIntance.getaccesstoken()!,"email":self.texfield.text!]
            Alamofire.request(Constant.sharedinstance.change_email,method:.get,parameters:param).responseJSON{ response in
                    if response.result.error == nil{
                        if response.data != nil{
                            do{
                                let userInfo = try JSONDecoder().decode(EmailResponse.self, from: response.data!)
                                if userInfo.status_code == "1"{
                                    ConfigManager.getInstance().setFirst(value: "YES")
                                }else{
                                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                                }
                            }
                            catch {
                                
                            }
                        }else{
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                        }
                    }else{
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
            }
    }


}
