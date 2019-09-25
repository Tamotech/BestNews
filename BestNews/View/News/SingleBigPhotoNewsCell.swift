//
//  SingleBigPhotoNewsCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class SingleBigPhotoNewsCell: BaseNewsCell {
    @IBOutlet weak var photoView1: UIImageView!
    
    @IBOutlet weak var titleLb: UILabel!
    
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
        if article.preimglist.count > 0 {
            let img = article.preimglist[0]
            if img.count > 0 {
                let rc = ImageResource(downloadURL: URL(string: img)!)
                photoView1.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m231_default"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
        if article.marks.count > 0 {
            tipBtn.isHidden = false
            tipBtn.setTitle(article.marks, for: .normal)
            tipBtn.backgroundColor = article.markColor()
            tipBtn.layer.borderWidth = 0
            tipBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
        else {
            tipBtn.isHidden = true
        }
        if article.type == "adv" {
            //广告
            tipBtn.isHidden = false
            tipBtn.layer.borderWidth = 1
            tipBtn.layer.borderColor = UIColor(hex: 0xb5b5b5)?.cgColor
            tipBtn.setTitle("广告", for: UIControlState.normal)
            tipBtn.setTitleColor(UIColor(hex: 0xb5b5b5), for: UIControlState.normal)
            tipBtn.backgroundColor = .clear
        }
        
        if SessionManager.isWithinCountrysDay() {
            tipBtn.backgroundColor = lightRed
        } else {
            tipBtn.backgroundColor = lightBlue
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
