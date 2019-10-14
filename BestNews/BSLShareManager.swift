//
//  BSLShareManager.swift
//  Summer
//
//  Created by 武淅 段 on 2017/9/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import WatchConnectivity

class BSLShareManager: NSObject {

    
    
    /// 分享到微信
    ///
    /// - Parameters:
    ///   - link: 网页链接
    ///  - title: 标题
    ///   - msg: 描述
    ///   - thumb: 缩略图url
    ///   - type: 类型 0 好友 1 朋友圈
    class func shareToWechat(link: String, title: String, msg: String, thumb: String, type: Int) {
        
        let message = WXMediaMessage()
        if thumb.count > 0 {
            guard let imgData = try? Data.init(contentsOf: URL(string: thumb)!) else {
                return
            }
            let img = UIImage(data: imgData)
            message.setThumbImage(img)
        }
        else {
            message.setThumbImage(#imageLiteral(resourceName: "logo"))
        }
        message.title = title
        message.description = msg
        
        let webPageObj = WXWebpageObject()
        webPageObj.webpageUrl = link
        message.mediaObject = webPageObj
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        if type == 0 {
            req.scene = Int32(WXSceneSession.rawValue)
        }
        else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        let r = WXApi.send(req)
        print("分享结果...>\(r)")
    }
    
    /// 分享到微信 图片格式
    ///
    /// - Parameters:
    ///  - title: 标题
    ///   - msg: 描述
    ///   - img: 图片
    ///   - type: 类型 0 好友 1 朋友圈
    class func shareToWechatWithImage(title: String, msg: String, thumb: String, img: UIImage, type: Int) {
        
        let message = WXMediaMessage()
        if thumb.count > 0 {
            guard let imgData = try? Data.init(contentsOf: URL(string: thumb)!) else {
                return
            }
            let img = UIImage(data: imgData)
            message.setThumbImage(img)
        }
        else {
            message.setThumbImage(#imageLiteral(resourceName: "logo"))
        }
        message.title = title
        message.description = msg
    
        
        let obj = WXImageObject()
        obj.imageData = UIImageJPEGRepresentation(img, 1)
        message.mediaObject = obj
        
        
        let req = SendMessageToWXReq()
        req.bText = false
        req.message = message
        if type == 0 {
            req.scene = Int32(WXSceneSession.rawValue)
        }
        else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        let r = WXApi.send(req)
        print("分享结果...>\(r)")
    }
    
    
    
    
    /// 分享至qq或qq空间
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - msg: 描述
    ///   - qqOrZorn: 0  qq  1 空间
    ///   - link: 链接
    ///   - thumb: 缩略图
    ///   - img: 图片
    class func shareToQQ(title: String, msg: String, qqOrZorn: Int, link: String, thumb: String, img: UIImage?) {
        var data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "logo"), 1)
        if thumb.count>0 {
            do {
                data = try Data(contentsOf: URL(string: thumb)!)
            }
            catch {
                
            }
        }
        
        var send: QQBaseReq?
        if img != nil {
            let imdata = UIImageJPEGRepresentation(img!, 1)!
            let obj = QQApiImageObject(data: imdata, previewImageData: imdata, title: title, description: msg)
            send = SendMessageToQQReq(content: obj!)
        }
        else {
            let obj = QQApiNewsObject(url: URL(string: link)!, title: title, description: msg, previewImageData: data!, targetContentType: QQApiURLTargetTypeNews)
            
            send = SendMessageToQQReq(content: obj!)
            let sent = QQApiInterface.send(send)
            print(sent)
        }
        if qqOrZorn == 0 {
            //qq
            let ret = QQApiInterface.send(send)
            print("分享qq...\(ret)")
        }
        else {
            //qq空间
            let ret = QQApiInterface.sendReq(toQZone: send)
            print("分享空间...\(ret)")
        }
    }
}
