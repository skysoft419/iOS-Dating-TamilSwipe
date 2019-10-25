//
//  EdtProfileViewController.swift
//  Igniter
//
//  Created by Rana Asad on 02/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import collection_view_layouts
import CropViewController
import UICircularProgressRing
import SwiftMessages
import ReachabilitySwift
class EditProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,ContentDynamicLayoutDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,CropViewControllerDelegate,GetProgress,UITextViewDelegate{
    func setProgress(progress: Float) {
        let index=IndexPath(row: indexpath!, section: 0)
        let cell=collectionView.cellForItem(at: index) as! ImageCollectionViewCell
        cell.progressbar.startProgress(to: CGFloat(progress), duration: 1.0)

    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        return cellsSizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=self.collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell
        if cell.button.imageView?.image == UIImage(named:"cancel"){
            self.Removeimage(imgID: indexPath.row)
        }else{
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.setUpViews()
        cell.imageView.layer.cornerRadius=6
        cell.imageView.clipsToBounds=true
        cell.circleView.layer.cornerRadius=12
        loadCollectionImages(cell: cell, collectionIndexPath: indexPath, selectedIndex: self.indexpath, isImageUploading: isFirst, uploadedImage: currentImage)
        return cell
    }
    private func loadCollectionImages(cell:ImageCollectionViewCell,collectionIndexPath:IndexPath,selectedIndex:Int?,isImageUploading:Bool,uploadedImage:UIImage?){
        if firstImageId == nil{
            if imageList.count > collectionIndexPath.row{
                cell.progressbar.isHidden=true
                cell.button.isHidden=false
                cell.circleView.isHidden=false
                if collectionIndexPath.row != 0{
                    cell.button.setImage(UIImage(named:"cancel"), for: .normal)
                }else{
                    cell.button.setImage(UIImage(named:"pencil-2"), for: .normal)
                }
                let imgeStr=imageList[collectionIndexPath.row]
                if uploadedImage != nil && selectedIndex == collectionIndexPath.row{
                    cell.imageView.sd_setImage(with: URL(string:imgeStr), placeholderImage: uploadedImage,completed: { (image, error, cache, url) in
                        let size=image?.size
                        self.currentImage=nil
                        if error != nil {
                            cell.imageView.image = #imageLiteral(resourceName: "Ello Avatar")
                        }
                    })
                }else{
                cell.imageView.sd_setImage(with: URL(string:imgeStr), placeholderImage: #imageLiteral(resourceName: "Ello Avatar"),completed: { (image, error, cache, url) in
                    let size=image?.size
                    if error != nil {
                        cell.imageView.image = #imageLiteral(resourceName: "Ello Avatar")
                    }
                })
                }
            }else if imageArray.count > 0 && isImageUploading == false && selectedIndex == collectionIndexPath.row{
                
                cell.progressbar.outerRingWidth=0
                cell.progressbar.isHidden=false
                cell.button.isHidden=true
                cell.circleView.isHidden=true
                if collectionIndexPath.row != 0{
                    cell.button.setImage(UIImage(named:"cancel"), for: .normal)
                }else{
                    cell.button.setImage(UIImage(named:"pencil-2"), for: .normal)
                }
                cell.imageView.image=imageArray[0]
                //cell.imageView.backgroundColor=UIColor.black.withAlphaComponent(0.5)
                self.isFirst=true
            }else{
                // cell.imageView.backgroundColor=UIColor.black.withAlphaComponent(0.0)
                cell.progressbar.isHidden=true
                cell.button.isHidden=false
                cell.circleView.isHidden=false
                cell.button.setImage(UIImage(named:"plus"), for: .normal)
                cell.imageView.image=nil
            }
        }else{
            if imageList.count > collectionIndexPath.row && collectionIndexPath.row != 0{
                
                //cell.imageView.backgroundColor=UIColor.black.withAlphaComponent(0.0)
                cell.progressbar.isHidden=true
                cell.button.isHidden=false
                cell.circleView.isHidden=false
                if collectionIndexPath.row != 0{
                    cell.button.setImage(UIImage(named:"cancel"), for: .normal)
                }else{
                    cell.button.setImage(UIImage(named:"pencil-2"), for: .normal)
                }
                let imgeStr=imageList[collectionIndexPath.row]
                cell.imageView.sd_setImage(with: URL(string:imgeStr), placeholderImage: #imageLiteral(resourceName: "Ello Avatar"),completed: { (image, error, cache, url) in
                    let size=image?.size
                    if error != nil {
                        cell.imageView.image = #imageLiteral(resourceName: "Ello Avatar")
                    }
                })
            }else if imageArray.count > 0 && isImageUploading == false && selectedIndex == collectionIndexPath.row{
                
                cell.progressbar.outerRingWidth=0
                cell.progressbar.isHidden=false
                cell.button.isHidden=true
                cell.circleView.isHidden=true
                if collectionIndexPath.row != 0{
                    cell.button.setImage(UIImage(named:"cancel"), for: .normal)
                }else{
                    cell.button.setImage(UIImage(named:"pencil-2"), for: .normal)
                }
                cell.imageView.image=imageArray[0]
               
                self.isFirst=true
            }else{
               
                cell.button.isHidden=false
                cell.circleView.isHidden=false
                cell.progressbar.isHidden=true
                cell.button.setImage(UIImage(named:"plus"), for: .normal)
                cell.imageView.image=nil
            }
        }
        cell.editImagetapAction = {() in
            let cell=self.collectionView.cellForItem(at: collectionIndexPath) as! ImageCollectionViewCell
            if collectionIndexPath.row == 0{
                self.firstImageId=self.imageId[collectionIndexPath.row]
                self.isFirst=false
                self.indexpath=collectionIndexPath.row
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            }else if collectionIndexPath.row < self.imageId.count{
                self.showAlert(imgId: collectionIndexPath.row)
            }else{
                self.firstImageId=nil
                self.isFirst=false
                self.indexpath=collectionIndexPath.row
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            }
            
        }
        cell.editButtonTapAction = {
            () in
            print("Edit tapped in cell", collectionIndexPath)
            let cell=self.collectionView.cellForItem(at: collectionIndexPath) as! ImageCollectionViewCell
            if cell.button.imageView?.image == UIImage(named:"cancel"){
                self.showAlert(imgId: collectionIndexPath.row)
            }else if(cell.button.imageView?.image == UIImage(named:"pencil-2")){
                self.firstImageId=self.imageId[collectionIndexPath.row]
                self.isFirst=false
                self.indexpath=collectionIndexPath.row
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
            }else{
                self.firstImageId=nil
                self.isFirst=false
                self.indexpath=collectionIndexPath.row
                self.picker.sourceType = .photoLibrary
                self.present(self.picker, animated: true, completion: nil)
                
            }
            
        }
        
    }
    func showAlert(imgId:Int) {
        let optionMenu = UIAlertController(title: nil, message: "Are you sure to delete image", preferredStyle: .actionSheet)
        
        
        
        
        
        
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
           self.Removeimage(imgID: imgId)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    @IBOutlet weak var forthViewHeight: NSLayoutConstraint!
    @IBOutlet weak var forthTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var forthLabel: UILabel!
    @IBOutlet weak var thirdViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var secondTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstTextView: NSLayoutConstraint!
    @IBOutlet weak var firstViewHeight: NSLayoutConstraint!
    @IBOutlet weak var firstLabel: UILabel!
    private var indexpath:Int?
    private  let kTagsPadding: CGFloat = 1
    private  let kMinCellSize: UInt32 = 50
    private  let kMaxCellSize: UInt32 = 100
    private var contentFlowLayout: ContentDynamicLayout?
    @IBOutlet weak var accountButton: UIButton!
    private var cellsSizes = [CGSize]()
    @IBOutlet weak var aboutmeView: UIView!
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var schollTExtView: UITextView!
    @IBOutlet weak var schoolView: UIView!
    @IBOutlet weak var distanceSwitch: UISwitch!
    @IBOutlet weak var comapnyTextView: UITextView!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var ageSwitch: UISwitch!
    @IBOutlet weak var comapnyView: UIView!
    @IBOutlet weak var jobTextView: UITextView!
    @IBOutlet weak var jobView: UIView!
    @IBOutlet weak var aboutmeTextview: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var customViewH: UIView!
    @IBOutlet weak var customViewHeight: NSLayoutConstraint!
    private var isSwipe:Bool=false
    private var isFirst:Bool=false
    @IBOutlet weak var scrollviewBottom: NSLayoutConstraint!
    @IBOutlet weak var done: UIBarButtonItem!
    private var cropViewController:CropViewController?
    private var loadingAlert:UIAlertController?
    private var imageList:Array<String>=[]
    private var imageId:Array<String>=[]
    private var picker = UIImagePickerController()
    private var ageStr = String()
    private var distanceStr = String()
    fileprivate var snapshotView: UIView?
    fileprivate var snapshotIndexPath: IndexPath?
    fileprivate var snapshotPanPoint: CGPoint?
    private var imageArray:Array<UIImage>=[]
    private var currentImage:UIImage?
    private var progress:Float=0
    private var firstImageId:String?
    private var isFirstCall=false
    private let reachability = Reachability()!
    override func viewDidLoad() {
        super.viewDidLoad()
        done.setTitleTextAttributes([NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        loadingAlert=UIAlertController(title:"",message:"Deleting....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Deleting....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        setLayout()
        aboutmeTextview.delegate=self
        jobTextView.delegate=self
        schollTExtView.delegate=self
        comapnyTextView.delegate=self
        picker.delegate=self
        contentFlowLayout = InstagramStyleFlowLayout()
        contentFlowLayout?.contentAlign = .right
        contentFlowLayout?.delegate = self
        contentFlowLayout?.contentPadding = ItemsPadding(horizontal: 0, vertical: 0)
        contentFlowLayout?.cellsPadding = ItemsPadding(horizontal: 0, vertical: 0)
        
        
        collectionView.collectionViewLayout = contentFlowLayout!
        //collectionView.delegate=self
        collectionView.dataSource=self
        for n in 1...6 {
            cellsSizes.append(provideRandomCellSize())
        }
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressRecognized(_:)))
        gestureRecognizer.minimumPressDuration = 0.2
        collectionView!.addGestureRecognizer(gestureRecognizer)
        loadProfileData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        addToolbar()
       
    }
    private func addToolbar(){
        let Toolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        Toolbar.barStyle = .blackTranslucent
        let button=UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(hidekeyboard))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        buttonTitleColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.tintColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        Toolbar.items = [flexibleSpace,button]
        Toolbar.sizeToFit()
        comapnyTextView.inputAccessoryView=Toolbar
        jobTextView.inputAccessoryView=Toolbar
        aboutmeTextview.inputAccessoryView=Toolbar
        schollTExtView.inputAccessoryView=Toolbar
        
    }
    @objc func hidekeyboard() {
        self.view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollviewBottom.constant=0
            let keyboardHeight = keyboardSize.height
            scrollviewBottom.constant -= keyboardHeight
            self.view.layoutIfNeeded()
            
           
    }
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollviewBottom.constant=0
        }
            
    }
    override func viewWillDisappear(_ animated: Bool) {

    }
    override func viewDidAppear(_ animated: Bool) {
    }
   @objc func longPressRecognized(_ recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: collectionView)
        let indexPath = collectionView?.indexPathForItem(at: location)
        
        switch recognizer.state {
        case UIGestureRecognizerState.began:
            if indexPath!.row < imageList.count{
            guard let indexPath = indexPath else { return }
            
            let cell = self.collectionView?.cellForItem(at: indexPath) as! ImageCollectionViewCell
            cell.imageView.layer.cornerRadius=6
            snapshotView = cell.imageView.snapshotView(afterScreenUpdates: true)
            snapshotView?.center=cell.center
            snapshotView?.layer.cornerRadius=5
            collectionView!.addSubview(snapshotView!)
            cell.contentView.alpha = 0.0
            
            UIView.animate(withDuration: 0.2, animations: {
                //self.snapshotView?.shake()
                self.snapshotView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                self.snapshotView?.alpha = 0.9
            })
            
            snapshotPanPoint = location
            snapshotIndexPath = indexPath
            }
        case UIGestureRecognizerState.changed:
            guard let snapshotPanPoint = snapshotPanPoint else { return }
            
            let translation = CGPoint(x: location.x - snapshotPanPoint.x, y: location.y - snapshotPanPoint.y)
            snapshotView?.center.x += translation.x
            snapshotView?.center.y += translation.y
            self.snapshotPanPoint = location
            
            guard let indexPath = indexPath else { return }
            if indexPath.row < imageList.count{
            
                let temp=self.imageId.remove(at: (snapshotIndexPath?.item)!)
                StaticData.allUserData!.imageId.remove(at: (snapshotIndexPath?.item)!)
                self.imageId.insert(temp, at: indexPath.item)
                StaticData.allUserData!.imageId.insert(temp,at:indexPath.item)
                let temp2=self.imageList.remove(at: (snapshotIndexPath?.item)!)
                self.imageList.insert(temp2, at: indexPath.item)
                let imagel=self.imageList
               StaticData.allUserData!.imageList.remove(at: (snapshotIndexPath?.item)!)
                StaticData.allUserData!.imageList.insert(temp2, at: (snapshotIndexPath?.item)!)
                let imagef=StaticData.allUserData!.imageList
            collectionView!.moveItem(at: snapshotIndexPath!, to: indexPath)
            collectionView.reloadData()
            snapshotIndexPath = indexPath
            }
        default:
            guard let snapshotIndexPath = snapshotIndexPath else { return }
            let cell = self.collectionView?.cellForItem(at: snapshotIndexPath)
            UIView.animate(
                withDuration: 0.2,
                animations: {
                    self.snapshotView?.center = cell!.center
                    self.snapshotView?.transform = CGAffineTransform.identity
                    self.snapshotView?.alpha = 1.0
            },
                completion: { finished in
                    cell!.contentView.alpha = 1.0
                    self.snapshotView?.removeFromSuperview()
                    self.snapshotView = nil
            })
            self.snapshotIndexPath = nil
            self.snapshotPanPoint = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.collectionView.reloadData()
            }
            
        }
    }
    private func setLayout(){
       
        self.secondLabel.isHidden=true
        self.thirdLabel.isHidden=true
        self.forthLabel.isHidden=true
        genderView.layer.cornerRadius=4
       
       
        
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let rangeOfTextToReplace = Range(range, in: textView.text) else {
            return false
        }
        let substringToReplace = textView.text[rangeOfTextToReplace]
        let count = textView.text.count - substringToReplace.count + text.count
        if textView == aboutmeTextview{
        return count <= 500
        }else{
            return count <= 120
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        heightOfView(textView: textView)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        dismiss(animated:true, completion: {
            self.cropViewController=CropViewController(image: chosenImage)
            self.cropViewController?.customAspectRatio = CGSize(width: 3, height: 4.48)
            self.cropViewController?.aspectRatioLockEnabled=true
            self.cropViewController?.cropView.gridOverlayView.setGridHidden(false, animated: true)
            self.cropViewController?.cropView.cropBoxResizeEnabled=false
            self.cropViewController?.rotateButtonsHidden=true
            self.cropViewController?.aspectRatioPickerButtonHidden=true
            self.cropViewController?.resetButtonHidden=true
            self.cropViewController?.delegate = self
            self.present(self.cropViewController!, animated: true, completion: nil)
        }) //5
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        let imageData = UIImageJPEGRepresentation(image, 0.7)
        let image: UIImage = UIImage(data: imageData!)!
        let size=image.size
        self.cropViewController?.dismiss(animated: true, completion: nil)
        self.imageArray.append(image)
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let imageId = self.firstImageId, Int(imageId)! > 0{
                self.editFirstImage(imgPath: image)
            }else{
                
                 self.uploadImage(imgPath: image)
                
            }
        }
    }
   

        func provideRandomCellSize() -> CGSize {
        let width = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        let height = CGFloat(arc4random_uniform(kMaxCellSize) + kMinCellSize)
        
        return CGSize(width: width, height: height)
    }
    private func loadProfileData(){
        imageId=(StaticData.allUserData?.imageId)!
        imageList=(StaticData.allUserData?.imageList)!
        let image=imageList
        self.jobTextView.text=StaticData.allUserData!.jobTitle!
        self.heightOfView(textView: self.jobTextView)
        self.schollTExtView.text=StaticData.allUserData!.college!
        self.heightOfView(textView: self.schollTExtView)
        if StaticData.allUserData!.gender! == "Men"{
            self.genderSegment.selectedSegmentIndex = 0
        }else{
            self.genderSegment.selectedSegmentIndex = 1
        }
        self.aboutmeTextview.text=StaticData.allUserData!.about!
        self.heightOfView(textView: self.aboutmeTextview)
        self.distanceStr=StaticData.allUserData!.distanceInvisible!
        /*
        if SharedVariables.sharedInstance.planType.count > 0 {
            if (distanceStr=="No") {
                
            }else{
                self.distanceSwitch.setOn(false, animated: true)
            }
        }
        else {
            self.distanceSwitch.setOn(false, animated: true)
        }
        self.ageStr=StaticData.allUserData!.showMyAge!
        if SharedVariables.sharedInstance.planType.count > 0 {
            if (self.ageStr=="No") {
                self.ageSwitch.setOn(true, animated: true)
            }
            else {
                self.ageSwitch.setOn(false, animated: true)
            }
        }
        else {
            self.ageSwitch.setOn(false, animated: true)
        }*/
        self.comapnyTextView.text = StaticData.allUserData!.work!
        self.heightOfView(textView: self.comapnyTextView)
        self.collectionView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    private func heightOfView(textView:UITextView){
        if textView == self.aboutmeTextview{
            firstLabel.text=String(describing:textView.text.length)+"/"+"500"
        }else if textView == self.jobTextView{
            secondLabel.text=String(describing:textView.text.length)+"/"+"120"
        }else if textView == self.comapnyTextView{
            thirdLabel.text=String(describing:textView.text.length)+"/"+"120"
        }else if textView == self.schollTExtView{
            forthLabel.text=String(describing:textView.text.length)+"/"+"120"
        }
        let oldHeight = textView.frame.size.height
        let maxHeight: CGFloat = 250.0 //beyond this value the textView will scroll
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight)
        newHeight = ceil(newHeight)
        if newHeight != oldHeight {
            UIView.animate(withDuration: 0.2) {
                if textView == self.aboutmeTextview{
                    self.firstTextView.constant=newHeight
                    self.firstViewHeight.constant=newHeight+20
                    self.customViewHeight.constant=newHeight+1160
                }else if textView == self.jobTextView{
                    self.secondTextViewHeight.constant=newHeight
                    self.secondViewHeight.constant=newHeight+10
                }else if textView == self.comapnyTextView{
                    self.thirdTextViewHeight.constant=newHeight
                    self.thirdViewHeight.constant=newHeight+10
                }else if textView == self.schollTExtView{
                    self.forthTextViewHeight.constant=newHeight
                    self.forthViewHeight.constant=newHeight+10
                }
                self.view.invalidateIntrinsicContentSize()
            }
        }
    }
    func editFirstImage(imgPath:UIImage){
        if reachability.currentReachabilityStatus != .notReachable{
        let imageData: NSData = UIImageJPEGRepresentation(imgPath, 0.9)! as NSData
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"image_id":self.firstImageId!]
        URLhandler.Sharedinstance.setCallBack(callback: self)
        URLhandler.Sharedinstance.imageUpload(urlString: Constant.sharedinstance.update_first_image as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
            if(error == nil) {
                print(ResponseDict)
                self.firstImageId=nil
                self.currentImage=self.imageArray[0]
                self.imageArray.removeAll()
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                let successMsg = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                print(ResponseDict)
                if(status_code == "1") {
                    self.showSucess()
                    let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "image_url") as AnyObject)
                    
                    if user_image_url.count > 0 {
                        
                        let imagesDictArray = ResponseDict!["image_url"] as! [Any]
                        for imageDict in imagesDictArray {
                            self.imageId.remove(at: 0)
                            self.imageList.remove(at: 0)
                            StaticData.allUserData!.imageId.remove(at: 0)
                            StaticData.allUserData!.imageList.remove(at: 0)
                            self.imageId.insert("\((imageDict as! [String:Any])["image_id"]!)", at: 0)
                            self.imageList.insert((imageDict as! [String:Any])["image"] as! String, at: 0)
                            StaticData.allUserData!.imageId.insert("\((imageDict as! [String:Any])["image_id"]!)", at: 0)
                            StaticData.allUserData!.imageList.insert((imageDict as! [String:Any])["image"] as! String, at: 0)
                        }
                    }
                    self.collectionView.reloadData()
                    
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
                self.editFirstImage(imgPath: imgPath)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func uploadImage(imgPath:UIImage) {
        if reachability.currentReachabilityStatus != .notReachable{
            let imageData: NSData = UIImageJPEGRepresentation(imgPath, 0.9)! as NSData
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.setCallBack(callback: self)
            URLhandler.Sharedinstance.imageUpload(urlString: Constant.sharedinstance.uploadProfileImageUrl as NSString, parameters: param, imgData: imageData) { (ResponseDict, error) in
                    if(error == nil) {
                        self.firstImageId=nil
                        self.currentImage=self.imageArray[0]
                        self.imageArray.removeAll()
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let successMsg = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1") {
                            self.showSucess()
                            let user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "image_url") as AnyObject)
                            
                            if user_image_url.count > 0 {
                                
                               self.imageList.removeAll()
                                self.imageId.removeAll()
                                StaticData.allUserData!.imageList.removeAll()
                                StaticData.allUserData!.imageId.removeAll()
                                let imagesDictArray = ResponseDict!["image_url"] as! [Any]
                                for imageDict in imagesDictArray {
                                    self.imageId.append("\((imageDict as! [String:Any])["image_id"]!)")
                                    self.imageList.append((imageDict as! [String:Any])["image"] as! String)
                                    StaticData.allUserData!.imageId.append("\((imageDict as! [String:Any])["image_id"]!)")
                                    StaticData.allUserData!.imageList.append((imageDict as! [String:Any])["image"] as! String)
                                }
                            }
                            self.collectionView.reloadData()
                            
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
                self.uploadImage(imgPath: self.imageArray[0])
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func showSucess(){
        let view: CustomCardView = try! SwiftMessages.viewFromNib()
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        successConfig.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        view.configureDropShadow()
        view.customView.layer.cornerRadius=6
        view.userimage?.layer.cornerRadius=6
        view.userimage?.clipsToBounds=true
        view.userimage?.image=currentImage!
        view.configureBackgroundView(width: 8.0)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        SwiftMessages.show(config: successConfig, view: view)
    }
    func Removeimage(imgID:Int) {
        self.present(self.loadingAlert!, animated: true, completion: {
            print(self.imageId[imgID])
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"image_id":self.imageId[imgID]]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.remove_profile_image as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if (error == nil) {
                        
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let successMsg = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        
                        if(status_code == "1") {
                            
                            self.imageList.remove(at: imgID)
                            self.imageId.remove(at: imgID)
                            StaticData.allUserData!.imageList.remove(at: imgID)
                            StaticData.allUserData!.imageId.remove(at: imgID)
                        }
                        else {
                            
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: successMsg)
                        }
                        self.collectionView.reloadData()
                    }
                    else {
                        
                        print(error?.localizedDescription as Any)
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                })
                
            })
        })
    }
    func updateProfileData()
    {
        Themes.sharedIntance.removeUserImage()
        Themes.sharedIntance.saveUserImage(userid: imageList[0])
        
        var str=""
        var first=true
        for img in imageId{
            if first{
                str=img
                first=false
            }else{
                str=str+","+img
            }
        }
            var gender:String?
            if self.genderSegment.selectedSegmentIndex == 0{
                gender="Men"
            }else{
                gender="Women"
            }
            var ageStatus = "yes"
        
            
            var distanceStatus="yes"
        
            
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"order_images":str,"gender":Themes.sharedIntance.CheckNullvalue(Str:gender! as AnyObject),"about":Themes.sharedIntance.CheckNullvalue(Str:self.aboutmeTextview.text as AnyObject),"college":Themes.sharedIntance.CheckNullvalue(Str: self.schollTExtView.text as AnyObject),"job_title":Themes.sharedIntance.CheckNullvalue(Str: self.jobTextView.text as AnyObject),/*"instagram_id":Themes.sharedIntance.CheckNullvalue(Str: instagramID as AnyObject),*/"distance_invisible":Themes.sharedIntance.CheckNullvalue(Str: distanceStatus as AnyObject),"show_my_age":Themes.sharedIntance.CheckNullvalue(Str: ageStatus as AnyObject),"work":Themes.sharedIntance.CheckNullvalue(Str: self.comapnyTextView.text as AnyObject)]
            StaticData.allUserData!.jobTitle=self.jobTextView.text!
            StaticData.allUserData!.about=self.aboutmeTextview.text!
            StaticData.allUserData!.college=self.schollTExtView.text!
            StaticData.allUserData!.work=self.comapnyTextView.text!
            StaticData.allUserData!.gender=gender!
            StaticData.allUserData!.distanceInvisible=distanceStatus
            StaticData.allUserData!.showMyAge=ageStatus
            StaticData.allUserData?.imageList.removeAll()
            StaticData.allUserData?.imageList=self.imageList
            StaticData.allUserData?.imageId.removeAll()
            StaticData.allUserData?.imageId=self.imageId
        self.navigationController?.dismiss(animated: true, completion:nil)
        if reachability.currentReachabilityStatus == .notReachable{
            StaticData.isPushed=true
        }else{
            DispatchQueue.global(qos: .background).async {
                URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.updateProfileView as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                    if((responseDict?.count)! > 0) {
                        
                        print(responseDict ?? "")
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1") {
                        }
                        else {
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        }
                    }
                    else {
                        
                        Themes.sharedIntance.RemoveProgress(view: self.view)
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                })
            }
        }
    }
    @IBAction func genderSegment(_ sender: Any) {
    }
    @IBAction func ageSwitch(_ sender: Any) {
        if !(SharedVariables.sharedInstance.planType == "Plus" || SharedVariables.sharedInstance.planType == "Gold") {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let destController = storyboard.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isGold = false
            let navController = UINavigationController(rootViewController: destController)
            navController.navigationBar.isHidden = true
            self.present(navController, animated:true, completion: nil)
            if(self.ageStr=="No") {
                self.ageSwitch.setOn(true, animated: true)
            }
            else {
                self.ageSwitch.setOn(false, animated: true)
                self.ageSwitch.onTintColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                self.ageSwitch.onTintColor=#colorLiteral(red: 0.8946250081, green: 0.3806622028, blue: 0.3167798817, alpha: 1)
            }
        }
    }
    @IBAction func accountButton(_ sender: Any) {
    }
    @IBAction func distanceSwitch(_ sender: Any) {
        
        if !(SharedVariables.sharedInstance.planType == "Plus" || SharedVariables.sharedInstance.planType == "Gold") {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let destController = storyboard.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isGold = false
            let navController = UINavigationController(rootViewController: destController)
            navController.navigationBar.isHidden = true
            self.present(navController, animated:true, completion: nil)
            if(self.distanceStr=="No") {
                
            }
            else {
                DispatchQueue.main.async {
                    self.distanceSwitch.setOn(false, animated: true)
                    //self.distanceSwitch.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.distanceSwitch.onTintColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                    self.distanceSwitch.onTintColor=#colorLiteral(red: 0.8946250081, green: 0.3806622028, blue: 0.3167798817, alpha: 1)
                }
                
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIBarButtonItem) {
        updateProfileData()
    }
}

extension Array {
    public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key:Element] {
        var dict = [Key:Element]()
        for element in self {
            dict[selectKey(element)] = element
        }
        return dict
    }
}
