//
//  ColumesCollectionViewCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ColumesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverPhotoView: UIImageView!
    
    @IBOutlet weak var columeNameLb: UILabel!
    
    @IBOutlet weak var subscripBtn: UIButton!
    
    var channel: NewsChannel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateCell(_ channel: NewsChannel) {
        self.channel = channel
        if channel.preimgpath.count > 0 {
            let rc = ImageResource(downloadURL: URL(string: channel.preimgpath)!)
            coverPhotoView.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m231_default"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        columeNameLb.text = channel.name
        subscripBtn.isSelected = channel.subscribe == 1
    }
    
    @IBAction func handleTapScriptBtn(_ sender: UIButton) {
        
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        sender.isSelected = !sender.isSelected
        channel!.subscribe = (channel!.subscribe+1) % 2
        
        if channel?.subscribe == 1 {
            APIRequest.subscriptChannelAPI(id: channel!.id, type: "channel", result: {[weak self] (success) in
                if !success {
                    self?.channel?.subscribe = 0
                    self?.subscripBtn.isSelected = false
                    sender.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
                    sender.setTitle("订阅", for: .normal)
                }
            })
        }
        else {
            APIRequest.cancelSubscriptChannelAPI(id: channel!.id, type: "channel", result: {[weak self] (success) in
                if !success {
                    self?.channel?.subscribe = 1
                    self?.subscripBtn.isSelected = true
                    sender.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
                    sender.setTitle("已订阅", for: .normal)
                }
            })
        }
        if sender.isSelected {
            sender.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
            sender.setTitle("已订阅", for: .normal)
        }
        else {
            sender.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
            sender.setTitle("订阅", for: .normal)

        }
    }
    
}
