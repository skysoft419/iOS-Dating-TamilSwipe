//
//  AllUserData.swift
//  Igniter
//
//  Created by Rana Asad on 23/04/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import Foundation
public class AllUserData:NSObject{
    public var unmatchReasons:Array<Reason>=[]
    public var reportReasons:Array<Reason>=[]
    public var deleteReasons:Array<Reason>=[]
    public var remainingLikes:Int?
    public var remainingBoost:Int?
    public var remianingLikes:Int?
    public var pin:String?
    public var age:String?
    public var name:String?
    public var unreadCount:Int?
    public var setting:SettingRecord?
    public var imageList:Array<String>=[]
    public var imageId:Array<String>=[]
    public var about:String?
    public var jobTitle:String?
    public var college:String?
    public var work:String?
    public var instagramId:String?
    public var gender:String?
    public var showMyAge:String?
    public var distanceInvisible:String?
    public var likeCount:String?
    public var goldLikeStatus:String?
    public var newMatchCount:String?
    public var kilometer:String?
    public var conservationNotStarteds:Array<matchProfileRecord>=[]
    public var conservationStarteds:Array<matchProfileRecord>=[]
    public var conservationNotStarted:Array<matchProfileRecord>=[]
    public var conservationStarted:Array<matchProfileRecord>=[]
    public var goldPlansDetails=[[String:Any]]()
    public var goldImageDict=[[String:Any]]()
    public var plusPlansDetails=[[String:Any]]()
    public var plusImageDict=[[String:Any]]()
    public var superPlansDetails=[[String:Any]]()
    public var superImageDict=[[String:Any]]()
    public var boostPlansDetail=[[String:Any]]()
    public var boostImageDict=[[String:Any]]()
    
    
    
    
}
