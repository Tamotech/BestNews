//
//  InterestColumnCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/24.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

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
    
    func updateCell(data: InterestColumn) {
        titleLab.text = data.name
        if data.selected {
            gLayer.isHidden = false
            addImg.image = #imageLiteral(resourceName: "check-white")
        }
        else {
            gLayer.isHidden = true
            addImg.image = #imageLiteral(resourceName: "add-white")
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gLayer.frame = self.bounds
    }

}
