//
//  LoginSMSCaptchaController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class LoginSMSCaptchaController: BaseViewController, SwiftyVerificationCodeViewDelegate {

    let showSelectChannelKey = "showSelectChannelBoolKey"
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var captchaView: UIView!
    
    var phone: String?
    var smsCode: String?
    
    @IBOutlet weak var loginBtn: UIButton!
    lazy var codeView: SwiftyVerificationCodeView = {
        let wid = (self.captchaView.width-16*5)/4
        let v = SwiftyVerificationCodeView(frame: CGRect.init(x: 0, y: 0, width: screenWidth-50, height: 40), num: 4, margin: 16, wid: wid, hei: 40)
        v.type = 1
        self.captchaView.addSubview(v)
        return v
    }()
    
    //渐变层
    lazy var gLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect.init(x: 0, y: 0, width: screenWidth-50, height: 49)
        layer.colors = [UIColor.init(ri: 22, gi: 198, bi: 255, alpha: 1)!.cgColor, UIColor.init(ri: 0, gi: 114, bi: 255, alpha: 1)!.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.cornerRadius = 8
        self.loginBtn.layer.addSublayer(layer)
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldClearNavBar = true
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "close-light-gray"), style: .plain, target: self, action: #selector(handleTapClose(_:)))
        navigationItem.rightBarButtonItem = close
        loginBtnEnable(enable: false)
        phoneLabel.text = phone
        sendSMSCode()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = barLightGrayColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        codeView.delegate = self
    }
    
    
    func sendSMSCode() {
        guard let ph = self.phone else {
            return
        }
        APIRequest.sendSMSCode(phone: ph) { [weak self](success, sms) in
            if success {
                self?.smsCode = sms
                
                ///自动填充
                if ph == "15721261417" {
                    self?.codeView.setText(text: sms!)
                }
                self?.loginBtnEnable(enable: true)
                SessionManager.sharedInstance.loginInfo.phone = ph
                SessionManager.sharedInstance.loginInfo.captcha = sms!
            }
        }
    }
    
    //MARK: - vertificationView Delegate
    func verificationCodeDidFinishedInput(verificationCodeView: SwiftyVerificationCodeView, code: String) {
        
        if smsCode != nil && smsCode == code {
            
            SessionManager.sharedInstance.loginInfo.phone = phone!
            SessionManager.sharedInstance.loginInfo.captcha = code
            loginBtnEnable(enable: true)
        }
        else {
            verificationCodeView.cleanVerificationCodeView()
            BLHUDBarManager.showError(msg: "验证码错误")
        }
    }
    
    //MARK: - actions
    
    @objc func handleTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleTapLogin(_ sender: Any?) {
        
        let type = SessionManager.sharedInstance.loginInfo.type
        SessionManager.sharedInstance.login(type: type) { [weak self](JSON, code, msg) in
            if code == 0 {
                
                if !UserDefaults.standard.bool(forKey: self!.showSelectChannelKey) {
                    let vc = SelectInterestItemController(nibName: "SelectInterestItemController", bundle: nil)
                    self?.navigationController?.pushViewController(vc, animated: true)
                    BLHUDBarManager.showSuccess(msg: "登录成功", seconds: 2)
                    UserDefaults.standard.set(true, forKey: self!.showSelectChannelKey)
                    UserDefaults.standard.synchronize()
                }
                else {
                    self?.navigationController?.dismiss(animated: true, completion: nil)
                }
            }
            else if code == -114{
                //未注册
                SessionManager.sharedInstance.regist(results: { (JSON1, code1, msg1) in
                    if code1 == 0 {
//                        self?.handleTapLogin(nil)
                        
                        if !UserDefaults.standard.bool(forKey: self!.showSelectChannelKey) {
                            let vc = SelectInterestItemController(nibName: "SelectInterestItemController", bundle: nil)
                            self?.navigationController?.pushViewController(vc, animated: true)
                            BLHUDBarManager.showSuccess(msg: "登录成功", seconds: 2)
                            UserDefaults.standard.set(true, forKey: self!.showSelectChannelKey)
                            UserDefaults.standard.synchronize()
                        }
                        else {
                            self?.navigationController?.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                    else {
                        BLHUDBarManager.showError(msg: msg1)
                    }
                })
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    @IBAction func handleTapResend(_ sender: Any) {
        sendSMSCode()
        BLHUDBarManager.showSuccess(msg: "验证码已发送", seconds: 1)
        codeView.cleanVerificationCodeView()
    }
    
    @IBAction func handleTapProtocol(_ sender: Any) {
        
    }
    
    
    //MARK: - private
    func loginBtnEnable(enable: Bool) {
        loginBtn.isEnabled = enable
        if enable {
            gLayer.isHidden = false
            loginBtn.setTitleColor(UIColor.white, for: .normal)
            loginBtn.layer.shadowColor = themeColor?.cgColor
            loginBtn.layer.shadowOffset = CGSize(width: 0, height: 5)
            loginBtn.layer.shadowRadius = 10
            loginBtn.layer.shadowOpacity = 0.3
        }
        else {
            gLayer.isHidden = true
            loginBtn.layer.shadowOpacity = 0
            loginBtn.backgroundColor = UIColor(ri: 229, gi: 229, bi: 229)
        }
    }
    
}
