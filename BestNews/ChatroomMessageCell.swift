//
//  ChatroomMessageCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/17.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ChatroomMessageCell: UITableViewCell {

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
        if data.content != nil && data.content! is RCTextMessage {
            msgLb.text = (data.content as! RCTextMessage).content!
            let content = data.content as! RCTextMessage
            if content.extra != nil {
            let extraArr = content.extra.split(separator: ";")
                if extraArr.count >= 3 {
                    let name = String(extraArr[0])
                    let img = String(extraArr[1])
                    let dateInt = TimeInterval(extraArr[2])!/1000
                    usernameLb.text = name
                    if img != "http://" {
                        if let url = URL(string: img)  {
                            let rc = ImageResource(downloadURL: url)
                            avatar.kf.setImage(with: rc)
                        }
                        else {
                            avatar.image = #imageLiteral(resourceName: "defaultUser")
                        }
                    }
                    else {
                        avatar.image = #imageLiteral(resourceName: "defaultUser")
                    }
                    let date = Date(timeIntervalSince1970: dateInt)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let dateStr = formatter.string(from: date)
                    timeLb.text = dateStr
                }
            }
            
        }
        else if data.content != nil && data.content! is RCInformationNotificationMessage {
            let content = data.content as! RCInformationNotificationMessage
            avatar.image = #imageLiteral(resourceName: "defaultUser")
            msgLb.text = content.message
            usernameLb.text = "用户"
        }
        else {
            avatar.image = #imageLiteral(resourceName: "defaultUser")
            usernameLb.text = ""
            msgLb.text = ""
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   
}
