//
//  UUMessage.swift
//  ChatApp
//
//  Created by Casp iOS on 10/01/17.
//  Copyright © 2017 Casp iOS. All rights reserved.
//
enum MessageType : Int {
    case uuMessageTypeText = 0
    case uuMessageTypePicture = 1
    case uuMessageTypeVoice = 2
}
enum MessageFrom : Int {
    case uuMessageFromMe = 0
    // 自己发的
    case uuMessageFromOther = 1
}
import UIKit

 class UUMessage: NSObject {
    
    
    var strIcon:String! = ""
    var strId:String! = ""
    var strTime:String! = ""
    var strName:String! = ""
    var strContent:String! = ""
    var picture: UIImage!
    var voice: Data!
    var strVoiceTime = ""
    var type:MessageType!
    var from:MessageFrom!

    var isShowDateLabel = false
func setWithDict(_ dict: [AnyHashable: Any]) {
    self.strIcon = dict["strIcon"] as! String
    self.strName = dict["strName"] as! String
  //  self.strId = dict["strId"] as! String
    self.strTime = self.changeTheDateString(dict["strTime"] as! String)
    self.from = MessageFrom(rawValue: Int(dict["from"] as! String)!)
    switch CInt(dict["from"] as! String)! {
        case 0:
            self.type = .uuMessageTypeText
            self.strContent = dict["strContent"] as! String
        case 1:
            self.type = .uuMessageTypePicture
            self.picture = dict["picture"] as! UIImage!
        case 2:
            self.type = .uuMessageTypeVoice
            self.voice = dict["voice"] as! Data!
            self.strVoiceTime = dict["strVoiceTime"] as! String
        default:
            break
    }
}
func changeTheDateString(_ Str: String) -> String {
    let subString = (Str as NSString).substring(with: NSRange(location: 0, length: 19))
    var lastDate = NSDate(from: subString, withFormat: "yyyy-MM-dd HH:mm:ss");
    let zone = NSTimeZone.system
    let interval = zone.secondsFromGMT(for: lastDate as! Date)
    lastDate = lastDate?.addingTimeInterval(TimeInterval(interval))
    var dateStr: String
    var period: String
    var hour: String
    let userCalendar = Calendar.current

    let iPhoneStevenoteDateComponents = userCalendar.dateComponents(
        [.year, .month, .day, .hour, .minute, .weekday, .weekOfYear],
        from: lastDate as! Date)
    let date = Date()
    let calendar = Calendar.current
    let Currentcomponents = calendar.dateComponents([.year, .month, .day], from: date)

    if lastDate?.year() == Currentcomponents.year {
        let days = NSDate.daysOffsetBetweenStart(lastDate as Date!, end: Date())
        if days <= 2 {
            dateStr = (lastDate?.stringYearMonthDayCompareToday())!
        }
        else {
            dateStr = (lastDate?.stringMonthDay())!
        }
    }
    else {
        dateStr = (lastDate?.stringYearMonthDay())!
    }
    if (iPhoneStevenoteDateComponents.hour! >= 5 && iPhoneStevenoteDateComponents.hour! < 12) {
        period = "AM"
        hour = String(format: "%02d", iPhoneStevenoteDateComponents.hour!)
    }
    else if iPhoneStevenoteDateComponents.hour! >= 12 && iPhoneStevenoteDateComponents.hour! <= 18 {
        period = "PM"
        hour = String(format: "%02d", Int(iPhoneStevenoteDateComponents.hour!) - 12)
    }
    else if iPhoneStevenoteDateComponents.hour! > 18 && iPhoneStevenoteDateComponents.hour! <= 23 {
        period = "Night"
        hour = String(format: "%02d", Int(iPhoneStevenoteDateComponents.hour!) - 12)
    }
    else {
        period = "Dawn"
        hour = String(format: "%02d", Int(iPhoneStevenoteDateComponents.hour!))
    }
    return "\(dateStr) \(period) \(hour):%02d"
}
    
func minuteOffSetStart(_ start: String, end: String) {
    if start == "" {
        self.isShowDateLabel = true
        return
    }
    let subStart = (start as NSString).substring(with: NSRange(location: 0, length: 19))
    let startDate = NSDate(from: subStart, withFormat: "yyyy-MM-dd HH:mm:ss");
    let subEnd = (end as NSString).substring(with: NSRange(location: 0, length: 19))
    let endDate =  NSDate(from: subEnd, withFormat: "yyyy-MM-dd HH:mm:ss");
    let timeInterval = startDate?.timeIntervalSince(endDate as! Date)
    //相距5分钟显示时间Label
    if fabs(timeInterval!) > 5 * 60 {
        self.isShowDateLabel = true
    }
    else {
        self.isShowDateLabel = false
    }
}

}
