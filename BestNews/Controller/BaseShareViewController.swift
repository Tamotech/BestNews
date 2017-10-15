//
//  BaseShareViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class BaseShareViewController: UIViewController {

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func handleTapWechatBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapTimelineBtn(_ sender: UIButton) {
    }
    
    @IBAction func handleTapWeiboBtn(_ sender: UIButton) {
    }
    
    @IBAction func handleTapQQBtn(_ sender: UIButton) {
    }
    
    @IBAction func handleTapQQZornBtn(_ sender: UIButton) {
    }
    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
