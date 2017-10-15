//
//  BaseSegmentControl.swift
//  Summer
//
//  Created by 武淅 段 on 2017/7/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias SelectSegmentIndexCallback = (Int, String) -> ()
class BaseSegmentControl: UIView {
    
    
    var buttons: [UIButton] = []
    var currentIndex: Int = 0
    var line = UIView()
    var selectItemAction: SelectSegmentIndexCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(items: [String], defaultIndex: Int) {
        self.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        
        let width = screenWidth/CGFloat(items.count)
        var maxTitleWidth:CGFloat = 0
        var fontSize:CGFloat = 18
        if items.count <= 3 {
            fontSize = 18
        }
        else if items.count > 3 && items.count <= 5 {
            fontSize = 16
        }
        else if items.count > 5 {
            fontSize = 14
        }
        for i in 0..<items.count {
            
            let x = CGFloat(i)*width
            let btn = UIButton(frame: CGRect(x: x, y: 0, width: width, height: self.height))
            btn.tag = i
            btn.addTarget(self, action: #selector(handleSelectItem(btn:)), for: .touchUpInside)
            if i == defaultIndex {
                btn.setTitleColor(themeColor, for: .normal)
            }
            else {
                btn.setTitleColor(gray155, for: .normal)
            }
            btn.setTitle(items[i], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
            btn.titleLabel?.sizeToFit()
            if btn.titleLabel!.width > maxTitleWidth {
                maxTitleWidth = btn.titleLabel!.width
            }
            self.addSubview(btn)
            buttons.append(btn)
        }
        
        line.frame = CGRect(x: 0, y: self.height-2, width: maxTitleWidth, height: 2)
        line.centerX = (CGFloat(currentIndex)+0.5)*(screenWidth/CGFloat(buttons.count))
        line.backgroundColor = themeColor
        line.layer.cornerRadius = 1
        line.clipsToBounds = true
        self.addSubview(line)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleSelectItem(btn:UIButton) {
        
        if (self.selectItemAction != nil) {
            self.selectItemAction!(btn.tag, btn.titleLabel!.text!)
        }
        
        currentIndex = btn.tag
        let centerX = (CGFloat(currentIndex)+0.5)*(screenWidth/CGFloat(buttons.count))
        UIView.animate(withDuration: 0.3) {
            self.line.centerX = centerX
            btn.setTitleColor(themeColor, for: .normal)
        }
        for b in self.buttons {
            if (b != btn) {
                b.setTitleColor(gray155, for: .normal)
            }
        }
    }
}

