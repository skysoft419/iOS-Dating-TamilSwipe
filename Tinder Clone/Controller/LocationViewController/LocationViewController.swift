//
//  LocationViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import GooglePlacePicker

class LocationViewController: RootBaseViewcontroller, GMSPlacePickerViewControllerDelegate{
    @IBOutlet weak var addLocation_Btn: UIButton!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var flightImageView: UIImageView!
    
    var addressDictArray = [[String:Any]]()
    var planType = String()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.reloadData()
        self.tableView.frame.size.height = self.tableView.contentSize.height
        self.addLocation_Btn.frame.origin.y = self.tableView.frame.size.height+self.tableView.frame.origin.y
        self.flightImageView.frame.origin.y = self.addLocation_Btn.frame.origin.y + (self.addLocation_Btn.frame.size.height - self.flightImageView.frame.size.height) / 2
        
        self.navigationItem.backBarButtonItem?.tintColor = Themes.sharedIntance.ReturnThemeColor()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        if SharedVariables.sharedInstance.addressDict.count > 0 {
            
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"latitude":SharedVariables.sharedInstance.addressDict["latitude"] as! String,"longitude":SharedVariables.sharedInstance.addressDict["longitude"] as! String, "type":"insert"]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.updatelocation as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                Themes.sharedIntance.RemoveProgress(view: self.view)
                if((responseDict?.count)! > 0)
                {
                    let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                    let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                    if(status_code == "1")
                    {
                        print(responseDict!)
                        
                        if (responseDict?.object(forKey: "user_location_detail") as! [[String:Any]]).count > 0 {
                            self.addressDictArray = responseDict?.object(forKey: "user_location_detail") as! [[String:Any]]
                            self.tableView.reloadData()
                            self.tableView.frame.size.height = self.tableView.contentSize.height
                            self.addLocation_Btn.frame.origin.y = self.tableView.frame.size.height+self.tableView.frame.origin.y
                            self.flightImageView.frame.origin.y = self.addLocation_Btn.frame.origin.y + (self.addLocation_Btn.frame.size.height - self.flightImageView.frame.size.height) / 2
                        }
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
            })
            
//            addressDictArray.append(SharedVariables.sharedInstance.addressDict)
            SharedVariables.sharedInstance.addressDict = [String:Any]()
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func DidclickNewLocation(_ sender: Any) {
//        let config = GMSPlacePickerConfig(viewport: nil)
//
//        let placePicker = GMSPlacePickerViewController(config: config)
//        placePicker.delegate = self
//        present(placePicker, animated: true, completion: nil)
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewControllerSID") as! MapViewController
        self.navigationController?.pushViewController(mapVC, animated: true)
        /*
        if planType == "Gold" || planType == "Plus" {
            let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewControllerSID") as! MapViewController
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
        else {
            let destController = self.storyboard?.instantiateViewController(withIdentifier: "goldPlansViewController") as! GoldPlansViewController
            destController.modalTransitionStyle = .crossDissolve
            destController.isGold = false
            self.navigationController?.present(destController, animated: true, completion: nil)
        }
        
        */
    }
    
    //MARK:- GMSPlacePickerViewControllerDelegate
    
    // To receive the results from the place picker 'self' will need to conform to
    // GMSPlacePickerViewControllerDelegate and implement this code.
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("Place name \(place.name)")
        print("Place address \(place.formattedAddress)")
        print("Place attributions \(place.attributions)")
        
        
        var addressDict = [String:Any]()
        addressDict["default"] = "Not Active"
        addressDict["id"] = ""
        addressDict["Name"] = place.name
        addressDict["location"] = place.formattedAddress
        addressDict["latitude"] = ""
        addressDict["longitude"] = ""
        
        addressDictArray.append(addressDict)
        
        tableView.reloadData()
        
        tableView.frame.size.height = tableView.contentSize.height
    }
    
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
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

extension LocationViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Current Location"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressDictArray.count
    }
   
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
//        var location = String()
//        if addressDictArray[indexPath.row]["Name"] != nil {
//            location = (addressDictArray[indexPath.row]["Name"]! as? String)!
//        }
//        else {
//            location = "My Current Location"
//        }
//        Cell.textLabel?.text = location
//        Cell.detailTextLabel?.text = addressDictArray[indexPath.row]["location"]! as? String
        Cell.textLabel?.text = addressDictArray[indexPath.row]["location"]! as? String
//        Cell.detailTextLabel?.textColor = UIColor.lightGray
        Cell.imageView?.image = #imageLiteral(resourceName: "marker_blue")
        if (addressDictArray[indexPath.row]["default"]! as? String) == "Active" {
            Cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "tick_blue"))
            Cell.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            Cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        }

        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!,"id":"\(addressDictArray[indexPath.row]["id"]!)"]
        URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.defaultLocaion as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
            Themes.sharedIntance.RemoveProgress(view: self.view)
            if responseDict != nil{
            if((responseDict?.count)! > 0)
            {
                let status_code = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_code") as AnyObject)
                let status_message = Themes.sharedIntance.CheckNullvalue(Str: responseDict?.object(forKey: "status_message") as AnyObject)
                if(status_code == "1")
                {
                    print(responseDict!)
//                    if (responseDict?.object(forKey: "user_location_detail") as! [[String:Any]]).count > 0 {
//                        self.addressDictArray = responseDict?.object(forKey: "user_location_detail") as! [[String:Any]]
//                        self.tableView.reloadData()
//                    }
                    
                    if (responseDict?.object(forKey: "user_location_detail") as! [[String:Any]]).count > 0 {
                        
                        for i in 0..<self.addressDictArray.count {
                            self.addressDictArray[i]["default"] = "Inactive"
                        }
                        self.addressDictArray[indexPath.row]["default"] = "Active"
                        self.tableView.reloadData()
                    }
                    
                    
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
            }
        })
        
//        addressDictArray.append(SharedVariables.sharedInstance.addressDict)
    }
    
}
