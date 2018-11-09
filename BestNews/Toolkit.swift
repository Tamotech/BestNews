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
        if topVC == nil {
            return nil
        }
        if topVC is UINavigationController {
            let navVC = topVC as! UINavigationController
            return navVC.childViewControllers.last
        }
        else if topVC!.isKind(of: UITabBarController.self) {
            let tabVC = topVC as! UITabBarController
            let firstVC  = tabVC.childViewControllers.first
            if firstVC is UINavigationController {
                return firstVC?.childViewControllers.first
            }
            return firstVC
        }
        return topVC
    }
    
    class func showLoginVC() {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            let loginVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            let navVC = BaseNavigationController(rootViewController: loginVC)
            let rootVC = Toolkit.getCurrentViewController()
            if rootVC?.presentedViewController == nil {
                rootVC?.present(navVC, animated: true, completion: nil)
            }
        }
    }
}

