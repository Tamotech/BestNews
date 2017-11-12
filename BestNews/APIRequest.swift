//
//  APIRequest.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/17.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

typealias JSONResult = (_ resultObject: Any?) -> ()

/// 构建 http 请求 以及处理返回结果
class APIRequest: NSObject {

    
    
    /// 核验手机号
    ///
    /// - Parameters:
    ///   - phone: 手机号
    ///   - result: re
    class func checkMobile(phone: String, result: @escaping (_ success: Bool) -> ()) {
        let path = "/regist/checkMobile.htm?mobile=\(phone)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 || code == -111 {
                result(true)
            }
            else {
                result(false)
            }
        }
        
    }
    
    ///获取手机验证码
    class func getPhotoCaptcha(result: @escaping (_ success: Bool, _ imgUrl: String?, _ captchaCode: String?) -> ()) {
        let path = "/captcha/newCaptcha.htm?width=60"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                guard let url = JSON!["memo"].rawString() else {
                    result(false, nil, nil)
                    return
                }
                let captchaCode = DES3EncryptUtil.decrypt(JSON?["info"].rawString()!)
                result(true, url, captchaCode)
            }
            else {
                result(false, nil, nil)
            }
        }
    }
    
    ///发送手机号短信验证码
    class func sendSMSCode(phone: String, result: @escaping (_ success: Bool, _ smsCode: String?) -> ()) {
        let path = "/smscaptcha/sendSms.htm?mobile=\(phone)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                guard let sms = JSON!["memo"].rawString() else {
                    result(false, nil)
                    return
                }
                result(true, DES3EncryptUtil.decrypt(sms))
            }
            else {
                result(false, nil)
            }
        }
    }
    
    
    
    
    /// 获取用户信息
    ///
    /// - Parameter result:  request
    class func getUserInfoAPI(result: @escaping JSONResult) {
        
        let path = "/member/getUserInfo.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) {(JSON, code, msg) in
            if code == 0 {
                let data = UserInfo.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 获取微信用户信息
    class func getWXUserInfo(accessToken: String, openId: String, result: @escaping JSONResult) {
        let path = String.init(format: "https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", accessToken, openId)
        Alamofire.request(path).responseJSON { (response) in
            if let value = response.result.value {
                let dic = JSON(value)
                if dic["errcode"] == JSON.null {
                    let data = WXUserInfo.deserialize(from: dic.rawString())
                    result(data)
                }
                
            }
        }
    }
    
    /// 首页banner
    class func getBannerListAPI(result: @escaping JSONResult) {
        let path = "/article/getIdxBanner.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = [HomeArticle].deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            
        }
    }
    
    /// 首页专题列表
    class func getSpecialListAPI(result: @escaping JSONResult) {
        let path = "/article/getSpecialChannelList.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = [SpecialChannel].deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            
        }
    }
    
    ///首页文章列表
    class func getHomeArticleListAPI(page: Int, row: Int, result: @escaping JSONResult) {
        let path = "/article/getIdxRecommendArticles.htm?page=\(page)&rows=\(row)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeArticleList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            
        }
    }
    
    ///推荐文章列表
    class func getRecommendArticleListAPI(articleId: String, page: Int, row: Int, result: @escaping JSONResult) {
        let path = "/article/articleRecommendPage.htm?id=\(articleId)&page=\(page)&rows=\(row)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeArticleList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            
        }
    }
    
    ///文章详情页
    class func newsDetailAPI(id: String, result: @escaping JSONResult) {
        let path = "/article/articleDetail.htm?id=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeNewsDetail.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            
        }
    }
    
    
    /// 发表评论
    ///
    /// - Parameters:
    ///   - articleId: 文章id
    ///   - commentId: 评论id
    ///   - content: 内容
    ///   - result: 回调
    class func commentAPI(articleId: String, commentId: String?, content: String, result: @escaping JSONResult) {
        let path = "/articleoperate/articleComment.htm"
        var params = ["articleid": articleId,
                      "content": content]
        if commentId != nil {
            params["replyid"] = commentId!
        }
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                BLHUDBarManager.showSuccess(msg: "评论成功", seconds: 1)
                result(JSON!["data"])
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
        
    }
    
    
    
    /// 评论列表
    ///
    /// - Parameters:
    ///   - articleId: 文章id
    ///   - commentId: 评论id
    ///   - page: 第几页   1,2,3
    ///   - result: 回调
    class func commentListAPI(articleId: String, commentId: String?, page: Int, result: @escaping JSONResult) {
        let path = "/articleoperate/commentPage.htm"
        /// TREAT: 回复默认最多加载100条 不做分页
        let rows = commentId == nil ? 20 : 100
        var params = ["articleid": articleId,
                      "page": "\(page)",
                      "rows": "\(rows)"]
        if commentId != nil {
            params["replyid"] = commentId!
        }
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = CommentList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
        }
        
    }
    
    
    /// 评论点赞
    ///
    /// - Parameters:
    ///   - commentId: 评论id
    ///   - result: 结果
    class func commentPraiseAPI(commentId: String, result: @escaping (_ success: Bool)->()) {
        let path = "/articleoperate/praise.htm"
        let params = ["id": commentId,
                      "type": "comment"]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                result(true)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
                result(false)
            }
        }
    }
    
    /// 评论取消点赞
    ///
    /// - Parameters:
    ///   - commentId: 评论id
    ///   - result: 结果
    class func commentCancelPraiseAPI(commentId: String, result: @escaping (_ success: Bool)->()) {
        let path = "/articleoperate/cancelPraise.htm"
        let params = ["id": commentId,
                      "type": "comment"]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                result(true)
            }
            else {
                result(false)
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
}
