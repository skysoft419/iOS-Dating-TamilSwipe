//
//  CustomButton.swift
 //
//  Created by Vaigunda Anand M on 4/8/17.
//

import UIKit
class CustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if(self.tag == 1)
        {
            self.titleLabel?.font = UIFont(name: "System-Bold", size: (self.titleLabel?.font.pointSize)!)
        }
        if(self.tag == 2)
        {
            self.titleLabel?.font = UIFont(name: "System-Semibold", size: (self.titleLabel?.font.pointSize)!)

         }
        else
        {
            self.titleLabel?.font = UIFont(name: "System-Regular", size: (self.titleLabel?.font.pointSize)!)
        }
    }
}

class CustomLbl: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if(self.tag == 1)
        {
            self.font = UIFont(name: "System-Bold", size: (self.font.pointSize))
        }
        if(self.tag == 2)
        {
            self.font = UIFont(name: "System-Semibold", size: (self.font.pointSize))
        }
        else
        {
            self.font = UIFont(name: "System-Regular", size: (self.font.pointSize))
            
            
        }
        
    }
}

class CustomView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        if(self.tag == 1)
        {
            self.backgroundColor =  Themes.sharedIntance.ReturnThemeColor()
        }
        else
        {
            self.backgroundColor =  Themes.sharedIntance.ReturnThemeColor()
            
            
        }
        
    }
}



/*
 // Only override draw() if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func draw(_ rect: CGRect) {
 // Drawing code
 }
 */

