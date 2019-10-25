//
//  NotificationViewController.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationViewController: UIViewController {
    @IBOutlet weak var notnow_Btn: CustomButton!
    @IBOutlet weak var notified_Btn: CustomButton!
    override func viewDidLoad() {
        super.viewDidLoad()



        // Do any additional setup after loading the view.
    }
    
   


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        Themes.sharedIntance.AddBorder(view: notified_Btn, borderColor: nil, borderWidth: nil, cornerradius: 22.0)

    }
    @IBAction func DidclickNotnow(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).isNotificationPer = true
        self.dismiss(animated: true) {
         }
     }

    @IBAction func DiclickNotified(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).isNotificationPer = true
         let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            
            // Enable or disable features based on authorization.
            if granted == true
            {
                print("Allow")
                UIApplication.shared.registerForRemoteNotifications()
            }
            else
            {
             UIApplication.shared.registerForRemoteNotifications()
                 print("Don't Allow")
            }
        }

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
