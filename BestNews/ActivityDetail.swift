//
//  ActivityDetail.swift
//  BestNews
//
//  Created by Worthy on 2017/11/16.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class ActivityDetail: HandyJSON {
    required init(){}
    
    var id: String = ""
    var title: String = ""
    var startdate: Int = 0
    var address: String = ""
    
    //l3_hot:热门活动
    //l2_coming:即将到来
    //l1_finish:已经结束
    var state: String = ""
    var enddate: Int = 0
    var preimgpath: String = ""
    var sponsor = ""
    var num: Int = 0
    var tags = ""
    var content = ""
    var applystarttime: Double = 0
    var applyendtime: Double = 0
    var refundflag = false
    var createdate: Double = 0
    var tickets: [ActivityTicket] = []
    
    ///是否收藏
    var collect: Int = 0
    
    
    
    lazy var dateformatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy年MM月dd日 EEEE"
        return f
    }()
    
    lazy var dateformatter1: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f
    }()
    
    ///标签
    func stateStr() -> String {
        if state == "l3_hot" {
            return "热门活动"
        }
        else if state == "l2_coming" {
            return "即将到来"
        }
        else if state == "l1_finish" {
            return "已经结束"
        }
        return ""
    }
    
    ///时间
    func dateStr() -> String {
        let start = Date(timeIntervalSince1970: TimeInterval(startdate/1000))
        let end = Date(timeIntervalSince1970: TimeInterval(enddate/1000))
        let d1 = dateformatter.string(from: start)
        let d2 = dateformatter1.string(from: start)
        let d3 = dateformatter1.string(from: end)
        return "\(d1) \(d2)-\(d3)"
    }
    
    ///价格
    func priceString() -> String {
        var str = ""
        for tic in tickets {
            str = str+String(tic.money)
            if tic.id != tickets.last!.id {
                str = str+","
            }
        }
        return str
    }
    
    func contentHtmlString() -> String {
        let html = "<html><boty><div style='margin:25px'><font size=\"26\" color=\"black\">\(content)<br><br><br><br></font></div></body></html>"
        return html
    }
}

class ActivityTicket: HandyJSON {
    
    required init(){}
    
    var id = ""
    var name = ""
    var saleenddate: Double = 0
    var money: Double = 0
    var num: Int = 0
    var sortid: Int = 0
    var salenum: Int = 0
    
    func endDateStr() -> String {
        let date = Date(timeIntervalSince1970: saleenddate)
        return date.stringWithFormat("MM月dd日")
    }
}
