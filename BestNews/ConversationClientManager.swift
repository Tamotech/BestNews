//
//  ConversationClientManager.swift
//  BestNews
//
//  Created by Worthy on 2017/12/16.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit


protocol ConversationDelegate: class {
    func finishConnectSDK(success: Bool)
}

let liveStreamKey = "xhfm2017m"

class ConversationClientManager: NSObject {

    static let shareInstanse = ConversationClientManager()
    var userId = ""
    var token = ""
    var finishConnectRMSDK = false
    
    weak var delegate: ConversationDelegate?
    
    override init() {
        super.init()
        self.initSDK()
    }
    
    
    
    /// 计算鉴权后的地址
    ///
    /// - Parameter url: url /AppName/StreamName
    class func addAuthorKey(url: String) -> String {
        ///有效期3天
        let now = Int(Date().timeIntervalSince1970)+259200
        let url = "\(url)-\(now)-0-0-\(liveStreamKey)"
        let md5 = url.md5String()
        let newStr = "\(now)-0-0-\(md5)"
        return newStr
    }
    
//    func initSDK() {
//
//        RCIMClient.shared().initWithAppKey("k51hidwqknfrb")
//        SessionManager.sharedInstance.initRMFlag = true
//        SessionManager.sharedInstance.getChatroomToken {
//            [weak self](token, userid, success) in
//            if success {
//                self?.token = token!
//                self?.userId = userid!
//                print("token---\(token!), userid----\(userid!)")
//                RCIMClient.shared().connect(withToken: token!, success: { (id) in
//                    print("登陆成功!")
//                    self?.finishConnectRMSDK = true
//                    //设置用户信息
//                    let userInfo = RCUserInfo(userId: userid!, name: SessionManager.sharedInstance.userInfo!.name, portrait: SessionManager.sharedInstance.userInfo!.headimg)
//                    RCIMClient.shared().currentUserInfo = userInfo
//                    if self?.delegate != nil {
//                        self!.delegate!.finishConnectSDK(success: true)
//                    }
//                }, error: { (errCode) in
//                    print("错误码: \(errCode)")
//                }, tokenIncorrect: {
//                    print("token错误")
//                })
//
//            }
//            else {
//                BLHUDBarManager.showError(msg: "获取token失败")
//            }
//        }
//    }
    
    
    func initSDK() {
        
        RCIM.shared().initWithAppKey("k51hidwqknfrb")
        SessionManager.sharedInstance.initRMFlag = true
        SessionManager.sharedInstance.getChatroomToken {
            [weak self](token, userid, success) in
            if success {
                self?.token = token!
                self?.userId = userid!
                print("token---\(token!), userid----\(userid!)")
                
                RCIM.shared().connect(withToken: token!, success: { (id) in
                    print("登陆成功!")
                    self?.finishConnectRMSDK = true
                    //设置用户信息
                    let userInfo = RCUserInfo(userId: userid!, name: SessionManager.sharedInstance.userInfo!.name, portrait: SessionManager.sharedInstance.userInfo!.headimg)
                    RCIM.shared().currentUserInfo = userInfo
                    RCIM.shared().enableMessageAttachUserInfo = true
                    if self?.delegate != nil {
                        self!.delegate!.finishConnectSDK(success: true)
                    }
                }, error: { (errCode) in
                    print("错误码: \(errCode)")
                }, tokenIncorrect: {
                    print("token错误")
                })
                
            }
            else {
                BLHUDBarManager.showError(msg: "获取token失败")
            }
        }
    }
    
}
