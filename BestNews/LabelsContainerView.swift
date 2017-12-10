//
//  LabelsContainerView.swift
//  BestNews
//
//  Created by Worthy on 2017/11/20.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias SelectLabelItemCallback = (String)->()

class LabelsContainerView: UIView {

    var labels: [Any] = []
    /// 0 默认  灰色背景不可点击  1 白色 可选中
    var style: Int = 0
    var selectCallback: SelectLabelItemCallback?
    
    func updateUI(_ labels: [Any]) {
        
        self.labels = labels
        initView()
    }
    
    func initView() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        for i in 0..<labels.count {
            
            let label = String(describing: labels[i])
            let w = label.getLabWidth(font: UIFont.systemFont(ofSize: 12), height: 18) + 20
            let h: CGFloat = 30
            if x + w > self.width {
                x = 0
                y = y + 40
            }
            let v = UIButton(frame: CGRect(x: x, y: y, width: w, height: h))
            
            v.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            if style == 0 {
                v.setTitleColor(UIColor(hexString: "999999"), for: .normal)
                v.borderWidth = 0
                v.backgroundColor = UIColor(hexString: "eeeeee")
                v.isEnabled = false
            }
            else {
                v.setTitleColor(UIColor(hexString: "333333"), for: .normal)
                v.borderWidth = 1
                v.borderColor = UIColor(hexString: "dddddd")!
                v.backgroundColor = .white
                v.isEnabled = true
                v.addTarget(self, action: #selector(handleSelectLabelItem(_:)), for: .touchUpInside)
                
            }
            v.setTitle(label, for: .normal)
            v.layer.cornerRadius = 15
            v.clipsToBounds = true
            self.addSubview(v)
            
            x = x + w + 10
        }
        y = y + 40
        self.height = y
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        for i in 0..<labels.count {
            
            let v = self.subviews[i] as! UIButton
            let label = String(describing: labels[i])
            let w = label.getLabWidth(font: UIFont.systemFont(ofSize: 12), height: 18) + 20
            let h: CGFloat = 30
            if x + w > self.width {
                x = 0
                y = y + 40
            }
            
            v.frame = CGRect(x: x, y: y, width: w, height: h)
            x = x + w + 10
        }
        y = y + 40
        self.height = y
        
    }

    
    @objc func handleSelectLabelItem(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.borderWidth = 0
            sender.setTitleColor(.white, for: .normal)
            sender.backgroundColor = themeColor
        }
        else {
            sender.borderWidth = 1
            sender.borderColor = UIColor(hexString: "dddddd")!
            sender.backgroundColor = .white
            sender.setTitleColor(UIColor(hexString: "333333"), for: .normal)
        }
        
        if self.selectCallback != nil {
            var tags: [String] = []
            for v in self.subviews {
                if v is UIButton {
                    let bt = v as! UIButton
                    if let title = bt.titleLabel?.text {
                        tags.append(title)
                    }
                    
                }
            }
            if tags.count > 0 {
                let tagstr = tags.joined(separator: ",")
                selectCallback!(tagstr)
            }
            else {
                selectCallback!("")
            }
        }
    }
}
