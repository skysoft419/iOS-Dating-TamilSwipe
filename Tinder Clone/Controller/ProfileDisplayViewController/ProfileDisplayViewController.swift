//
//  ProfileDisplayViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.

import UIKit
import KUITagLabel


class ProfileDisplayViewController: UIViewController,SliderCollectionViewDelegate,UIScrollViewDelegate {
    
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var connectionView: UIView!
    @IBOutlet weak var tagsView: UIView!
    @IBOutlet weak var tagLabel: KUITagLabel!
    @IBOutlet weak var profilScrollView: UIScrollView!
    @IBOutlet weak var slider_collectionview: SliderCollectionView!
    @IBOutlet weak var page_control: FXPageControl!
    @IBOutlet weak var back_Btn: UIButton!
    private var loadingAlert:UIAlertController?
    let profileDetailArr:NSMutableArray = NSMutableArray()
    private var isFirst=true
    
    var imgArr:NSArray = NSArray()
    
    
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var topSliderCollectionView: UICollectionView!
    
    
    var isToEditProfile = Bool()
    var userID = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        profilScrollView.isHidden=true
        Themes.sharedIntance.addshadowtoView(view: editBtn, radius: editBtn.frame.size.height/2, ShadowColor: .black)
        
        tblView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCellSID")
        
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.estimatedRowHeight = 34.0
        tblView.delegate=self
        tblView.dataSource=self
        
        setDataToTagLabel()
        tblView.tableFooterView = UIView()
        
