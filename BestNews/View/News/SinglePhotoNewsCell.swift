//
//  SinglePhotoNewsCell.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class SinglePhotoNewsCell: BaseNewsCell {

    @IBOutlet weak var photoView1: UIImageView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var labelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateCell(article: HomeArticle) {
        super.updateCell(article: article)
        titleLb.text = article.title
        descLb.text = article.cellListPublisher()
        dateLb.text = article.dateString()
        if article.preimglist.count > 0 {
            let img = article.preimglist[0]
            if img.count > 0 {
                let rc = ImageResource(downloadURL: URL(string: img)!)
                photoView1.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m231_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
        if article.marks.count > 0 {
            labelBtn.isHidden = false
            labelBtn.setTitle(article.marks, for: .normal)
            labelBtn.backgroundColor = article.markColor()
        }
        else {
            labelBtn.isHidden = true
        }
    }
    
    /// 切换夜间模式
    ///
    /// - Parameter night: 夜间or日间
    override func changeReadBGMode(night: Bool) {
        if night {
            titleLb.textColor = UIColor(hexString: "#9b9b9b")
            self.backgroundColor = UIColor(hexString: "#222222")
            descLb.textColor = UIColor(hexString: "#b5b5b5")
            
        }
        else {
            titleLb.textColor = UIColor(hexString: "#9b9b9b")
            self.backgroundColor = UIColor.white
            descLb.textColor = UIColor(hexString: "#484848")
        }
    }
    
}
