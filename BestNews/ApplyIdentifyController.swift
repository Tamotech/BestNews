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
    }
    
    @IBAction func handleTapSubmit(_ sender: UIButton) {
        
        
        let name = nameField.text!
        let idcode = idCodeField.text!
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
    
    @objc func fieldValueChange(sender: UITextField) {
        if nameField.text!.count > 0 && idCodeField.text!.count > 0 {
            submitBtn.isEnabled = true
            submitBtn.backgroundColor = themeColor
        }
        else {
            submitBtn.isEnabled = false
            submitBtn.backgroundColor = gray229
        }
    }
    

}
