//
//  LoginViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher
import WatchKit

class LoginViewController: BaseViewController, UITextFieldDelegate, TencentSessionDelegate {
    
    

    @IBOutlet weak var phoneField: UITextField!

    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var thirdLoginView: UIView!
    
    @IBOutlet weak var avartarInfoView: UIView!
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var nickNameLb: UILabel!
    
    var tencentOth: TencentOAuth?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldClearNavBar = true
        avartarInfoView.isHidden = true
        
        if !UIApplication.shared.canOpenURL(URL(string:"wechat://")!) {
            thirdLoginView.isHidden = true
        }
        else {
            thirdLoginView.isHidden = false
        }
        phoneField.delegate = self
        tipView.isHidden = true
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "close-light-gray"), style: .plain, target: self, action: #selector(handleTapClose(_:)))
        navigationItem.rightBarButtonItem = close
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLoginWechatSuccessNoti(noti:)), name: kLoginWechatSuccessNotifi, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = barLightGrayColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    
    
    //MARK: - notification
    
    func receiveLoginWechatSuccessNoti(noti: Notification) {
        let info = JSON(noti.object ?? [])
        let code = info["code"]
        let state = info["state"]
        self.pleaseWait()
        if state == "wechat_sdk_login_demo" {
            let url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(wxAppId)&secret=\(wxSecretKey)&code=\(code)&grant_type=authorization_code"
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                if let value = response.result.value {
                    let jsonDic = JSON(value)
                    //                    print(jsonDic)
                    let accessToken = jsonDic["access_token"].string
                    //                    let expires = jsonDic["expires_in"].int
                    guard let openid = jsonDic["openid"].string else {
                        return
                    }
                    SessionManager.sharedInstance.loginInfo.wxid = openid
                    SessionManager.sharedInstance.loginInfo.wxAccessToken = accessToken!
                    
                    ///获取个人信息
                    APIRequest.getWXUserInfo(accessToken: accessToken!, openId: openid, result: { (userInfo) in
                        let wxInfo =  userInfo as? WXUserInfo
                        SessionManager.sharedInstance.wxUserInfo = wxInfo
                        SessionManager.sharedInstance.loginInfo.type = 1
                        SessionManager.sharedInstance.loginInfo.name = wxInfo!.nickname
                        SessionManager.sharedInstance.loginInfo.avatarUrl = wxInfo!.headimgurl
                        //尝试用 wxid 登录
                        SessionManager.sharedInstance.login(type: 1, results: { [weak self](json, code, msg) in
                            self?.clearAllNotice()
                            if code == 0 {
                                //成功
                                wxInfo?.updateUserInfo()
                                self?.phoneField.resignFirstResponder()
                                NotificationCenter.default.post(name: kUserLoginStatusChangeNoti, object: nil)
                                DispatchQueue.main.async {
                                    //自动到下一步
                                   
                                    self?.navigationController?.dismiss(animated: true, completion: {})
                                    
                                    
                                }
                            }
                            else if code == -132 || code == -133 || code == -134 {
                                //去绑定手机号登录
                                self?.avartarInfoView.isHidden = false
                                self?.thirdLoginView.isHidden = true
                                let rc = ImageResource(downloadURL: URL(string: wxInfo!.headimgurl)!)
                                self?.avatarImg.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                                self?.nickNameLb.text = wxInfo?.nickname
                                
                            }
                            
                        })
                    })
                }
            })
        }
        
    }
    
    //MARK: - textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.validPhoneNum() {
            
            //验证手机号
            self.view.pleaseWait()
            APIRequest.checkMobile(phone: newText, result: { [weak self](success) in
                if success {
                    DispatchQueue.main.async {
                        self?.view.clearAllNotice()
                        //自动到下一步
                        self?.tipView.isHidden = true
                        let vc = LoginCaptchaController(nibName: "LoginCaptchaController", bundle: nil)
                        vc.phone = newText
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                else {
                    self?.tipView.isHidden = false
                }
            })
        }
        else if newText.count > 11 {
            tipView.isHidden = false
        }
        else if newText.count <= 11 {
            tipView.isHidden = true
        }
        
        return true
    }
    
    //MARK: - actions
    func handleTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleTapWechat(_ sender: Any) {
        let req = SendAuthReq()
        req.scope = "snsapi_userinfo"
        req.state = "wechat_sdk_login_demo"
        WXApi.send(req)
    }
    
    @IBAction func handleTapQQ(_ sender: Any) {
        tencentOth = TencentOAuth(appId: qqAppId, andDelegate: self)
        let permission = [kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
        tencentOth?.authorize(permission, inSafari: false)
    }
    
    @IBAction func handleTapWeibo(_ sender: Any) {
        
    }
    
    
    //MARK: - Tencent session
    
    func tencentDidLogin() {
//        let acessToken = tencentOth!.accessToken
        let openid = tencentOth!.openId
        tencentOth?.getUserInfo()
        SessionManager.sharedInstance.userInfo = UserInfo()
        SessionManager.sharedInstance.loginInfo.type = 3
        SessionManager.sharedInstance.userInfo?.qqid = openid!
        SessionManager.sharedInstance.userInfo?.qqinfo = tencentOth?.getUserOpenID() ?? ""
        
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        
    }
    
    func tencentDidNotNetWork() {
        
    }
    
    func tencentFailedUpdate(_ reason: UpdateFailType) {
        
    }
    
    func tencentDidUpdate(_ tencentOAuth: TencentOAuth!) {
        
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        if response.retCode == URLREQUEST_SUCCEED.rawValue {

            print("qq用户信息获取完毕...>")
            print(response.jsonResponse)
            let user = JSON(response.jsonResponse)
            let nickname = user["nickname"].rawString()
            let url = user["figureurl_qq_2"].rawString()
            if url != nil {
                let rc = ImageResource(downloadURL: URL(string: url!)!)
                SessionManager.sharedInstance.userInfo?.headimg = url!
                SessionManager.sharedInstance.userInfo?.name = nickname!
                self.avatarImg.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            self.nickNameLb.text = nickname
            
            //尝试用 qq 登录
            SessionManager.sharedInstance.userInfo?.qqinfo = nickname!
            self.pleaseWait()
            SessionManager.sharedInstance.login(type: 3, results: { [weak self](json, code, msg) in
                self?.clearAllNotice()
                if code == 0 {
                    //成功
                    SessionManager.sharedInstance.userInfo?.updateUserInfo(result: { (success, msg) in
                        
                    })
                    self?.phoneField.resignFirstResponder()
                    NotificationCenter.default.post(name: kUserLoginStatusChangeNoti, object: nil)
                    DispatchQueue.main.async {
                        //自动到下一步
                        
                        self?.navigationController?.dismiss(animated: true, completion: {})
                        
                        
                    }
                }
                else if code == -114 || code == -130 || code == -132 || code == -133 || code == -134 {
                    //去绑定手机号登录
                    self?.avartarInfoView.isHidden = false
                    self?.thirdLoginView.isHidden = true
                    
                    
                }
                
            })
        }
    }
}
