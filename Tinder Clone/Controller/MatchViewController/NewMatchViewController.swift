//
//  NewMatchViewController.swift
//  Igniter
//
//  Created by Rana Asad on 23/05/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI
import Lottie
class NewMatchViewController: UIViewController,MFMessageComposeViewControllerDelegate  {

   
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var animatedLabel: UIStrokeAnimatedLabel!
    @IBOutlet weak var opactityImageView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var keepSwiping: UIButton!
    @IBOutlet weak var sendMessage: UIButton!
    var delegate:MatchViewControllerDelegate?
    var objmatchProfileRecord:matchProfileRecord = matchProfileRecord()
    let animationView = AnimationView(name: "matched")
    override func viewDidLoad() {
        super.viewDidLoad()
        initThings()
        // Do any additional setup after loading the view.
    }
    private func initThings(){
        animationView.frame=CGRect(x:0,y:0,width: self.customView.frame.size.width,height:self.customView.frame.size.height)
        self.customView.addSubview(animationView)
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        opactityImageView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
        sendMessage.setBackgroundImage(#imageLiteral(resourceName: "themegradient"), for: .normal)
        Themes.sharedIntance.AddBorder(view: keepSwiping, borderColor: Themes.sharedIntance.ReturnThemeColor(), borderWidth: 2.0, cornerradius: 25.0)
        Themes.sharedIntance.AddBorder(view: sendMessage, borderColor: nil, borderWidth: nil, cornerradius: 25.0)
        
        userImageView.sd_setImage(with: URL(string:objmatchProfileRecord.user_image_url), placeholderImage: #imageLiteral(resourceName: "displayavatar"))
        NotificationCenter.default.addObserver(self, selector: #selector(self.navigateToChat(notification:)), name: Notification.Name("NavigateToChat"), object: nil)
    }
    @IBAction func keepSwipingClicked(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    @objc func navigateToChat(notification: Notification) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func sendMessageClicked(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.MovetoChat(objmatchProfileRecord: self.objmatchProfileRecord)
        }
    }
    
    @IBAction func tellYourFriendClicked(_ sender: UIButton) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            //            if(objRecord.ge)
            controller.body = "I found a girl on \(k_Application_Name)"
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
   

}
