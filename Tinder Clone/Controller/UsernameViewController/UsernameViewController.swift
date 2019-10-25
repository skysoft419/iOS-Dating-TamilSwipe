//
//  UsernameViewController.swift
///  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var ConfirmBtn: UIButton!

    @IBOutlet weak var Delete_Btn: UIButton!
    @IBOutlet weak var error_Lbl: CustomLbl!
    @IBOutlet weak var count_Lbl: CustomLbl!
    @IBOutlet weak var username: UITextField!
    var user_name:String = String()
    override func viewDidLoad() {
        super.viewDidLoad()
username.becomeFirstResponder()
         username.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        count_Lbl.text = "\(user_name.characters.count)"
        ConfirmBtn.isUserInteractionEnabled = false
        Delete_Btn.isUserInteractionEnabled = false
        ConfirmBtn.setTitleColor(Themes.sharedIntance.ReturnThemeColor().withAlphaComponent(0.5), for: .normal)
        Delete_Btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor().withAlphaComponent(0.5), for: .normal)
        username.text = user_name
        username.delegate = self
        error_Lbl.text = ""
        // Do any additional setup after loading the view.
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 20 // Bool
    }
    
    func ClaimUsername()
    {
        
        Themes.sharedIntance.ShowProgress(view: self.view)
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"username":username.text!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.username_claim as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
            
            Themes.sharedIntance.RemoveProgress(view: self.view)
            if((ResponseDict?.count)! > 0)
            {
            let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
            if(status_code == "1")
            {
                self.navigationController?.popViewController(animated: true)
                Themes.sharedIntance.showSuccessMsg(view: self.view, withMsg: status_message)

            }
            else
            {
                self.error_Lbl.text = status_message

 
                }
                
            }
        else
            {
                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                
            }
        })

        

    }

     @objc func textFieldDidChange(_ textField: UITextField) {
        
     if(textField.text?.characters.count == 0)
     {
        count_Lbl.text = "20"
        ConfirmBtn.isUserInteractionEnabled = false
        Delete_Btn.isUserInteractionEnabled = true
         ConfirmBtn.setTitleColor(Themes.sharedIntance.ReturnThemeColor().withAlphaComponent(0.5), for: .normal)
        Delete_Btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor().withAlphaComponent(0.5), for: .normal)


        }
        else
     {
        ConfirmBtn.isUserInteractionEnabled = true
        Delete_Btn.isUserInteractionEnabled = true

        ConfirmBtn.setTitleColor(Themes.sharedIntance.ReturnThemeColor().withAlphaComponent(1.0), for: .normal)
        Delete_Btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor().withAlphaComponent(1.0), for: .normal)

        count_Lbl.text = "\((textField.text?.characters.count)!)"

        }
        
 
    }
     
    @IBAction func DidclickConfirm(_ sender: Any) {
       self.ClaimUsername()
    
    }
    @IBAction func DidclickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }

    @IBAction func DidclickDelete(_ sender: Any) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
