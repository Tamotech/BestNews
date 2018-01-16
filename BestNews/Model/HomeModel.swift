//
//  HomeModel.swift
//  BestNews
//
//  Created by Worthy on 2017/12/19.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class HomeModel: NSObject {

    static let shareInstansce = HomeModel()
    
    ///首页专题列表
    var specilList: [SpecialChannel] = []
    
    ///专题列表(非导航)
    var specilList1: [SpecialChannel] = []
    
    //首页所有频道
    var allChannels: [NewsChannel] = []
    
    ///首页导航栏栏目
    func navTitles() -> [String] {
        
        var titles = ["推荐","快讯","订阅"]
        for data in specilList {
        //    if data.showinnavflag == 1 {
                titles.append(data.name)
            }
        //}
        titles.append("视频")
        return titles
    }
    
    
    func getChannel(_ title: String) -> SpecialChannel? {
        for channel in specilList {
            if channel.name == title {
                return channel
            }
        }
        return nil
    }
}
