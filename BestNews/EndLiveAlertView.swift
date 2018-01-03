
//
//  EndLiveAlertView.swift
//  BestNews
//
//  Created by Worthy on 2018/1/3.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit

class EndLiveAlertView: BaseView {

    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    
    var actionCallback:ButtonActionCallback?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapBG))
        self.addGestureRecognizer(tap)
    }
    
    func show() {
        self.frame = UIScreen.main.bounds
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.containerBottom.constant = 0
            self.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerBottom.constant = -150
            self.layoutIfNeeded()
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    
    func handleTapBG() {
        dismiss()
    }
    
    @IBAction func tapend(_ sender: Any) {
        if self.actionCallback != nil {
            self.actionCallback!("End")
        }
        dismiss()
    }
    
    @IBAction func tapcancel(_ sender: Any) {
        if self.actionCallback != nil {
            self.actionCallback!("Cancel")
        }
        dismiss()
    }
    
}
