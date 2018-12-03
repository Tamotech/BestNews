//
//  AdvertiseModel.swift
//  BestNews
//
//  Created by Worthy on 2018/1/17.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class AdvertiseModel: HandyJSON {

    required init(){}
    
    var configid = ""
    var groups = ""
    var id = ""
    var name = ""
    var outlink = ""
    var outlinktitle = ""
    var path = ""
    var imgData: Data?
    /// iphoneX 的广告图
    var code = ""
    
    ///合适的尺寸
    var suitADImg: String {
        if IS_IPHONEX || IS_IPHONEXMAX {
            return code
        }
        return path
    }
    
}
