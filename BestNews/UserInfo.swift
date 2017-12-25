//
//  UserInfo.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/19.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class UserInfo: HandyJSON {
    
    /*
     "birthday": "1990-09-10",
     "sex": "male",
     "height": 175,
     "weight": 51.5,
     "wxid": "demowxid",
     "headimg": "/upload/files/app/image/201708/70b7c978-9e3b-4258-9cf5-ead156462fb2.png",
     "name": "John",
     "mobile": "13123456789"*/
    
    var birthday: String = ""
    var sex: String = ""
    var height: CGFloat = 0
    var weight: CGFloat = 0
    var headimg: String = ""
    var name: String = ""
    var mobile: String = ""
    var wxid: String = ""
    ///是否实名认证
    var idproveflag: Bool = false
    var idname: String = ""
    var idnumber: String = ""
    ///是否vip
    var vipflag: Bool = false
    ///是否是名人
    var celebrityflag: Bool = false
    ///简介
    var intro: String = ""
    ///标签
    var tags: String = ""
    var wxinfo: String = ""
    var qqid: String = ""
    var qqinfo: String = ""
    /// 微博id
    var wbid: String = ""
    var wbinfo: String = ""
    
    func getWeight() -> CGFloat {
        if weight == 0 {
            if sex == "male" {
                return 60
            }
            else {
                return 45
            }
        }
        return weight
    }
    
    func getHeight() -> CGFloat {
        if height == 0 {
            if sex == "male" {
                return 180
            }
            else {
                return 165
            }
        }
        return height
    }
    
    required init () {}
    
    func updateUserInfo(result: @escaping (_ success: Bool, _ msg: String) -> ()) {
        let path = "/member/updateUserInfo.htm"
        let params = ["name": name,
                      "sex": sex,
                      "birthday": birthday,
                      "heading": headimg,
                      "wxid": wxid,
                      "height": height,
                      "weight": weight] as [String : Any]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                NotificationCenter.default.post(name: kUserInfoDidUpdateNotify, object: nil)
                result(true, msg)
            }
            else {
                result(false, msg)
            }
        }
    }
    
    ///更新用户信息
    func updateUserInfoWithParams(params: [String: String], result: @escaping (_ success: Bool, _ msg: String) -> ()) {
        let path = "/member/updateUserInfo.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
                NotificationCenter.default.post(name: kUserInfoDidUpdateNotify, object: nil)
                result(true, msg)
            }
            else {
                result(false, msg)
            }
        }
    }
}

class WXUserInfo: HandyJSON {
    var openid: String = ""
    var nickname: String = ""
    var sex = 1
    var province: String = ""
    var city: String = ""
    var country: String = ""
    var headimgurl: String = ""
    var unionid: String = ""
    
    required init() {}
    
    
    func updateUserInfo() {
        let params = ["name": nickname,
                      "wxid": openid,
                      "headimg": headimgurl]
        APIRequest.updateUserInfo(params: params) { (success) in
            
        }
    }
}

