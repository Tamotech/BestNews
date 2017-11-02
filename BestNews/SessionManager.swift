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
    var lock = NSLock()
    
    override init() {
        super.init()
        
//        self.openAndLocation()
        self.readLoginInfo()
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
            params["wxinfo"] = wxUserInfo?.unionid ?? ""
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
        if loginInfo.wxid.characters.count > 0 {
            params["wxid"] = loginInfo.wxid
        }
        APIManager.shareInstance.postRequest(urlString: "/regist/mobileregist.htm", params: params) { [weak self](JSON, code, msg) in
            let token = JSON?["memo"].string!
            self?.token = token!
            self?.loginInfo.isLogin = true
            results(JSON, code, msg)
            self?.getUserInfo()
        }
    }
    
    func getUserInfo() {
//        APIRequest.getUserInfoAPI { [weak self](result) in
//            if result != nil {
//                self?.userInfo = result as? UserInfo
//                NotificationCenter.default.post(name: kUserInfoDidUpdateNotify, object: nil)
//            }
//        }
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
            if token.characters.count > 0 {
                loginInfo.isLogin = true
            }
            
            if (userId.characters.count > 0) {
                //绑定别名
                //JPUSHService.setTags(Set(["DefaultTag"]), aliasInbackground: userId)
            }
            
            APIManager.shareInstance.headers["token"] = self.token
            self.getUserInfo()
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
    
}
