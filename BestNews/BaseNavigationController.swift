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
    
    func setBarBackgroundClear(clear: Bool) {
        if clear {
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
            self.navigationBar.tintColor = UIColor.white
        }
        else {
            let bgImg = UIImage.image(backgroundColor: UIColor.white, size: CGSize(width: 2, height: 2))
            let shadowImg = UIImage.image(backgroundColor: UIColor(hexString: "#e5e5e5")!, size: CGSize(width: 0.5, height: 0.5))
            self.navigationBar.setBackgroundImage(bgImg, for: .default)
            self.navigationBar.shadowImage = shadowImg
            self.navigationBar.tintColor = gray51
        }
    }

}
