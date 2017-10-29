//
//  LoginCaptchaController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class LoginCaptchaController: BaseViewController, SwiftyVerificationCodeViewDelegate {

    @IBOutlet weak var captchaView: UIView!
    
    @IBOutlet weak var captchaImgView: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    lazy var codeView: SwiftyVerificationCodeView = {
        let wid = (self.captchaView.width-8*5)/4
        let v = SwiftyVerificationCodeView(frame: self.captchaView.bounds, num: 4, margin: 8, wid: wid, hei: 40)
        self.captchaView.addSubview(v)
        return v
    }()
    
    
    
    var phone: String?
    ///图形验证码
    var captchaCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldClearNavBar = true
        tipView.isHidden = true
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "close-light-gray"), style: .plain, target: self, action: #selector(handleTapClose(_:)))
        navigationItem.rightBarButtonItem = close
        loadCaptcha()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = barLightGrayColor
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        codeView.delegate = self
    }
    
    
    func loadCaptcha() {
        APIRequest.getPhotoCaptcha { [weak self](success, imgUrl, captchaCode) in
            if success {
                self?.captchaCode = captchaCode
                let rc = ImageResource(downloadURL: URL(string: imgUrl!)!)
                self?.captchaImgView.kf.setImage(with: rc)
            }
        }
    }
    
    //MARK: - vertificationView Delegate
    func verificationCodeDidFinishedInput(verificationCodeView: SwiftyVerificationCodeView, code: String) {
        // 登陆逻辑
        
        if captchaCode != nil && code.uppercased() == captchaCode?.uppercased() {
            tipView.isHidden = true
            let vc = LoginSMSCaptchaController(nibName: "LoginSMSCaptchaController", bundle: nil)
            vc.phone = phone
            navigationController?.pushViewController(vc, animated: true)
            codeView.cleanVerificationCodeView()
        }
        else {
            codeView.cleanVerificationCodeView()
            tipView.isHidden = false
            
        }
        
    }
    
    //MARK: - actions
    
    @IBAction func handleTapRefresh(_ sender: Any) {
        self.loadCaptcha()
    }
    
    func handleTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    

}
