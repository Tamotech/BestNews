//  YLCycleCell.swift
//  YLCycleView
//
//  Created by Raindew on 2016/11/1.
//  Copyright © 2016年 Raindew. All rights reserved.
//

import UIKit

class YLCycleCell: UICollectionViewCell {

    //声明属性
//    var dataSource : [[String]]!
    lazy var iconImageView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var bottomView = UIView()
    lazy var adLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        setupUI()
    }
   
}
extension YLCycleCell {

    fileprivate func setupUI() {

        iconImageView.frame = self.bounds
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = UIViewContentMode.scaleAspectFill
        bottomView.frame = CGRect(x: 0, y: iconImageView.bounds.height - 45, width: iconImageView.bounds.width, height: 45)
        titleLabel.frame = CGRect(x: 15, y: iconImageView.bounds.height - 45, width: iconImageView.bounds.width - 30, height: 45)

        //设置属性
        bottomView.backgroundColor = .black
        bottomView.alpha = 0.4
        titleLabel.textAlignment = .left
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        adLabel.frame = CGRect(x: self.bounds.size.width-10-37, y: 10, width: 37, height: 17)
        adLabel.layer.borderWidth = 1
        adLabel.layer.cornerRadius = 4
        adLabel.textColor = UIColor(white: 1, alpha: 0.6)
        adLabel.layer.borderColor = UIColor(white: 1, alpha: 0.6).cgColor

        contentView.addSubview(iconImageView)
        contentView.addSubview(bottomView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(adLabel)
    }

}
