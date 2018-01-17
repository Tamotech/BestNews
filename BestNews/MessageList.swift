//
//  MessageList.swift
//  BestNews
//
//  Created by Worthy on 2018/1/17.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class MessageList: HandyJSON {

    required init(){}
    
    var total: Int = 0
    var page: Int = 0
    var list: [MessageModel] = []
}

class MessageModel: HandyJSON {
    
    required init(){}
    
    var id = ""
    var title = ""
    var param: [String: Any]?
    var description = ""
    var userid = ""
    var img = ""
    var pushdate: Int = 0
    var type = ""
    //是否已读
    var readflag: Int = 0
    
    func dateStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(pushdate)/1000.0)
        return formatter.string(from: date)
    }
}
