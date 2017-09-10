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
    
}