        if(Themes.sharedIntance.CheckLogin())
        {
            let userDetail_arr:NSArray = DatabaseHandler.sharedinstance.fetchTableAllData(tableName: Constant.sharedinstance.User_details) as NSArray
            if(userDetail_arr.count > 0)
            {
                for i in 0..<userDetail_arr.count
                {
                    let manaObj:NSManagedObject = userDetail_arr[i] as! NSManagedObject
                    let dict = manaObj.dictionaryWithValues(forKeys: Array(manaObj.entity.attributesByName.keys))
                    print(dict)
                    
                    userID = (manaObj.value(forKey: "user_id") as! String)
                }
            }
        }
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            //loadPrfoileData()
        
        
    }
    
    func loadPrfoileData(){
       
            if(self.profileDetailArr.count>0){
                self.profileDetailArr.removeAllObjects()
            }
            let objProfileRec:ProfileRecord = ProfileRecord()
            
            let workStr = StaticData.allUserData!.work!
            if(workStr.count>0) && workStr != " at "{
                objProfileRec.desc=workStr
                objProfileRec.status="1"
                self.profileDetailArr.add(objProfileRec)
            }
            let objProfileRec1:ProfileRecord = ProfileRecord()
            let collegeStr = StaticData.allUserData!.college!
            if(collegeStr.count>0){
                objProfileRec1.desc=collegeStr
                objProfileRec1.status="2"
                self.profileDetailArr.add(objProfileRec1)
            }
            
            
            let objProfileRec2:ProfileRecord = ProfileRecord()
            
            
            
            var kmStr = StaticData.allUserData!.kilometer!
            var distanceTypeStr = StaticData.allUserData!.setting!.distance_type
            if distanceTypeStr == "mi" {
                distanceTypeStr = "Mile"
            }
            if let kmFloat = Float(kmStr) {
                if kmFloat < 1 {
                    kmStr = "Less than a kilometer away"
                }
                else {
                    kmStr = "\(kmFloat) kilometers away"
                }
            }
            if(kmStr.count>0){
                objProfileRec2.desc=kmStr
                objProfileRec2.status="3"
                self.profileDetailArr.add(objProfileRec2)
            }
            
            let objProfileRec3:ProfileRecord = ProfileRecord()
            let aboutStr = StaticData.allUserData!.about!
            if(aboutStr.count>0){
                objProfileRec3.desc=aboutStr
                objProfileRec3.status="0"
                self.profileDetailArr.add(objProfileRec3)
            }
            
            self.tblView.reloadData()
            self.tblView.separatorColor = .clear
            
            var name = StaticData.allUserData!.name!
            name = String(name.split(separator: " ")[0])
            
            if StaticData.allUserData!.age! == "0" {
                self.nameLbl.text = name
            }
            else {
                self.nameLbl.text = name+" "+StaticData.allUserData!.age!
            }
            
            self.imgArr = StaticData.allUserData!.imageList as! NSArray
            self.profilScrollView.isHidden=false
            self.setFrameForView()
           self.topSliderCollectionView.reloadData()
            self.editBtn.isHidden=false
            
            if self.isToEditProfile {
                self.isToEditProfile = true
                if isFirst{
                let _ : Timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.didClickEditInfoBtn(_:)), userInfo: nil, repeats: false)
                }
                self.isFirst=false
            }
        print(topSliderCollectionView.frame)
        print("asad")
    }
    
    func GetProfileData()
    {
        self.present(self.loadingAlert!, animated: true, completion: {
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!, "user_id":self.userID]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.other_profile_view as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if ResponseDict != nil{
                    if((ResponseDict?.count)! > 0)
                    {
                        print(ResponseDict ?? "")
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1")
                        {
                            if(self.profileDetailArr.count>0){
                                self.profileDetailArr.removeAllObjects()
                            }
                            let objProfileRec:ProfileRecord = ProfileRecord()
                            
                            let workStr = "\(Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "job_title") as AnyObject)) at \(Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "work") as AnyObject))"
                            if(workStr.count>0) && workStr != " at "{
                                objProfileRec.desc=workStr
                                objProfileRec.status="1"
                                self.profileDetailArr.add(objProfileRec)
                            }
                            let objProfileRec1:ProfileRecord = ProfileRecord()
                            let collegeStr = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "college") as AnyObject)
                            if(collegeStr.count>0){
                                objProfileRec1.desc=collegeStr
                                objProfileRec1.status="2"
                                self.profileDetailArr.add(objProfileRec1)
                            }
                            
                            
                            let objProfileRec2:ProfileRecord = ProfileRecord()
                            
                            
                            
                            var kmStr = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "kilometer") as AnyObject)
                            var distanceTypeStr = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "distance_type") as AnyObject)
                            if distanceTypeStr == "mi" {
                                distanceTypeStr = "Mile"
                            }
                            if let kmFloat = Float(kmStr) {
                                if kmFloat < 1 {
                                    kmStr = "Less than a \(distanceTypeStr) away"
                                }
                                else {
                                    kmStr = "\(kmFloat) \(distanceTypeStr) away"
                                }
                            }
                            if(kmStr.count>0){
                                objProfileRec2.desc=kmStr
                                objProfileRec2.status="3"
                                self.profileDetailArr.add(objProfileRec2)
                            }
                            
                            let objProfileRec3:ProfileRecord = ProfileRecord()
                            let aboutStr = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "about_me") as AnyObject)
                            if(aboutStr.count>0){
                                objProfileRec3.desc=aboutStr
                                objProfileRec3.status="0"
                                self.profileDetailArr.add(objProfileRec3)
                            }
                            
                            self.tblView.reloadData()
                            
                            var name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "name") as AnyObject)
                            name = String(name.split(separator: " ")[0])
                            
                            if Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "age") as AnyObject) == "0" {
                                self.nameLbl.text = name
                            }
                            else {
                                self.nameLbl.text = name+", "+Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "age") as AnyObject)
                            }
                            
                            self.imgArr = (ResponseDict?.object(forKey: "images") as AnyObject) as! NSArray
                            self.topSliderCollectionView.reloadData()
                            self.profilScrollView.isHidden=false
                            self.setFrameForView()
                            self.editBtn.isHidden=false
                            print(self.topSliderCollectionView.frame)
                            if self.isToEditProfile {
                                self.isToEditProfile = false
                                let _ : Timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.didClickEditInfoBtn(_:)), userInfo: nil, repeats: false)
                            }
                            
                        }
                        else {
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                        }
                    }
                    else {
                        Themes.sharedIntance.RemoveProgress(view: self.view)
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                    }else{
                        let err=error as? NSError
                        if err?.code == 401{
                            let alert = UIAlertController(title: "Oops", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler:{action in
                                self.GetProfileData()
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            })
        })
        
    }
    
    
    
    
    
    @IBAction func slideShowImages(_ sender:AnyObject?){
        if(self.page_control.currentPage+1 > 2)
        {
            let indexPath:IndexPath = IndexPath(item: 0, section: 0)
            slider_collectionview.scrollToItem(at:indexPath , at: .left, animated: true)
        }
        else
        {
            let indexPath:IndexPath = IndexPath(item: self.page_control.currentPage+1, section: 0)
            slider_collectionview.scrollToItem(at:indexPath , at: .left, animated: true)
        }
    }
    
    
    
    @IBAction func didClickBackBtn(_ sender:AnyObject?){
        self.dismiss(animated: true, completion: nil);
    }
    
    
    
    
    
    func initialiseCollectionView()
    {
        let imageArr:Array=["notification","notification","notification"]
        let HeaderSliderArray:NSMutableArray = NSMutableArray()
        for i in 0..<imageArr.count
        {
            let objRecord:SliderRecord=SliderRecord(imageName: imageArr[i], LogoimageName: "", DetailText: "I meant to swipe right", subtext: "")
            HeaderSliderArray.add(objRecord)
            
            
        }
        slider_collectionview.List_data_source = NSMutableArray(array: HeaderSliderArray)
        slider_collectionview.Slidercat = .list
        slider_collectionview.Paging_Enabled=true
        slider_collectionview.ReloadSlider()
        page_control.numberOfPages = imageArr.count
        let spb = SegmentedProgressBar(numberOfSegments: imgArr.count, duration: 5)
        spb.frame = CGRect(x: 15, y: 15, width: view.frame.width - 30, height: 4)
        self.slider_collectionview.addSubview(spb)
        page_control.defersCurrentPageDisplay = true;
        page_control.isHidden=true
        self.page_control.selectedDotColor = Themes.sharedIntance.ReturnThemeColor();
        self.page_control.dotColor = UIColor.lightGray
        self.page_control.currentPage = 0;
        page_control.selectedDotSize = 8.0;
        page_control.dotSpacing = 15.0
        page_control.dotSize = 5.0
        
        
    }
    
    func IndexforPageControl(index: Int) {
        self.page_control.currentPage = index;
    }
    
    func setDataToTagLabel(){
        tagLabel.numberOfLines=0
        let config = KUITagConfig(insets: UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 5.0),
                                  titleColor: Themes.sharedIntance.ReturnThemeColor(),
                                  titleFont: UIFont.boldSystemFont(ofSize: 13.0),
                                  titleInsets: UIEdgeInsets(top: 2.0, left: 6.0, bottom: 2.0, right: 6.0),
                                  backgroundColor: UIColor.white,
                                  cornerRadius: 8.0,
                                  borderWidth: 1.0,
                                  borderColor: Themes.sharedIntance.ReturnThemeColor(),
                                  backgroundImage: nil)
        
        //        let config = KUITagConfig(titleColor: UIColor.blueColor(),
        //                                  titleFont: UIFont.systemFontOfSize(15.0),
        //                                  backgroundColor: UIColor.yellowColor())
        //
        
        tagLabel.lineSpace = 15.0
        
        tagLabel.onSelectedHandler = { [weak self] (tag) in
            print("tag : \(tag.title)")
            
            if tag.title == "#clean" {
                self?.tagLabel.removeAll()
                self?.tagLabel.refresh()
            }
        }
        
        tagLabel.onTouchEmptySpaceHandler = { () in
            print("empty")
        }
        
        tagLabel.add(tag: KUITag(title: "#테스트", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트1", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트2", config: config))
        tagLabel.add(tag: KUITag(title: "테스트3", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트4", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트5", config: config))
        tagLabel.add(tag: KUITag(title: "테스트6", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트7", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트8", config: config))
        tagLabel.add(tag: KUITag(title: "테스트9", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트10", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트11", config: config))
        tagLabel.add(tag: KUITag(title: "#clean", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트1", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트2", config: config))
        tagLabel.add(tag: KUITag(title: "테스트3", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트4", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트5", config: config))
        tagLabel.add(tag: KUITag(title: "테스트6", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트7", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트8", config: config))
        tagLabel.add(tag: KUITag(title: "테스트9", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트10", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트11", config: config))
        tagLabel.add(tag: KUITag(title: "#clean", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트1", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트2", config: config))
        tagLabel.add(tag: KUITag(title: "테스트3", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트4", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트5", config: config))
        tagLabel.add(tag: KUITag(title: "테스트6", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트7", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트8", config: config))
        tagLabel.add(tag: KUITag(title: "테스트9", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트10", config: config))
        tagLabel.add(tag: KUITag(title: "#테스트11", config: config))
        tagLabel.add(tag: KUITag(title: "#clean", config: config))
        tagLabel.refresh()
        tagLabel.sizeToFit()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    //GetProfileData()
            loadPrfoileData()
        
    }
    override func viewDidLayoutSubviews() {
        setFrameForView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFrameForView(){
        if (UIDevice.modelName == "iPhone X") || (UIDevice.modelName == "Simulator iPhone X") || (UIDevice.modelName == "iPhone XS") || (UIDevice.modelName == "iPhone XS Max") || (UIDevice.modelName == "iPhone XR") {
            topSliderCollectionView.frame.origin.y = -44
            nameLbl.frame.origin.y=topSliderCollectionView.frame.height-30
        }else{
            topSliderCollectionView.frame.origin.y = -25
            nameLbl.frame.origin.y=topSliderCollectionView.frame.height-5
        }
        nameLbl.numberOfLines=0
        nameLbl.sizeToFit()
        connectionView.isHidden=true
        tagsView.isHidden=true
        topSliderCollectionView.frame.size.height=topSliderCollectionView.frame.width*1.25
        tblView.frame.origin.y=tblView.frame.origin.y
        back_Btn.frame.origin.y = ( topSliderCollectionView.frame.origin.y + topSliderCollectionView.frame.height ) - ( back_Btn.frame.height / 2 )
        tblView.frame = CGRect(x: tblView.frame.origin.x, y: nameLbl.frame.origin.y+nameLbl.frame.size.height, width:  tblView.frame.size.width, height: tblView.contentSize.height+200)
        connectionView.frame=CGRect(x: connectionView.frame.origin.x, y: tblView.frame.origin.y+tblView.frame.size.height+20, width:  connectionView.frame.size.width, height: 0)
        tagsView.frame=CGRect(x: tagsView.frame.origin.x, y: connectionView.frame.origin.y+connectionView.frame.size.height+10, width:  tagsView.frame.size.width, height: 0)
        profilScrollView.contentSize=CGSize(width: profilScrollView.frame.size.width, height: tagsView.frame.origin.y+tagsView.frame.size.height+80)
        
        print(topSliderCollectionView.frame.height)
        print("Asad")
        
    }
    @IBAction func didClickEditInfoBtn(_ sender: Any) {
        /*
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "ProfileEditViewControllerSID") as! ProfileEditViewController
        let navController = UINavigationController(rootViewController: VC1)
        navController.navigationBar.isHidden = true
        self.present(navController, animated:true, completion: nil)
 */
        let vc=AppStoryboard.Extra.viewController(viewControllerClass: EditProfileNVC.self)
        self.present(vc, animated: true, completion:nil)
        
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

extension ProfileDisplayViewController:UITableViewDataSource,UITableViewDelegate
    
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileDetailArr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var profileCell:ProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCellSID") as? ProfileTableViewCell
        
        if(profileCell == nil)
        {
            profileCell = UITableViewCell(style: .value1, reuseIdentifier: "ProfileTableViewCellSID") as? ProfileTableViewCell
        }
        
        let objrec = profileDetailArr[indexPath.row] as! ProfileRecord
        
        
        profileCell?.descLbl.text=objrec.desc
        if(objrec.status=="1") {
            profileCell?.imgView.image=UIImage(named: "WorkImg")
        }
        else if(objrec.status=="2"){
            profileCell?.imgView.image=UIImage(named: "UnivCap")
        }
        else if(objrec.status=="3"){
            profileCell?.imgView.image=UIImage(named: "LocMarkImg")
            
        }
        else if(objrec.status=="0"){
            profileCell?.imgView.image = nil
            
        }
        
        if objrec.status == "3" {
            profileCell?.separatorInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }
        else {
            profileCell?.separatorInset = UIEdgeInsetsMake(0.0, self.view.frame.size.width, 0.0, 0.0)
        }
        
        profileCell?.descLbl.numberOfLines=0
        profileCell?.descLbl.sizeToFit()
        
        return profileCell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        profilScrollView.bounces = scrollView.contentOffset.y > 100
    }
    
    
    
}

extension ProfileDisplayViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopSlideCellID", for: indexPath as IndexPath) as! UserCollectionViewCell
        
        if let findView = cell.contentView.viewWithTag(102) as? UIImageView {
            
//            findView.image = #imageLiteral(resourceName: "displayavatar")
            findView.contentMode = .scaleAspectFill
            findView.frame.size.height=findView.frame.width*1.25
            findView.sd_setImage(with: URL(string:imgArr.object(at: indexPath.row) as! String), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
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
    
    
    
}

