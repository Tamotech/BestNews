//
//  SessionManager.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/14.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

let kLoginInfo = "login_info_key"

struct LoginInfo {
    var phone: String = ""
    var wxid: String = ""
    var wxAccessToken: String = ""
    var captcha: String = ""
    var name: String = ""
    var age: String = ""
    var gender: String = ""
    var isLogin: Bool = false
    var avatarUrl: String = ""
    var birthday: String = ""
    var idfv: String = ""
    var type: Int = 0   // 0 默认手机号  1 微信  2 微博  3 qq
}


class SessionManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance: SessionManager = SessionManager()
    var loginInfo: LoginInfo = LoginInfo()
    
    var token:String = ""       //登录令牌
    var userId: String = ""     //用户 Id
    var userInfo: UserInfo?
    var wxUserInfo: WXUserInfo?
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()        ///定位
    ///推送tags
    var pushTags = ["system", "articlecomment", "articlereply", "articlecommentzan"]
    
    ///下载链接
    var downloadURL: String?
    
    var lock = NSLock()
    ///行业字典
    var tradeArr: [String] = []
    ///名人标签
    var famousTagArr: [String] = []
    ///名人申请 行业标签
    var famousTradeArr: [String] = []
    
    ///所有敏感词
    var sensitiveWords: [String] = []
    
    ///所有搜索热词
    var hotwords: [String] = []
    
    ///直播室聊天token
    var liveToken = ""
    
    /// 邀请者ID
    var invitorUid: String?
    
    var initRMFlag = false
    
    
    
    /// 1 日间模式   2 夜间模式
    var daynightModel = 1
    
    override init() {
        super.init()
        
//        self.openAndLocation()
        self.readLoginInfo()
        self.getTags()
        self.getAllSensitiveWords()
        self.getHotWords()
    }
    
    
    
    /// 登录
    ///
    /// - Parameters:
    ///   - type: 0 手机号 1 微信  2 微博  3 qq
    ///   - results: 结果
    func login(type: Int, results: @escaping(_ resultObject: JSON?, _ code: Int, _ msg: String) -> ()) {
        
        
        var params: [String: String] =
            ["mobile": self.loginInfo.phone,
             "captcha": self.loginInfo.captcha]
        if type == 1 {
            params["wxid"] = wxUserInfo?.openid ?? ""
            params["wxinfo"] = wxUserInfo?.nickname ?? ""
        }
        else if type == 3 {
            params["qqid"] = userInfo?.qqid ?? ""
            params["qqinfo"] = userInfo?.qqinfo ?? ""
        }
        
        APIManager.shareInstance.postRequest(urlString: "/login/login.htm", params: params, result: { [weak self](result, code, msg) in
            if code == 0 {
                let token = result?["memo"].string!
                self?.loginInfo.isLogin = true
                APIManager.shareInstance.headers["token"] = token
                self?.token = token!
                self?.userId = result?["id"].string ?? ""
                self?.saveLoginInfo()
                self?.getUserInfo()
                results(result, code, msg)
            }
            else {
                results(result, code, msg)
            }
            
        })
    }
    
    
    func regist(results: @escaping(_ resultObject: JSON?, _ code: Int, _ msg: String) -> ()) {
        var params: [String: Any] = ["mobile": loginInfo.phone,
                      "captcha": loginInfo.captcha,
                      "name": loginInfo.name,
                      "sex": loginInfo.gender,
                      "headimg": loginInfo.avatarUrl]
        if loginInfo.type == 1 {
            params["wxid"] = loginInfo.wxid
            params["wxinfo"] = wxUserInfo?.nickname ?? ""
        }
        else if loginInfo.type == 3 {
            params["qqid"] = userInfo?.qqid ?? ""
            params["wxinfo"] = userInfo?.qqinfo ?? ""
        }
        //邀请人id
        if self.invitorUid != nil {
            params["uid"] = invitorUid!
            params["channelCode"] = "1"
        }
        APIManager.shareInstance.postRequest(urlString: "/regist/mobileregist.htm", params: params) { [weak self](JSON, code, msg) in
            let token = JSON?["memo"].string!
            self?.token = token!
            self?.loginInfo.isLogin = true
            self?.userId = JSON?["id"].string ?? ""
            self?.saveLoginInfo()
            self?.getUserInfo()
            results(JSON, code, msg)
        }
    }
    
    ///获取用户信息
    func getUserInfo() {
        if loginInfo.isLogin {
            APIRequest.getUserInfoAPI { [weak self](result) in
                if result != nil {
                    self?.userInfo = result as? UserInfo
                    NotificationCenter.default.post(name: kUserInfoDidUpdateNotify, object: nil)
                }
            }
        }
    }
    
    ///登出
    func logoutCurrentUser() {
        self.token = ""
        self.loginInfo.isLogin = false
        self.loginInfo = LoginInfo()
        self.userInfo = nil
        APIManager.shareInstance.headers["token"] = ""
        UserDefaults.standard.removeObject(forKey: kLoginInfo)
        NotificationCenter.default.post(name: kUserInfoDidUpdateNotify, object: nil)
        NotificationCenter.default.post(name: kUserLoginStatusChangeNoti, object: nil)
        
    }
    
    
    
    //MARK: - private
    
    //保存登录信息到本地
    func saveLoginInfo() {
        let loginInfo = ["userId": userId,
                         "token": token]
        UserDefaults.standard.setValue(loginInfo, forKey: kLoginInfo)
    }
    
    func readLoginInfo() {
        let info = UserDefaults.standard.value(forKey: kLoginInfo) as? [String: String]
        if info != nil {
            token = info!["token"] ?? ""
            userId = info!["userId"] ?? ""
            if token.count > 0 {
                loginInfo.isLogin = true
            }
            
            if (userId.count > 0) {
                //绑定别名
                //JPUSHService.setTags(Set(["DefaultTag"]), aliasInbackground: userId)
            }
            
            APIManager.shareInstance.headers["token"] = self.token
            self.getUserInfo()
        }
    }
    
    //获取字典标签
    func getTags() {
        let path1 = "/config/getDict.htm?code=FIX_TRADE"
        APIManager.shareInstance.postRequest(urlString: path1, params: nil) {[weak self] (JSON, code, msg) in
            if code == 0 {
                if let arr = JSON!["data"].array {
                    self?.tradeArr.removeAll()
                    for a in arr {
                        self?.tradeArr.append(a["name"].rawString()!)
                    }
                }
            }
        }
        let path2 = "/config/getDict.htm?code=FIX_CELEBRITY_TAG"
        APIManager.shareInstance.postRequest(urlString: path2, params: nil) {[weak self] (JSON, code, msg) in
            if code == 0 {
                if let arr = JSON!["data"].array {
                    self?.famousTagArr.removeAll()
                    for a in arr {
                        self?.famousTagArr.append(a["name"].rawString()!)
                    }
                }
            }
        }
        let path3 = "/config/getDict.htm?code=FIX_CELEBRITY_TRADE"
        APIManager.shareInstance.postRequest(urlString: path3, params: nil) {[weak self] (JSON, code, msg) in
            if code == 0 {
                if let arr = JSON!["data"].array {
                    self?.famousTradeArr.removeAll()
                    for a in arr {
                        self?.famousTradeArr.append(a["name"].rawString()!)
                    }
                }
            }
        }
    }
    
    
    /// 开启并定位
    func openAndLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        print("---------->开始定位")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lock.lock()
        currentLocation = locations.last!
        lock.unlock()
        print("---------->获取最新位置")
    }
    
    
    
    /// 获取直播聊天室token
    func getChatroomToken(result: @escaping (_: String?, _: String?, _ success: Bool)->()) {
        let path = "/chatroom/getUserToken.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { [weak self](JSON, code, msg) in
            if code == 0 {
                self?.liveToken = JSON!["data"]["token"].rawString()!
                let userid = JSON!["data"]["userid"].rawString()!
                result(self?.liveToken, userid, true)
            }
            else {
                print("获取融云token失败.."+msg)
                result(nil, nil, false)
            }
        }
    }
    
    /// 创建聊天室
    func createChatroom(roomid: String, roomname: String,  result: @escaping (_: Bool)->()) {
        let path = "/chatroom/createChatRoom.htm"
        let params = ["roomid": roomid,
                      "roomname": roomname]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { (JSON, code, msg) in
            if code == 0 {
//                let roomid = JSON!["data"]["roomid"].rawString()!
//                let roomname = JSON!["data"]["roomname"].rawString()!
                result(true)
            }
            else {
                print("创建聊天室失败.."+msg)
                result(false)
            }
        }
    }
    
    //所有敏感词
    func getAllSensitiveWords() {
        let path  = "/config/getSensitiveWrod.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { [weak self](JSON, code, msg) in
            if code == 0 {
                let words = JSON!["data"].rawValue as! [String]
                self?.sensitiveWords = words
            }
            else {
                self?.getAllSensitiveWords()
            }
        }
    }
    
    //搜索热词
    func getHotWords() {
        let path = "/search/getHotKeyword.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { [weak self](JSON, code, msg) in
            if code == 0 {
                let words = JSON!["data"].rawValue as! [String]
                self?.hotwords = words
            }
            else {
                self?.getHotWords()
            }
        }
    }
    
    
    //获取下载地址
    func getDownloadURL() {
        APIRequest.getUserConfig(codes: "u_app_download_ios") { [weak self](JSONData) in
            let data = JSONData as! JSON
            let urlStr = data["u_app_download_ios"]["v"].stringValue
            self?.downloadURL = urlStr
            
        }
    }
    
}
