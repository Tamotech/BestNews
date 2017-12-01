//
//  SubscribeButton.swift
//  BestNews
//
//  Created by Worthy on 2017/11/28.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class SubscribeButton: UIButton {

    override func awakeFromNib() {
        
        layer.cornerRadius = 4
        switchStateSub(false)
    }

    func switchStateSub(_ isSub: Bool) {
        if isSub {
            backgroundColor = UIColor.clear
            layer.borderWidth = 1
            layer.borderColor = gray146?.cgColor
            layer.shadowOpacity = 0
            setTitle("已订阅", for: .normal)
            setTitleColor(gray72, for: .normal)
        }
        else {
            setTitleColor(UIColor.white, for: .normal)
            setTitle("订阅", for: .normal)
            backgroundColor = themeColor
            layer.borderWidth = 0
            layer.shadowOffset = CGSize(width: 0, height: 2)
            layer.shadowRadius = 3
            layer.shadowColor = themeColor?.cgColor
            shadowOpacity = 0.3
        }
    }
    
    
}
