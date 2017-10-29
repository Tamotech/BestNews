//
//  ProfileCenterController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ProfileCenterController: BaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    @IBOutlet weak var nicknameLb: UILabel!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var columnContainerView: UIView!
   
    @IBOutlet weak var phoneLb: UILabel!
    
    @IBOutlet weak var wechatLb: UILabel!
    
    @IBOutlet weak var weiboLb: UILabel!
    
    @IBOutlet weak var qqLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.showCustomTitle(title: "我的资料")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - actions
    @IBAction func handleTapAvatar(_ sender: Any) {
        
    }
    @IBAction func handleTapPhone(_ sender: Any) {
        
    }
    @IBAction func handleTapWechat(_ sender: Any) {
        
    }
    
    @IBAction func handleTapWeibo(_ sender: Any) {
        
    }
    
    @IBAction func handleTapQQ(_ sender: Any) {
        
    }
    

}
