//
//  ChoosePicViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import AFMActionSheet
import UIImageCropper
import CropViewController
import UICircularProgressRing
import ReachabilitySwift
import Lottie
class ChoosePicViewController: RootBaseViewcontroller,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIImageCropperProtocol,CropViewControllerDelegate,GetProgress {
    func setProgress(progress: Float) {
        progressBars.startProgress(to: CGFloat(progress), duration: 1.0)
    }
    
    
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        
        var path = String()
        
        let imageData = UIImageJPEGRepresentation(croppedImage!, 0.2)
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent("tmp.png")
        try! imageData?.write(to: imageURL)
        
        path = (imageURL.relativePath)
        
        objLogRecord.image = path
        picker .dismiss(animated: true, completion: nil)
        self.image_Btn.setImage(croppedImage, for: .normal)
        done_btn.setTitleColor(UIColor.white, for: .normal)
        done_btn.isUserInteractionEnabled = true
        done_btn.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
        done_btn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
        self.image_Btn.layer.cornerRadius = 5.0
        self.image_Btn.clipsToBounds = true
        
    }
    private var allUserData:AllUserData=AllUserData()
    var picker = UIImagePickerController()
    var objLogRecord:LoginRecord = LoginRecord()
    @IBOutlet weak var done_btn: CustomButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var image_Btn: UIButton!
    @IBOutlet weak var header_Lbl: UILabel!
    private let reachability = Reachability()!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var progressBars: UICircularProgressRing!
    @IBOutlet weak var choosePicView: UIView!
    private var loadingAlert:UIAlertController?
    var cropViewController:CropViewController?
    let animationView = AnimationView(name: "progress")
    
    
    let actionSheet = AFMActionSheetController(style: .actionSheet, transitioningDelegate: AFMActionSheetTransitioningDelegate())
    
    let cropper = UIImageCropper(cropRatio: 2/2)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.frame=self.view.frame
        topView.isHidden=true
        progressBars.isHidden=true
        topView.backgroundColor=UIColor(white: 1, alpha: 0.7)
            self.customView.frame=CGRect(x:self.progressBars.frame.origin.x,y:self.progressBars.frame.origin.y,width:250,height:250)
        self.customView.center=image_Btn.center
    animationView.frame=CGRect(x:0,y:0,width:self.customView.frame.size.width,height:self.customView.frame.size.height)
        
        self.customView.addSubview(animationView)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        self.customView.backgroundColor = .clear
        animationView.isHidden=true
        customView.isHidden=true
        progressBars.isHidden=true
        StaticData.allUserData=nil
        StaticData.updated=true
        progressBars.outerRingWidth=0
        progressBars.center=image_Btn.center
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        done_btn.isUserInteractionEnabled = false
        header_Lbl.text = "My\nbest pic is"
        Addaction()
        image_Btn.imageView?.contentMode = .scaleAspectFill
        picker.delegate=self
        //cropper.picker = picker
        //cropper.delegate = self
        //cropper.cropRatio = 2/3 //(can be set during runtime or in init)
        cropper.cropButtonText = "UPLOAD PHOTO" // button labes can be localised/changed
        cropper.cancelButtonText = "CANCEL"
        
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X"){
            navigationView.frame.origin.y += 50
            choosePicView.frame.origin.y += 50
        }


        // Do any additional setup after loading the view.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        dismiss(animated:true, completion: nil) //5
        cropViewController=CropViewController(image: chosenImage)
        self.cropViewController?.customAspectRatio = CGSize(width: 3, height: 4.48)
        self.cropViewController?.cropView.gridOverlayView.setGridHidden(false, animated: true)
        self.cropViewController?.cropView.cropBoxResizeEnabled=false
        self.cropViewController?.rotateButtonsHidden=true
        self.cropViewController?.aspectRatioPickerButtonHidden=true
        self.cropViewController?.resetButtonHidden=true
        cropViewController?.delegate = self
        present(cropViewController!, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        objLogRecord.imageRaw=image
        self.cropViewController?.dismiss(animated: true, completion: nil)
        enableButton(image: image)
      
    }
    private func enableButton(image:UIImage){
        self.image_Btn.setImage(image, for: .normal)
        done_btn.isUserInteractionEnabled = true
        done_btn.backgroundColor = Themes.sharedIntance.ReturnThemeColor()
        done_btn.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
        
        done_btn.setTitleColor(UIColor.white, for: .normal)
        self.image_Btn.layer.cornerRadius = 5.0
        self.image_Btn.clipsToBounds = true

    }
    func Addaction()
    {
        
        let action2 = AFMAction(title: "Gallery", enabled: true) { (action: AFMAction) -> Void in
            self.openGallary()
        }
        let action3 = AFMAction(title: "Cancel", handler: nil)
        actionSheet.add(action2)
        actionSheet.add(cancelling: action3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didclickDoneBtn(_ sender: Any) {
        RegisterUser(objRecord: objLogRecord)

//        let notificationVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewControllerID") as! NotificationViewController
//        self.navigationController?.present(notificationVC, animated: true, completion: nil)
    }
    func RegisterUser(objRecord:LoginRecord)
    {
            topView.isHidden=false
            animationView.isHidden=false
            customView.isHidden=false
            animationView.play()
            let image: UIImage = objRecord.imageRaw
            StaticData.imageUpload=objRecord.imageRaw
            ConfigManager.getInstance().setImageUpload(value: "Yes")
            ConfigManager.getInstance().setImage(image: objRecord.imageRaw)
            let imageData: NSData = UIImageJPEGRepresentation(image, 0.5)! as NSData
            let countryCode:String =  objRecord.country_code.replacingOccurrences(of: "+", with: "")
            let param:[String:String] = ["email_id":Themes.sharedIntance.CheckNullvalue(Str: objRecord.email_id as AnyObject),"password":Themes.sharedIntance.CheckNullvalue(Str: objRecord.password as AnyObject),"first_name":Themes.sharedIntance.CheckNullvalue(Str: objRecord.first_name as AnyObject),"last_name":objRecord.last_name,"dob":Themes.sharedIntance.CheckNullvalue(Str: objRecord.dob as AnyObject),"gender":Themes.sharedIntance.CheckNullvalue(Str: objRecord.gender as AnyObject),"verification_code":Themes.sharedIntance.CheckNullvalue(Str: objRecord.verification_code as AnyObject),"phone_number":Themes.sharedIntance.CheckNullvalue(Str: objRecord.phone_number as AnyObject),"country_code":countryCode]
            
            URLhandler.Sharedinstance.uploadImage(urlString: Constant.sharedinstance.Phonenumber_Signup as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
                    if(error == nil)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        _ = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        
                        if(status_code == "1")
                        {
                            let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_image_url") as AnyObject)
                            
                            let email = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "email") as AnyObject)
                            
                            let first_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "first_name") as AnyObject)
                            
                            let last_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "last_name") as AnyObject)
                            let user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "user_id") as AnyObject)
                            let access_token = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "access_token") as AnyObject)
                            let fullname = "\(first_name) \(last_name)"
                            let param:[String:String] = ["access_token":access_token,"email":email,"first_name":first_name,"full_name":fullname,"last_name":last_name,"signup_type":"fb","user_id":user_id,"user_image_url":user_image_url]
                            Themes.sharedIntance.saveUserID(userid: user_id)
                            Themes.sharedIntance.saveaccesstoken(userid:access_token)
                            DatabaseHandler.sharedinstance.insertDataForTable(tableName: Constant.sharedinstance.User_details, dictValues: param as NSDictionary)
                            self.getData()

                            
                        }
                        else {
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: ResponseDict!["status_message"]! as! String)
                        }
                        
                    }
                    else
                    {
                        print(error?.localizedDescription as Any)
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
            
                
            }
        
    }
    @IBAction func DidclickImage(_ sender: Any) {
        
        // Add the actions
//        picker.delegate = self
 
    
        //actionSheet.add(title: "Select Language")
        
        self.present(actionSheet, animated: true, completion: nil)
     
 
    }
    override func viewDidLayoutSubviews() {
        let transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
        progressBar.transform = transform
        progressBar.tintColor = Themes.sharedIntance.ReturnThemeColor()
        progressBar.progress = 1.0
        
        Themes.sharedIntance.AddBorder(view: done_btn, borderColor: nil, borderWidth: nil, cornerradius: done_btn.frame.size.height / 2)


    }
    @IBAction func DidclickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            self.picker.sourceType = .camera
            self.present(self.picker, animated: true, completion: nil)
        }
        else
        {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallary()
    {
        self.picker.sourceType = .photoLibrary
        self.present(self.picker, animated: true, completion: nil)
    }
    private func getData(){
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.user_data as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    
                   // print(responseDict)
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                   // print(responseDict)
                    if(status_code == "1") {
                        //Profile Data
                        
                        ConfigManager.getInstance().setData(value:StaticData.UserData! )
                        self.convertDictionary(responseDict: responseDict)
                        
                        
                    }else {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    }
                }else {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }else{
                let  err=error as? NSError
                if err?.code == 401{
                    let dit=ConfigManager.getInstance().getData()
                    if dit != nil{
                        do{
                            let responseDicts = try JSONSerialization.jsonObject(
                                
                                with: dit!,
                                
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            self.convertDictionary(responseDict: responseDicts)
                        }catch{
                            
                        }
                    }
                }
            }
        })
    }
    func uploadImage() {
        
        if reachability.currentReachabilityStatus != .notReachable {
            let imageData: NSData = UIImageJPEGRepresentation(StaticData.imageUpload!, 0.3)! as NSData
            done_btn.isUserInteractionEnabled=false
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.setCallBack(callback: self)
            URLhandler.Sharedinstance.imageUpload(urlString: Constant.sharedinstance.uploadProfileImageUrl as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
                self.animationView.stop()
                self.topView.isHidden=true
                self.animationView.isHidden=true
                self.customView.isHidden=true
                StaticData.isFirstTime=true
                ConfigManager.getInstance().setFirstTap(value: "YES")
                ConfigManager.getInstance().setFirstLike(value: "YES")
                if(error == nil) {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                    let successMsg = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1") {
                        StaticData.imageUpload=nil
                        let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "image_url") as AnyObject)
                        ConfigManager.getInstance().setImageUpload(value: "No")
                        if user_image_url.count > 0 {
                            
                            StaticData.allUserData!.imageList.removeAll()
                            StaticData.allUserData!.imageId.removeAll()
                            let imagesDictArray = ResponseDict!["image_url"] as! [Any]
                            for imageDict in imagesDictArray {
                                StaticData.allUserData!.imageId.append("\((imageDict as! [String:Any])["image_id"]!)")
                                StaticData.allUserData!.imageList.append((imageDict as! [String:Any])["image"] as! String)
                            }
                            StaticData.isFirstSignUp=true
                            (UIApplication.shared.delegate as! AppDelegate).MovetoRoot(status: "home")
                        }
                        
                        
                    }
                    else {
                        
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: successMsg)
                    }
                }
                else {
                    let err=error as? NSError
                    if err?.code == 401{
                        let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                }
            }
        }else{
            let alert = UIAlertController(title: "Oops", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler:{action in
                self.uploadImage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func getAllPlansData(){
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.all_plans_data as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            print(responseDict)
            print(error)
            if responseDict != nil{
                if((responseDict?.count)! > 0)
                {
                    
                    
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1") {
                        ConfigManager.getInstance().setPlans(value:StaticData.UserData!)
                        self.plansConvert(responseDict: responseDict)
                    }else {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    }
                }else {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                }
            }else{
                let  err=error as? NSError
                if err?.code == 401{
                    let dit=ConfigManager.getInstance().getPlans()
                    if dit != nil{
                        do{
                            let responseDicts = try JSONSerialization.jsonObject(
                                
                                with: dit!,
                                
                                options: JSONSerialization.ReadingOptions.mutableContainers
                                ) as? NSDictionary
                            self.plansConvert(responseDict: responseDicts)
                        }catch{
                            
                        }
                    }
                }
            }
        })
    }
    private func plansConvert(responseDict:NSDictionary?){
        let goldPlan=responseDict!["super_gold"] as! NSDictionary
        self.allUserData.goldImageDict = goldPlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.goldPlansDetails = goldPlan["plan_detail"] as! [[String:Any]]
        let plusPlan=responseDict!["super_plus"] as! NSDictionary
        self.allUserData.plusImageDict = plusPlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.plusPlansDetails = plusPlan["plan_detail"] as! [[String:Any]]
        //
        let boostPlan=responseDict!["boosts"] as! NSDictionary
        self.allUserData.boostImageDict = boostPlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.boostPlansDetail = boostPlan["plan_detail"] as! [[String:Any]]
        //
        let likePlan=responseDict!["super_like"] as! NSDictionary
        self.allUserData.superImageDict = likePlan["plan_images"] as! [[String:Any]]
        //
        self.allUserData.superPlansDetails = likePlan["plan_detail"] as! [[String:Any]]
        self.getData()
    }
    private func convertDictionary(responseDict:NSDictionary?){
        self.allUserData.jobTitle=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "job_title") as AnyObject)
        self.allUserData.college=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "college") as AnyObject)
        self.allUserData.gender=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "gender") as AnyObject)
        self.allUserData.about = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "about") as AnyObject)
        self.allUserData.distanceInvisible=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_invisible") as AnyObject)
        self.allUserData.pin=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email_otp") as AnyObject)
        StaticData.pin=self.allUserData.pin
        self.allUserData.showMyAge=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "show_my_age") as AnyObject)
        self.allUserData.kilometer=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "kilometer") as AnyObject)
        self.allUserData.remainingBoost = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "remaining_boost_count") as AnyObject)
        self.allUserData.remianingLikes = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "remaining_slikes_count") as AnyObject)
        self.allUserData.name=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "name") as AnyObject)
        self.allUserData.age=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "age") as AnyObject)
        self.allUserData.unreadCount=Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
        self.allUserData.work = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "work") as AnyObject)
        self.allUserData.remianingLikes=Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "remaining_slikes_count") as AnyObject)
        if ((responseDict?.object(forKey: "image_url") as AnyObject) as? NSArray) != nil {
            
            let imgArrayDict = (responseDict?.object(forKey: "image_url") as AnyObject) as! NSArray
            
            for imgDict:NSDictionary in imgArrayDict as! [NSDictionary] {
                
                let imgStr = Themes.sharedIntance.CheckNullvalue(Str: imgDict.object(forKey: "image") as AnyObject)
                let imgStrID = Themes.sharedIntance.CheckNullvalue(Str: imgDict.object(forKey: "image_id") as AnyObject)
                self.allUserData.imageList.append(imgStr)
                self.allUserData.imageId.append(imgStrID)
            }
        }
        //Reasons
        let unmatchReasonsArray = (responseDict?.object(forKey: "unmatch_reasons") as AnyObject) as! NSArray
        for unmatch:NSDictionary in unmatchReasonsArray as! [NSDictionary] {
            let reason:Reason=Reason()
            reason.reason_id=unmatch["reason_id"] as! Int
            reason.reason_message=unmatch["reason_message"] as! String
            self.allUserData.unmatchReasons.append(reason)
        }
        let reportReasonsArray = (responseDict?.object(forKey: "report_reasons") as AnyObject) as! NSArray
        for report:NSDictionary in reportReasonsArray as! [NSDictionary] {
            let reason:Reason=Reason()
            reason.reason_id=report["reason_id"] as! Int
            reason.reason_message=report["reason_message"] as! String
            self.allUserData.reportReasons.append(reason)
        }
        let deleteReasonsArray = (responseDict?.object(forKey: "delete_reasons") as AnyObject) as! NSArray
        for delete:NSDictionary in deleteReasonsArray as! [NSDictionary] {
            let reason:Reason=Reason()
            reason.reason_id=delete["reason_id"] as! Int
            reason.reason_message=delete["reason_message"] as! String
            self.allUserData.deleteReasons.append(reason)
        }
        // Setting Data
        let objRecord:SettingRecord = SettingRecord()
        objRecord.email=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email") as AnyObject)
        StaticData.email=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email") as AnyObject)
        StaticData.phonenumber=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_number") as AnyObject)
        StaticData.phonecode=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_code") as AnyObject)
        objRecord.phoneNumber=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_number") as AnyObject)
        objRecord.countryCode=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "phone_code") as AnyObject)
        objRecord.community_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "community_url") as AnyObject)
        objRecord.distance_type = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_type") as AnyObject)
        objRecord.distance_unit = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "distance_unit") as AnyObject)
        objRecord.help_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "help_url") as AnyObject)
        //                       self.objRecord.location = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "location") as AnyObject)
        if Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "location") as AnyObject).count > 0 {
            objRecord.locationDictArray = responseDict?.object(forKey: "location") as! [[String:Any]]
        }
        objRecord.max_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "max_age") as AnyObject)
        
        objRecord.max_distance = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "max_distance") as AnyObject)
        objRecord.minimum_distance = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "minimum_distance") as AnyObject)
        objRecord.maximum_distance = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "maximum_distance") as AnyObject)
        objRecord.plan_type = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "plan_type") as AnyObject)
        objRecord.message_likes = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "message_likes") as AnyObject)
        objRecord.min_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "min_age") as AnyObject)
        objRecord.minimum_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "minimum_age") as AnyObject)
        objRecord.maximum_age = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "maximum_age") as AnyObject)
        objRecord.new_match = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "new_match") as AnyObject)
        objRecord.privacy_policy_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "privacy_policy_url") as AnyObject)
        objRecord.profile_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "profile_url") as AnyObject)
        objRecord.receiving_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "receiving_message") as AnyObject)
        objRecord.safety_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "safety_url") as AnyObject)
        objRecord.show_me = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "show_me") as AnyObject)
        objRecord.gender = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "matching_profile") as AnyObject)
        if objRecord.gender == "Both" {
            objRecord.gender = "Men and Women"
        }
        objRecord.super_likes = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "super_likes") as AnyObject)
        objRecord.verifyEmail=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "email_verify") as AnyObject)
        objRecord.terms_of_service_url = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "terms_of_service_url") as AnyObject)
        objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "user_id") as AnyObject)
        objRecord.username = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "username") as AnyObject)
        objRecord.username = objRecord.username.removingWhitespaces()
        objRecord.city=Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "city") as AnyObject)
        
        // Get Chat History
        let unread_count = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
        Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
        self.allUserData.setting=objRecord
        let conversation_not_started_array:NSArray =  responseDict?.object(forKey: "conversation_not_started_array") as! NSArray
        
        if(conversation_not_started_array.count > 0)
        {
            for i in 0..<conversation_not_started_array.count
            {
                let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                let objRecords:matchProfileRecord = matchProfileRecord()
                objRecords.isgoldLike = false
                
                objRecords.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                objRecords.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                objRecords.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                
                objRecords.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                objRecords.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                objRecords.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                
                objRecords.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                
                self.allUserData.conservationNotStarteds.append(objRecords)
                
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
                let objRecords:matchProfileRecord = matchProfileRecord()
                objRecords.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                objRecords.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                objRecords.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                
                objRecords.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                objRecords.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                objRecords.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                objRecords.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                objRecords.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                objRecords.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                self.allUserData.conservationStarteds.append(objRecords)
                
            }
            
        }
        DispatchQueue.main.async {
                StaticData.allUserData=self.allUserData
                
                self.uploadImage()
            
        }
        
    }
}

