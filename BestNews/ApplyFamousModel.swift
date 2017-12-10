//
//  ApplyFamousModel.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class ApplyFamousModel: HandyJSON {
    required init(){}
    
    var company: String = ""
    ///行业
    var trade: String = ""
    ///职位
    var position: String = ""
    ///标签,多标签之间通过英文逗号分隔     列表通过接口查询字典编码对应字典项获取code:FIX_CELEBRITY_TAG
    var tags: String = ""
    ///名片地址
    var businesscard: String = ""
    
    func completeFlag() -> Bool {
        if company.count > 0 && trade.count > 0 && position.count > 0 && tags.count > 0 && businesscard.count > 0 {
            return true
        }
        return false
    }
}
