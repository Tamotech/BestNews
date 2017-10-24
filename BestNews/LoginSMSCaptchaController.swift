//
//  LoginSMSCaptchaController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class LoginSMSCaptchaController: BaseViewController, SwiftyVerificationCodeViewDelegate {

    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var captchaView: UIView!
    
    @IBOutlet weak var loginBtn: UIButton!
    lazy var codeView: SwiftyVerificationCodeView = {
        let wid = (self.captchaView.width-16*5)/4
        let v = SwiftyVerificationCodeView(frame: self.captchaView.bounds, num: 4, margin: 16, wid: wid, hei: 40)
        self.captchaView.addSubview(v)
        return v
    }()
    
    //渐变层
    lazy var gLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = self.loginBtn.bounds
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = barLightGrayColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        codeView.delegate = self
    }
    
    
    //MARK: - vertificationView Delegate
    func verificationCodeDidFinishedInput(verificationCodeView: SwiftyVerificationCodeView, code: String) {
        loginBtnEnable(enable: true)
    }
    
    //MARK: - actions
    
    func handleTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleTapLogin(_ sender: Any) {
        
        let vc = SelectInterestItemController(nibName: "SelectInterestItemController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapResend(_ sender: Any) {
        
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
