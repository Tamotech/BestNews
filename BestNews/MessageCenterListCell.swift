//
//  MessageCenterListCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

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
    
}
