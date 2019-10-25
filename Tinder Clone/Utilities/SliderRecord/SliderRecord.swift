//
//  SliderRecord.swift
//
//  Created by Vaigunda Anand M on 3/18/17.
//  Copyright © 2017 RoomBoys. All rights reserved.
//

import UIKit
import SDWebImage

class SliderRecord: NSObject {
    var MainimageName:String=String()
    var DetailText:String=String()
    var LogoimageName:String=String()
    var subtext:String=String()

    init(imageName:String,LogoimageName:String,DetailText:String,subtext:String) {
        self.MainimageName=imageName
        self.DetailText=DetailText
        self.LogoimageName=LogoimageName
        self.subtext = subtext
        
    }
    
}
