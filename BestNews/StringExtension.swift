//
//  StringExtension.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/7.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

extension String {

    func validPhoneNum() -> Bool {
        
        let str = self.replacingOccurrences(of: " ", with: "")
        if str.characters.count != 11 {
            return false
        }
        if !str.characters.starts(with: ["1"]) {
            return false
        }
        return true
    }
    
    func trip() -> String {
        var newStr = self.replacingOccurrences(of: " ", with: "")
        newStr = newStr.replacingOccurrences(of: "-", with: "")
        return newStr
    }
    
    
    /// 从字符串中提取 整数数字
    func getIntFromString() -> Int {
        let scanner = Scanner(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        
        scanner.scanInt(&number)
        
        return number
    }
    
    /// 从字符串中提取浮点数数字
    func getFloatFromString() -> CGFloat {
        let scanner = Scanner(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number : Float = 0
        
        scanner.scanFloat(&number)
        
        return CGFloat(number)
    }
    
    
    /// 计算文字的高度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽度
    /// - Returns: 高度
    func getLabHeigh(font:UIFont,width:CGFloat) -> CGFloat {
        let statusLabelText: NSString = NSString(string: self)
        let size = CGSize(width: width, height: 900)
        let dic = [NSFontAttributeName: font]
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        return strSize.height
    }
}


