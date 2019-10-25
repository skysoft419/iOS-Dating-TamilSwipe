//
//  ProfileSliderCollectionViewCell.swift
//  Tinder Clone
//
//  Created by Vaigunda Anand M on 9/3/17.
//  Copyright © 2017 Anonymous. All rights reserved.
//

import UIKit

class ProfileSliderCollectionViewCell: UICollectionViewCell {
    var indexpath:IndexPath = IndexPath()
    @IBOutlet weak var sub_text: UILabel!
    @IBOutlet weak var detail_Lbl: UILabel!

    @IBOutlet weak var detail_Img: UIImageView!
    @IBOutlet weak var wrapperView: UIView!
    var detailframe:CGFloat = CGFloat()
    var Actframe:CGFloat = CGFloat()

    override func awakeFromNib() {
        super.awakeFromNib()
        wrapperView.frame.size.width = UIScreen.main.bounds.size.width
        Actframe  = detail_Lbl.frame.origin.x - detail_Img.frame.size.width-5
       
          detailframe = detail_Img.frame.origin.x + 40
      
        
        // Initialization code
    }
    func Setdata(objRecord:SliderRecord)
    {
        detail_Img.contentMode = .scaleAspectFill
        sub_text.text = objRecord.subtext

        detail_Lbl.text = objRecord.DetailText
         detail_Img.image=UIImage(named: objRecord.MainimageName)
     
//        if(objRecord.DetailText ==   "Get \(Themes.sharedIntance.GetAppName())  Gold")
//        {
//            detail_Img.frame.origin.x = detailframe
//
//        }
//
//         else if(objRecord.DetailText ==   "Boost your profile")
//         {
//            detail_Img.frame.origin.x = detailframe
//
//        }
//        else
//        {
//            detail_Img.frame.origin.x =  Actframe
//
//        }
        let label_x = wrapperView.frame.origin.x + ((wrapperView.frame.width - detail_Lbl.intrinsicContentSize.width) / 2)
        let label_frame = CGRect.init(x: label_x, y: detail_Lbl.frame.origin.y, width: detail_Lbl.intrinsicContentSize.width, height: detail_Lbl.frame.height)
        detail_Lbl.frame = label_frame
        detail_Img.frame.origin.x = detail_Lbl.frame.origin.x - detail_Img.frame.size.width - 5
    }

}
