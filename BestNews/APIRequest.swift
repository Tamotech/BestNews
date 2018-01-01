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
    
    
    
    /// 更新用户信息
    ///
    /// - Parameters:
    ///   - params: 参数
    ///   - result: 结果
    class func updateUserInfo(params: [String: String], result: @escaping (_: Bool)->()) {
        
        let path = "/member/updateUserInfo.htm"
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) {(JSON, code, msg) in
            if code == 0 {
                result(true)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
                result(false)
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
        let path = "/article/commentPage.htm"
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
    
    
    
    /// 文章赞赏列表
    ///
    /// - Parameters:
    ///   - articleId: 文章列表
    ///   - result: 结果
    class func ArticleReardManListAPI(articleId: String, result: @escaping JSONResult) {
        let path = "/article/articleRewardHist.htm"
        let params = ["articleid": articleId]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = RewardManList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 快讯列表
    ///
    /// - Parameters:
    /// - collect 是否仅收藏
    ///   - page: 页
    ///   - result: 结果
    class func getFastNewsListAPI(page: Int, collect: Bool, result: @escaping JSONResult) {
        let path = "/article/getNewsFlashPage.htm"
        var params = ["page": page,
        "rows": 20] as [String: Any]
        if collect {
            params["collectflag"] = "true"
        }
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = FastNewsList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    ///股票行情
    class func getStockStatusAPI(result: @escaping JSONResult) {
        let path = "/article/getHangqing.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = [TodayStockStatus].deserialize(from: JSON!["data"].rawString())
                result(data)
            }
        }
    }
    
    ///所有频道列表
    class func getAllChannelAPI(result: @escaping JSONResult) {
        let path = "/article/getAllChannnel.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = [NewsChannel].deserialize(from: JSON!["data"].rawString())
                result(data)
            }
        }
    }
    
    
    
    /// 批量注册订阅
    /// 调用此接口会清空原所有订阅的栏目，请谨慎调用
    /// - Parameters:
    ///   - channelIds: channelid, ','分割
    ///   - result: 成功失败
    class func multiSubscriptChannelAPI(channelIds: String, result: @escaping (_: Bool)->()) {
        let path = "/subseribe/batchSubseribeChannel.htm?channelids=\(channelIds)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                result(true)
            }
            else {
                result(false)
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 订阅单个栏目/用户/机构
    ///
    /// - Parameters:
    ///   - id: id
    ///   - type: channel:栏目 user:用户 organize:机构
    ///   - result: 成功/失败
    class func subscriptChannelAPI(id: String, type: String, result: @escaping (_: Bool)->()) {
        let path = "/subseribe/subseribe.htm"
        let params = ["id": id,
                      "type": type]
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
    
    /// 取消订阅单个栏目/用户/机构
    ///
    /// - Parameters:
    ///   - id: id
    ///   - type: channel:栏目 user:用户 organize:机构
    ///   - result: 成功/失败
    class func cancelSubscriptChannelAPI(id: String, type: String, result: @escaping (_: Bool)->()) {
        let path = "/subseribe/cancelSubseribe.htm"
        let params = ["id": id,
                      "type": type]
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
    
    /// 查询订阅状态
    ///
    /// - Parameters:
    ///   - ids: id 都好分割
    ///   - result: 结果
    class func subscriptStatusAPI(ids: String, result: @escaping JSONResult) {
        let path = "/subseribe/subseribeState.htm"
        let params = ["id": ids]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                result(JSON)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 活动列表
    ///
    /// - Parameters:
    /// - collect: 是否收藏
    ///   - page: 分页
    ///   - result: 结果
    class func activityListAPI(collect: Bool, page: Int, result: @escaping JSONResult) {
        var path = "/activity/listPage.htm?page=\(page)&rows=\(20)"
        if collect {
            path = path+"&collectflag=true"
        }
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = ActivityList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
        
    }
    
    
    
    /// 活动详情
    ///
    /// - Parameters:
    ///   - id: id
    ///   - result: 结果
    class func activityDetailAPI(id: String, result: @escaping JSONResult) {
     
        let path = "/activity/detail.htm?id=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = ActivityDetail.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 机构列表
    ///
    ///   - Parameters:
    ///   - xgorganizeid: 你可能感兴趣组织（组织详情页使用）
    ///   - page: 页
    ///   - result: 结果
    class func ognizationListAPI(xgorganizeid: String?, page: Int, result: @escaping JSONResult) {
        var path = "/organize/getOrganizePage.htm?page=\(page)&rows=\(20)"
        if xgorganizeid != nil {
            path = path + "&xgorganizeid=\(xgorganizeid!)"
        }
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = OgnizationList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 机构详情
    ///
    /// - Parameter result: 结果
    class func ognizationDetailAPI(id: String, result: @escaping JSONResult) {
        let path = "/organize/organizeDetail.htm?id=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = OgnizationModel.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    /// 活动报名准备信息
    ///
    /// - Parameters:
    ///   - id: id
    ///   - result: 结果
    class func activityPrepareAPI(id: String, result: @escaping JSONResult) {
        
        let path = "/activityoperate/prepare.htm?aid=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = ActivityPrepare.deserialize(from: JSON!["data"]["fillhist"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 申请报名
    ///
    /// - Parameters:
    ///   - activity: 报名信息
    ///   - result: 结果
    class func applyActivityAPI(activity: ActivityPrepare, result: @escaping JSONResult) {
        let path = "/activityoperate/apply.htm"
        let params = activity.toJSON()
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = ActivityPayResult.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 收藏文章/快讯/活动
    ///
    /// - Parameters:
    ///   - id: id
    ///   - type: article:新闻  newsflash:快讯  activity:活动
    ///   - result: 成功/失败
    class func collectAPI(id: String, type: String, result: @escaping (_: Bool)->()) {
        let path = "/collect/collect.htm"
        let params = ["id": id, "type": type]
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
    
    
    /// 取消收藏文章/快讯/活动
    ///
    /// - Parameters:
    ///   - id: id
    ///   - type: article:新闻  newsflash:快讯  activity:活动
    ///   - result: 成功/失败
    class func cancelCollectAPI(id: String, type: String, result: @escaping (_: Bool)->()) {
        let path = "/collect/cancelCollect.htm"
        let params = ["id": id, "type": type]
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
    
    
    
    /// 分页查询文章列表（频道专题下文章、机构相关文章，名人发布文章）
    ///
    /// - Parameters:
    ///   - id: id
    ///   - type: channelid/organizeid/userid
    ///   - result: 列表
    class func articleListAPI(id: String, type: String, page:Int, result: @escaping JSONResult) {
        let path = "/article/getArticlePage.htm"
        let params = ["page": "\(page)",
                      type: id,
                      "rows": "20"]
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeArticleList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 名人列表
    ///
    /// - Parameters:
    ///   - id: 组织/可能感兴趣名人
    ///   - type: organizeid/xguserid
    ///   - page: 第几页
    ///   - result: 结果
    class func famousListAPI(id: String, type: String, page:Int, result: @escaping JSONResult) {
        let path = "/celebrity/getCelebrityPage.htm"
        let params = ["page": "\(page)",
            type: id,
            "rows": "20"]
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = OgnizationList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    /// 名人详情
    ///
    /// - Parameter result: 结果
    class func famousDetailAPI(id: String, result: @escaping JSONResult) {
        let path = "/celebrity/celebrityDetail.htm?userid=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = OgnizationModel.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 查询用户订阅文章
    ///
    /// - Parameters:
    ///   - result: 列表
    class func subscribeArticleListAPI(page:Int, result: @escaping JSONResult) {
        let path = "/articleoperate/getSubscribeArticlePage.htm"
        let params = ["page": "\(page)",
            "rows": "20"]
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeArticleList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    /// 查询用户收藏文章
    ///
    /// - Parameters:
    ///   - result: 列表
    class func collectedArticleListAPI(page:Int, result: @escaping JSONResult) {
        let path = "/articleoperate/getCollectArticlePage.htm"
        let params = ["page": "\(page)",
            "rows": "20"]
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeArticleList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 文章打赏
    ///
    /// - Parameters:
    ///   - articleId: 文章id
    ///   - money: 金额
    ///   - payway: zhibubao:支付宝支付 weixin:微信支付
    ///   - payaccount: 支付帐号
    ///   - orderno: 支付订单号
    ///   - result: 成功
    class func articleRewardAPI(articleId: String, money: Double, payway: String, result: @escaping JSONResult) {
        let path = "/articleoperate/reward.htm"
        let params = ["articleid": articleId,
                      "money": "\(money)",
                      "payway": payway]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = ActivityPayResult.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 查询用户订阅收藏活动文章数量
    ///
    /// - Parameter result: 结果
    class func meInfoCountAPI(result: @escaping JSONResult) {
        let path = "/member/countUserOPNum.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                result(JSON!["data"])
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 申请实名认证
    ///
    /// - Parameters:
    ///   - idname: 姓名
    ///   - idCode: 身份证号
    ///   - result: 结果
    class func applyIdentiify(idname: (String), idCode: (String), result: @escaping (_ success: Bool)->()) {
        let path = "/certification/certification.htm"
        let params = ["idname": idname,
                      "idnumber": idCode]
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                result(true)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
                
            }
        }
    }
    
    
    
    /// 分页查询当前用户购买的票卷信息
    ///
    /// - Parameters:
    ///   - page: 第几页
    ///   - result: 结果
    class func activityTicketDetailList(page:Int, result: @escaping JSONResult) {
        let path = "/activityoperate/payedTicketPage.htm"
        let params = ["page": "\(page)",
            "rows": "20"]
        
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = ActivityTicketDetailList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 申请名人
    ///
    /// - Parameters:
    ///  - model: 名人model
    ///   - result: 结果
    class func applyFamousIdentiify(model: ApplyFamousModel, result: @escaping (_ success: Bool)->()) {
        let path = "/certification/applyCelebrity.htm"
        let params = ["company": model.company,
                      "trade": model.trade,
                      "position": model.position,
                      "tags": model.tags,
                      "businesscard": model.businesscard]
        
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
    
    
    /// 直播列表
    ///
    /// - Parameters:
    ///   - page: 页
    ///   - collect: 收藏
    ///   - result: 结果
    class func getLivePageListAPI(page: Int, collect: Bool, result: @escaping JSONResult) {
        let path = "/live/getLivePageList.htm"
        let params = ["page": page,
                      "collectflag": (collect ? "true": "false"),
                      "rows": "10"]
            as [String : Any]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = LiveModelList.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    ///直播详情
    class func liveDetailAPI(id: String, result: @escaping JSONResult) {
        let path = "/live/liveDetail.htm?id=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = LiveModel.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    /// 查询频道封面文章
    ///
    /// - Parameters:
    ///   - id: id
    ///   - result: jieguo
    class func channelCoverArticleAPI(id: String, result: @escaping JSONResult) {
        let path = "/article/getChannelCoverArticles.htm?channelid=\(id)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = HomeArticle.deserialize(from: JSON!["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
        
    }
}
