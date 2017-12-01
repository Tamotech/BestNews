//
//  TodayStockStatus.swift
//  BestNews
//
//  Created by Worthy on 2017/11/13.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

///股票行情
class TodayStockStatus: HandyJSON {

    required init(){}
    
    var percent: Double = 0
    var price: Double = 0
    var updatetime: Int = 0
    var name: String = ""
    var updown: Double = 0
    
}
