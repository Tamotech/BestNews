//
//  FashNewsCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class FastNewsCell: UITableViewCell {

    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(news: FastNews) {
        contentLb.text = news.content
    }

    @IBAction func handTapRepostBtn(_ sender: UIButton) {
        
    }
    @IBAction func handleTapCollectionBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
}
