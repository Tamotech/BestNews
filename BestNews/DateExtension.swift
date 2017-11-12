//
//  DateExtension.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/14.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

extension Date {

    func stringOfDay() -> String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let str = formater.string(from: self)
        return str
    }
    
    /// 时间戳格式: xx分钟前 xx小时前 xx月xx日
    func newsDateStr() -> String {
        let now = Date()
        let gregorian = Calendar(identifier: .gregorian)
        let result = gregorian.dateComponents([Calendar.Component.minute], from: self, to: now)
        if result.minute! >= 1 && result.minute! < 60 {
            return "\(result.minute!)分钟前"
        }
        else if result.minute! > 60 && result.minute! <= 60*24 {
            return "\(result.minute! / 60)小时前"
        }
        else if result.minute! >= 60*24 && result.minute! < 60*48 {
            return "1天前"
        }
        else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd"
            return formatter.string(from: self)
        }
    }
    
}
