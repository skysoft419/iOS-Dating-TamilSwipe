//
//  Messages.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import Foundation
import GiphyCoreSDK

public class Messages{
    public var senderId:String?
    public var senderDisplayName:String?
    public var date:String?
    public var text:String?
    public var gifUrl:String?
    public var gifRatio:CGFloat = 0.5{
        didSet {
            gifRatio = max(min(gifRatio, 1),0)
        }
    }
    public var isEmoji:String?
    
    init(){
        
    }
}
