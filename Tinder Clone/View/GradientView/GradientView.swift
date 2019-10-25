//
//  GradientView.swift
//  Igniter
//
//  Created by Rana Asad on 30/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import Foundation
@IBDesignable class GradientView: UIView {
    
    var topColor: UIColor = #colorLiteral(red: 0.8980392814, green: 0.4509803057, blue: 0.4509803653, alpha: 1)
    var bottomColor: UIColor = #colorLiteral(red: 0.9882352941, green: 0.5960784314, blue: 0.2588235294, alpha: 1)
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradient()
    }
    
    public func setGradient() {
        (layer as! CAGradientLayer).colors = [bottomColor.cgColor, topColor.cgColor]
        (layer as! CAGradientLayer).startPoint = CGPoint(x: 0.5, y: 0.0)
        (layer as! CAGradientLayer).endPoint = CGPoint(x: 0.5, y: 1.0)
    }    
}
