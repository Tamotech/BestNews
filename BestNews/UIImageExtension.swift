//
//  UIImageExtension.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/27.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

extension UIImage {
    
    
    ///带圆环的文字图片
    class func image(_ text:String,size:(CGFloat,CGFloat),backColor:UIColor=UIColor.white,textColor:UIColor=UIColor.green,isCircle:Bool=true) -> UIImage?{
        // 过滤空""
        if text.isEmpty { return nil }
        // 取第一个字符(测试了,太长了的话,效果并不好)
        let letter = (text as NSString).substring(to: 1)
        let sise = CGSize(width: size.0, height: size.1)
        let rect = CGRect(origin: CGPoint.zero, size: sise)
        // 开启上下文
        UIGraphicsBeginImageContext(sise)
        // 拿到上下文
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        // 取较小的边
        let minSide = min(size.0, size.1)
        // 是否圆角裁剪
        if isCircle {
            UIBezierPath(roundedRect: rect, cornerRadius: minSide*0.5).addClip()
        }
        // 设置填充颜色
        ctx.setFillColor(backColor.cgColor)
        // 填充绘制
        ctx.fill(rect)
        let attr = [ NSForegroundColorAttributeName : textColor, NSFontAttributeName : UIFont.systemFont(ofSize: minSide*0.9)]
        // 写入文字
        (letter as NSString).draw(at: CGPoint(x: minSide*0.05, y: minSide*0.0), withAttributes: attr)
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image
    }
    
    ///生成纯色背景的图片
    class func image(backgroundColor: UIColor, size: CGSize)->UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(backgroundColor.cgColor)
        ctx?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    
    //压缩图片到指定尺寸
    @objc func imageWithMaxSize(maxSize: CGFloat) -> UIImage? {
        let w = self.size.width
        let h = self.size.height
        let originMaxSize = w > h ? w : h
        if(originMaxSize > maxSize) {
            
            var newW = maxSize
            var newH = newW * h / w;
            if(newH > maxSize) {
                newH = maxSize
                newW = newH * w / h;
            }
            let size = CGSize(width: newW, height: newH)
            let scale = newH / h
            UIGraphicsBeginImageContext(size)
            let context = UIGraphicsGetCurrentContext()
            var transform = CGAffineTransform.identity
            transform = transform.scaledBy(x: scale, y: scale)
            context?.ctm.concatenating(transform)
            self.draw(at: CGPoint(x: 0, y: 0))
            let newimg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newimg
        }
        else {
            return self
        }
    }
}
