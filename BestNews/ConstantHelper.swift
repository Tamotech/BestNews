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


#if DEBUG
let rongyunAppKey = "k51hidwqknfrb"
let jPushKey = "d5db367eb1abec4c03a051dc"
let jPushSecret = "8be34e6163e6b1a40f6df5f9"
let debugEnv = true
#else
let rongyunAppKey = "tdrvipkstqg35"
let jPushKey = "d5db367eb1abec4c03a051dc"
let jPushSecret = "8be34e6163e6b1a40f6df5f9"
let debugEnv = false
#endif

///屏幕适配
///去年适配的iPhoneX 的分辨率：2436 * 1125 || pt: 812 * 375
//iPhoneXr的分辨率：1792 * 828 || pt: 896 * 414
//iPhoneXs 的分辨率： 2436 * 1125 || pt: 812 * 375
//iPhoneXs Max 的分辨率：2688 * 1242 || pt: 896 * 414

let IS_IPHONEX: Bool = screenHeight == 812.0
let IS_IPHONEXMAX: Bool = screenHeight == 896.0

/// 顶部距离 （适配iPhone X） 64 | 88

let topGuideHeight: CGFloat = screenHeight >= 812.0 ? 88.0 : 64.0
/// 底部距离
let bottomGuideHeight: CGFloat = screenHeight >= 812.0 ? 34 : 0

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
let kLiveDidEndNotify = Notification.Name("live_did_end_noti")
let kLiveDidStartNotify = Notification.Name("live_did_start_noti")
let kLiveDidCallbackNotify = Notification.Name("live_did_callback_noti")
let kNetFailNotify = Notification.Name("network_fail_noti")
let kTapReloadNotify = Notification.Name("tap_reloaddata_noti")

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

#if DEBUG
let baseUrlString = "http://xhfmedia.com:8080"
#else
let baseUrlString = "http://xhfmedia.com"
#endif
let baseHtmlString = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title></title><style>body {font:48px/1.5 tahoma,arial,sans-serif;color:#55555;text-align:justify;text-align-last:justify;line-height:70px}hr {height:1px;border:none;border-top:1px solid #e8e8e8;} img {width:100%;height:auto}</style></head><body><div style='margin:35px' id=\"content\">${contentHtml}</div></body></html>"
    
    

