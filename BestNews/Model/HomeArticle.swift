//
//  HomeArticle.swift
//  BestNews
//
//  Created by Worthy on 2017/11/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class HomeArticle: HandyJSON {

    var id: String = ""
    var title: String = ""
    var channeltype: String = ""
    var channelname: String = ""
    var masks: String = ""
    var preimglist: [Any] = []
    var publishdate: Date = Date()
    var titleimgpath: String = ""
    var preimgtype: String = ""
    var publisher: String = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            publishdate <-- DateTransform()
    }
}
