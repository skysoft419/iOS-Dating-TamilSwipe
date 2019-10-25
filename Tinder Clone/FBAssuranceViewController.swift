//
//  FBAssuranceViewController.swift
//  Tinder Clone
//
//  Created by trioangle on 08/06/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit

protocol LoginFromFBAssuranceDelegate {
    func loginType(type: String)
}

class FBAssuranceViewController: UIViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var loginButtonsView: UIView!
    @IBOutlet weak var loginWithFBButtonOutlet: UIButton!
    @IBOutlet weak var loginWithMobileButtonOutlet: UIButton!
    
    var delegate:LoginFromFBAssuranceDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginWithFBButtonOutlet.frame.size.height=49
        loginWithMobileButtonOutlet.frame.size.height=49
        loginButtonsView.addBottomBorderWithColor(color: .lightGray, width: 0.5)
        
        loginWithMobileButtonOutlet.clipsToBounds = true
        loginWithMobileButtonOutlet.layer.cornerRadius = loginWithMobileButtonOutlet.frame.size.height / 2
        loginWithMobileButtonOutlet.layer.borderWidth = 0.5
        loginWithMobileButtonOutlet.layer.borderColor = UIColor.lightGray.cgColor
        loginWithFBButtonOutlet.addBottomBorderWithColor(color: .lightGray, width: 0.5)
        
        loginWithFBButtonOutlet.clipsToBounds = true
        loginWithFBButtonOutlet.layer.cornerRadius = loginWithMobileButtonOutlet.frame.size.height / 2
        loginWithFBButtonOutlet.layer.borderWidth = 0.5
        loginWithFBButtonOutlet.layer.borderColor = UIColor.lightGray.cgColor
        let tapUrl = UITapGestureRecognizer(target: self, action: #selector(goToPrivacy))
        firstLabel.addGestureRecognizer(tapUrl)
        secondLabel.addGestureRecognizer(tapUrl)
        thirdLabel.addGestureRecognizer(tapUrl)
        // Do any additional setup after loading the view.
    }
    @objc func goToPrivacy(){
        if let url = URL(string: "https://www.hackingwithswift.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    @IBAction func dismissButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithFBButtonAction(_ sender: Any) {
        delegate?.loginType(type: "Facebook")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginWithMobileButtonAction(_ sender: Any) {
        delegate?.loginType(type: "Mobile")
        self.dismiss(animated: true, completion: nil)
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
