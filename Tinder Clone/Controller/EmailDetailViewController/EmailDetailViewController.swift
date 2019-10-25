//
//  EmailDetailViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import MIAlertController


class EmailDetailViewController: RootBaseViewcontroller,UITextFieldDelegate {
    @IBOutlet weak var header_Lbl: CustomLbl!

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var signup_Btn: CustomButton!
    @IBOutlet weak var status_Lbl: CustomLbl!
    @IBOutlet weak var email_Fld: PaddinTextField!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    
    var objLogRecord:LoginRecord = LoginRecord()
    
    
    func navigationCustom() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [kCTForegroundColorAttributeName: Themes.sharedIntance.ReturnThemeColor()] as [NSAttributedStringKey : Any]
        let backButton = UIBarButtonItem.init(title: "o", style: .plain, target: self, action: #selector(EmailDetailViewController.didClickBack))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([kCTFontAttributeName as NSAttributedStringKey: UIFont(name: Constant.sharedinstance.iconfontname, size: 22)!], for: .normal)
        
        self.navigationItem.leftBarButtonItem = backButton
//        self.navigationItem.rightBarButtonItem?.tintColor = Themes.sharedIntance.ReturnThemeColor()
//        self.navigationItem.backBarButtonItem?.tintColor = Themes.sharedIntance.ReturnThemeColor()
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        
        self.navigationController?.navigationBar.barTintColor = self.view.backgroundColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    @objc func didClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationCustom()
        status_Lbl.isHidden=false
        header_Lbl.text = "My\nemail is"
 email_Fld.delegate = self
        signup_Btn.isUserInteractionEnabled = false
        email_Fld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X"){
            navigationView.frame.origin.y += 50
            emailView.frame.origin.y += 50
        }
        

        // Do any additional setup after loading the view.
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(isEmail(testStr: textField.text!))
        {
            signup_Btn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
            signup_Btn.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
            signup_Btn.setTitleColor(UIColor.white, for: .normal)
            signup_Btn.isUserInteractionEnabled = true
        }
        else
        {
            signup_Btn.setBackgroundImage(nil, for: .normal)
            signup_Btn.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
            signup_Btn.setTitleColor(UIColor.lightGray, for: .normal)
            signup_Btn.isUserInteractionEnabled = false
            
        }

     }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.email_Fld.becomeFirstResponder()
        }
    }
    override func viewDidLayoutSubviews() {
        email_Fld.layer.addBorder(edge: .bottom, color: UIColor.darkGray, thickness: 2.0)
        let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        progressBar.transform = transform
        progressBar.tintColor = Themes.sharedIntance.ReturnThemeColor()
        signup_Btn.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
        signup_Btn.setTitleColor(UIColor.lightGray, for: .normal)

        Themes.sharedIntance.AddBorder(view: signup_Btn, borderColor: nil, borderWidth: nil, cornerradius: 22.0)
        if StaticData.fromFacebook == false{
        var percentProgress = Float((10.0*100.0)/60.0)
        percentProgress = percentProgress/100.0
        self.progressBar.progress = percentProgress
        }else{
            if StaticData.facebookIsDob{
                self.progressBar.progress=0.5
            }else{
                self.progressBar.progress=1.0
            }
        }
 
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func diclickSignup(_ sender: Any) {
        if StaticData.fromFacebook == false{
        let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
        profVC.profType = .name
        objLogRecord.password="asad6006577"
        objLogRecord.email_id = email_Fld.text!
        profVC.objLogRecord = objLogRecord
        self.navigationController?.pushViewController(profVC, animated: true)
        }else if StaticData.facebookIsDob{
            
            StaticData.facebookEmail = email_Fld.text!
            if (StaticData.facebookIsDob){
            let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
            profVC.profType = .birthday
            objLogRecord.password="asad6006577"
            objLogRecord.email_id = email_Fld.text!
            profVC.objLogRecord = objLogRecord
            self.navigationController?.pushViewController(profVC, animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
            }
        }

    }
    @IBAction func DidclickBack(_ sender: Any) {
        let alertController = MIAlertController(
            title: "Are you Sure",
            message: "You will exit sign up process and all Your information will be deleted"
        )
        
          alertController.addButton(
            MIAlertController.Button(title: "NO", type: .destructive, action: {
            }))

        
        alertController.addButton(
            MIAlertController.Button(title: "YES", type: .destructive, action: {
                self.navigationController?.popToRootViewController(animated: true)
            
              }))
         
        alertController.presentOn(self)

    }
 
    @IBAction func DiclickSkip(_ sender: Any) {
        
        let alertController = MIAlertController(
            title: "Are you Sure",
            message: "Without an email address you will not able to recover your account  if you forget your password"
        )
        
        //        alertController.addButton(
        //            MIAlertController.Button(title: "Yep")
        //        )
        alertController.addButton(
            MIAlertController.Button(title: "NO", type: .destructive, action: {
            }))
        
         alertController.addButton(
            MIAlertController.Button(title: "YES", type: .destructive, action: {
                
                let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
                profVC.profType = .password
                self.objLogRecord.email_id = ""
                profVC.objLogRecord = self.objLogRecord
                self.navigationController?.pushViewController(profVC, animated: true)
                
            }))
        
        alertController.presentOn(self)
    }
    func isEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    override var prefersStatusBarHidden: Bool {
        return true
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
