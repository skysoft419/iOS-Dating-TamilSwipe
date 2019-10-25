
//
//  User_DetailViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import AFMActionSheet
import MessageUI

protocol  User_DetailViewControllerDelegate{
    func SwipeAction(Status:String)
}


class User_DetailViewController: RootBaseViewcontroller,MFMessageComposeViewControllerDelegate {
    
    let actionSheet = AFMActionSheetController(style: .actionSheet, transitioningDelegate: AFMActionSheetTransitioningDelegate())
    var delegate:User_DetailViewControllerDelegate?
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var pagecontrol: FXPageControl!
    @IBOutlet weak var Slider_CollectionView: SliderCollectionView!
    @IBOutlet weak var toafrnd_Lbl: UILabel!
    @IBOutlet weak var profile_LikeBtn: UIButton!
    @IBOutlet weak var recommendLbl: UILabel!
    @IBOutlet weak var ProfileSuperLikeBtn: UIButton!

    @IBOutlet weak var topCollection: UICollectionView!
    @IBOutlet weak var ProfileUnlikeBtn: UIButton!
    @IBOutlet weak var profDetail_BtnWrapperView: UIView!
    @IBOutlet weak var marker_img: UIButton!
    @IBOutlet weak var loc_Lbl: UILabel!
    @IBOutlet weak var univ_Lbl: UILabel!
    @IBOutlet weak var name_Lbl: UILabel!
    @IBOutlet weak var univ_img: UIButton!
    @IBOutlet weak var share_Btn: UIButton!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var profile_scrollView: UIScrollView!
    @IBOutlet weak var Profile_DetailView: UIView!
    @IBOutlet var reportLabelOutlet: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var lineLabel: UILabel!
    @IBOutlet weak var aboutUserView: UIView!
    @IBOutlet weak var reportContainer: UIView!
    public var user_id:String?
    public var from=0
    private var isFirstCall=false
    var callback:CallBack?
    
    
    var objRecord:otherUserRecord = otherUserRecord()
    var isfromuserDetail:Bool = Bool()
    var reportDatasourceArr:NSMutableArray = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        reportLabelOutlet.isHidden = true
//        lineLabel.frame.size.width = aboutUserView.frame.size.width
            SetData()
       
