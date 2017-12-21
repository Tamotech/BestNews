//
//  SpecialChannel.swift
//  BestNews
//
//  Created by Worthy on 2017/11/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

/// 专题
class SpecialChannel: HandyJSON {

    var id: String = ""
    var name: String = ""
    var type: String = ""
    var preimgpath: String = ""
    var fullname: String = ""
    ///是否显示在首页
    var showinnavflag: Int = 0
    
    required init() {}
}
