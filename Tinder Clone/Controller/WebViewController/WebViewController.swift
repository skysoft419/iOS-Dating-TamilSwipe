//
//  WebViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class WebViewController: RootBaseViewcontroller,UIWebViewDelegate {

    @IBOutlet weak var header_lbl: UILabel!
    @IBOutlet weak var webview: UIWebView!
    var URl:String = String()
    var HeaderStr:String = String()
    private var isFirstCall=false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webview.loadRequest(URLRequest(url: URL(string: URl)!))
        webview.delegate = self
        header_lbl.text = HeaderStr
        Themes.sharedIntance.ShowProgress(view: self.view)
        //NotificationCenter.default.addObserver(self, selector: #selector(loadChats), name:Notification.Name("NewMessageReceived"), object: nil)
    }
    @objc func loadChats(){
        if isFirstCall == false{
            self.isFirstCall=true
            StaticData.allUserData!.conservationStarted.removeAll()
            StaticData.allUserData!.conservationNotStarted.removeAll()
            let param:[String:String] = ["token":Themes.sharedIntance.getaccesstoken()!]
            URLhandler.Sharedinstance.makeCall(url: Constant.sharedinstance.match_details as NSString, param: param, _method: .get, completionHandler: { (responseDict, error) in
                if responseDict != nil{
                    if((responseDict?.count)! > 0)
                    {
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
                                    
                                    StaticData.allUserData?.conservationNotStarted.removeAll()
                                    StaticData.allUserData?.conservationNotStarted.append(objRecord)
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
                                    StaticData.allUserData?.conservationStarted.removeAll()
                                    StaticData.allUserData?.conservationStarted.append(objRecord)
                                    self.isFirstCall=false
                                }
                                
                            }
                            
                            
                        }
                        else
                        {
                            
                        }
                        
                    }
                    else
                    {
                        
                    }
                }
            })
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        Themes.sharedIntance.RemoveProgress(view: self.view)
        
    }
    

    @IBAction func DidclickDone(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

}