            profDetail_BtnWrapperView.isHidden = true
            reportLabelOutlet.isHidden=false
            reportLabelOutlet.text="Report \(objRecord.name)".uppercased()
            reportView.isHidden=false
            reportView.layer.borderColor=#colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
            reportView.layer.borderWidth=0.5
            
        
         // Do any additional setup after loading the view.
    }
    private func setDetailViewOrigins(){
        aboutUserView.frame.origin.x=0
        aboutLabel.frame.size.width=self.view.frame.width-10
        aboutUserView.frame.size.width=self.view.frame.width-10
        marker_img.frame.origin.y=name_Lbl.frame.origin.y+40
        loc_Lbl.frame.origin.y=name_Lbl.frame.origin.y+40
        officeButton.frame.origin.y=marker_img.frame.origin.y+25
        jobTitleLabel.frame.origin.y=marker_img.frame.origin.y+25
        univ_img.frame.origin.y=officeButton.frame.origin.y+25
        univ_Lbl.frame.origin.y=officeButton.frame.origin.y+25
        aboutLabel.frame.origin.y=univ_Lbl.frame.origin.y+25
        
    }
    private func setUpView(){
        let height=aboutUserView.frame.height
        var maximumLabelSize: CGSize = CGSize(width: 276, height: 9999)
        var expectedLabelSize: CGSize = aboutLabel.sizeThatFits(maximumLabelSize)
        aboutUserView.frame.size.height = height + expectedLabelSize.height
        self.profile_scrollView.bringSubview(toFront: pagecontrol)
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X") || (UIDevice.modelName == "iPhone XS") || (UIDevice.modelName == "iPhone XS Max") || (UIDevice.modelName == "iPhone XR") {
            Slider_CollectionView.frame.size.height=Slider_CollectionView.frame.width*1.25;
        //    Slider_CollectionView.frame.origin.y = -44
            self.aboutUserView.frame.origin.y=Slider_CollectionView.frame.height + 10
            self.reportView.frame.origin.y=Slider_CollectionView.frame.height+self.aboutUserView.frame.height
            profile_scrollView.contentSize=CGSize(width:profile_scrollView.frame.width,height:Slider_CollectionView.frame.height+reportView.frame.height+aboutUserView.frame.height+90)
        }else{
        
            Slider_CollectionView.frame.size.height=Slider_CollectionView.frame.width*1.25;
                Slider_CollectionView.frame.origin.y = -25
                self.aboutUserView.frame.origin.y=Slider_CollectionView.frame.height-10
            self.reportView.frame.origin.y=Slider_CollectionView.frame.height+self.aboutUserView.frame.height+35
            profile_scrollView.contentSize=CGSize(width:profile_scrollView.frame.width,height:Slider_CollectionView.frame.height+reportView.frame.height+aboutUserView.frame.height+90)
        }
        pagecontrol.frame.origin.y = ( Slider_CollectionView.frame.origin.y + Slider_CollectionView.frame.height ) - pagecontrol.frame.height
        setDetailViewOrigins()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if StaticData.reportedUser == 1 && from==0{
            from=1
           
        }
        if from==1{
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func SetData()
    {
        if objRecord.age == "0" {
            name_Lbl.text = "\(objRecord.name)"
            name_Lbl.sizeToFit()
        }
        else {
            name_Lbl.text = "\(objRecord.name) \(objRecord.age)"
            name_Lbl.sizeToFit()
          
        }
        
        
        if(objRecord.college != "") {
            univ_Lbl.text = objRecord.college
        }
        else {
            univ_img.isHidden=true
            univ_Lbl.text = ""
        }
        
        if(objRecord.job_title != "") {
            jobTitleLabel.text = objRecord.job_title
        }
        else {
            officeButton.isHidden=true
            jobTitleLabel.text = ""
        }
        
        if(objRecord.about != "<null>") && (objRecord.about != ""){
            aboutLabel.text = objRecord.about
            aboutLabel.sizeToFit()
        }
        else {
            aboutLabel.text = ""
        }
        
        if objRecord.distanceType != "" {
            marker_img.isHidden = false
            
            var distanceType = String()
            print(objRecord.distanceType)
            if objRecord.distanceType == "mi" {
                distanceType = "Mile"
            }
            else {
                distanceType = objRecord.distanceType
            }
            if let distance = Float(objRecord.kilometer) {
                if distance < 1 {
                    loc_Lbl.text = "Less than a kilometer away"
                }
                else if distance == 1 {
                    loc_Lbl.text = "\(objRecord.kilometer) kilometer away"
                }else{
                    loc_Lbl.text = "\(objRecord.kilometer) kilometers away"
                }
            }
//            if (objRecord.kilometer == "0.00") ||  (objRecord.kilometer == "") || (objRecord.kilometer == "0"){
//                loc_Lbl.text = "Less than a \(distanceType) Away"
//            }
//            else {
//                loc_Lbl.text = "\(objRecord.kilometer) \(distanceType) Away"
//            }
        }
        else {
            marker_img.isHidden = true
            loc_Lbl.text = ""
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(reportUser))
        reportView.addGestureRecognizer(tap)
        setUpView()
        self.initialiseCollectionView()
       print(Slider_CollectionView.frame.height)
        print("Asad")
    }
    
    @objc func reportUser(){
       
            
       
        self.dismiss(animated: true, completion: {
            self.callback!.clicked()
        })
        
    }
    func initialiseCollectionView()
    {
        let imageArr:Array = objRecord.images
        let HeaderSliderArray:NSMutableArray = NSMutableArray()
        for i in 0..<imageArr.count
        {
            
//            if(!imagename.contains("http"))
//            {
//                imagename = 
//            }
            let objRecord:SliderRecord=SliderRecord(imageName:imageArr[i], LogoimageName: "", DetailText: "I meant to swipe right",subtext:"")
            HeaderSliderArray.add(objRecord)
            
            
        }
        
        Slider_CollectionView.Header_Data_Source = NSMutableArray(array: HeaderSliderArray)
        StaticData.profile=true
        StaticData.heightOfImage=Slider_CollectionView.frame.height
        Slider_CollectionView.Slidercat = .profile
        Slider_CollectionView.Paging_Enabled=true
        Slider_CollectionView.ReloadSlider()
        if imageArr.count > 1{
        pagecontrol.numberOfPages = imageArr.count
        }else{
           pagecontrol.numberOfPages=0
        }
        pagecontrol.defersCurrentPageDisplay = true;
        self.pagecontrol.selectedDotColor = Themes.sharedIntance.ReturnThemeColor();
        self.pagecontrol.dotColor = UIColor.lightGray
        self.pagecontrol.currentPage = 0;
        pagecontrol.selectedDotSize = 8.0;
        pagecontrol.dotSpacing = 15.0
        pagecontrol.dotSize = 5.0
        let action2 = AFMAction(title: "REPORT", enabled: true) { (action: AFMAction) -> Void in
           self.reportUser()
        }
        let action3 = AFMAction(title: "Cancel", handler: nil)
        
        actionSheet.add(action2)
        actionSheet.add(cancelling: action3)
        
        
    }
    
    func IndexforPageControl(index: Int) {
        self.pagecontrol.currentPage = index;
    }
    func moveToNext(index: Int){
        self.pagecontrol.currentPage = index;
    }
    override func viewDidLayoutSubviews() {
//        Themes.sharedIntance.AddBorder(view: profile_LikeBtn, borderColor: nil, borderWidth: nil, cornerradius: profile_LikeBtn.frame.size.width/2)
//        Themes.sharedIntance.AddBorder(view: profile_LikeBtn, borderColor: nil, borderWidth: nil, cornerradius: profile_LikeBtn.frame.size.width/2)
//        Themes.sharedIntance.AddBorder(view: ProfileSuperLikeBtn, borderColor: nil, borderWidth: nil, cornerradius: ProfileSuperLikeBtn.frame.size.width/2)
//        Themes.sharedIntance.AddBorder(view: ProfileUnlikeBtn, borderColor: nil, borderWidth: nil, cornerradius: ProfileUnlikeBtn.frame.size.width/2)
       
        //actionSheet.add(title: "Select Language")

    }
    override func viewWillDisappear(_ animated: Bool) {
        StaticData.profile=false
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
    
    @IBAction func Didclicknope(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.SwipeAction(Status: "nope")
        }
      
     }
    @IBAction func Didclicksuper(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.SwipeAction(Status: "super like")
        }
    }
    @IBAction func Didclicklike(_ sender: Any) {
        self.dismiss(animated: false) {
            self.delegate?.SwipeAction(Status: "like")
        }
    }
    @IBAction func Didclickback(_ sender: Any) {
        self.dismiss(animated: true) {
         }
    }
    @IBAction func DidClickMenu(_ sender: Any) {
       
        
        self.present(actionSheet, animated: true, completion: nil)

    }

    @IBAction func Didclickreport(_ sender: Any) {
        self.present(actionSheet, animated: true, completion: nil)

        
    }
    @IBAction func DidclickShare(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
//            if(objRecord.ge)
            controller.body = "I found a girl on \(k_Application_Name)"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }

}

extension User_DetailViewController:UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentingAnimationController()
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissingAnimationController()
        
        
    }
}
extension User_DetailViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate
{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objRecord.images.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopSlideCellID", for: indexPath as IndexPath) as! UserCollectionViewCell
        
        if let findView = cell.contentView.viewWithTag(102) as? UIImageView {
            
            //            findView.image = #imageLiteral(resourceName: "displayavatar")
            findView.contentMode = .scaleAspectFill
            findView.sd_setImage(with: URL(string:objRecord.images[indexPath.row] as! String), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
            print(findView.frame.height)
            
        }
        //        else {
        //            findView.image = #imageLiteral(resourceName: "displayavatar")
        //        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let kWhateverHeightYouWant = collectionView.frame.size.height
        return CGSize(width: collectionView.bounds.size.width, height: CGFloat(kWhateverHeightYouWant));
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = topCollection.indexPathForItem(at: center) {
            self.moveToNext(index: ip.row)
        }
    }
    
    
}
