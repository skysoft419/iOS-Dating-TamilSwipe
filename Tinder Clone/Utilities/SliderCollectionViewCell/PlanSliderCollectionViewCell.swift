//
//  PlanSliderCollectionViewCell.swift
//  Tinder Clone
//
//  Created by Vignesh Palanivel on 26/03/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import SDWebImage

class PlanSliderCollectionViewCell: UICollectionViewCell {

    var indexpath:IndexPath = IndexPath()
    @IBOutlet weak var sub_text: UILabel!
    @IBOutlet weak var detail_Lbl: UILabel!
    
    @IBOutlet weak var detail_Img: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    var detailframe:CGFloat = CGFloat()
    var Actframe:CGFloat = CGFloat()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        wrapperView.frame.size.width = UIScreen.main.bounds.size.width 
        Actframe  = detail_Lbl.frame.origin.x - detail_Img.frame.size.width-5
        
        detailframe = detail_Img.frame.origin.x + 40
        detail_Img.frame.size.width=50
        detail_Img.frame.size.height=50
        
        
        // Initialization code
    }
    func Setdata(objRecord:SliderRecord, isGold:Bool)
    {
        
        sub_text.text = objRecord.subtext
        detail_Img.contentMode = .scaleAspectFill
        detail_Lbl.text = objRecord.DetailText        
        detail_Img.sd_setImage(with: URL(string:objRecord.MainimageName), placeholderImage: nil)
        
        if !isGold {
            sub_text.textColor = UIColor.white
            detail_Lbl.textColor = UIColor.white
        }
        
        
        
//        if(objRecord.DetailText ==   "Get \(Themes.sharedIntance.GetAppName())  Gold")
//        {
//            detail_Img.frame.origin.x = detailframe
//
//        }
//
//        else if(objRecord.DetailText ==   "Boost your profile")
//        {
//            detail_Img.frame.origin.x = detailframe
//
//        }
//        else
//        {
//            detail_Img.frame.origin =  UIScreen.main.bounds.origin
//
//        }
        
    }


}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
