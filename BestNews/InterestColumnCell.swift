//
//  InterestColumnCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class InterestColumnCell: UICollectionViewCell {

    @IBOutlet weak var coverImg: UIImageView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var titleLab: UILabel!
    @IBOutlet weak var addImg: UIImageView!
    
    lazy var gLayer: CAGradientLayer = {
       let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.colors = [UIColor.init(ri: 107, gi: 210, bi: 247, alpha: 1)!.cgColor, UIColor.init(ri: 39, gi: 142, bi: 246, alpha: 1)!.cgColor]
        layer.opacity = 0.9
        layer.cornerRadius = 4
        self.coverView.layer.addSublayer(layer)
        return layer
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func updateCell(data: NewsChannel) {
        titleLab.text = data.name
        if data.subscribe == 1 {
            gLayer.isHidden = false
            addImg.image = #imageLiteral(resourceName: "check-white")
        }
        else {
            gLayer.isHidden = true
            addImg.image = #imageLiteral(resourceName: "add-white")
        }
        if data.preimgpath.count == 0 {
            return
        }
        guard let url = URL(string: data.preimgpath) else {
            return
        }
        let rc = ImageResource(downloadURL: url)
        coverImg.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m231_default"), options: nil, progressBlock: nil, completionHandler: nil)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gLayer.frame = self.bounds
    }

}
