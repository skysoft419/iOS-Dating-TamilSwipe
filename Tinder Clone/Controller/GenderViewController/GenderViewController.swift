//
//  GenderViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class GenderViewController: RootBaseViewcontroller {
    var objLogRecord:LoginRecord = LoginRecord()
    @IBOutlet weak var progress_Bar: UIProgressView!
    @IBOutlet weak var continue_Btn: CustomButton!
    @IBOutlet weak var man_btn: CustomButton!
    @IBOutlet weak var women_Btn: CustomButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var genderView: UIView!
    private var isFirstCall=false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continue_Btn.isUserInteractionEnabled = false
        
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X"){
            navigationView.frame.origin.y += 50
            genderView.frame.origin.y += 50
        }

        
    }
    override func viewDidLayoutSubviews() {
        Themes.sharedIntance.AddBorder(view: continue_Btn, borderColor: nil, borderWidth: nil, cornerradius: 22.0)
        
        Themes.sharedIntance.AddBorder(view: man_btn, borderColor: UIColor.lightGray, borderWidth: 2.0, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: women_Btn, borderColor: UIColor.lightGray, borderWidth: 2.0, cornerradius: 22.0)
        let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        progress_Bar.transform = transform
        progress_Bar.tintColor = Themes.sharedIntance.ReturnThemeColor()
        var percentProgress = Float(50.0*100.0/60.0)
        percentProgress = percentProgress/100.0

        progress_Bar.progress = percentProgress
    }
    
    @IBAction func DidclickContinue(_ sender: Any) {

        let ChoosePhotoVC = self.storyboard?.instantiateViewController(withIdentifier: "ChoosePicViewControllerID") as! ChoosePicViewController
        ChoosePhotoVC.objLogRecord = objLogRecord
        self.navigationController?.pushViewController(ChoosePhotoVC, animated: true)

    }
    @IBAction func DidclickWomen(_ sender: Any) {
        objLogRecord.gender  = "Men"
        Themes.sharedIntance.AddBorder(view: women_Btn, borderColor: Themes.sharedIntance.ReturnThemeColor(), borderWidth: 2.0, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: man_btn, borderColor: UIColor.lightGray, borderWidth: 2.0, cornerradius: 22.0)
        women_Btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
        man_btn.setTitleColor(UIColor.lightGray, for: .normal)
        continue_Btn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)

        continue_Btn.isUserInteractionEnabled = true
        continue_Btn.setTitleColor(UIColor.white, for: .normal)
        continue_Btn.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
        
        
    }

    @IBAction func DidclickMan(_ sender: Any) {
         objLogRecord.gender  = "Women"
        Themes.sharedIntance.AddBorder(view: women_Btn, borderColor: UIColor.lightGray, borderWidth: 2.0, cornerradius: 22.0)
        Themes.sharedIntance.AddBorder(view: man_btn, borderColor: Themes.sharedIntance.ReturnThemeColor(), borderWidth: 2.0, cornerradius: 22.0)
        man_btn.setTitleColor(Themes.sharedIntance.ReturnThemeColor(), for: .normal)
        women_Btn.setTitleColor(UIColor.lightGray, for: .normal)
        continue_Btn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
         continue_Btn.isUserInteractionEnabled = true
         continue_Btn.setTitleColor(UIColor.white, for: .normal)
        continue_Btn.backgroundColor = Themes.sharedIntance.ReturnThemeColor()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool
    {
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func DIdclickBack(_ sender: Any)
    {
  self.navigationController?.popViewController(animated: true)
        
        
    }

}
