//
//  HomeSearchModel.swift
//  BestNews
//
//  Created by Worthy on 2018/1/17.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

///首页搜索
class HomeSearchModel: HandyJSON {

    required init() {}
    
    var normalArticle = HomeArticleList()
    var newsflash = FastNewsList()
    var specialArticle = HomeArticleList()
    var activity = ActivityList()
    var organize = OgnizationList()
    var celebrityuser = OgnizationList()
    
    
    func sectionNum() -> Int {
        return 6
    }
    
    func rowsNumInSection(_ section: Int) -> Int {
        if section == 0 {
            return normalArticle.list.count
        }
        else if section == 1 {
            return newsflash.list.count
        }
        else if section == 2 {
            return specialArticle.list.count
        }
        else if section == 3 {
            return activity.list.count
        }
        else if section == 4 {
            return organize.list.count
        }
        else if section == 5 {
            return celebrityuser.list.count
        }
        return 0
    }
    
    func model(section: Int, row: Int) -> Any? {
        if section == 0 {
            return normalArticle.list[row]
        }
        else if section == 1 {
            return newsflash.list[row]
        }
        else if section == 2 {
            return specialArticle.list[row]
        }
        else if section == 3 {
            return activity.list[row]
        }
        else if section == 4 {
            return organize.list[row]
        }
        else if section == 5 {
            return celebrityuser.list[row]
        }
        return nil
    }
}
