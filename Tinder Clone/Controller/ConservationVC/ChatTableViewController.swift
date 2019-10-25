//
//  ChatTableViewController.swift
//  Igniter
//
//  Created by Rana Asad on 18/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import SwipeCellKit
import SwipeTransition
class ChatTableViewController: UITableViewController,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate,SwipeTableViewCellDelegate,UIGestureRecognizerDelegate {

    lazy var searchBar:UISearchBar = UISearchBar()
    
    private var conservationStartedList:Array<matchProfileRecord>=[]
    private var conservartionNOtStartedList:Array<matchProfileRecord>=[]
    private var conservationFilterStared:Array<matchProfileRecord>=[]
    private var conservationFilterNotStarted:Array<matchProfileRecord>=[]
    private var isAlready:Bool=false
    private var isSearch:Bool=false
    private var searchString:String=""
    private var isFirst:Bool=true
    private var isFromChat=true
    private var chat=false
    private var reported:Bool=false
    
    var searchBarContainer : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.tableView.alwaysBounceVertical=true
        NotificationCenter.default.addObserver(self, selector: #selector(self.isLoadChats(msgDict:)), name:Notification.Name("NewMessageReceiveds"), object: nil)

        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.placeholder = " Search"
        searchBar.sizeToFit()
  
//        searchBar.isTranslucent = false
//        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        self.tableView.separatorColor = .clear
        //searchController.searchBar.barTintColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //searchController.searchBar.tintColor=#colorLiteral(red: 0.8946250081, green: 0.3806622028, blue: 0.3167798817, alpha: 1)
        tableView.frame.size.height=tableView.contentSize.height
        
        searchBarContainer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: searchBar.frame.height))
        searchBarContainer.backgroundColor = UIColor.white
        searchBarContainer.addSubview(searchBar)
        
        self.tableView.tableHeaderView = searchBarContainer
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        conservationStartedList.removeAll()
        conservartionNOtStartedList.removeAll()
        conservationFilterNotStarted.removeAll()
        conservationFilterStared.removeAll()
        conservationStartedList=(StaticData.allUserData?.conservationStarteds)!
        conservartionNOtStartedList=(StaticData.allUserData?.conservationNotStarteds)!
        conservationFilterStared=(StaticData.allUserData?.conservationStarteds)!
        conservationFilterNotStarted=(StaticData.allUserData?.conservationNotStarteds)!
        if self.conservationStartedList.count > 0 || self.conservartionNOtStartedList.count > 0{
            self.tableView.tableHeaderView?.isHidden=false
            searchBar.isHidden = false
        }else{
            self.tableView.tableHeaderView?.isHidden=true
            searchBar.isHidden = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.view.endEditing(true)
            }
            
            self.searchString=""
            conservationStartedList=StaticData.allUserData!.conservationStarteds
            conservartionNOtStartedList=StaticData.allUserData!.conservationNotStarteds
            self.tableView.reloadData()
        }else{
            searchString=searchText
            search()
        }
    }
    
    func search(){
        isSearch=true
        conservationStartedList=[]
        conservartionNOtStartedList=[]
        conservationStartedList=tableviewDataSourceFiltered
        conservartionNOtStartedList=collectionDataSourceFiltered
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        StaticData.reportedUser=0
        chat=false
        //print(StaticData.allUserData!.conservationNotStarteds.count)
        if StaticData.isFromChat == true{
            matchDetails()
        }
        if isAlready == false && StaticData.isFromChat == false && StaticData.updated==true{
            conservationStartedList=[]
            conservartionNOtStartedList=[]
            conservationFilterNotStarted=[]
            conservationFilterStared=[]
            print(StaticData.allUserData!.conservationStarteds.count)
            print("checkthis")
            print(StaticData.allUserData!.conservationNotStarteds.count)
            conservationStartedList=(StaticData.allUserData?.conservationStarteds)!
            conservartionNOtStartedList=(StaticData.allUserData?.conservationNotStarteds)!
            conservationFilterStared=(StaticData.allUserData?.conservationStarteds)!
            conservationFilterNotStarted=(StaticData.allUserData?.conservationNotStarteds)!
            if self.conservationStartedList.count > 0 || self.conservartionNOtStartedList.count > 0{
                self.tableView.tableHeaderView?.isHidden=false
                searchBar.isHidden = false
            }else{
                self.tableView.tableHeaderView?.isHidden=true
                searchBar.isHidden = true
            }
            self.isFirst=false
            
            self.isAlready=false
            self.tableView.reloadData()
            StaticData.updated=false
        }
        
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        if reported == true{
            conservationStartedList=[]
            conservartionNOtStartedList=[]
            conservationFilterNotStarted=[]
            conservationFilterStared=[]
            conservationStartedList=(StaticData.allUserData?.conservationStarteds)!
            conservartionNOtStartedList=(StaticData.allUserData?.conservationNotStarteds)!
            conservationFilterStared=(StaticData.allUserData?.conservationStarteds)!
            conservationFilterNotStarted=(StaticData.allUserData?.conservationNotStarteds)!
            self.tableView.reloadData()
            self.reported=false
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if conservartionNOtStartedList.count > 0{
        return 2
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  (section == 0 && conservationStartedList.count > 0) || (section == 0 && conservartionNOtStartedList.count > 0){
            return 20
            
        }else if section == 1 && conservationStartedList.count > 0{
            return 20
        }else{
        return 0
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let unmatchAction = SwipeAction(style: .default, title: "Unmatch") { action, indexPath in
            if indexPath.row < self.conservationStartedList.count{
                self.reported=true
                let conservation=self.conservationStartedList[indexPath.row]
                let conservationController=AppStoryboard.Extra.viewController(viewControllerClass: UnmatchTableViewController.self)
                conservationController.userRecord=conservation
                conservationController.selectionFromChat=indexPath.row
                conservationController.match=false
                self.navigationController?.pushViewController(conservationController, animated: true)
            }
        }
        
        // customize the action appearance
        unmatchAction.backgroundColor=#colorLiteral(red: 0.8941176471, green: 0.3215686275, blue: 0.4666666667, alpha: 1)
        unmatchAction.image = UIImage(named: "cancel-1")
        let reportAction = SwipeAction(style: .default, title: "Report") { action, indexPath in
            if indexPath.row < self.conservationStartedList.count{
                 self.reported=true
                let conservation=self.conservationStartedList[indexPath.row]
                let conservationController=AppStoryboard.Extra.viewController(viewControllerClass: ReportTableViewController.self)
                conservationController.user_id=conservation.user_id
                conservationController.selectionFromChat=indexPath.row
                conservationController.match=false
                self.navigationController?.pushViewController(conservationController, animated: true)
            }
        }
        
        // customize the action appearance
        reportAction.backgroundColor=#colorLiteral(red: 0.9568627451, green: 0.7843137255, blue: 0.3960784314, alpha: 1)
        reportAction.image = UIImage(named: "slating-flag")
        
        return [unmatchAction,reportAction]
    }
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
       options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 && conservartionNOtStartedList.count > 0{
            return "New Matches"
        }else if section == 0 && conservartionNOtStartedList.count == 0 && conservationStartedList.count > 0 {
            return "Messages"
        }else if section == 1 && conservationStartedList.count > 0{
            return "Messages"
        }
        else{
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            if section == 0 && conservartionNOtStartedList.count > 0{
                self.tableView.isUserInteractionEnabled=true
                return 1
            }else if conservationStartedList.count > 0{
                self.tableView.isUserInteractionEnabled=true
                return conservationStartedList.count
            }else{
                if isFirst==true{
                    return 0
                }else{
                    if conservationStartedList.count == 0 && conservartionNOtStartedList.count == 0{
                    
                    }
                return 1
                }
        }
        
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel!.textColor=#colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
            header.backgroundColor=#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            header.tintColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && conservationStartedList.count == 0 && conservartionNOtStartedList.count > 0{
            self.tableView.separatorColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.tableView.separatorStyle = .singleLine
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewConservationTableViewCell", for: indexPath) as! NewConservationTableViewCell
            cell.collectionView.dataSource=self
            cell.collectionView.delegate=self
            cell.collectionView.reloadData()
            
            return cell
        }
       else if indexPath.section == 0 && conservartionNOtStartedList.count > 0{
            self.tableView.separatorColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             self.tableView.separatorStyle = .singleLine
             let cell = tableView.dequeueReusableCell(withIdentifier: "NewConservationTableViewCell", for: indexPath) as! NewConservationTableViewCell
            cell.collectionView.dataSource=self
            cell.collectionView.delegate=self
            cell.collectionView.reloadData()
            return cell
            
        }else if indexPath.section == 0 && conservationStartedList.count > 0 && conservartionNOtStartedList.count == 0{
            self.tableView.separatorColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
             self.tableView.separatorStyle = .singleLine
            let conservation=conservationStartedList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            cell.userImageView.sd_setImage(with: URL(string:conservation.user_image_url), placeholderImage:#imageLiteral(resourceName: "gold_like"),completed: { (image, error, cache, url) in
                if error != nil {
                    cell.userImageView.image = #imageLiteral(resourceName: "gold_like")
                }
            })
            cell.userImageView.layer.cornerRadius=cell.userImageView.frame.size.width/2
            cell.userImageView.clipsToBounds=true
            cell.senderLabel.text=conservation.status_message
            cell.messageLabel.text=conservation.status_message
            cell.usernameLabel.text=conservation.user_name
            if conservation.like_status == "super_like"{
                cell.superLikeButton.isHidden=false
            }else{
                cell.superLikeButton.isHidden=true
            }
            if conservation.is_reply == "Yes"{
                cell.replyButton.isHidden=false
                cell.messageLabel.isHidden=false
                cell.senderLabel.isHidden=true
            }else{
                cell.replyButton.isHidden=true
                cell.messageLabel.isHidden=true
                cell.senderLabel.isHidden=false
            }
            if conservation.read_status == "Unread"{
                cell.unreadButton.isHidden=false
            }else{
                cell.unreadButton.isHidden=true
            }
            cell.accessoryType = .disclosureIndicator
            cell.delegate=self
            let bgColorView = UIView()
            bgColorView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
            cell.selectedBackgroundView = bgColorView
            return cell
            
        }else if indexPath.section == 1 && conservationStartedList.count > 0 {
            self.tableView.separatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
             self.tableView.separatorStyle = .singleLine
            let conservation=conservationStartedList[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell", for: indexPath) as! ChatTableViewCell
            cell.userImageView.sd_setImage(with: URL(string:conservation.user_image_url), placeholderImage:#imageLiteral(resourceName: "gold_like"),completed: { (image, error, cache, url) in
                if error != nil {
                    cell.userImageView.image = #imageLiteral(resourceName: "gold_like")
                }
            })
            cell.userImageView.layer.cornerRadius=cell.userImageView.frame.size.width/2
            cell.userImageView.clipsToBounds=true
            cell.messageLabel.text=conservation.status_message
            cell.senderLabel.text=conservation.status_message
            cell.usernameLabel.text=conservation.user_name
            if conservation.is_reply == "Yes"{
                cell.replyButton.isHidden=false
                cell.messageLabel.isHidden=false
                cell.senderLabel.isHidden=true
            }else{
                cell.replyButton.isHidden=true
                cell.messageLabel.isHidden=true
                cell.senderLabel.isHidden=false
            }
            if conservation.like_status == "super_like"{
                cell.superLikeButton.isHidden=false
            }else{
                cell.superLikeButton.isHidden=true
            }
            if conservation.read_status == "Unread"{
                cell.unreadButton.isHidden=false
            }else{
                cell.unreadButton.isHidden=true
            }
            cell.accessoryType = .disclosureIndicator
            cell.delegate=self
            let bgColorView = UIView()
            bgColorView.backgroundColor = #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
            cell.selectedBackgroundView = bgColorView
            return cell
            }else{
            self.tableView.separatorColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.tableView.separatorStyle = .none
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoMatchTableViewCell", for: indexPath) as! NoMatchTableViewCell
            cell.selectionStyle = .none
            if conservationStartedList.count == 0 && conservartionNOtStartedList.count > 0 && isSearch == false{
                
                cell.noImageView.image=UIImage(named: "smiley")
                cell.noLabel.text="Say Ello!"
                cell.wavingLabel.text="Don’t make your matches wait..."
                
            }else{
                cell.noImageView.image=UIImage(named: "no-matches")
                cell.noLabel.text="Get Swiping"
                cell.wavingLabel.text="When you match with other users they'll appear here where you can send them a message."
            }
            
            return cell
        }
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && conservationFilterNotStarted.count > 0{
        return 100
        }else if conservationStartedList.count > 0 && indexPath.section == 0 || conservationStartedList.count > 0 && indexPath.section == 1{
            return 100
        }else{
           
            return 300
           
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if conservartionNOtStartedList.count > 0{
            return conservartionNOtStartedList.count
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < conservationStartedList.count{
            let cell=tableView.cellForRow(at: indexPath)
            if (cell?.isSelected)!{
               // cell?.backgroundColor=#colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
            }
        let conservation=conservationStartedList[indexPath.row]
        let conservationController=AppStoryboard.Extra.initialViewController() as! ConservationViewController
        conservationController.userRecord=conservation
        StaticData.isFromChat=true
            chat=true
        self.navigationController?.pushViewController(conservationController, animated: true)
        }
        
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
            self.navigationController?.popViewController(animated: true)
        }
        return false
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let conservation=conservartionNOtStartedList[indexPath.row]
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "NewConservationCollectionViewCell", for: indexPath) as! NewConservationCollectionViewCell
        
        cell.userimageView.layer.cornerRadius=cell.userimageView.frame.size.width/2
        cell.userimageView.clipsToBounds=true
        if let id = Int(conservation.users_like_id), id > 0{
            
            cell.usernameLabel.text=conservation.user_name
            cell.userimageView.sd_setImage(with: URL(string:conservation.user_image_url), placeholderImage:#imageLiteral(resourceName: "gold_like"),completed: { (image, error, cache, url) in
                if error != nil {
                    cell.userimageView.image = #imageLiteral(resourceName: "gold_like")
                }
            })
            if conservation.read_status == "unread" {
                cell.newButton.isHidden=false
            }else{
                cell.newButton.isHidden=true
            }
            if conservation.like_status == "super_like"{
                cell.superButton.isHidden=false
            }else{
                cell.superButton.isHidden=true
            }
            
        }else{
            cell.userimageView.image = #imageLiteral(resourceName: "gold_like")
            cell.usernameLabel.text = "Favourited"
            cell.newButton.isHidden=true
            cell.superButton.isHidden=true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < conservartionNOtStartedList.count{
            let conservation=conservartionNOtStartedList[indexPath.row]
            if let id = Int(conservation.users_like_id), id > 0{
                let conservationController=AppStoryboard.Extra.initialViewController() as! ConservationViewController
                conservationController.userRecord=conservation
                StaticData.isFromChat=true
                self.navigationController?.pushViewController(conservationController, animated: true)
            }else{
                let mainController = self.parent as! MainViewController
                mainController.addSuperLikeUserOfHome(record: conservation)
                mainController.changeToPage(index: 1)
            }
        }
    }
    func convertToDictionary(text: String) -> NSDictionary? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isAlready=false
//        searchController.dismiss(animated: false, completion: nil)
    }
    
    @objc func isLoadChats(msgDict: Notification){
        if StaticData.pageNumber == 2{
            let msgsDict = convertToDictionary(text: ((msgDict.object! as! [String:Any])["custom"] as! String))!
            
            let chat=msgsDict.object(forKey: "chat_status") as? NSDictionary
            print(chat)
            if chat != nil{
                StaticData.allUserData!.conservationNotStarteds=[]
                StaticData.allUserData!.conservationStarteds=[]
                let conversation_not_started_array:NSArray =  chat?.object(forKey: "conversation_not_started") as! NSArray
                
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
                        
                        objRecords.age = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "age") as AnyObject)
                        objRecords.college = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "college") as AnyObject)
                        objRecords.distance_type = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "distance_type") as AnyObject)
                        objRecords.kilometer = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "kilometer") as AnyObject)
                        objRecords.work = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "work") as AnyObject)
                        
                        objRecords.plan_type = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "plan_type") as AnyObject)
                        
                        let arrDict = ResponseDict["all_images"] as! [String]
                        
                        for var arr in arrDict{
                            objRecords.all_images.append(arr as! String)
                        }
                        
                        StaticData.allUserData!.conservationNotStarteds.append(objRecords)
                        
                    }
                }
                //                    self.CollectionView.reloadData()
                
                
                
                let conversation_started_array:NSArray =  chat?.object(forKey: "conversation_started") as! NSArray
                
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
                        StaticData.allUserData!.conservationStarteds.append(objRecords)
                        
                    }
                    
                }
            }else{
                let chat=msgsDict.object(forKey: "match_status") as? NSDictionary
                if chat != nil{
                    StaticData.allUserData!.conservationNotStarteds=[]
                    StaticData.allUserData!.conservationStarteds=[]
                    let conversation_not_started_array:NSArray =  chat?.object(forKey: "conversation_not_started") as! NSArray
                    
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
                            
                            StaticData.allUserData!.conservationNotStarteds.append(objRecords)
                            
                        }
                    }
                    //                    self.CollectionView.reloadData()
                    
                    
                    
                    let conversation_started_array:NSArray =  chat?.object(forKey: "conversation_started") as! NSArray
                    
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
                            StaticData.allUserData!.conservationStarteds.append(objRecords)
                            
                        }
                        
                    }
                }
            }
        self.conservationFilterStared=[]
        self.conservationFilterNotStarted=[]
        self.conservationStartedList=[]
        self.conservartionNOtStartedList=[]
        self.conservartionNOtStartedList=StaticData.allUserData!.conservationNotStarteds
        self.conservationFilterNotStarted=StaticData.allUserData!.conservationNotStarteds
        self.conservationStartedList=StaticData.allUserData!.conservationStarteds
        self.conservationFilterStared=StaticData.allUserData!.conservationStarteds
        self.tableView.reloadData()
        }
    }
    @objc func matchDetails()
    {
        if isAlready == false{
        isAlready=true
        isSearch=false
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.match_details as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            if responseDict != nil{
            if((responseDict?.count)! > 0)
            {   self.conservationFilterStared=[]
                self.conservationFilterNotStarted=[]
                self.conservartionNOtStartedList=[]
                self.conservationStartedList=[]
                StaticData.allUserData!.conservationStarteds=[]
                StaticData.allUserData!.conservationNotStarteds=[]
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                
                if(status_code == "1")
                {
                    let unread_count = Themes.sharedIntance.CheckNullForInt(input_value: responseDict?.object(forKey: "unread_count") as AnyObject)
                    Themes.sharedIntance.saveUnreadCount(unread_count: unread_count)
                    let conversation_not_started_array:NSArray =  responseDict?.object(forKey: "conversation_not_started_array") as! NSArray
                   
                    if(conversation_not_started_array.count > 0)
                    {   print(conversation_not_started_array)
                        for i in 0..<conversation_not_started_array.count
                        {
                            let ResponseDict:NSDictionary = conversation_not_started_array[i] as! NSDictionary
                            let objRecord:matchProfileRecord = matchProfileRecord()
                            objRecord.isgoldLike = false
                            
                            objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                            objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                            objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                            
                            objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                            objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                            objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                            
                            objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                            
                            self.conservartionNOtStartedList.append(objRecord)
                            self.conservationFilterNotStarted.append(objRecord)
                            StaticData.allUserData?.conservationNotStarteds.append(objRecord)
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
                            let objRecord:matchProfileRecord = matchProfileRecord()
                            objRecord.like_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "like_status") as AnyObject)
                            objRecord.read_status = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "read_status") as AnyObject)
                            objRecord.match_user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "status_message") as AnyObject)
                            
                            objRecord.user_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_id") as AnyObject)
                            objRecord.user_image_url = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_image_url") as AnyObject)
                            objRecord.users_like_id = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "match_id") as AnyObject)
                            objRecord.user_name = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "user_name") as AnyObject)
                            objRecord.status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "message") as AnyObject)
                            objRecord.is_reply = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict.object(forKey: "is_reply") as AnyObject)
                            self.conservationStartedList.append(objRecord)
                            self.conservationFilterStared.append(objRecord)
                            StaticData.allUserData?.conservationStarteds.append(objRecord)
                        }
                        
                    }
                    DispatchQueue.main.async {
                        if self.conservationStartedList.count > 0 || self.conservartionNOtStartedList.count > 0{
                            self.tableView.tableHeaderView?.isHidden=false
                            self.searchBar.isHidden = false
                        }else{
                            self.tableView.tableHeaderView?.isHidden=true
                            self.searchBar.isHidden = true
                        }
                         self.isFirst=false
                        if self.chat == false{
                        self.tableView.reloadData()
                        }
                        self.isAlready=false
                        StaticData.isFromChat=false
                    }
                   
                }
                else
                {
                    Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                    self.isAlready=false
                    self.isFirst=false
                    StaticData.isFromChat=false
                }
                
            }
            else
            {
                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                self.isAlready=false
                self.isFirst=false
                StaticData.isFromChat=false
            }
            }else{
                self.conservationStartedList=StaticData.allUserData!.conservationStarteds
                self.conservartionNOtStartedList=StaticData.allUserData!.conservationNotStarteds
                self.isAlready=false
                self.isFirst=false
                StaticData.isFromChat=false
            }
        })
        }
    }
    var tableviewDataSourceFiltered:Array<matchProfileRecord> {
        get {
            var filteredArray:Array<matchProfileRecord> = []
            filteredArray.removeAll()
            self.conservationFilterStared.filter() {
                if let objrecord = $0 as? matchProfileRecord {
                    if let user_name = objrecord.user_name as? String {
                        if user_name.lowercased().range(of: self.searchString.lowercased()) != nil {
                            filteredArray.append(objrecord)
                        }
                    }
                }
                return false
            }
            return filteredArray
        }
    }
    var collectionDataSourceFiltered: Array<matchProfileRecord> {
        get {
            //            return collectionDatasource
            var filteredArray:Array<matchProfileRecord> = []
            filteredArray.removeAll()
            self.conservationFilterNotStarted.filter() {
                if let objrecord = $0 as? matchProfileRecord {
                    if let user_name = objrecord.user_name as? String {
                        if user_name.lowercased().range(of: self.searchString.lowercased()) != nil {
                            filteredArray.append(objrecord)
                        }
                    }
                }
                return false
            }
            return filteredArray
        }
    }
}


