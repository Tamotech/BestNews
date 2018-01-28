//
//  AppDelegate.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyJSON
import UserNotifications


let kFirstLoadApp = "firstLoadAppKey"
let umengAppKey = "5a6b6592b27b0a1c6200049d"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate, TencentSessionDelegate, OpenInstallDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if !UserDefaults.standard.bool(forKey: kFirstLoadApp) {
             UserDefaults.standard.set(true, forKey: kFirstLoadApp)
            window?.rootViewController = GuideViewController()
        }
        WXApi.registerApp(wxAppId)
        let tencent = TencentOAuth(appId: qqAppId, andDelegate: self)
        let permission = [kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        tencent?.incrAuth(withPermissions:permission)
        
        
        OpenInstallSDK.setAppKey("v2t7d4", withDelegate: self)
        OpenInstallSDK.reportRegister()
        
        IQKeyboardManager.sharedManager().enable = true
        
        UMConfigure.initWithAppkey(umengAppKey, channel: "App Store")
        UMErrorCatch.initErrorCatch()
        
        //注册推送
        if #available(iOS 10.0, *){
            let entiity = JPUSHRegisterEntity()
            entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
                UNAuthorizationOptions.badge.rawValue |
                UNAuthorizationOptions.sound.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        } else if #available(iOS 8.0, *) {
            let types = UIUserNotificationType.badge.rawValue |
                UIUserNotificationType.sound.rawValue |
                UIUserNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: types, categories: nil)
        }else {
            let type = UIRemoteNotificationType.badge.rawValue |
                UIRemoteNotificationType.sound.rawValue |
                UIRemoteNotificationType.alert.rawValue
            JPUSHService.register(forRemoteNotificationTypes: type, categories: nil)
        }
        
        JPUSHService.setup(withOption: launchOptions, appKey: jPushKey, channel: "app store", apsForProduction: true)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    //MARK: - Wechat
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.host!.contains("safepay") {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (resultDic) in
                print("支付宝支付结果.....> \(resultDic!)")
                let dic = JSON(resultDic!)
                if dic["resultStatus"].rawString() == "9000" {
                    NotificationCenter.default.post(name: kZhifubaoPaySuccessNotify, object: nil)
                }
                else {
                    NotificationCenter.default.post(name: kZhifubaoPayFailNotify, object: nil)
                }
            })
        }
        else if url.description.contains("tencent") {
            return TencentOAuth.handleOpen(url)
        }
        return WXApi.handleOpen(url, delegate: self)
    }
    
    func onReq(_ req: BaseReq!) {
        print(req)
    }
    
    func onResp(_ resp: BaseResp!) {
        print(resp)
        if resp is SendAuthResp {
            let send = resp as! SendAuthResp
            let info = ["code": send.code,
                        "state": send.state,
                        "country": send.country,
                        "lang": send.lang]
            NotificationCenter.default.post(name: kLoginWechatSuccessNotifi, object: info)
        }
        else if resp is PayResp {
            if resp.errCode == 0 {
                NotificationCenter.default.post(name: kWexinPaySuccessNotify, object: nil)
            }
            else if resp.errCode == -1 {
                NotificationCenter.default.post(name: kWexinPayFailNotify, object: nil)
            }
        }
    }
    
    //tencent 增量授权
    func tencentDidLogin() {
        
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func tencentNeedPerformReAuth(_ tencentOAuth: TencentOAuth!) -> Bool {
        return true
    }
    
    func tencentNeedPerformIncrAuth(_ tencentOAuth: TencentOAuth!, withPermissions permissions: [Any]!) -> Bool {
        return true
    }
    
    
    //遵守OpenInstallDelegate协议
    //通过OpenInstall 获取自定义参数，数据为空时也会回调此方法。渠道统计返回参数名称为openinstallChannelCode
    func getInstallParams(fromOpenInstall params: [AnyHashable : Any]!, withError error: Error!) {
        if error == nil {
//            print("OpenInstall 自定义数据：\(params.description)")
            if params != nil && !params.isEmpty {
                if let uid = params["uid"] {
                    SessionManager.sharedInstance.invitorUid = uid as? String
                }
            }
            else {
                print("OpenInstall error \(error)")
            }
        }
    }

    func getWakeUpParams(fromOpenInstall params: [AnyHashable : Any]!, withError error: Error!) {
       
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool{
        //判断是否通过OpenInstall生成的universal link唤起App
        if OpenInstallSDK.continue(userActivity){
            return true
        }
        else {
            //其他第三方唤醒回调；
            return true
        }
    }
    
    
    //MARK: - JPUSH Delegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
        if (SessionManager.sharedInstance.userId.count > 0) {
            //绑定别名
            JPUSHService.setAlias(SessionManager.sharedInstance.userId, completion: { (code, msg, i) in
                
            }, seq: 0)
            JPUSHService.setTags(Set.init(SessionManager.sharedInstance.pushTags), completion: { (code, set, i) in
                
            }, seq: 0)
            
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did Fail To Register For Remote Notifications With Error = \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        print(">JPUSHRegisterDelegate jpushNotificationCenter willPresent");
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNAuthorizationOptions.alert.rawValue))// 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        // 取得 APNs 标准信息内容
        let userInfo = response.notification.request.content.userInfo
        let aps = userInfo["aps"] as! [String:Any?]
        let content = aps["alert"] ?? ""
        let badge = aps["badge"] ?? ""
        
        //extra 信息
        
        
        print("content: \(String(describing: content)), badge: \(String(describing: badge))")
        
        
        print(">JPUSHRegisterDelegate jpushNotificationCenter didReceive");
        
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }

}


