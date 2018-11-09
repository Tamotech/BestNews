//
//  BaseViewController.swift
//  Summer
//
//  Created by 武淅 段 on 2017/6/19.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh
import Presentr
import Kingfisher

class BaseViewController: UIViewController {
    
    
    lazy var presentr:Presentr = {
        let pr = Presentr(presentationType: .fullScreen)
        pr.transitionType = TransitionType.coverVertical
        pr.dismissOnSwipe = true
        pr.dismissAnimated = true
        return pr
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(frame: CGRect(x: 10, y: 20, width: 44, height: 44))
        btn.setImage(UIImage(named: "close-gray-bold"), for: .normal)
        btn.addTarget(self, action: #selector(handleTapCloseVc(sender:)), for: .touchUpInside)
        return btn
    } ()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 80, y: 20, width: screenWidth-160, height: 44))
        
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
        } else {
            label.font = UIFont.systemFont(ofSize: 18)
        }
        label.textColor = UIColor(hexString: "333333")
        label.textAlignment = .center
        return label
    } ()
    
    lazy var barView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
        view.backgroundColor = UIColor.white
        view.shadowColor = UIColor(hexString: "e8e8e8")!
        view.shadowOffset = CGSize(width: 0, height: 1)
        view.shadowRadius = 1
        view.shadowOpacity = 0.8
        return view
    }()
    
    var shouldClearNavBar:Bool = false
    
    
    /// 显示关闭按钮
    public func showCloseBtn() {
        self.view.addSubview(closeBtn)
    }
    
    /// 显示自定义标题
    public func showCustomTitle(title: String) {
        self.view.addSubview(titleLabel)
        titleLabel.text = title
    }
    
    class public func instanceFromStoryboard()->UIViewController {
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:NSStringFromClass( object_getClass(self.classForCoder())).components(separatedBy: ".").last!)
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.barView)
        self.barView.isHidden = true
//        if self.navigationController != nil && self.navigationController?.childViewControllers.count == 1 {
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        }
        self.hidesBottomBarWhenPushed = true
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if !shouldClearNavBar {
            self.barView.isHidden = false
            self.view.bringSubview(toFront: barView)
            if navigationController != nil {
                navigationController?.navigationBar.tintColor = gray51
            }
        }
        else {
            self.barView.isHidden = true
            if navigationController is BaseNavigationController {
               let navVC = navigationController as! BaseNavigationController
                navVC.setTintColor(tint: UIColor.white)
            }
        }
        
        if (!closeBtn.isHidden) {
            self.view.bringSubview(toFront: closeBtn)
        }
        if (!titleLabel.isHidden) {
            self.view.bringSubview(toFront: titleLabel)
        }
    }

    
    
    
    func handleTapCloseVc(sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("deinit ----- \(self.classForCoder)")
        NotificationCenter.default.removeObserver(self)
    }

    

}
