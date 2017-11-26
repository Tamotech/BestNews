//
//  ActivityPrepare.swift
//  BestNews
//
//  Created by Worthy on 2017/11/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class ActivityPrepare: HandyJSON {

    required init(){}
    var sex: String = "male"
    var idnum: String = ""
    var trade: String = ""
    var profession: String = ""
    var company: String = ""
    var name: String = ""
    var buscard: String = ""
    var mobile: String = ""
    
    ///外面赋值
    var aid: String = ""
    var tid: String = ""
    
    
    func isCompleteFill() -> Bool {
        if sex == "" || idnum == "" || name == "" || trade == ""
            || company == "" || mobile == "" || profession == "" {
            return false
        }
        return true
    }
    
}
