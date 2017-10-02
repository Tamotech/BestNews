//
//  SubscriptSectionHeaderView.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

class SubscriptSectionHeaderView: UITableViewHeaderFooterView {

    lazy var nameLb: UILabel = {
        let lb = UILabel()
        lb.textColor = gray34
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubview(nameLb)
        nameLb.snp.makeConstraints { (make) in
            make.top.left.equalTo(15)
        }
        
        let arrowIm = UIImageView(image: #imageLiteral(resourceName: "icon_more_blue"))
        addSubview(arrowIm)
        arrowIm.snp.makeConstraints { (make) in
            make.right.equalTo(15)
            make.centerY.equalTo(nameLb.snp.centerY)
        }
        
        let detailLb = UILabel()
        detailLb.textColor = gray181
        detailLb.font = UIFont.systemFont(ofSize: 14)
        detailLb.text = "更多"
        addSubview(detailLb)
        detailLb.snp.makeConstraints { (make) in
            make.right.equalTo(arrowIm.snp.left).offset(-6)
            make.centerY.equalTo(arrowIm.snp.centerY)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
