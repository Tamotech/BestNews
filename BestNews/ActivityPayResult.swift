//
//  ActivityPayResult.swift
//  BestNews
//
//  Created by Worthy on 2017/12/31.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class ActivityPayResult: HandyJSON {

    required init(){}
    
    var needpaymoney: Double = 0
    var orderno = ""
    var weixin: WXPayInfo = WXPayInfo()
    var zhifubao = ""
    var aaid = ""       //活动报名id
    
}

class WXPayInfo: HandyJSON {
    required init(){}
    
    var appid = ""
    var partnerid = ""
    var prepayid = ""
    var package = ""
    var noncestr = ""
    var timestamp = ""
    var sign = ""
}
