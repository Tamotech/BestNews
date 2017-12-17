//
//  ChatroomMessageCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/17.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ChatroomMessageCell: UITableViewCell, RCIMUserInfoDataSource {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var msgPopview: UIView!
    
    @IBOutlet weak var usernameLb: UILabel!
    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var msgLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ data: RCMessage) {
        
        if data.content != nil {
            msgLb.text = (data.content as! RCTextMessage).content!
        }
        self.getUserInfo(withUserId: data.senderUserId) { [weak self](userInfo) in
            if userInfo != nil {
                if let url = URL(string: userInfo!.portraitUri) {
                    let rc = ImageResource(downloadURL: url)
                    self!.avatar.kf.setImage(with: rc)
                }
                self!.usernameLb.text = userInfo!.name
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!) {
        
    }
}
