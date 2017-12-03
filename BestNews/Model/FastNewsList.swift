//
//  FastNewsList.swift
//  BestNews
//
//  Created by Worthy on 2017/11/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class FastNewsList: HandyJSON {

    required init(){}
    
    var total: Int = 0
    var page: Int = 0
    var list: [FastNews] = []
    
    
    var newsDict: [String: [FastNews]] = [:]
    ///存放日期key
    var dateKeys: [String] = []
    
    //类似于懒加载 同步字典
    func asynDict() {
        if newsDict.values.count != list.count {
            newsDict.removeAll()
            dateKeys.removeAll()
            for news in list {
                let dateStr = news.dayStr()
                var contains = false
                for key in newsDict.keys {
                    if key == dateStr {
                        contains = true
                        break
                    }
                }
                if contains {
                    var newsList = newsDict[dateStr]
                    newsList?.append(news)
                    newsDict[dateStr] = newsList
                }
                else {
                    newsDict[dateStr] = [news]
                    dateKeys.append(dateStr)
                }
            }
        }
    }
    
    func numberOfSections() -> Int {
        asynDict()
        return dateKeys.count
    }
        
    func numberOsRowsInSection(section: Int) -> Int {
        asynDict()
        let key = dateKeys[section]
        let arr = newsDict[key]
        return arr?.count ?? 0
    }
        
    func titleForSection(_ section: Int) -> String {
        asynDict()
        return dateKeys[section]
        
    }
        
    func newsIn(section: Int, row: Int) -> FastNews {
        asynDict()
        let key = dateKeys[section]
        let arr = newsDict[key]!
        return arr[row]
    }
}

class FastNews: HandyJSON {
    
    required init() {}
    var content: String = ""
    var id: String = ""
    var createdate: Int = 0
    var collect: Int = 0
    
    lazy var dateFormmater: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    lazy var dateFormmater1: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MM-dd"
        return f
    }()
    
    
    /// 时间  HH:mm
    ///
    /// - Returns: 字符串
    func timeStr() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(createdate/1000))
        return dateFormmater.string(from: date)
    }
    
    func dayStr() -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(createdate/1000))
        let now = Date()
        let yesterday = now.addingTimeInterval(-24*3600)
        let beforeYesterday = now.addingTimeInterval(-48*3600)
        if date.stringOfDay() == now.stringOfDay() {
            return "今天"
        }
        else if date.stringOfDay() == yesterday.stringOfDay() {
            return "昨天"
        }
        else if date.stringOfDay() == beforeYesterday.stringOfDay() {
            return "前天"
        }
        else {
            return dateFormmater1.string(from: date)
        }
    }
    
}
