//
//  BaseNewsCell.swift
//  BestNews
//
//  Created by Worthy on 2017/11/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class BaseNewsCell: UITableViewCell {

    var article: HomeArticle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(article: HomeArticle) {
        self.article = article
    }

}
