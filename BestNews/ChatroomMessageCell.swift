//
//  ChatroomMessageCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/17.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

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
        if data.content != nil && data.content! is CustomeMessage {
            let msg = data.content as! CustomeMessage
            if let user = data.content?.senderUserInfo {
                usernameLb.text = user.name
                if user.portraitUri != nil && user.portraitUri.count > 0 {
                    let url = URL(string: user.portraitUri)
                    let rc = ImageResource(downloadURL: url!)
                    avatar.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            timeLb.text = msg.timeStr()
            msgLb.text = msg.content
        }
        else if data.content != nil && data.content! is RCTextMessage {
            msgLb.text = (data.content as! RCTextMessage).content!
            let content = data.content as! RCTextMessage
            if content.extra != nil && content.extra.contains(";") {
            let extraArr = content.extra.split(separator: ";")
                if extraArr.count >= 3 {
                    let name = String(extraArr[0])
                    let img = String(extraArr[1])
                    let dateInt = TimeInterval(extraArr[2])!/1000
                    usernameLb.text = name
                    if img != "http://" {
                        if let url = URL(string: img)  {
                            let rc = ImageResource(downloadURL: url)
                            avatar.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
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
            else if content.extra != nil && content.extra.contains("{") {
            
                let json = JSON.init(parseJSON: content.extra!)
                msgLb.text = content.content
                if let user = content.senderUserInfo {
                    usernameLb.text = user.name
                    if user.portraitUri != nil && user.portraitUri.count > 0 {
                        let rc = ImageResource(downloadURL: URL(string: user.portraitUri)!)
                        avatar.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                    }
                }
                let dateInt = json["date"].doubleValue/1000
                let date = Date(timeIntervalSince1970: dateInt)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let dateStr = formatter.string(from: date)
                timeLb.text = dateStr
            }
            
        }
        else if data.content is RCInformationNotificationMessage {
            let msg = data.content as! RCInformationNotificationMessage
            usernameLb.text = msg.senderUserInfo.name
            if let urlstring = msg.senderUserInfo.portraitUri {
                if let url = URL(string: urlstring) {
                    let rc = ImageResource(downloadURL: url)
                    avatar.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            msgLb.text = msg.message
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
