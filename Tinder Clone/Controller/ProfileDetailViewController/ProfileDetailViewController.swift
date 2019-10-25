//
//  ProfileDetailViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import PinCodeTextField

class ProfileDetailViewController: RootBaseViewcontroller {
    
    enum ProfileType {
        case password
        case birthday
        case name
        case lastname

        case _default

    }
    @IBOutlet weak var lastname_wrapperView: UIView!
    @IBOutlet weak var birthday_headerLbl: UILabel!
    @IBOutlet weak var birthday_Continue: CustomButton!
    @IBOutlet weak var lastnameContinue: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var password_wrapperView: UIView!
    @IBOutlet weak var passheader_Lbl: CustomLbl!
    @IBOutlet weak var passerror_Lbl: CustomLbl!
  
    @IBOutlet weak var name_ContinueBtn: CustomButton!
    @IBOutlet weak var name_error_Lbl: CustomLbl!
    @IBOutlet weak var password_continueBtn: CustomButton!
    
    @IBOutlet weak var year_Fld: PinCodeTextField!
    @IBOutlet weak var month_Fld: PinCodeTextField!
    @IBOutlet weak var password_txtField: PaddinTextField!
    @IBOutlet weak var name_Fld: PaddinTextField!
    @IBOutlet weak var nameHeader_Lbl: CustomLbl!
    @IBOutlet weak var name_wrapperView: UIView!
    @IBOutlet weak var BirthdaywrappperView: UIView!

    @IBOutlet weak var date_Fld: PinCodeTextField!
    @IBOutlet weak var masterView: UIView!
    
    @IBOutlet weak var appearanceTextLabel: UILabel!
    @IBOutlet weak var appearanceTextLabel2: UILabel!
    
    
    var profType: ProfileType = ._default
    var objLogRecord:LoginRecord = LoginRecord()
    
    var minDate = Date()
    var maxDate = Date()
    
    var minimumDateString = String()
    var maximumDateString = String()
    let myDateFormatter: DateFormatter = DateFormatter()

    @IBOutlet weak var last_nameFld: PaddinTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        name_Fld.autocapitalizationType = .words
        last_nameFld.autocapitalizationType = .words
        passheader_Lbl.text = "My\npassword is"
       password_continueBtn.isUserInteractionEnabled = false
        passerror_Lbl.text = "Your password should contain 1 letter, 1 number and at least 8 character"
        passerror_Lbl.textColor = UIColor.lightGray
        password_continueBtn.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
        birthday_Continue.setTitleColor(UIColor.lightGray, for: .normal)
        lastnameContinue.setTitleColor(UIColor.lightGray, for: .normal)
        lastnameContinue.isUserInteractionEnabled = false
        
        date_Fld.needToUpdateUnderlines = false
        month_Fld.needToUpdateUnderlines = false
        year_Fld.needToUpdateUnderlines = false
        

         birthday_Continue.isUserInteractionEnabled = false
        birthday_Continue.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
         password_txtField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        last_nameFld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        nameHeader_Lbl.text = "My first\nname is"
        
        name_error_Lbl.text = "Your first name will be visible on ello.ie"
        birthday_headerLbl.text = "My\nbirthday is"
        year_Fld.delegate = self
        year_Fld.keyboardType = .numberPad
        month_Fld.delegate = self
        month_Fld.keyboardType = .numberPad
        date_Fld.delegate = self
        date_Fld.keyboardType = .numberPad
//        date_Fld.needToUpdateUnderlines = false
        
        appearanceTextLabel.text = "This won’t be visible to others."
        appearanceTextLabel2.text = "Your first name will be visible on ello.ie"
        
 
        var percentProgress:Float!
         if(profType == .password)
        {
            name_wrapperView.isHidden = true
            password_wrapperView.isHidden = false
            BirthdaywrappperView.isHidden = true
              percentProgress = Float(20.0*100.0/70.0)
 
         }
        else if(profType == .name)
        {
            name_wrapperView.isHidden = false
            password_wrapperView.isHidden = true
            BirthdaywrappperView.isHidden = true
            percentProgress = Float(20.0*100.0/60.0)

         }
         else if(profType == .name)
         {
            name_wrapperView.isHidden = false
            password_wrapperView.isHidden = true
            BirthdaywrappperView.isHidden = true
            percentProgress = Float(20.0*100.0/60.0)
            
         }
            
         else if(profType == .lastname)
         {
            lastname_wrapperView.isHidden = false
            password_wrapperView.isHidden = true
            name_wrapperView.isHidden = true
             BirthdaywrappperView.isHidden = true
            percentProgress = Float(30.0*100.0/60.0)
            
         }
        else if(profType == .birthday)
         {  name_wrapperView.isHidden = true
            password_wrapperView.isHidden = true
            BirthdaywrappperView.isHidden = false
            if StaticData.fromFacebook == false{
            percentProgress = Float(40.0*100.0/60.0)
            }else{
                percentProgress=Float(60.0*100.0/60.0)
            }

         }
         name_Fld.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        percentProgress = percentProgress/100.0
         self.progressBar.progress = percentProgress

