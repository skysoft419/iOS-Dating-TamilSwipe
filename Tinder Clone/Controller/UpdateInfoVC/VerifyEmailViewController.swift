//
//  VerifyEmailViewController.swift
//  Ello.ie
//
//  Created by Rana Asad on 05/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//
import UIKit
import Alamofire
class VerifyEmailViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var firsttextField: UITextField!
    @IBOutlet weak var secondtextField: UITextField!
    @IBOutlet weak var thirdtextField: UITextField!
    @IBOutlet weak var forthtextField: UITextField!
    private var loadingAlert:UIAlertController?
    private var isFirstCall=false
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        firsttextField.clearButtonMode=UITextFieldViewMode.whileEditing
        secondtextField.clearButtonMode=UITextFieldViewMode.whileEditing
        thirdtextField.clearButtonMode=UITextFieldViewMode.whileEditing
        forthtextField.clearButtonMode=UITextFieldViewMode.whileEditing
        firsttextField.delegate=self
        secondtextField.delegate=self
        thirdtextField.delegate=self
        forthtextField.delegate=self
        firsttextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        secondtextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        thirdtextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        forthtextField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        verifyButton.isUserInteractionEnabled=false
        //NotificationCenter.default.addObserver(self, selector: #selector(loadChats), name:Notification.Name("NewMessageReceived"), object: nil)
    }
    @objc private func textFieldDidChange(textField:UITextField){
        let textFields=textField.text
        if textFields?.utf16.count==1{
            switch textField{
            case firsttextField:
                firsttextField.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                firsttextField.layer.borderWidth=1.0
                firsttextField.layer.cornerRadius=5
                secondtextField.layer.borderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
                secondtextField.layer.borderWidth=1.0
                secondtextField.layer.cornerRadius=5
                secondtextField.becomeFirstResponder()
            case secondtextField:
                secondtextField.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                secondtextField.layer.borderWidth=1.0
                secondtextField.layer.cornerRadius=5
                thirdtextField.layer.borderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
                thirdtextField.layer.borderWidth=1.0
                thirdtextField.layer.cornerRadius=5
                thirdtextField.becomeFirstResponder()
            case thirdtextField:
                thirdtextField.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                thirdtextField.layer.borderWidth=1.0
                thirdtextField.layer.cornerRadius=5
                forthtextField.layer.borderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
                forthtextField.layer.borderWidth=1.0
                forthtextField.layer.cornerRadius=5
                forthtextField.becomeFirstResponder()
            case forthtextField:
                verifyButton.isUserInteractionEnabled=true
                verifyButton.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
                verifyButton.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
                verifyButton.setTitleColor(UIColor.white, for: .normal)
                self.view.endEditing(true)
            default:
                break
            }
        }else{
            
        }
        
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField{
        case secondtextField:
            secondtextField.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            secondtextField.layer.borderWidth=1.0
            secondtextField.layer.cornerRadius=5
            firsttextField.layer.borderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
            firsttextField.layer.borderWidth=1.0
            firsttextField.layer.cornerRadius=5
            if textField.text == ""{
                firsttextField.becomeFirstResponder()
            }
            
            return true
        case thirdtextField:
            thirdtextField.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            thirdtextField.layer.borderWidth=1.0
            thirdtextField.layer.cornerRadius=5
            secondtextField.layer.borderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
            secondtextField.layer.borderWidth=1.0
            secondtextField.layer.cornerRadius=5
            if textField.text == ""{
                secondtextField.becomeFirstResponder()
            }
            
            return true
        case forthtextField:
            forthtextField.layer.borderColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            forthtextField.layer.borderWidth=1.0
            forthtextField.layer.cornerRadius=5
            thirdtextField.layer.borderColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
            thirdtextField.layer.borderWidth=1.0
            thirdtextField.layer.cornerRadius=5
            if textField.text == ""{
                thirdtextField.becomeFirstResponder()
                
            }
            thirdtextField.becomeFirstResponder()
            return true
        default:
            return false
        }
        return false
    }

    @IBAction func verifyButtonClicked(_ sender: UIButton) {
        let code=firsttextField.text!+secondtextField.text!+thirdtextField!.text!+forthtextField!.text!
        sendCode(code:code)
    }
    func sendCode(code:String)
    {
            self.present(loadingAlert!, animated: true, completion: {
                let param:[String:Any] = ["token":Themes.sharedIntance.getaccesstoken()!,"email_otp":code]
                Alamofire.request(Constant.sharedinstance.verify_email,method:.get,parameters:param).responseJSON{ response in
                    self.loadingAlert?.dismiss(animated: true, completion: {
                        if response.result.error == nil{
                            if response.data != nil{
                                do{
                                    print(response)
                                    let userInfo = try JSONDecoder().decode(EmailResponse.self, from: response.data!)
                                    if userInfo.status_code == "1"{
                                        StaticData.from=1
                                        StaticData.pin="0"
                                        StaticData.allUserData!.pin="0"
                                        StaticData.email=StaticData.emailToVerified!
                                        StaticData.allUserData!.setting!.email=StaticData.emailToVerified!
                                        StaticData.allUserData!.setting!.verifyEmail="1"
                                       self.navigationController?.popToRootViewController(animated: true)
                                    }else{
                                        StaticData.pin="1"
                                        StaticData.allUserData?.pin="1"
                                        StaticData.allUserData!.setting!.verifyEmail="0"
                                        StaticData.email=StaticData.emailToVerified!
                                        StaticData.allUserData!.setting!.email=StaticData.emailToVerified!
                                     
                                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "Incorrect code please try again!")
                                    }
                                }
                                catch {
                                    
                                }
                            }else{
                                StaticData.allUserData!.setting!.verifyEmail="0"
                                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                            }
                        }else{
                            StaticData.allUserData!.setting!.verifyEmail="0"
                                    let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                            
                        }
                    })
                }
            })
        }
    
}

