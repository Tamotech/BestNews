//
//  BrestTabbarViewController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class BestTabbarViewController: UIViewController {

    
    let mainVC = MainController.init(nibName: "MainController", bundle: nil)
    let activityVC = ActivityController.init(nibName: "ActivityController", bundle: nil)

    let timelineVC = TimeLineController.init(nibName: "TimeLineController", bundle: nil)
    let meVC = MeController.init(nibName: "MeController", bundle: nil)
    
    let tabbarView = BaseTabBarView.instanceFromXib() as! BaseTabBarView
    
    
    func initChildControllers() {
        let navVC1 = BaseNavigationController(rootViewController: mainVC)
        self.addChildViewController(navVC1)
        self.view.addSubview(navVC1.view)
        navVC1.view.isHidden = false

        let navVC2 = BaseNavigationController(rootViewController: activityVC)
        self.addChildViewController(navVC2)
        self.view.addSubview(navVC2.view)
        navVC2.view.isHidden = true

        let navVC3 = BaseNavigationController(rootViewController: timelineVC)
        self.addChildViewController(navVC3)
        self.view.addSubview(navVC3.view)
        navVC3.view.isHidden = true

        let navVC4 = BaseNavigationController(rootViewController: meVC)
        self.addChildViewController(navVC4)
        self.view.addSubview(navVC4.view)
        navVC4.view.isHidden = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initChildControllers()
        tabbarView.frame = CGRect(x: 0, y: screenHeight-49, width: screenWidth, height: 49)
        self.view.addSubview(tabbarView)
        tabbarView.selectItemAction = {index in
            for (i, vc) in self.childViewControllers.enumerated() {
                if i == index {
                    vc.view.isHidden = false
                }
                else {
                    vc.view.isHidden = true
                }
            }
        }
    }
    
    

}