         // Do any additional setup after loading the view.
        
        myDateFormatter.dateFormat = "dd-MM-yyyy"
        
//        let minDate = Date().addingTimeInterval(TimeInterval(60 * 60 * 24 * 365 * SharedVariables.sharedInstance.minimumAge))
        minDate = Calendar.current.date(byAdding: .year, value: -SharedVariables.sharedInstance.minimumAge, to: Date())!
        maxDate = Calendar.current.date(byAdding: .year, value: -SharedVariables.sharedInstance.maximumAge, to: Date())!
        
        
        minimumDateString = myDateFormatter.string(from: minDate)
        maximumDateString = myDateFormatter.string(from: maxDate)
        
        print(minimumDateString)
        print(maximumDateString)
        
        date_Fld.tintColor = .black
        
        ShowTextFld()
        
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X"){
            masterView.frame.origin.y += 50
            masterView.frame.size.height -= 50
        }
        
        
    }
    func ShowTextFld()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if(self.profType == .password)
            {
                self.password_txtField.becomeFirstResponder()

            }
            else if(self.profType == .name)
            {
                self.name_Fld.becomeFirstResponder()

                
            }
            else if(self.profType == .lastname)
            {
                self.last_nameFld.becomeFirstResponder()
                
                
            }
            else if(self.profType == .birthday)
            {
                self.date_Fld.becomeFirstResponder()

            }
        }

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(textField == password_txtField)
        {
            if(isvalidatepassword(testStr: password_txtField.text!))
            {
                password_continueBtn.isUserInteractionEnabled = true
                passerror_Lbl.text = "Your password is valid"
                passerror_Lbl.textColor = UIColor.green
                
                password_continueBtn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
                password_continueBtn.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
                password_continueBtn.setTitleColor(UIColor.white, for: .normal)
                password_continueBtn.isUserInteractionEnabled = true


            }
            
            else
            {
                password_continueBtn.setBackgroundImage(nil, for: .normal)
                password_continueBtn.isUserInteractionEnabled = false
                passerror_Lbl.text = "Your password should contain 1 letter, 1 number and at least 8 character"
                passerror_Lbl.textColor = UIColor.lightGray
                password_continueBtn.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
                password_continueBtn.setTitleColor(UIColor.lightGray, for: .normal)
                password_continueBtn.isUserInteractionEnabled = false


            }
        }
       else if(textField == name_Fld || textField == last_nameFld)
        {
            if((textField.text?.characters.count)! > 0)
            {
                if(textField == name_Fld)
                {
                    name_ContinueBtn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
                    
                             name_ContinueBtn.setTitleColor(UIColor.white, for: .normal)
                name_ContinueBtn.isUserInteractionEnabled = true
                }
                else
                {
                    lastnameContinue.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
                     lastnameContinue.setTitleColor(UIColor.white, for: .normal)
                    lastnameContinue.isUserInteractionEnabled = true
                 }

            }
            else
            {
                if(textField == name_Fld)
                {
                    name_ContinueBtn.setBackgroundImage(nil, for: .normal)

                 name_ContinueBtn.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
                    name_ContinueBtn.setTitleColor(UIColor.lightGray, for: .normal)
                name_ContinueBtn.isUserInteractionEnabled = false
                }
                  else
                {
                    lastnameContinue.setBackgroundImage(nil, for: .normal)

                    lastnameContinue.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
                    lastnameContinue.setTitleColor(UIColor.lightGray, for: .normal)
                    lastnameContinue.isUserInteractionEnabled = false


            }
            
        }

        
    }
    }
    func isvalidatepassword(testStr:String) -> Bool {
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    
    override func viewDidLayoutSubviews() {
        password_txtField.layer.addBorder(edge: .bottom, color: UIColor.darkGray, thickness: 2.0)
        name_Fld.layer.addBorder(edge: .bottom, color: UIColor.darkGray, thickness: 2.0)
        last_nameFld.layer.addBorder(edge: .bottom, color: UIColor.darkGray, thickness: 2.0)

 
let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        progressBar.transform = transform
        progressBar.tintColor = Themes.sharedIntance.ReturnThemeColor()
        Themes.sharedIntance.AddBorder(view: name_ContinueBtn, borderColor: nil, borderWidth: nil, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: password_continueBtn, borderColor: nil, borderWidth: nil, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: birthday_Continue, borderColor: nil, borderWidth: nil, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: name_ContinueBtn, borderColor: nil, borderWidth: nil, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: lastnameContinue, borderColor: nil, borderWidth: nil, cornerradius: 22.0)


        
        

    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBAction func DidclickPasswordContinue(_ sender: Any) {
        let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
        objLogRecord.password = password_txtField.text!
        profVC.profType = .name
        profVC.objLogRecord = objLogRecord
         self.navigationController?.pushViewController(profVC, animated: true)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didclickback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func Didclicklast_name(_ sender: Any) {
        let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
        profVC.profType = .birthday
        objLogRecord.last_name = last_nameFld.text!
        profVC.objLogRecord = objLogRecord
        self.navigationController?.pushViewController(profVC, animated: true)
    }
    @IBAction func DidclickNameBtn(_ sender: Any) {
        let profVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileDetailViewControllerID") as! ProfileDetailViewController
        objLogRecord.first_name = name_Fld.text!
        profVC.profType = .lastname
        profVC.objLogRecord = objLogRecord
        self.navigationController?.pushViewController(profVC, animated: true)

    }
    @IBAction func DiclickBirthday_continue(_ sender: Any) {
        if StaticData.fromFacebook == false{
        let GenderVC = self.storyboard?.instantiateViewController(withIdentifier: "GenderViewControllerID") as! GenderViewController
         objLogRecord.dob = "\(date_Fld.text!)-\(month_Fld.text!)-\(year_Fld.text!)"
        let dateValue = isValidDate(str: objLogRecord.dob)
        print(dateValue)
        GenderVC.objLogRecord = objLogRecord
       self.navigationController?.pushViewController(GenderVC, animated: true)
        }else{
            StaticData.facebookDob="\(date_Fld.text!)-\(month_Fld.text!)-\(year_Fld.text!)"
            self.navigationController?.popToRootViewController(animated: true)
        }

    }
    
    func isValidDate(str: String) -> Date{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        guard let date = dateFormatter.date(from: str) else {
            return Date()
        }
        
        
        return date
        
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
extension ProfileDetailViewController: PinCodeTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        
        if textField == month_Fld {
            if (date_Fld.text?.count)! < 2 {
                return false
            }
        }
        else if textField == year_Fld {
            if (month_Fld.text?.count)! < 2 {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldValueChanged(_ textField: PinCodeTextField) {
        
        let stringToBeTested = textField.text
//        let datePattern = "[0123]+[0-9]{2}"
//        let datePred = NSPredicate(format: "SELF MATCHES %@", datePattern)
//        var isDate: Bool = datePred.evaluate(with: stringToBeTested)
        
//        let monthPattern = "[01-12]{1}"
//        let monthPred = NSPredicate(format: "SELF MATCHES %@", monthPattern)
//        let isMonth: Bool = monthPred.evaluate(with: stringToBeTested)
//
//        let yearPattern = "[1990-2018]{4}"
//        let yearPred = NSPredicate(format: "SELF MATCHES %@", yearPattern)
//        let isYear: Bool = yearPred.evaluate(with: stringToBeTested)
        
        var isDate = Bool()
        if textField == date_Fld {
            if let date = Int(textField.text!) {
                if date <= 31 && date > 0 && textField.text!.count == 2 {
                    isDate = true
                }
                else if textField.text!.count == 2 {
                    isDate = false
                    date_Fld.text = ""
                }
                else {
                    isDate = false
                }
            }
            print("VALID DATE \(isDate)")
        }
        
        var isMonth = Bool()
        if textField == month_Fld {
            if let month = Int(textField.text!) {
                if month <= 12 && month > 0 && textField.text!.count == 2 {
                    isMonth = true
                }
                else if textField.text!.count == 2 {
                    isMonth = false
                    month_Fld.text = ""
                }
                else {
                    isMonth = false
                }
            }
            print("VALID MONTH \(isMonth)")
        }
        
        if(date_Fld.text?.count == 2 && month_Fld.text?.count == 2 && year_Fld.text?.count == 4)
        {
            let enteredDateString = "\(date_Fld.text!)-\(month_Fld.text!)-\(year_Fld.text!)"
            let enteredDate = myDateFormatter.date(from: enteredDateString)
            
            print("MINIMUM TIME INTERVAL \(String(describing: minDate.timeIntervalSince(enteredDate!)))")
            print("MAXIMUM TIME INTERVAL \(String(describing: maxDate.timeIntervalSince(enteredDate!)))")
            
            if minDate.timeIntervalSince(enteredDate!) > 0 && maxDate.timeIntervalSince(enteredDate!) < 0 {
                birthday_Continue.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
                birthday_Continue.setTitleColor(UIColor.white, for: .normal)
                birthday_Continue.isUserInteractionEnabled = true
            }
            else {
                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: "Your age must be between \(SharedVariables.sharedInstance.minimumAge) and \(SharedVariables.sharedInstance.maximumAge)")
                year_Fld.text = ""
                return
            }
            
            
        }
        else
        {
            birthday_Continue.setBackgroundImage(nil, for: .normal)

            birthday_Continue.backgroundColor = Themes.sharedIntance.ReturnSecondryThemeColor()
            birthday_Continue.setTitleColor(UIColor.lightGray, for: .normal)
            birthday_Continue.isUserInteractionEnabled = false
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
 
                if(self.date_Fld.text?.count == 2 && self.month_Fld.text?.count == nil)
            {
                self.month_Fld.becomeFirstResponder()
            }
    if(self.month_Fld.text?.count == 2 && self.year_Fld.text?.count == nil)
            
            {
                self.year_Fld.becomeFirstResponder()
            }
            else if(self.year_Fld.text?.count == 4)
                
            {
                
                
            }
            }

        }
        
     
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        
        return true
    }
    
    
}
