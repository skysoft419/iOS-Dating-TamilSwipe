//
//  ChatModel.swift
//  Ello.ie
//
//  Updated by Rana Asad on 19/03/2019.
//  Copyright © 2019 Anonymous. All rights reserved.
//

import UIKit

class ChatModel: NSObject {
    var dataSource = [Any]()
    var isGroupChat = false
    var isReceive = false
    
     var previousTime: String? = nil
    func populateRandomDataSource() {
        self.dataSource = [Any]()
        //[self.dataSource addObjectsFromArray:[self additems:5]];
    }
    func addSpecifiedItem(_ dic: [AnyHashable: Any]) {
        let messageFrame = UUMessageFrame()
        let message = UUMessage()
        var dataDic = dic
        dataDic["strName"] = "10 30 PM"
        if (dic["from"] as! String) == Themes.sharedIntance.getuserID()! {
            dataDic["from"] = "1"
        }
        else {
            dataDic["from"] = "0"
        }
        
//         if (self.isReceive == true) {
//            dataDic["from"] = "1"
//            
//        }
//        else if (self.isReceive == false)
//        {
//            dataDic["from"] = "0"
//        }
        dataDic["strTime"] = Date().description
         print(dataDic)
         message.setWithDict(dataDic)
        //message.minuteOffSetStart(previousTime, end: dataDic["strTime"] as! String!)
//        messageFrame.showTime = message.showDateLabel
        messageFrame.showTime = true
        messageFrame.message = message
    
        if message.showDateLabel {
            previousTime = dataDic["strTime"] as! String?
        }
        
         self.dataSource.append(messageFrame)
    }
    
    
}
