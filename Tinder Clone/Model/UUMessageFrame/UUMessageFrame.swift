//
//  UUMessageFrame.swift
//  ChatApp
//
//  Created by Casp iOS on 10/01/17.
//  Copyright © 2017 Casp iOS. All rights reserved.
//
let ChatMargin:CGFloat = 10
let ChatIconWH:CGFloat = 0
let ChatPicWH:CGFloat = 200
let ChatContentW:CGFloat = 180
let ChatTimeMarginW:CGFloat = 15
let ChatTimeMarginH:CGFloat = 10
let ChatContentTop:CGFloat = 15
let ChatContentLeft:CGFloat = 50
let ChatContentBottom:CGFloat = 15
let ChatContentRight:CGFloat = 15
let ChatTimeFont = UIFont.systemFont(ofSize: CGFloat(11))
let ChatContentFont = UIFont.systemFont(ofSize: CGFloat(14))

import UIKit


class UUMessageFrame: NSObject {
    
    
    var nameF:CGRect!;
    var iconF:CGRect!;
    var timeF:CGRect!;
    var contentF:CGRect!;
    var ContentSize:CGFloat!;
    var cellHeight:CGFloat!;
    var message:UUMessage!;
    var showTime:Bool=Bool();
     var paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle();
    
    
    func set_Message(_ message: UUMessage) {
        
        paragraphStyle.lineBreakMode = .byWordWrapping

        self.message = message
        let screenW: CGFloat = UIScreen.main.bounds.size.width
        // 1、计算时间的位置
        if (showTime) {
            let timeY: CGFloat = CGFloat(ChatMargin)
            
            
            let timeSize = message.strTime.boundingRect(with: CGSize(width: CGFloat(300), height: CGFloat(100)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: ChatTimeFont,NSParagraphStyleAttributeName: paragraphStyle], context: nil)
  
            let timeX: CGFloat = (screenW - timeSize.width) / 2
            self.timeF = CGRect(x: timeX, y: timeY, width: CGFloat(timeSize.width+ChatTimeMarginW), height: CGFloat(timeSize.height + ChatTimeMarginH))
        }
         var iconX: CGFloat = CGFloat(ChatMargin)
        
        if message.from == .uuMessageFromMe {
            iconX = screenW - ChatMargin - ChatIconWH
        }
        let iconY: CGFloat = timeF.maxY + ChatMargin
        self.iconF = CGRect(x: iconX, y: iconY, width: CGFloat(ChatIconWH), height: CGFloat(ChatIconWH))
        // 3、计算ID位置
        self.nameF = CGRect(x: iconX, y: CGFloat(iconY + ChatIconWH), width: CGFloat(ChatIconWH), height: CGFloat(20))
        // 4、计算内容位置
        var contentX: CGFloat = iconF.maxX + ChatMargin
        let contentY: CGFloat = iconY

 //        case  = 0
//        case uuMessageTypePicture = 1
//        case uuMessageTypeVoice = 2
        var content_Size:CGSize=CGSize.zero
        switch message.type {
        case MessageType(rawValue: 0)!:
            let content_Size_rect:CGRect = message.strContent.boundingRect(with: CGSize(width: CGFloat(ChatContentW), height: CGFloat(CGFloat.greatestFiniteMagnitude)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: ChatContentFont,NSParagraphStyleAttributeName: paragraphStyle], context: nil)
            content_Size=content_Size_rect.size
            
            
        case MessageType(rawValue: 1)!:
            content_Size = CGSize(width: CGFloat(ChatPicWH), height: CGFloat(ChatPicWH))
        case MessageType(rawValue: 2)!:
            //syed

            if (UIScreen.main.bounds.height == 568) {
                content_Size = CGSize(width: CGFloat(180), height: CGFloat(10))
            }
            else {
            content_Size = CGSize(width: CGFloat(250), height: CGFloat(20))

            }
        default:
            break
        }
        
        
        self.ContentSize = 0.0
        if message.from == .uuMessageFromMe {
            contentX = iconX - content_Size.width - ChatContentLeft - ChatContentRight - ChatMargin
            ContentSize = 15
            self.contentF = CGRect(x: CGFloat(contentX), y: CGFloat(contentY), width: CGFloat(content_Size.width+ChatContentLeft+ChatContentRight), height: CGFloat(content_Size.height+ChatContentTop+ChatContentBottom+ContentSize))
        }
        else {
            self.ContentSize = 15
            self.contentF = CGRect(x: CGFloat(contentX), y: CGFloat(contentY), width: CGFloat(content_Size.width+ChatContentLeft+ChatContentRight), height: CGFloat(content_Size.height+ChatContentTop+ChatContentBottom+ContentSize))
        }
        self.cellHeight = max(contentF.maxY, nameF.maxY) + ChatMargin


        
        
    }


}
