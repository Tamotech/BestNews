//
//  HomeNewsDetail.swift
//  BestNews
//
//  Created by Worthy on 2017/11/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class HomeNewsDetail: HandyJSON {

    /**
     "content": "文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容文章内容",
     "id": "255f351c-f4c7-4deb-a675-2201d04a37ee",
     "author": "",
     "title": "文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题文章标题",
     "channeltype": "normal",
     "channelname": "栏目1",
     "marks": "",
     "headimg": "http://localhost:8080/platform/upload/files/default/image/201710/84cb4a8b-fa6f-4a92-a8af-a95eb271cfcb_crop.jpg",
     "userid": "",
     "type": "grasp",
     "publishdate": 1507642324000,
     "publisher": "中国新闻网",
     "channelid": "1"
     */
    
    required init() {}
    var id: String = ""
    var content: String = ""
    var author: String = ""
    var title: String = ""
    var channeltype: String = ""
    var channelname: String = ""
    var marks: String = ""
    var headimg: String = ""
    var userid: String = ""
    var type: String = ""
    var publishDate: Int = 0
    var publisher: String = ""
    var channelid: String = ""
    
    ///评论数量
    var commentNum: Int = 0
    // 0 未收藏  1 已收藏
    var collect: Int = 0
    
    ///是否订阅
    var subseribe: Int = 0
    
    /// 栏目名 日期
    func descString() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(publishDate)/1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let str = formatter.string(from: date)
        let desc = "\(channelname) \(str)"
        return desc
    }
    
}
