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

        // Configure the view for the selected state
    }
    
    @IBAction func handleTapScriptBtn(_ sender: UIButton) {
        
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected {
////            sender.layer.borderWidth = 0
//            
//        }
//        else {
//            sender.backgroundColor = UIColor.clear
//            sender.layer.borderWidth = 1
//        }
    }
}
