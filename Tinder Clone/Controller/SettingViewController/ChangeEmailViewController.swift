//
//  ChangeEmailViewController.swift
//  Igniter
//
//  Created by Rana Asad on 22/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import  Alamofire
class ChangeEmailViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var contniueButton: UIButton!
    private var loadingAlert:UIAlertController?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        textfield.text=StaticData.email!
        contniueButton.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
        contniueButton.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
        contniueButton.setTitleColor(UIColor.white, for: .normal)
        contniueButton.isUserInteractionEnabled = true
        textfield.delegate=self
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textfield.layer.addBorder(edge: .bottom, color: UIColor.darkGray, thickness: 2.0)
        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(isValidEmail(testStr: textField.text!))
        {
            contniueButton.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
            contniueButton.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
            contniueButton.setTitleColor(UIColor.white, for: .normal)
            contniueButton.isUserInteractionEnabled = true
        }
        else
        {
            contniueButton.setBackgroundImage(nil, for: .normal)
            contniueButton.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
            contniueButton.setTitleColor(UIColor.lightGray, for: .normal)
            contniueButton.isUserInteractionEnabled = false
            
        }
        
    }
    
    @IBAction func continueButtonClicked(_ sender: UIButton) {
        sendCode()
    }
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func sendCode()
    {
        self.present(loadingAlert!, animated: true, completion: {
            let param:[String:Any] = ["token":Themes.sharedIntance.getaccesstoken()!,"email":self.textfield.text!]
            Alamofire.request(Constant.sharedinstance.change_email,method:.get,parameters:param).responseJSON{ response in
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if response.result.error == nil{
                        if response.data != nil{
                            do{
                                print(response)
                                let userInfo = try JSONDecoder().decode(EmailResponse.self, from: response.data!)
                                if userInfo.status_code == "1"{
                                    StaticData.email=self.textfield.text!
                                    let vc=AppStoryboard.Extra.viewController(viewControllerClass: VerifyEmailViewController.self)
                                    self.navigationController?.pushViewController(vc, animated: true)
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
                })
            }
        })
    }


}
