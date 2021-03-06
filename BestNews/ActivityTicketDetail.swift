//
//  ActivityTicketDetail.swift
//  BestNews
//
//  Created by Worthy on 2017/12/9.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

/// 票券详情
class ActivityTicketDetail: HandyJSON {

    required init(){}
    
    var aid: String = ""        //活动id
    var aaid: String = ""       //报名id
    var title: String = ""
    var preimgpath: String = ""
    var address: String = ""
    var startdate: Int = 0
    var enddate: Int = 0
    /// l3_hot:热门活动  l2_coming:即将到来  l1_finish:已经结束
    var state: String = ""
    var tid: String = ""
    var tname: String = ""
    var num: Int = 0
    var userid: String = ""
    var username: String = ""
    var mobile: String = ""
    //二维码编码
    var ano: String = ""
    var refundflag = 0      //是否可以退款
    
    
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
}

class ActivityTicketDetailList: HandyJSON {
    required init(){}
    var total: Int = 0
    var page: Int = 1
    var rows: Int = 20
    var list: [ActivityTicketDetail] = []
}
