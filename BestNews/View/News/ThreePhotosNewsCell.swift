//
//  ThreePhotosNewsCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ThreePhotosNewsCell: BaseNewsCell {

    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var photoView1: UIImageView!
    
    @IBOutlet weak var photoView2: UIImageView!
    
    @IBOutlet weak var photoView3: UIImageView!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var tipBtn: UIButton!
    
    @IBOutlet weak var dateLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func updateCell(article: HomeArticle) {
        super.updateCell(article: article)
        titleLb.text = article.title
        descLb.text = article.cellListPublisher()
        dateLb.text = article.dateString()
        if article.marks.count > 0 {
            tipBtn.isHidden = false
            tipBtn.setTitle(article.marks, for: .normal)
            tipBtn.backgroundColor = article.markColor()
        }
        else {
            tipBtn.isHidden = true
        }
        for i in 0..<article.preimglist.count {
            let img = article.preimglist[i]
            if img.count > 0 {
                let rc = ImageResource(downloadURL: URL(string: img)!)
                if i == 0 {
                    photoView1.kf.setImage(with: rc)
                }
                else if i == 1 {
                    photoView2.kf.setImage(with: rc)
                }
                else if i == 2 {
                    photoView3.kf.setImage(with: rc)
                }
            }
        }
    }
    
}
