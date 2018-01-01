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
        if str.count != 11 {
            return false
        }
        if !str.starts(with: ["1"]) {
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
    
    /// 计算文字的宽度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽度
    /// - Returns: 宽度
    func getLabWidth(font:UIFont,height:CGFloat) -> CGFloat {
        let statusLabelText: NSString = NSString(string: self)
        let size = CGSize(width: 900, height: height)
        let dic = [NSFontAttributeName: font]
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic, context: nil)
        return strSize.width
    }
    
    
    /// MD5 加密
    ///
    /// - Parameter str: 字符串
    /// - Returns: 加密后
    func md5String() -> String{
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
    
    
    /// 生成二维码
    ///
    /// - Parameter qrImageName: 中间图片
    /// - Returns: 二维码
    func createQRForString(qrImageName: String?) -> UIImage?{
        
        let stringData = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        //创建一个二维码的滤镜
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        let qrCIImage = qrFilter?.outputImage
        
        // 创建一个颜色滤镜,黑白色
        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(qrCIImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor0")
        colorFilter.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor1")
        // 返回二维码image
        let codeImage = UIImage(ciImage: (colorFilter.outputImage!.applying(CGAffineTransform(scaleX: 5, y: 5))))
        
        // 中间一般放logo
        if qrImageName != nil {
            let iconImage = UIImage(named: qrImageName!)
            let rect = CGRect(x: 0, y: 0, width: codeImage.size.width, height: codeImage.size.height)
            
            UIGraphicsBeginImageContext(rect.size)
            codeImage.draw(in: rect)
            let avatarSize = CGSize(width: rect.size.width*0.25, height: rect.size.height*0.25)
            
            let x = (rect.width - avatarSize.width) * 0.5
            let y = (rect.height - avatarSize.height) * 0.5
            iconImage?.draw(in: CGRect(x: x, y: y, width: avatarSize.width, height: avatarSize.height))
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return resultImage
        }
        return codeImage
       
    }
}


