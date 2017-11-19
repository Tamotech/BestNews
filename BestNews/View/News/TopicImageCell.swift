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

    func updateCell(data: SpecialChannel) {
        let img = data.preimgpath
        let name = data.fullname
        if img.count > 0 {
            let rc = ImageResource(downloadURL: URL(string: img)!)
            coverImageView.kf.setImage(with: rc)
        }
        topicLabel.text = name
    }
}
