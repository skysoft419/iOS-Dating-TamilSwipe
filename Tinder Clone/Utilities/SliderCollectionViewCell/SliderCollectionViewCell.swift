//
//  SliderCollectionViewCell.swift
//  Tablviewcreator
//
//  Created by Vaigunda Anand M on 3/18/17.
//  Copyright © 2017 RoomBoys. All rights reserved.
//

import UIKit
import SDWebImage

class SliderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var Slider_Image: UIImageView!
 
    @IBOutlet weak var wrapperView: UIView!
     @IBOutlet weak var detail_Lbl: UILabel!
     @IBOutlet weak var main_image: UIImageView!
    var story=false
    var profile=false
    override func awakeFromNib() {
        super.awakeFromNib()
        if StaticData.profile{
            Slider_Image.frame.size.height=StaticData.heightOfImage!+20
        }
        
     }
    override func layoutSubviews() {
        if story == false{
        main_image.layer.cornerRadius = 5.0;
        main_image.clipsToBounds = true;
        Slider_Image.clipsToBounds=true
        wrapperView.frame.size.width = UIScreen.main.bounds.size.width
        if (UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "Simulator iPhone 6"||UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 6s"||UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "Simulator iPhone 7"||UIDevice.modelName == "iPhone 7s" || UIDevice.modelName == "Simulator iPhone 7s"||UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8" ||
            UIDevice.modelName == "iPhone 8 Plus" || UIDevice.modelName == "Simulator iPhone 8 Plus"||UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "Simulator iPhone 6 Plus"||UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 6s Plus"||UIDevice.modelName == "iPhone 7 Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus"
            ){
           
            Slider_Image.contentMode = .scaleAspectFill
            
        }else{
        //Slider_Image.frame.size.height=450
       Slider_Image.contentMode = .scaleAspectFill
        }
        main_image.contentMode = .scaleAspectFit
        if (UIDevice.modelName == "iPhone 6" || UIDevice.modelName == "Simulator iPhone 6"||UIDevice.modelName == "iPhone 6s" || UIDevice.modelName == "Simulator iPhone 6s"||UIDevice.modelName == "iPhone 7" || UIDevice.modelName == "Simulator iPhone 7"){
            main_image.frame.size.height=300
            main_image.frame.size.width=220
            main_image.center.x=wrapperView.center.x
        }
        if UIDevice.modelName == "iPhone 8" || UIDevice.modelName == "Simulator iPhone 8"{
            main_image.frame.size.height=main_image.frame.size.height-80
            main_image.frame.size.width=main_image.frame.size.width-40
             main_image.center.x=wrapperView.center.x
        }else if (UIDevice.modelName == "iPhone 6 Plus" || UIDevice.modelName == "Simulator iPhone 6 Plus"||UIDevice.modelName == "iPhone 6s Plus" || UIDevice.modelName == "Simulator iPhone 6s Plus"||UIDevice.modelName == "iPhone 7 Plus" || UIDevice.modelName == "Simulator iPhone 7 Plus"||UIDevice.modelName == "iPhone 8 Plus" || UIDevice.modelName == "Simulator iPhone 8 Plus"){
            main_image.frame.size.height=main_image.frame.size.height-40
            main_image.frame.size.width=main_image.frame.size.width-20
            main_image.center.x=wrapperView.center.x
        }
        }else{
            Slider_Image.contentMode = .scaleToFill
            self.Slider_Image.frame.origin.x=0
            self.Slider_Image.frame.origin.y=0
            
        }

     }
  
    func Setdata(objRecord:SliderRecord)
    {
         detail_Lbl.text=objRecord.DetailText
         //main_image.contentMode = .scaleToFill
        if objRecord.MainimageName.range(of:"http") != nil {
            main_image.sd_setImage(with: URL(string:objRecord.MainimageName), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        else
        {
            main_image.image=UIImage(named: objRecord.MainimageName)

        }

    }
    // This method is showing the images on card.
    func setStoryData(objRecord:SliderRecord){
        Slider_Image.contentMode = .scaleToFill
        Slider_Image.frame.size.height=self.frame.size.height
        self.Slider_Image.frame.origin.x = -5
        self.Slider_Image.frame.origin.y=0
        detail_Lbl.isHidden = true
        main_image.isHidden = true
        Slider_Image.isHidden = false
        print(Slider_Image.frame.size.width)
        if objRecord.MainimageName.range(of:"http") != nil {
            print("exists")
            Slider_Image.sd_setImage(with: URL(string:objRecord.MainimageName),placeholderImage: #imageLiteral(resourceName: "again"),completed: { (image, error, cache, url) in
                let size=image?.size
                //self.Slider_Image.image = #imageLiteral(resourceName: "Ello Avatar")
                if error != nil {
                    self.Slider_Image.image = #imageLiteral(resourceName: "Ello Avatar")
                }
            })
            //Slider_Image.contentMode = .scaleAspectFill
            
        }
        else
        {
            Slider_Image.image=UIImage(named: objRecord.MainimageName)
            
        }
        
    }
    func SetSliderdata(objRecord:SliderRecord)
    {
        detail_Lbl.isHidden = true
        main_image.isHidden = true
        Slider_Image.isHidden = false
        Slider_Image.contentMode = .scaleAspectFill
        if objRecord.MainimageName.range(of:"http") != nil {
            print("exists")
            Slider_Image.sd_setImage(with: URL(string:objRecord.MainimageName),placeholderImage: #imageLiteral(resourceName: "Ello Avatar"),completed: { (image, error, cache, url) in
                let size=image?.size
                if error != nil {
                    self.Slider_Image.image = #imageLiteral(resourceName: "Ello Avatar")
                }
            })
            //Slider_Image.contentMode = .scaleAspectFill
            
        }
        else
        {
            Slider_Image.image=UIImage(named: objRecord.MainimageName)

        }
        
    }
    func setProfileData(objRecord:SliderRecord)
    {
        print(Slider_Image.frame.height)
        detail_Lbl.isHidden = true
        main_image.isHidden = true
        Slider_Image.isHidden = false
        //Slider_Image.frame.size.height=Slider_Image.frame.width*1.25
        Slider_Image.contentMode = .scaleAspectFill
        if objRecord.MainimageName.range(of:"http") != nil {
            print("exists")
            Slider_Image.sd_setImage(with: URL(string:objRecord.MainimageName),placeholderImage: #imageLiteral(resourceName: "Ello Avatar"),completed: { (image, error, cache, url) in
                let size=image?.size
                if error != nil {
                    self.Slider_Image.image = #imageLiteral(resourceName: "Ello Avatar")
                }
            })
            //Slider_Image.contentMode = .scaleAspectFill
            
        }
        else
        {
            Slider_Image.image=UIImage(named: objRecord.MainimageName)
            
        }
        
    }
    
  }

