//
//  BaseEmptyView.swift
//  BestNews
//
//  Created by Worthy on 2017/12/28.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

class BaseEmptyView: UIView {

    
    var emptyString = "还没有消息~"
    var emptyLb = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let img = UIImageView(image: UIImage(named: "no-data-person"))
        self.addSubview(img)
        img.contentMode = .scaleAspectFit
        img.snp.makeConstraints { (make) in
            make.top.equalTo(100)
            make.centerX.equalTo(self.snp.centerX)
            make.size.equalTo(CGSize(width: 100, height: 170))
        }
        
        let lb = UILabel()
        lb.text = emptyString
        lb.textColor = UIColor(hexString: "b5b5b5")
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(lb)
        lb.snp.makeConstraints { (make) in
            make.top.equalTo(img.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        emptyLb = lb
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        emptyLb.text = emptyString
    }
    
}
