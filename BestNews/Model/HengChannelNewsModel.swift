//
//  HengChannelNewsModel.swift
//  BestNews
//
//  Created by wuxi on 2018/12/5.
//  Copyright © 2018 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

///横向文章集
class HengChannelNewsModel: HandyJSON {

    required init() {
        
    }
    var id = ""
    var icon = ""
    var name = ""
    var type = ""
    var fullname = ""
    var pageData: [HomeArticle] = []
    
    func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &pageData, name: "pageData.list")
    }
    
}
