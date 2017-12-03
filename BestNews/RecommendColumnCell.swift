//
//  RecommendColumnCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class RecommendColumnCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var scriptBtn: SubscribeButton!
    
    var org: OgnizationModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func updateCell(_ data: OgnizationModel) {
        org = data
        if let url = URL(string: data.headimg) {
            let rc = ImageResource(downloadURL: url)
            avatarView.kf.setImage(with: rc)
        }
        nameLb.text = data.name
        scriptBtn.switchStateSub(data.subscribe == 1)
    }
    
    @IBAction func handleTapSubscriptBtn(_ sender: SubscribeButton) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        org?.subscribe = (org!.subscribe + 1) % 2
        scriptBtn.switchStateSub(org?.subscribe == 1)
        if org?.subscribe == 1 {
            APIRequest.subscriptChannelAPI(id: org!.id, type: "organize", result: { [weak self](success) in
                if !success {
                    self?.org?.subscribe = 0
                    self?.scriptBtn.switchStateSub(false)
                }
            })
        }
        else {
            APIRequest.cancelSubscriptChannelAPI(id: org!.id, type: "organize", result: { [weak self](success) in
                if !success {
                    self?.org?.subscribe = 1
                    self?.scriptBtn.switchStateSub(true)
                }
            })
        }
    }
    

}
