//
//  LabelsContainerView.swift
//  BestNews
//
//  Created by Worthy on 2017/11/20.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class LabelsContainerView: UIView {

    var labels: [String.SubSequence] = []
    
    func updateUI(_ labels: [String.SubSequence]) {
        
        self.labels = labels
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        for i in 0..<labels.count {
            
            let label = String(labels[i])
            let w = label.getLabWidth(font: UIFont.systemFont(ofSize: 12), height: 18) + 20
            let h: CGFloat = 30
            if x + w > self.width {
                x = 0
                y = y + 40
            }
            let v = UILabel(frame: CGRect(x: x, y: y, width: w, height: h))
            v.backgroundColor = UIColor(hexString: "eeeeee")
            v.font = UIFont.systemFont(ofSize: 12)
            v.textColor = UIColor(hexString: "999999")
            v.text = label
            v.textAlignment = .center
            v.layer.cornerRadius = 15
            v.clipsToBounds = true
            self.addSubview(v)
            
            x = x + w + 10
        }
        y = y + 40
        self.height = y
        
    }

}
