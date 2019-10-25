//
//  UnmatchTableViewController.swift
//  Ello.ie
//
//  Created by Rana Asad on 06/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//
// This controller shows the user Unmatch option whne user try to unmatch some user then next controller is this.
import UIKit
import Alamofire
class UnmatchTableViewController: UITableViewController {
    private var loadingAlert:UIAlertController?
    private var userSelectionIndex:Int?
    var userRecord:matchProfileRecord = matchProfileRecord()
    private let appDel = UIApplication.shared.delegate as! AppDelegate
    private var isFirstCall=false
    var match:Bool=false
    var selectionFromChat:Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9372548461, blue: 0.9450979829, alpha: 1)
        tableView.separatorColor = #colorLiteral(red: 0.9254902005, green: 0.9372548461, blue: 0.9450979829, alpha: 1)
        self.tableView.tableFooterView = UIView()
        loadingAlert=UIAlertController(title:"",message:"Loading....", preferredStyle: UIAlertControllerStyle.alert)
        loadingAlert?.setValue(NSAttributedString(string: "Loading....", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 19),NSAttributedStringKey.foregroundColor : UIColor.black]), forKey: "attributedMessage")
        tableView.reloadData()
       
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if StaticData.allUserData!.unmatchReasons.count != 0{
            return 2
        }else{
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            if StaticData.allUserData!.unmatchReasons.count != 0{
                return (StaticData.allUserData!.unmatchReasons.count)+1
            }else{
                return 0
            }
        }else{
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9372548461, blue: 0.9450979829, alpha: 1)
        return headerView
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if StaticData.allUserData!.unmatchReasons.count != 0{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
                    return cell
                }else{
                    let currentReason=StaticData.allUserData!.unmatchReasons[indexPath.row-1]
                    let cell = tableView.dequeueReusableCell(withIdentifier: "ReasonsTableViewCell", for: indexPath) as! ReasonsTableViewCell
                    
                    cell.detailLabel.text=currentReason.reason_message!
                    if userSelectionIndex != nil && userSelectionIndex == indexPath.row{
                        cell.iconButton.isHidden=false
                    }else{
                        cell.iconButton.isHidden=true
                    }
                    return cell
                }
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteTableViewCell", for: indexPath) as! DeleteTableViewCell
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeleteTableViewCell", for: indexPath) as! DeleteTableViewCell
            if userSelectionIndex != nil{
                cell.deleteLabel.textColor = UIColor.black
            }
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 100
            }else{
                return 50
            }
        }else{
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row > 0{
            self.userSelectionIndex=indexPath.row
            self.tableView.reloadData()
        }else if indexPath.section == 1{
            if userSelectionIndex != nil{
                let id=String(describing: StaticData.allUserData!.unmatchReasons[userSelectionIndex!-1].reason_id!)
                self.unmatchUser(reasonId: id)
            }
        }
    }
   
    private func unmatchUser(reasonId:String){
        self.present(self.loadingAlert!, animated: true, completion: {
            let urlStr:String = Constant.sharedinstance.unmatch_account
            
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!, "report_id":"\(reasonId)", "user_id":self.userRecord.user_id]
            URLhandler.Sharedinstance.makeCall(url:urlStr  as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if responseDict != nil{
                    if((responseDict?.count)! > 0)
                    {
                        let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                        let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                        if(status_code == "1")
                        {
                            if self.selectionFromChat != -1{
                                if self.match == true{
                                    StaticData.allUserData!.conservationNotStarteds.remove(at: self.selectionFromChat)
                                }else{
                                    StaticData.allUserData!.conservationStarteds.remove(at: self.selectionFromChat)
                                }
                            }
                            self.navigationController?.popViewController(animated: true)
                            
                        }
                        else
                        {
                            Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                            
                        }
                    }
                    else
                    {
                        Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: Constant.sharedinstance.errorMessage)
                    }
                    }else{
                        let err=error as? NSError
                        if err?.code == 401{
                            let alert = UIAlertController(title: "", message: "Please check you internet and try again!", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler:{action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                       
                    }
                })
                
            })
        })
    }
    
}
