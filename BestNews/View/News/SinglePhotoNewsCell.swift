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
        descLb.text = article.publisher
        dateLb.text = article.dateString()
        if article.preimglist.count > 0 {
            let img = article.preimglist[0]
            if img.count > 0 {
                let rc = ImageResource(downloadURL: URL(string: img)!)
                photoView1.kf.setImage(with: rc)
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
    
}
