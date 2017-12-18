//
//  CustomeMessage.swift
//  BestNews
//
//  Created by Worthy on 2017/12/17.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SwiftyJSON

///自定义消息类
class CustomeMessage: RCMessageContent, NSCoding {
    
    var content: String?
    var img: String?
    ///发送日期
    var date: Int = 0
    /// 游客 visitor 主持: compere
    var messageType: String?
    var extra: String?
    
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content)
        aCoder.encode(img)
        aCoder.encode(date)
        aCoder.encode(messageType)
        aCoder.encode(extra)
    }
    
    override init() {
        super.init()
        senderUserInfo = RCUserInfo()
        senderUserInfo.name = SessionManager.sharedInstance.userInfo?.name ?? ""
        senderUserInfo.portraitUri = SessionManager.sharedInstance.userInfo?.headimg ?? ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.content = aDecoder.decodeObject(forKey: "content") as? String
        self.img = aDecoder.decodeObject(forKey: "img") as? String
        self.date = aDecoder.decodeInteger(forKey: "date")
        self.messageType = aDecoder.decodeObject(forKey: "messageType") as? String
        self.extra = aDecoder.decodeObject(forKey: "extra") as? String
    }
    
    override func encode() -> Data! {
        var dic: [String: Any] = [:]
        dic["content"] = content ?? ""
        dic["img"] = img ?? ""
        dic["date"] = date
        dic["messageType"] = messageType ?? ""
        dic["extra"] = extra ?? ""
        if senderUserInfo != nil {
            var userDic: [String: Any] = [:]
            userDic["name"] = senderUserInfo.name ?? ""
            userDic["id"] = senderUserInfo.userId ?? ""
            userDic["portrait"] = senderUserInfo.portraitUri ?? ""
            dic["user"] = userDic
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
            return data
        }
        catch let error {
            print("解析失败...\(error.localizedDescription)")
        }
        return Data()
    }
    
    override func decode(with data: Data!) {
        if data != nil {
            do {
                let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                self.content = dic["content"] as? String
                self.date = dic["date"] as! Int
                self.extra = dic["extra"] as? String
                self.img = dic["img"] as? String
                self.messageType = dic["messageType"] as? String
                self.extra = dic["extra"] as? String
                let user = dic["user"] as! [String: Any]
                self.decodeUserInfo(user)

            }
            catch let error {
                print("解析失败....\(error)")
            }
        }
    }
    
    override func conversationDigest() -> String! {
        return content ?? ""
    }
    
    
    lazy var hourFormatter: DateFormatter = {
       let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    func timeStr() -> String {
        let d = Date(timeIntervalSince1970: TimeInterval(date/1000))
//        let now = Date()
        return hourFormatter.string(from: d)
    }
    
}
