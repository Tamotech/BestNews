//
//  LiveMessageCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

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
        
        super.awakeFromNib()
        photoIm.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapPhoto(_:)))
        photoIm.addGestureRecognizer(tap)
    }

    func updateCell(_ data: RCMessage) {
        let content = data.content
        if content is CustomeMessage {
            let msg = content as! CustomeMessage
            if let user = content?.senderUserInfo {
                nameLb.text = user.name
                if let url = URL(string: user.portraitUri) {
                    let rc = ImageResource(downloadURL: url)
                    avatarIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }
            timeLb.text = msg.timeStr()
            if let url = URL(string: msg.img ?? "") {
                let rc = ImageResource(downloadURL: url)
                photoIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m252_default2"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            contentLb.text = msg.content
            if msg.extra?.count ?? 0 > 0 {
                let extraArr = msg.extra!.split(separator: ";")
                let w = String(extraArr[0]).getFloatFromString()
                let h = String(extraArr[1]).getFloatFromString()
                let imgH = photoIm.width*h/w
                photoHeight.constant = imgH
            }
            else {
                photoHeight.constant = 0
            }
        }
        else if content is RCTextMessage {
            let text = (content as! RCTextMessage)
            contentLb.text = text.content
            photoHeight.constant = 0
            if text.extra != nil && text.extra.contains(";") {
                let extraArr = text.extra.split(separator: ";")
                if extraArr.count >= 3 {
                    let name = String(extraArr[0])
                    let img = String(extraArr[1])
                    let dateInt = TimeInterval(extraArr[2])!/1000
                    nameLb.text = name
                    if img != "http://" {
                        if let url = URL(string: img)  {
                            let rc = ImageResource(downloadURL: url)
                            avatarIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
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
            }       ///最新版的需求
            else if text.extra != nil && text.extra.contains("{") {
                let json = JSON.init(parseJSON: text.extra!)
                contentLb.text = text.content
                if let user = text.senderUserInfo {
                    nameLb.text = user.name
                    if user.portraitUri != nil && user.portraitUri.count > 0 {
                        let url = URL(string: user.portraitUri)
                        let rc = ImageResource(downloadURL: url!)
                        avatarIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                    }
                }
                let dateInt = json["date"].doubleValue/1000
                let date = Date(timeIntervalSince1970: dateInt)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                let dateStr = formatter.string(from: date)
                timeLb.text = dateStr
                if json["img"] != JSON.null {
                    if let url = URL(string: json["img"].stringValue) {
                        let rc = ImageResource(downloadURL: url)
                        photoIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m252_default2"), options: nil, progressBlock: nil, completionHandler: nil)
                        if json["width"] != JSON.null {
                            let w = json["width"].doubleValue
                            let h = json["height"].doubleValue
                            let imgH = photoIm.width*CGFloat(h/w)
                            photoHeight.constant = imgH
                        }
                        else {
                            photoHeight.constant = photoIm.width
                        }
                    }
                    else {
                        photoHeight.constant = 0
                    }
                }
                else {
                    photoHeight.constant = 0
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
                    photoIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m252_default2"), options: nil, progressBlock: nil, completionHandler: nil)
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
                        avatarIm.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
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
    
    
    func handleTapPhoto(_ sender : Any) {
        let v = UIImageView(image: photoIm.image)
        let frame = keyWindow!.convert(photoIm.frame, from: photoIm.superview)
        v.frame = frame
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .white
        v.isUserInteractionEnabled = true
        keyWindow?.addSubview(v)
        let tap = UITapGestureRecognizer(target: self, action: #selector(photodismiss(_:)))
        v.addGestureRecognizer(tap)
        UIView.animate(withDuration: 0.3) {
            v.frame = UIScreen.main.bounds
        }
    }
    
    func photodismiss(_ sender: UIGestureRecognizer) {
        let frame = keyWindow!.convert(photoIm.frame, from: photoIm.superview)
        UIView.animate(withDuration: 0.3, animations: {
            sender.view?.frame = frame
        }) { (success) in
            sender.view?.removeFromSuperview()
        }
    }
}
