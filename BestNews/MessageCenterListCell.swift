//
//  MessageCenterListCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class MessageCenterListCell: UITableViewCell {

    @IBOutlet weak var avatarBtn: UIButton!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCell(_ message: MessageModel) {
        let url = URL(string: message.img)
        if url != nil {
            let rc = ImageResource(downloadURL: url!)
            avatarBtn.kf.setImage(with: rc, for: UIControlState.normal, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        nameLb.text = message.title
        contentLb.text = message.description
        dateLb.text = message.dateStr()
    }
}
