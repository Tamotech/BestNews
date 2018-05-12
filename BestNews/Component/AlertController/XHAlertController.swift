//
//  XHAlertController.swift
//  BestNews
//
//  Created by Worthy on 2018/1/3.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import SnapKit


/// buttonType  0 确定  1 取消
typealias XHAlertActionCallback = (Int)->()

class XHAlertController: UIViewController {

    
    var tit = ""
    var msg = ""
    var callback: XHAlertActionCallback?
    
    /// 0  确认 取消   1  确认
    var style: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(hexString: "#000000", alpha: 0.2)
        let contentView = UIView(frame: CGRect.zero)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        self.view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(-20)
            make.width.equalTo(280)
        }
        
        let titleLb = UILabel(frame: CGRect.zero)
        titleLb.font = UIFont.boldSystemFont(ofSize: 18)
        titleLb.textColor = .black
        titleLb.textAlignment = .center
        contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(24)
        }
        
        let msgLb = UILabel(frame: CGRect.zero)
        msgLb.font = UIFont.systemFont(ofSize: 16)
        msgLb.textColor = UIColor(hexString: "#555555")
        msgLb.textAlignment = .center
        msgLb.numberOfLines = 0
        contentView.addSubview(msgLb)
        msgLb.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLb.snp.bottom).offset(15)
        }
        
        titleLb.text = tit
        msgLb.text = msg
        
        let cancelBtn = UIButton(type: UIButtonType.custom)
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.setTitleColor(UIColor.init(hexString: "#999999"), for: UIControlState.normal)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.backgroundColor = UIColor.init(hexString: "#eeeeee")
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        contentView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            if (self.style == 0) {
                make.left.equalTo(15)
                make.height.equalTo(42)
                make.top.equalTo(msgLb.snp.bottom).offset(15)
                make.bottom.equalTo(-15)
            }
            else {
                make.left.equalTo(15)
                make.height.equalTo(42)
                make.width.equalTo(0)
                make.top.equalTo(msgLb.snp.bottom).offset(15)
                make.bottom.equalTo(-15)
            }
        }
        
        let confirmBtn = UIButton(type: UIButtonType.custom)
        confirmBtn.layer.cornerRadius = 8
        confirmBtn.setTitleColor(UIColor.init(hexString: "#ffffff"), for: UIControlState.normal)
        confirmBtn.setTitle("确定", for: UIControlState.normal)
        confirmBtn.backgroundColor = themeColor!
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmBtn.shadowColor = themeColor!
        confirmBtn.shadowOffset = CGSize(width: 2, height: 8)
        confirmBtn.shadowRadius = 4
        confirmBtn.shadowOpacity = 0.3
        contentView.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            if self.style == 0 {
                make.right.equalTo(-15)
                make.height.equalTo(42)
                make.bottom.equalTo(-15)
                make.left.equalTo(cancelBtn.snp.right).offset(15)
                make.width.equalTo(cancelBtn.snp.width)
            }
            else {
                make.right.equalTo(-15)
                make.height.equalTo(42)
                make.bottom.equalTo(-15)
                make.left.equalTo(cancelBtn.snp.right).offset(0)
            }
        }
        
        cancelBtn.addTarget(self, action: #selector(tapCancel(_:)), for: UIControlEvents.touchUpInside)
        confirmBtn.addTarget(self, action: #selector(tapConfirm(_:)), for: UIControlEvents.touchUpInside)

    }

    func tapConfirm(_ sender: Any) {
        dismiss(animated: false) {
            if self.callback != nil {
                self.callback!(0)
            }
        }
    }
    
    func tapCancel(_ sender: Any) {
        dismiss(animated: false) {
            if self.callback != nil {
                self.callback!(1)
            }
        }
    }
    
    
}
