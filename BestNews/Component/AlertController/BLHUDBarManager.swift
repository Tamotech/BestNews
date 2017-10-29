//
//  BLHUDBarManager.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import PopupDialog

/// 弹窗样式
class BLHUDBarManager: NSObject {

    static let instance = BLHUDBarManager()
    
    
    
    class func showSuccess(msg: String?, seconds: TimeInterval) {
        
        
        let simpleHUD = SimpleHUDController(nibName: "SimpleHUDController", bundle: nil)
        guard let vc = Toolkit.getCurrentViewController() else {
            return
        }
        simpleHUD.modalPresentationStyle = .overCurrentContext
        vc.present(simpleHUD, animated: false) {
            simpleHUD.msgLabel.text = msg
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+seconds, execute: { 
                vc.dismiss(animated: false, completion: nil)
            })
        }
        
    }
    
    class func showError(msg: String?) {
        
        let simpleHUD = SimpleHUDController(nibName: "SimpleHUDController", bundle: nil)
        
        guard let vc = Toolkit.getCurrentViewController() else {
            return
        }
        simpleHUD.modalPresentationStyle = .overCurrentContext
        vc.present(simpleHUD, animated: false) {
            simpleHUD.setupView(img: #imageLiteral(resourceName: "fail-white"), title: msg)
            let seconds: TimeInterval = 2
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+seconds, execute: {
                vc.dismiss(animated: false, completion: nil)
            })
        }
        
    }
    
    class func showErrorWithClose(msg: String?, descTitle: String) {
        let alert = BaseAlertView.instanceFromXib() as! BaseAlertView
        alert.setupView(msg: msg, img: #imageLiteral(resourceName: "fail-white"), actionTitle: descTitle, needClose: true)
        alert.show(autodismiss: false, transparent: false)
    }
    
    
    
}
