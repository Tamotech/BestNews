//
//  LoginViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var phoneField: UITextField!

    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var thirdLoginView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldClearNavBar = true
        phoneField.delegate = self
        tipView.isHidden = true
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "close-light-gray"), style: .plain, target: self, action: #selector(handleTapClose(_:)))
        navigationItem.rightBarButtonItem = close
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = barLightGrayColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneField.becomeFirstResponder()
    }
    
    //MARK: - textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.validPhoneNum() {
            
            //验证手机号
            APIRequest.checkMobile(phone: newText, result: { [weak self](success) in
                if success {
                    DispatchQueue.main.async {
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
        else if newText.characters.count >= 11 {
            tipView.isHidden = false
        }
        else if newText.characters.count < 11 {
            tipView.isHidden = true
        }
        
        return true
    }
    
    //MARK: - actions
    func handleTapClose(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleTapWechat(_ sender: Any) {
        
    }
    
    @IBAction func handleTapQQ(_ sender: Any) {
        
    }
    
    @IBAction func handleTapWeibo(_ sender: Any) {
        
    }
}
