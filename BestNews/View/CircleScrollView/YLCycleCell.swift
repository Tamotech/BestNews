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

        contentView.addSubview(iconImageView)
        contentView.addSubview(bottomView)
        contentView.addSubview(titleLabel)

    }

}
