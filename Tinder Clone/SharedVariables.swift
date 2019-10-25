//
//  SharedVariables.swift
//  Tinder Clone
//
//  Created by trioangle on 14/06/18.
//  Copyright © 2018 Anonymous. All rights reserved.
//

import UIKit
import GoogleMaps

class SharedVariables: NSObject {
    
    static let sharedInstance = SharedVariables()
    
    var minimumAge = Int()
    var maximumAge = Int()
    var likesCount = Int()
    var boostCount = Int()
    var isLikeLimited = Bool()
    var superLikesCount = Int()
    var currentCoordinates = CLLocationCoordinate2D()
    var addressDict = [String:Any]()
    var distanceUnit = String()
    var planType = String()
    var isToShowOTPPage = Bool()
}
