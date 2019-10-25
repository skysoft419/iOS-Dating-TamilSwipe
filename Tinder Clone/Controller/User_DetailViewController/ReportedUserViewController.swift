//
//  ReportedUserViewController.swift
//  Igniter
//
//  Created by Rana Asad on 28/05/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import SimpleAnimation
class ReportedUserViewController: UIViewController {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var reportedButton: UIButton!
    @IBOutlet weak var animateView: UIView!
    public var user_image:String?
    public var callback:CallBack?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
   
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.alpha=0.9
        reportedButton.layer.cornerRadius=12
        reportedButton.layer.borderWidth=10
        reportedButton.layer.borderColor=#colorLiteral(red: 0.9372549057, green: 0.3254901171, blue: 0.3137254119, alpha: 1)
        userImageView.layer.cornerRadius=userImageView.frame.size.height/2
        
        userImageView.sd_setImage(with: URL(string:user_image!), placeholderImage: nil)
        userImageView.clipsToBounds=true
        animateView.popOut()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            
            self.dismiss(animated: true, completion: {
                self.callback?.clicked()
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
