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
        if content is RCTextMessage {
            let text = (content as! RCTextMessage)
            contentLb.text = text.content
            photoHeight.constant = 0
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
                let w = im.extra.split(separator: ";").first!.uppercased().getFloatFromString()
                let h = im.extra.split(separator: ";").last!.uppercased().getFloatFromString()
                let imgH = photoIm.width*h/w
                photoHeight.constant = imgH
            }
            contentLb.text = ""
            
            
        }
    }
}
