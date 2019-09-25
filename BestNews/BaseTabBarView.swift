//
//  BaseTabBarView.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias SelectTabItemAction = (Int) -> ()

class BaseTabBarView: BaseView {

    
    @IBOutlet var tabIcons: [UIImageView]!
   
    @IBOutlet var tabItemLabels: [UILabel]!
    
    var selectItemAction: SelectTabItemAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.height = 49 + bottomGuideHeight
        switchToIndex(index: 0)
    }
    
    func switchToIndex(index: Int) {
        for (i,icon) in tabIcons.enumerated() {
            
            var name = "tab\(i+1)On"
            var color = themeColor
            if SessionManager.isWithinCountrysDay() {
                name = "\(name)_red"
                color = flagRed
            }
            if i == index {
                icon.image = UIImage(named: name)
                 tabItemLabels[i].textColor = color
            }
            else {
                icon.image = UIImage(named: "tab\(i+1)Off")
                tabItemLabels[i].textColor = gray146
            }
        }
        
        if selectItemAction != nil {
            selectItemAction!(index)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point = touch?.location(in: self)
        let width = screenWidth/CGFloat(tabIcons.count)
        let index = Int(point!.x / width)
        switchToIndex(index: index)
    }
}
