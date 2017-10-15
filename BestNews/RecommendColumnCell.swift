//
//  RecommendColumnCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class RecommendColumnCell: UICollectionViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var scriptBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func handleTapSubscriptBtn(_ sender: UIButton) {
    }
    

}
