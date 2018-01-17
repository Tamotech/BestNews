//
//  SearchArticleCell.swift
//  BestNews
//
//  Created by Worthy on 2018/1/17.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit

class SearchArticleCell: UITableViewCell {

    
    @IBOutlet weak var articleTitleLb: UILabel!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var authorLb: UILabel!
    
    @IBOutlet weak var columnLb: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(_ data: Any) {
        if data is HomeArticle {
            let article = data as! HomeArticle
            articleTitleLb.text = article.title
            authorLb.text = article.cellListPublisher()
            columnLb.text = article.dateString()
            clockIcon.isHidden = false
        }
        else if data is ActivityModel {
            let activity = data as! ActivityModel
            articleTitleLb.text = activity.title
            clockIcon.isHidden = true
            authorLb.text = activity.dateStr()
            columnLb.text = ""
        }
    }
    
    
    
}
