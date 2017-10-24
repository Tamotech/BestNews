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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shouldClearNavBar = true
        phoneField.delegate = self
        let close = UIBarButtonItem(image: #imageLiteral(resourceName: "close-light-gray"), style: .plain, target: self, action: #selector(handleTapClose(_:)))
        navigationItem.rightBarButtonItem = close
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = barLightGrayColor
    }
    
    //MARK: - textfield delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.validPhoneNum() {
            //自动到下一步
            let vc = LoginCaptchaController(nibName: "LoginCaptchaController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
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
