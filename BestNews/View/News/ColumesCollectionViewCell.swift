//
//  ColumesCollectionViewCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ColumesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coverPhotoView: UIImageView!
    
    @IBOutlet weak var columeNameLb: UILabel!
    
    @IBOutlet weak var subscripBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateCell(_ channel: NewsChannel) {
        ///TODO: prepath 不正确
        if channel.preimgpath.count > 0 {
//            let rc = ImageResource(downloadURL: URL(string: channel.preimgpath)!)
//            coverPhotoView.kf.setImage(with: rc)
        }
        columeNameLb.text = channel.name
    }
    
    @IBAction func handleTapScriptBtn(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
            sender.setTitle("已订阅", for: .normal)
        }
        else {
            sender.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
            sender.setTitle("订阅", for: .normal)

        }
    }
    
}
