//
//  LiveModelList.swift
//  BestNews
//
//  Created by Worthy on 2017/12/16.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class LiveModel: HandyJSON {
    
    required init(){}
    
    var id: String = ""
    var title: String = ""
    var marks: String = ""
    var state: String = ""
    var zannum: Int = 0
    var preimgpath: String = ""
    var collectnum: Int = 0
    var collect: Int = 0
    var createdate: Int = 0
    /// 直播开始时间
    var livedatestart: Int = 0
    ///主持人用户的id
    var compereuserid: String = ""
    ///主播用户id
    var anchoruserid: String = ""
    ///用户名
    var anchorusername: String = ""
    ///主播头像
    var anchorheadimg: String = ""
    /// 主播推流appName
    var livepush_appname: String = ""
    /// 直播推流的StreamName
    var livepush_streamname: String = ""
    /// 融云主持人聊天室房间号
    var chatroom_id_compere: String = ""
    /// 融云群聊聊天室房间号
    var chatroom_id_group: String = ""
    /// 直播/录像视频地址
    var videopath: String = ""
    
    var subscribe: Int = 0
    
    
    func stateStr() -> String {
        if state == "l1_finish" {
            if videopath.count > 0 {
                return "  视频回放  "
            }
            else {
                return "  直播视频正在生成..."
            }
        }
        else if state == "l2_coming" {
            return "  即将到来  "
        }
        else if state == "l3_living" {
            return "   正在直播  "
        }
        return "其他"
    }
    
    
    ///日期字符串
    func dateStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date(timeIntervalSince1970: TimeInterval(createdate/1000))
        return formatter.string(from: date)
    }
}

class LiveModelList: HandyJSON {
    required init(){}
    
    var total: Int = 0
    var page: Int = 0
    var list: [LiveModel] = []
}
