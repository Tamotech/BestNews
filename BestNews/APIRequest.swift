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
            if code == 0 {
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
    
    
    /*
    /// 查询当天的 AQI
    ///
    /// - Parameter result: request
    class func AQIQueryAPI(result: @escaping JSONResult) {
        
        print("--------->查询今天 AQI")
        let path = "/aqi/getTodayAqiByGeo.htm"
        let location = SessionManager.sharedInstance.currentLocation
        if location.coordinate.latitude == 0 {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 2), execute: {
                APIRequest.AQIQueryAPI(result: result)
            })
            return
        }
        let params = ["lng": location.coordinate.longitude,
                      "lat": location.coordinate.latitude]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = CurrentAQI.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 查询最近一星期的 AQI:
    ///
    /// - Parameters:
    ///   - cityID: cityID
    ///   - result: result
    class func recentWeekAQIAPI(cityID: Int, result: @escaping JSONResult) {
        
        let path = "/aqi/getRecentAqiMinMax.htm"
        let params = ["cityid": cityID]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = RecentWeekAQI.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
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
                else {
                    
                }
            }
        }
    }
    
    
    /// 获取用户风速配置信息
    ///
    /// - Parameter result:  result
    class func getUserWindSpeedConfig(result: @escaping JSONResult) {
        let path = "/maskwindspeedset/getCfgList.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let list = JSON?["data"]["cfglist"]
                let cfgList = [UserWindSpeedConfig].deserialize(from: list?.rawString())
                result(cfgList)
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    
    
    /// 读取用户配置
    ///
    /// - Parameters:
    ///   - codes: 编码
    /// http://www.blueskylab.cn/wiki/index.do?wikiid=wiki&navid=8fe3da70-3ffa-4cef-bcd0-1068719e701f
    ///   - result: data
    class func getUserConfig(codes: String, result: @escaping JSONResult) {
        let path = "/config/getCfgByCodes.htm"
        let params = ["codes": codes]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let list = JSON?["data"]
                result(list)
            }
        }
    }
    
    
    
    
    /// 获取文章列表
    ///
    /// - Parameters:
    ///   - channelId: 8:常见问题 9:关于产品 10:关于售后
    ///   - page: 默认1
    ///   - rows: 默认5
    ///   - result: data
    class func getArticleList(channelId: Int, page: Int, rows: Int, result: @escaping JSONResult) {
        let path = "/article/list.htm"
        let params = ["channelid": channelId,
                      "page": page,
                      "rows": rows] as [String : Any]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let list = JSON?["data"]
                let articleList = ArticleList.deserialize(from: list?.rawString())
                result(articleList)
            }
        }
    }
    
    
    /// 获取用户口罩配置信息
    class func getUserMaskConfig(result: @escaping JSONResult) {
        let path = "/member/getUserCfg.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = UserMaskConfig.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
        }
    }
    
    
    
    /// 通知列表
    class func getNotificationList(page: Int, rows: Int, result: @escaping JSONResult) {
        let path = "/member/noticeList.htm"
        let params = ["page": page,
        "rows": rows] as [String: Any]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = NotificationList.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
        }
    }

    /// 通知详情
    class func getNotificationDetail(id: String, result: @escaping JSONResult) {
        let path = "/member/noticeDetail.htm"
        let params = ["id": id] as [String: Any]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = NotificationItem.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
        }
    }
    
    ///aqi 历史数据
    /// type: 1 日  2 周  3 月  4 年
    class func getAQIHistoryData(type: Int, cityID: Int, result: @escaping JSONResult) {
        var path = ""
        switch type {
        case 1:
            path = "/aqi/getHourHistData.htm?cityid=\(cityID)"
            break
        case 2:
            path = "/aqi/getWeekHistData.htm?cityid=\(cityID)"
            break
        case 3:
            path = "/aqi/getMonthHistData.htm?cityid=\(cityID)"
            break
        case 4:
            path = "/aqi/getYearHistData.htm?cityid=\(cityID)"
            break
        default:
            break
        }
        
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                let data = AQIDataList.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
        }
    }
    
    ///分页查询城市 aqi
    class func getCityAQIHistotyData(page: Int, rows: Int, cityId: Int, result: @escaping JSONResult) {
        let path = "/aqi/getDayHistPage.htm"
        let params = ["cityid": cityId,
                      "page": page,
                      "rows": rows] as [String: Any]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                let data = CityAQIDataList.deserialize(from: JSON?["data"].rawString())
                result(data)
            }
        }
    }
    
    ///更新用户配置信息
    class func updateUserConfig(params: [String:String]) {
        let path = "/member/updateUserCfg.htm"
//        MBProgressHUD.showAdded(to: keyWindow!, animated: true)
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
//            MBProgressHUD.hide(for: keyWindow!, animated: true)
            if code != 0 {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    */
}
