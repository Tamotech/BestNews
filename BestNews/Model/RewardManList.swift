//
//  RewardManList.swift
//  BestNews
//
//  Created by Worthy on 2017/11/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

///赞赏列表
class RewardManList: HandyJSON {

    required init(){}
    
    var total: Int = 0
    var list: [RewardMan] = []
}

class RewardMan: HandyJSON {
    
    required init(){}
    
    var userid: String = ""
    var name: String = ""
    var headimg: String = ""
    var money: Double = 0
    
}


