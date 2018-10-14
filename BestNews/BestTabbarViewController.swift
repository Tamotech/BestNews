//
//  BrestTabbarViewController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class BestTabbarViewController: UIViewController, UINavigationControllerDelegate {

    
    let mainVC = MainController.init(nibName: "MainController", bundle: nil)
    let activityVC = ActivityController.init(nibName: "ActivityController", bundle: nil)

    let timelineVC = CircleHomeViewController.init(nibName: "CircleHomeViewController", bundle: nil)
    let meVC = MeController.init(nibName: "MeController", bundle: nil)
    let videoVC = LiveListController.init(nibName: "LiveListController", bundle: nil)
    
    let tabbarView = BaseTabBarView.instanceFromXib() as! BaseTabBarView
    
    
    func initChildControllers() {
        let navVC1 = BaseNavigationController(rootViewController: mainVC)
        self.addChildViewController(navVC1)
        self.view.addSubview(navVC1.view)
        navVC1.view.isHidden = false
        navVC1.delegate = self

        let navVC2 = BaseNavigationController(rootViewController: activityVC)
        self.addChildViewController(navVC2)
        self.view.addSubview(navVC2.view)
        navVC2.view.isHidden = true
        navVC2.delegate = self
        
        let navVC5 = BaseNavigationController(rootViewController: videoVC)
        videoVC.entry = 2
        self.addChildViewController(navVC5)
        self.view.addSubview(navVC5.view)
        navVC5.view.isHidden = true
        navVC5.delegate = self

        let navVC3 = BaseNavigationController(rootViewController: timelineVC)
        self.addChildViewController(navVC3)
        self.view.addSubview(navVC3.view)
        navVC3.view.isHidden = true
        navVC3.delegate = self

        let navVC4 = BaseNavigationController(rootViewController: meVC)
        self.addChildViewController(navVC4)
        self.view.addSubview(navVC4.view)
        navVC4.view.isHidden = true
        navVC4.delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initChildControllers()
        let h = 49+bottomGuideHeight
        tabbarView.frame = CGRect(x: 0, y: screenHeight-h, width: screenWidth, height: h)
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
            NotificationCenter.default.post(name: kSwitchTabbarItemNotify, object: index)
        }
    }
    
    //MARK: - navigation
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.childViewControllers.first == viewController {
            //tabbarView.isHidden = false
        }
        else {
            //tabbarView.isHidden = true
            self.showTabbarViewAnimated(show: false)
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.childViewControllers.first == viewController {
            //tabbarView.isHidden = false
            self.showTabbarViewAnimated(show: true)
        }
        else {
            //tabbarView.isHidden = true
            self.showTabbarViewAnimated(show: false)
        }
    }
    
    func showTabbarViewAnimated(show: Bool) {
        if show {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabbarView.top = screenHeight-self.tabbarView.height
                self.tabbarView.alpha = 1
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.tabbarView.top = screenHeight
                self.tabbarView.alpha = 0
            })
        }
    }

}
