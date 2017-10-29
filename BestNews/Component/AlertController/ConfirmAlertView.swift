//
//  ConfirmAlertView.swift
//  Summer
//
//  Created by 武淅 段 on 2017/7/30.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias confirmAlertActionCallback = ()->()

class ConfirmAlertView: BaseView {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    var confirmCalback:confirmAlertActionCallback?
    var cancelCalback:confirmAlertActionCallback?
    
    public func show() {
        keyWindow?.addSubview(self)
        self.frame = keyWindow?.bounds ?? CGRect.zero
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapCancelBtn(_:)))
        self.addGestureRecognizer(tap)
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }

    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        if self.cancelCalback != nil {
            self.cancelCalback!()
        }
        self.dismiss()
    }
    
    @IBAction func handleTapConfirmBtn(_ sender: UIButton) {
        if self.confirmCalback != nil {
            self.confirmCalback!()
        }
        self.dismiss()
    }
    
    
}
