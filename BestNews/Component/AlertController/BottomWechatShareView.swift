//
//  BottomWechatShareView.swift
//  Summer
//
//  Created by 武淅 段 on 2017/7/30.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

protocol BottomShareViewDelegate: class {
    func didTapWechat()
    func didTapWechatCircle()
}

class BottomWechatShareView: BaseView {

    
    let containerHeight:CGFloat = 186
    
    weak var delegate: BottomShareViewDelegate?
    
    @IBOutlet weak var bottonConsttaint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
    }
    
    func show() {
        
        self.frame = UIScreen.main.bounds
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.bottonConsttaint.constant = 0
            self.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.layoutIfNeeded()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.bottonConsttaint.constant = -self.containerHeight
            self.backgroundColor = UIColor(white: 0, alpha: 0)
            self.layoutIfNeeded()

        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func handleTapWechatBtn(_ sender: Any) {
        self.dismiss()
        if self.delegate != nil {
            self.delegate!.didTapWechat()
        }
    }
    
    @IBAction func handleTapWechatCircleBtn(_ sender: Any) {
        self.dismiss()
        if self.delegate != nil {
            self.delegate!.didTapWechatCircle()
        }
    }
    
    @IBAction func handleCancelBtn(_ sender: Any) {
        self.dismiss()
    }

}
