//
//  DeleteAccountTableViewController.swift
//  Ello.ie
//
//  Created by Rana Asad on 04/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//
/*
 /// This controller shows the option to user when user want to delete his account.
///
 */
import UIKit
import Alamofire
class DeleteAccountTableViewController: UITableViewController {
    private var loadingAlert:UIAlertController?
    private var userSelectionIndex:Int?
    private let appDel = UIApplication.shared.delegate as! AppDelegate
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
        if StaticData.allUserData!.deleteReasons.count != 0{
        return 2
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            if StaticData.allUserData!.deleteReasons.count != 0{
                return (StaticData.allUserData!.deleteReasons.count)+1
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
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.9372548461, blue: 0.9450979829, alpha: 1)
        return headerView
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if StaticData.allUserData!.deleteReasons.count  != 0{
                if indexPath.row == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
                    return cell
                }else{
                    let currentReason=StaticData.allUserData!.deleteReasons[indexPath.row-1]
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
            if index != nil{
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
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0
        }else{
            return 40
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 180
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row > 0{
            self.userSelectionIndex=indexPath.row
            self.tableView.reloadData()
        }else if indexPath.section == 1{
            if userSelectionIndex != nil{
                let id=String(describing: StaticData.allUserData!.deleteReasons[userSelectionIndex!-1].reason_id!)
                self.deleteAccount(reasonId: id)
            }
        }
    }
    private func deleteAccount(reasonId:String){
        self.present(self.loadingAlert!, animated: true, completion: {
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"reason_id":reasonId]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.delete_account as NSString, param: param, _method: .get, completionHandler: { (ResponseDict, error) in
                self.loadingAlert?.dismiss(animated: true, completion: {
                    if ResponseDict != nil{
                        if (ResponseDict?.count)! > 0{
                            StaticData.isHomeController=false
                            let status_code = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_code") as AnyObject)
                            let status_message = Themes.sharedIntance.CheckNullvalue(Str: ResponseDict?.object(forKey: "status_message") as AnyObject)
                            if status_code == "1"{
                                DatabaseHandler.sharedinstance.truncateDataForTable(tableName: Constant.sharedinstance.User_details)
                                Themes.sharedIntance.ClearUSerDetails()
                                self.appDel.MovetoRoot(status: "login")
                            }else{
                                Themes.sharedIntance.showErrorMsg(view: self.view, withMsg: status_message)
                            }
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
