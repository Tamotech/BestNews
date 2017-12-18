//
//  LiveMessageCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class LiveMessageCell: UITableViewCell {

    @IBOutlet weak var avatarIm: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var photoIm: UIImageView!
    
    @IBOutlet weak var photoHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ data: RCMessage) {
        let content = data.content
        if content is CustomeMessage {
            let msg = content as! CustomeMessage
            if let user = content?.senderUserInfo {
                nameLb.text = user.name
            }
            timeLb.text = msg.timeStr()
            if let url = URL(string: msg.img ?? "") {
                let rc = ImageResource(downloadURL: url)
                avatarIm.kf.setImage(with: rc)
            }
        }
        else if content is RCTextMessage {
            let text = (content as! RCTextMessage)
            contentLb.text = text.content
            photoHeight.constant = 0
            if text.extra != nil {
                let extraArr = text.extra.split(separator: ";")
                if extraArr.count >= 3 {
                    let name = String(extraArr[0])
                    let img = String(extraArr[1])
                    let dateInt = TimeInterval(extraArr[2])!/1000
                    nameLb.text = name
                    if img != "http://" {
                        if let url = URL(string: img)  {
                            let rc = ImageResource(downloadURL: url)
                            avatarIm.kf.setImage(with: rc)
                        }
                        else {
                            avatarIm.image = #imageLiteral(resourceName: "defaultUser")
                        }
                    }
                    else {
                        avatarIm.image = #imageLiteral(resourceName: "defaultUser")
                    }
                    let date = Date(timeIntervalSince1970: dateInt)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let dateStr = formatter.string(from: date)
                    timeLb.text = dateStr
                }
            }
        }
        else if content is RCImageMessage {
            let im = (content as! RCImageMessage)
            if im.originalImage != nil {
                photoIm.image = im.originalImage
            }
            else if im.imageUrl != nil {
                if let url = URL(string: im.imageUrl) {
                    let rc = ImageResource(downloadURL: url)
                    photoIm.kf.setImage(with: rc)
                }
            }
            else if im.localPath != nil {
                if let img = try! UIImage(data: Data.init(contentsOf: URL.init(fileURLWithPath: im.localPath), options: Data.ReadingOptions.mappedIfSafe)) {
                    photoIm.image = img

                }
            }
            
            if im.extra != nil {
                let extraArr = im.extra.split(separator: ";")
                if extraArr.count >= 5 {
                    let name = String(extraArr[0])
                    let img = String(extraArr[1])
                    let dateInt = TimeInterval(extraArr[2])!/1000
                    let w = String(extraArr[3]).getFloatFromString()
                    let h = String(extraArr[4]).getFloatFromString()
                    let imgH = photoIm.width*h/w
                    photoHeight.constant = imgH
                    
                    nameLb.text = name
                    if let url = URL(string: img) {
                        let rc = ImageResource(downloadURL: url)
                        avatarIm.kf.setImage(with: rc)
                    }
                    let date = Date(timeIntervalSince1970: dateInt)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let dateStr = formatter.string(from: date)
                    timeLb.text = dateStr
                }
            }
            contentLb.text = ""
            
        }
    }
}
