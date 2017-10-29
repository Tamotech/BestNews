//
//  Tookit.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class Toolkit: NSObject {
    
    
    class func getCurrentViewController() -> UIViewController? {
        
        var topVC = UIApplication.shared.keyWindow?.rootViewController
        while(topVC?.presentedViewController != nil) {
            topVC = topVC?.presentedViewController
        }
        if topVC is UINavigationController {
            let navVC = topVC as! UINavigationController
            return navVC.childViewControllers.last
        }
        return topVC
    }
}

