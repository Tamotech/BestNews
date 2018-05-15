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
        self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
    }

    func updateCell(article: HomeArticle) {
        self.article = article
    }

    /// 切换夜间模式
    ///
    /// - Parameter night: 夜间or日间
    func changeReadBGMode(night: Bool) {
    }
}
