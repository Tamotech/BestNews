//
//  ApplyIdentifyController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/9.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ApplyIdentifyController: BaseViewController {

    @IBOutlet weak var nameLb: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var idCodeField: UITextField!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var verifyBtn: UIButton!
    
    @IBOutlet weak var vrcodeField: UITextField!
    
    var seconds: Int = 60
    
    var timer: Timer?
    
    var smsCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showCustomTitle(title: "实名认证")
        if let user = SessionManager.sharedInstance.userInfo {
            nameLb.text = user.name
            phoneField.text = user.mobile
            phoneField.isEnabled = false
        }
        nameField.addTarget(self, action: #selector(fieldValueChange(sender:)), for: UIControlEvents.editingChanged)
        idCodeField.addTarget(self, action: #selector(fieldValueChange(sender:)), for: UIControlEvents.editingChanged)
        vrcodeField.addTarget(self, action: #selector(fieldValueChange(sender:)), for: UIControlEvents.editingChanged)
    }
    
    
    func timerEvent(_ t: Timer) {
        seconds = seconds - 1
        if seconds <= 0 {
            t.invalidate()
            seconds = 60
            verifyBtn.backgroundColor = themeColor
            verifyBtn.setTitle("发送验证码", for: UIControlState.normal)
            verifyBtn.backgroundColor = themeColor
            verifyBtn.setTitleColor(.white, for: UIControlState.normal)
            verifyBtn.isEnabled = true
        }
        else {
            verifyBtn.isEnabled = false
            verifyBtn.setTitle("\(seconds)", for: UIControlState.normal)
            verifyBtn.backgroundColor = UIColor(hexString: "#EEEEEE")
            verifyBtn.setTitleColor(UIColor.init(hexString: "#999999"), for: UIControlState.normal)
        }
    }
    
    func sendSMSCode() {
        let ph = SessionManager.sharedInstance.userInfo!.mobile
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        timer!.fire()
        APIRequest.sendSMSCode(phone: ph) { [weak self](success, sms) in
            if success {
                self?.smsCode = sms
                
                ///自动填充
                if ph == "15721261417" {
                    self?.vrcodeField.text = sms
                }
                if self!.nameField.text!.count > 0
                    && self!.idCodeField.text!.count > 0
                    && self!.vrcodeField.text!.count > 0 {
                    self?.submitBtn.isEnabled = true
                    self?.submitBtn.backgroundColor = themeColor
                }
                else {
                    self?.submitBtn.isEnabled = false
                    self?.submitBtn.backgroundColor = gray229
                }
                
            }
        }
    }
    
    
    @IBAction func handleTapSubmit(_ sender: UIButton) {
        
        
        let name = nameField.text!
        let idcode = idCodeField.text!
        let vrcode = vrcodeField.text!
        if vrcode != smsCode {
            BLHUDBarManager.showError(msg: "验证码错误")
            return
        }
        APIRequest.applyIdentiify(idname: name, idCode: idcode) { [weak self](success) in
            if success {
                SessionManager.sharedInstance.getUserInfo()
                DispatchQueue.main.async {
                    let alert = ApplyIdentifySuccessAlertController(nibName: "ApplyIdentifySuccessAlertController", bundle: nil)
                    self?.customPresentViewController(self!.presentr, viewController: alert, animated: false, completion: {
                        
                    })
                    alert.completeCallback = {
                        [weak self] in
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func handleTapSendCodeBtn(_ sender: UIButton) {
        
        sendSMSCode()
    }
    
    @objc func fieldValueChange(sender: UITextField) {
        if nameField.text!.count > 0 && idCodeField.text!.count > 0 && vrcodeField.text!.count > 0 {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = themeColor
        }
        else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = gray229
        }
    }
    

}
