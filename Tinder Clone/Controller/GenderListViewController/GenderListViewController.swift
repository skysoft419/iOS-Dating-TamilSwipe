//
//  GenderListViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.

import UIKit
protocol  GenderListViewControllerDelegate{
    func ReturnChoosenname(Str:String, isFromGender:Bool)
}

class GenderListViewController: RootBaseViewcontroller
{
    var Delegate:GenderListViewControllerDelegate?
    var GenderArr:[String] = [String]()
    var Choosenname:String = String()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
GenderArr = ["Guys","Girls","Guys and Girls"]
        self.navigationItem.title = "Show me"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
 }


extension GenderListViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GenderArr.count
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell:UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "CellID")
      
        Cell.textLabel?.text = GenderArr[indexPath.row]
        if(Choosenname == GenderArr[indexPath.row])
        {
            Cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "tick_theme"))
 
        }
        Cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        return Cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Choosenname = GenderArr[indexPath.row]
        tableView.reloadData()
        self.Delegate?.ReturnChoosenname(Str: Choosenname, isFromGender: true)
        self.navigationController?.popViewController(animated: true)
    }
}

