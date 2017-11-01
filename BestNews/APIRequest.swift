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
                else {
                    
                }
            }
        }
    }
    
    
}
