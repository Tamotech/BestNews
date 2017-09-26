//
//  BaseNavigationController.swift
//  Summer
//
//  Created by 武淅 段 on 2017/6/19.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTintColor(tint: gray72!)
    }
    
    func setTintColor(tint: UIColor) {
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: tint, NSFontAttributeName: UIFont.systemFont(ofSize: 17)]
        self.navigationBar.tintColor = tint
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        if tint.isEqual(UIColor.white) {
            let backImg = #imageLiteral(resourceName: "iconBack")
            self.navigationItem.backBarButtonItem?.setBackgroundImage(backImg, for: .normal, barMetrics: .default)
        }
        else {
            let backImg = #imageLiteral(resourceName: "iconBack")
            self.navigationItem.backBarButtonItem?.setBackgroundImage(backImg, for: .normal, barMetrics: .default)

        }
        
        self.navigationItem.backBarButtonItem?.setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: -100, vertical: -100), for: .default)
        
    }

}
