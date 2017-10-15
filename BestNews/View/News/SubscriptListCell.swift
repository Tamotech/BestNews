//
//  SubscriptListCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class SubscriptListCell: UITableViewCell {

    @IBOutlet weak var avtarBtn: UIButton!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var subscriptBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure
    }
    
    @IBAction func handleTapScriptBtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.backgroundColor = UIColor.clear
            sender.layer.borderWidth = 1
            sender.layer.borderColor = gray146?.cgColor
            sender.layer.shadowOpacity = 0
            sender.setTitle("已订阅", for: .normal)
            sender.setTitleColor(gray72, for: .normal)
        }
        else {
            sender.setTitleColor(UIColor.white, for: .normal)
            sender.setTitle("订阅", for: .normal)
            sender.backgroundColor = themeColor
            sender.layer.borderWidth = 0
            sender.shadowOpacity = 0.3
        }
    }
}
