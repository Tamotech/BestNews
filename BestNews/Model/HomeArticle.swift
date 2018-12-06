//
//  HomeArticle.swift
//  BestNews
//
//  Created by Worthy on 2017/11/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class HomeArticle: HandyJSON, Equatable {
    static func == (lhs: HomeArticle, rhs: HomeArticle) -> Bool {
        return lhs.id == rhs.id
    }
    

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
    var linkurl = ""
    var reporter = ""
    var source = ""     //来源
    
    // normal  原创 grasp 抓取
    var type = ""
    
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
        if type == "normal" {
            if reporter.contains("null") {
                reporter = ""
            }
            return "\(source) \(reporter)"
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
    
    ///横向专栏文章集 2018-11-27
    var channelArticleList: [HengChannelNewsModel] = []
    var synthesizeArr: [Any] = []
    
    func numOfSections() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        genSynthesizeArray()
        return synthesizeArr.count
    }
    
    func cellModel(row: Int) -> Any {
        genSynthesizeArray()
        return synthesizeArr[row]
    }
    
    ///整合专题文章和首页文章为大列表 每三个插一个
    private func genSynthesizeArray() {
        //过滤掉空文章集
        channelArticleList = channelArticleList.filter{ $0.pageData.count > 0 }
        if synthesizeArr.count == list.count + channelArticleList.count {
            return
        }
        var index = 0
        var result: [Any] = list
        for channel in channelArticleList {
            index = index + 3
            if index >= result.count {
                break
            }
            result.insert(channel, at: index)
            index = index + 1
        }
        synthesizeArr = result
    }
}
