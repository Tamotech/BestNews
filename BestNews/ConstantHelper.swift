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
let qqAppId = "1106335273"
let qqKey = "VkRdgEBjxTriHGiE"
let weiboAppid = "2973921044"
let weiboKey = "3b47f9bec148972d0dc4e0e31afbea58"
let aliPayAppid = "2017122000999924"
let jPushKey = "d5db367eb1abec4c03a051dc"
let jPushSecret = "8be34e6163e6b1a40f6df5f9"


let kLoginWechatSuccessNotifi = Notification.Name(rawValue:"Login_Wechat_Success_Notify_key")
let kUserLoginStatusChangeNoti = Notification.Name("user_login_status_change_key")
let kAppDidBecomeActiveNotify = Notification.Name("App_did_become_active_key")
let kUserInfoDidUpdateNotify = Notification.Name("user_info_did_update_noti_key")
let kZhifubaoPaySuccessNotify = Notification.Name("zhifubao_pay_success_noti_key")
let kZhifubaoPayFailNotify = Notification.Name("zhifubao_pay_fail_noti_key")
let kWexinPaySuccessNotify = Notification.Name("wexin_pay_success_noti_key")
let kWexinPayFailNotify = Notification.Name("wexin_pay_fail_noti_key")
let kActivityRefundSuccessNotify = Notification.Name("activity_refund_ticket_success_noti")
let kSwitchTabbarItemNotify = Notification.Name("switch_tabbar_item_noti")
let kDidSwitchNavTitleNotify = Notification.Name("switch_nav_title_item_noti")

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
let baseHtmlString = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title></title><style>body {font:48px/1.5 tahoma,arial,sans-serif;color:#55555;text-align:justify;text-align-last:justify;line-height:70px}hr {height:1px;border:none;border-top:1px solid #e8e8e8;} img {width:100%;height:auto}</style></head><body><div style='margin:35px' id=\"content\">${contentHtml}</div></body></html>"
    
    

