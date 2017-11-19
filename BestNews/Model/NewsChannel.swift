//
//  NewsChannel.swift
//  BestNews
//
//  Created by Worthy on 2017/11/13.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class NewsChannel: HandyJSON {

    required init(){}
    
    var id: String = ""
    var name: String = ""
    var fullname: String = ""
    
    //normal：普通   special：专题
    var type: String = ""
    var preimgpath: String = ""
    
    var selected: Bool = false
}
