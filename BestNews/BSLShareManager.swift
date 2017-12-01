//
//  BSLShareManager.swift
//  Summer
//
//  Created by 武淅 段 on 2017/9/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import WatchKit

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
        WXApi.send(req)
    }
}
