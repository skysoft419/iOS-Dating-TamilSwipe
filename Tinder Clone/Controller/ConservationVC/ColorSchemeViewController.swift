//
//  ColorSchemeViewController.swift
//  Ello.ie
//
//  Created by PingLi on 7/1/19.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class ColorSchemeViewController: UIViewController {

    let topColors = ["#434343", "#3f5efb", "#7579ff", "#009fff", "#bdc3c7", "#43cea2", "#00c6fb", "#92fe9d", "#ef8e38", "#FC00FF", "#dd2476", "#ffc0cb", "#f953c6", "#8f94fb", "#0abfbc", "#f2f501"]
    let bottomColors = ["#000000", "#fc466b", "#b224ef", "#ec2f4b", "#2c3e50", "#185a9d", "#005bea", "#00c9ff", "#108dc7", "#00DBDE", "#ff512f", "#800080", "#b91d73", "#4e54c8", "#fc354c", "#de0000"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func applyGradient(index:Int){
        Themes.sharedIntance.setChatGradientTopColor(topColor: topColors[index])
        Themes.sharedIntance.setChatGradientBottomColor(bottomColor: bottomColors[index])
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ColorSchemeChanged"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onColor0ButtonClicked(_ sender: Any) {
        applyGradient(index: 0)
    }
    
    @IBAction func onColor1ButtonClicked(_ sender: Any) {
        applyGradient(index: 1)
    }
    
    @IBAction func onColor2ButtonClicked(_ sender: Any) {
        applyGradient(index: 2)
        
    }
    
    @IBAction func onColor3ButtonClicked(_ sender: Any) {
        applyGradient(index: 3)
    }
    
    @IBAction func onColor4ButtonClicked(_ sender: Any) {
        applyGradient(index: 4)
    }
    
    
    @IBAction func onColor5ButtonClicked(_ sender: Any) {
        applyGradient(index: 5)
    }
    
    @IBAction func onColor6ButtonClicked(_ sender: Any) {
        applyGradient(index: 6)
    }
    
    @IBAction func onColor7ButtonClicked(_ sender: Any) {
        applyGradient(index: 7)
    }
    
    @IBAction func onColor8ButtonClicked(_ sender: Any) {
        applyGradient(index: 8)
    }
    
    @IBAction func onColor9ButtonClicked(_ sender: Any) {
        applyGradient(index: 9)
    }
    
    @IBAction func onColor10ButtonClicked(_ sender: Any) {
        applyGradient(index: 10)
    }
    
    @IBAction func onColor11ButtonClicked(_ sender: Any) {
        applyGradient(index: 11)
    }
    
    @IBAction func onColor12ButtonClicked(_ sender: Any) {
        applyGradient(index: 12)
    }
    
    @IBAction func onColor13ButtonClicked(_ sender: Any) {
        applyGradient(index: 13)
    }
    
    @IBAction func onColor14ButtonClicked(_ sender: Any) {
        applyGradient(index: 14)
    }
    
    @IBAction func onColor15ButtonClicked(_ sender: Any) {
        applyGradient(index: 15)
    }
    
}
