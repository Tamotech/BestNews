//
//  LoginCaptchaController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class LoginCaptchaController: BaseViewController, SwiftyVerificationCodeViewDelegate {

    @IBOutlet weak var captchaView: UIView!
    
    @IBOutlet weak var captchaImgView: UIImageView!
    
    lazy var codeView: SwiftyVerificationCodeView = {
        let wid = (self.captchaView.width-8*5)/4
        let v = SwiftyVerificationCodeView(frame: self.captchaView.bounds, num: 4, margin: 8, wid: wid, hei: 40)
        self.captchaView.addSubview(v)
        return v
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldClearNavBar = true
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "close-light-gray"), style: .plain, target: self, action: #selector(handleTapClose(_:)))
        navigationItem.rightBarButtonItem = close
        
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
        // 登陆逻辑
        let vc = LoginSMSCaptchaController(nibName: "LoginSMSCaptchaController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        codeView.cleanVerificationCodeView()
    }
    
    //MARK: - actions
    
    @IBAction func handleTapRefresh(_ sender: Any) {
        
    }
    
    func handleTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    

}
