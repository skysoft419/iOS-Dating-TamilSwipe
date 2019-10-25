//
//  SettingTableViewCell.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit
import RangeSeekSlider
import MultiSlider
protocol  SettingTableViewCellDelegate{
    func SliderValue(minValue: CGFloat, maxValue: CGFloat)
}

class SettingTableViewCell: UITableViewCell,RangeSeekSliderDelegate {
    var delegate:SettingTableViewCellDelegate?
//    @IBOutlet weak var marker_slider: MARKRangeSlider!
    var endMaxValue = Int()
    @IBOutlet weak var DoubleSlider: MultiSlider!
    @IBOutlet weak var main_TxtLbl: UILabel!
    @IBOutlet weak var textDetail: UILabel!
    @IBOutlet weak var Detail_Lbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var Slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        DoubleSlider.orientation = .horizontal
        
        self.Slider.addTarget(self, action: #selector(self.DistanceChaged(Slider:)), for: .valueChanged)
       // DoubleSlider.selectedHandleDiameterMultiplier = 1.0
        //DoubleSlider.delegate = self
        //Slider.frame.origin.x=Slider.frame.origin.x+10
        //DoubleSlider.frame.origin.x=DoubleSlider.frame.origin.x+10
        main_TxtLbl.frame.origin.x=main_TxtLbl.frame.origin.x-8
        textDetail.frame.origin.x=textDetail.frame.origin.x-8
        textDetail.frame.origin.y=textDetail.frame.origin.y-7
        DoubleSlider.addTarget(self, action: #selector(self.sliderChanged(slider:)), for: .valueChanged)
        Slider.frame.origin.x=Slider.frame.origin.x-5
        Slider.frame.size.width=Slider.frame.size.width+20
        DoubleSlider.frame.origin.x=DoubleSlider.frame.origin.x-5
        DoubleSlider.frame.size.width=DoubleSlider.frame.size.width+20
        if #available(iOS 12, *) {
        DoubleSlider.frame.origin.y=DoubleSlider.frame.origin.y+5
        }else{
            DoubleSlider.frame.origin.y=DoubleSlider.frame.origin.y-2
        }
        //DoubleSlider.thumbCount=1
        //Slider.frame.size.width=Slider.frame.size.width-5
        
       
 
    }
   @objc  func sliderChanged(slider: MultiSlider) {
        print("\(slider.value)")
    var min = Int(round(slider.value[0])) // x is Int
    var max = Int(round(slider.value[1])) // x is Int
    if max == endMaxValue {
        if min < StaticData.min!{
            min=StaticData.min!
        }
        if max > StaticData.max!{
            max=StaticData.max!
            self.Detail_Lbl.text = "\(min)-\(StaticData.max!)+"
        }
        else{
        self.Detail_Lbl.text = "\(min)-\(max)+"
        }
    }
    else {
        if min < StaticData.min!{
            min=StaticData.min!
        }
        if max>StaticData.max!{
            max=StaticData.max!
        self.Detail_Lbl.text = "\(min)-\(StaticData.max!)+"
        }else{
         self.Detail_Lbl.text = "\(min)-\(max)"
        }
        
    }
    
    self.delegate?.SliderValue(minValue: CGFloat(min), maxValue: CGFloat(max))
    }
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        let min = Int(round(minValue)) // x is Int
        let max = Int(round(maxValue)) // x is Int
        if max == endMaxValue {
            self.Detail_Lbl.text = "\(min)-\(max)+"
        }
        else {
            self.Detail_Lbl.text = "\(min)-\(max)"
        }
        
        self.delegate?.SliderValue(minValue: CGFloat(min), maxValue: CGFloat(max))

    }


     @objc func DistanceChaged(Slider:UISlider)
    {
        let Distance = Int(round(Slider.value)) // x is Int

         self.Detail_Lbl.text = "\(Distance) \(SharedVariables.sharedInstance.distanceUnit)"

    }
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
