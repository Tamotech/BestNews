//
//  NetworkFailViewController.swift
//  BestNews
//
//  Created by wuxi on 2018/10/14.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit

///网络加载失败
class NetworkFailViewController: UIViewController {

    var tapReloadAction: (()->())?
    @IBOutlet weak var barHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        barHeight.constant = topGuideHeight
    }

    @IBAction func tapclose(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapReload(_ sender: UIButton) {
        if tapReloadAction != nil {
            tapReloadAction!()
        }
        NotificationCenter.default.post(name: kTapReloadNotify, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}
