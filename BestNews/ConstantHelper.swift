//
//  ConstantHelper.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

let wxAppId = "wx3b03f4dfa9d44785"
let wxSecretKey = "3bd9585d9accda261e9b85276ba0c866"
let jPushKey = "1c5b0bf1379cf38b6a436146"
let jPushSecret = "02348df4cadd5293af3e7c0a"

let qqAppID = "1106506886"
let qqAppKey = "x0Sb91LBlbKBkYum"


let kLoginWechatSuccessNotifi = Notification.Name(rawValue:"Login_Wechat_Success_Notify_key")
let kUserLoginStatusChangeNoti = Notification.Name("user_login_status_change_key")
let kAppDidBecomeActiveNotify = Notification.Name("App_did_become_active_key")
let kUserInfoDidUpdateNotify = Notification.Name("user_info_did_update_noti_key")

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let keyWindow = UIApplication.shared.keyWindow
let rootController = UIApplication.shared.keyWindow?.rootViewController!
let themeColor = UIColor(ri: 0, gi: 152, bi: 255, alpha: 1)
let gray155 = UIColor(ri: 155, gi: 155, bi: 155)
let gray72 = UIColor(ri: 72, gi: 72, bi: 72)
let gray34 = UIColor(ri: 34, gi: 34, bi: 34)
let gray51 = UIColor(ri: 51, gi: 51, bi: 51)
let gray146 = UIColor(ri: 146, gi: 146, bi: 146)
let gray181 = UIColor(ri: 181, gi: 181, bi: 181)
let gray229 = UIColor(ri: 229, gi: 229, bi: 229)
let gray244 = UIColor(ri: 244, gi: 244, bi: 244)
let translucentBGColor = UIColor(white: 0, alpha: 0.5)
let barLightGrayColor = UIColor(ri: 209, gi: 213, bi: 219)

let baseUrlString = "http://xinhuaNews"
let baseHtmlString = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title></title><style>body {font:42px/1.5 tahoma,arial,sans-serif;color:#55555;text-align:justify;text-align-last:justify;line-height:66px}hr {height:1px;border:none;border-top:1px solid #e8e8e8;} img {width:100%;height:auto}</style></head><body><div style='margin:35px' id=\"content\">${contentHtml}</div></body></html>"
    
    

