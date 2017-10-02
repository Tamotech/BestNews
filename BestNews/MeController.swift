//
//  MeController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MeController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarView: UIButton!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var identityBtn: UIButton!
    
    @IBOutlet weak var subscriptionAmountLb: UILabel!
    
    @IBOutlet weak var collectionAmountLb: UILabel!
    
    @IBOutlet weak var activityAmountLb: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let settingData: [(String, UIImage)] = [("实名认证", #imageLiteral(resourceName: "me_identity")),
                       ("开通VIP", #imageLiteral(resourceName: "me_open_vip")),
                       ("我要投稿", #imageLiteral(resourceName: "me_post_article")),
                       ("成为名人", #imageLiteral(resourceName: "me_become_star")),
                       ("分享APP", #imageLiteral(resourceName: "me_share_app")),
                       ("意见反馈", #imageLiteral(resourceName: "me_feed_back")),
                       ("退出登录", #imageLiteral(resourceName: "me_logout"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        
        self.shouldClearNavBar = true
        self.showCustomTitle(title: "我的")
        let nib = UINib(nibName: "ProfileCenterCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    

    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileCenterCell
        let data = settingData[indexPath.row]
        cell.iconView.image = data.1
        cell.titleLb.text = data.0
        return cell
    }

}
