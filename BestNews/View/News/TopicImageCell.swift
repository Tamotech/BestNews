//
//  TopicImageCell.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

/// 专题
class TopicImageCell: UICollectionViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var topicLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(data: Any) {
        if data is SpecialChannel {
            let channel = data as! SpecialChannel
            let img = channel.preimgpath
            let name = channel.name
            if img.count > 0 {
                let rc = ImageResource(downloadURL: URL(string: img)!)
                coverImageView.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m231_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            else {
                coverImageView.image = #imageLiteral(resourceName: "m24_default")
            }
            topicLabel.text = name
        }
        else if data is HomeArticle {
            let article = data as! HomeArticle
            if let url = article.preimglist.first,
                url.count > 0 {
                let rc = ImageResource(downloadURL: URL(string: url)!)
                coverImageView.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m231_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            else {
                coverImageView.image = #imageLiteral(resourceName: "m24_default")
            }
            topicLabel.text = article.title
        }
    }
}
