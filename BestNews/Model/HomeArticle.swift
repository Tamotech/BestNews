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
    var marks: String = ""
    var preimglist: [String] = []
    var publishdate: Int = 0
    var titleimgpath: String = ""
    var preimgtype: String = ""
    var publisher: String = ""
    
    ///是否是推荐新闻
    var recommendFlag = false
    
    required init() {}
    
    
    ///标签颜色
    func markColor() -> UIColor {
        if marks == "原创" {
            return UIColor(hexString: "#60ACFD")!
        }
        else if marks == "推广" {
            return UIColor(hexString: "#FFD772")!
        }
        else if marks == "快讯" {
            return UIColor(hexString: "CFB2FF")!
        }
        else if marks == "专题" {
            return UIColor(hexString: "FE8A8A")!
        }
        return themeColor!
    }
    
    
    func cellListPublisher() -> String {
        if marks == "原创" {
            return ""
        }
        return publisher
    }
    
    func dateString() -> String {
        let date = Date(timeIntervalSince1970: Double(publishdate)/1000)
        let dateStr = date.newsDateStr()
        return dateStr
    }
}

class HomeArticleList: HandyJSON {
    
    required init() {}
    
    var rows: Int = 0
    var total: Int = 0
    var page: Int = 1
    var list: [HomeArticle] = []
}
