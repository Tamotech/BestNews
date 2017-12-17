//
//  LiveMessageCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

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

    
}
