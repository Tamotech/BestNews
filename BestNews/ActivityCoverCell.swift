//
//  ActivityCoverCell.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ActivityCoverCell: UITableViewCell {

    @IBOutlet weak var coverBg: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var addressLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
