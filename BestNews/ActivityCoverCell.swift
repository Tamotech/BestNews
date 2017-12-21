//
//  ActivityCoverCell.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityCoverCell: UITableViewCell {

    @IBOutlet weak var coverBg: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var addressLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ data: ActivityModel) {
        if data.preimgpath.count > 0 {
            let rc = ImageResource(downloadURL: URL(string: data.preimgpath)!)
            coverBg.kf.setImage(with: rc)
        }
        titleLb.text = data.title
        dateLb.text = data.dateStr()
        tipLabel.text = data.stateStr().0
        tipView.backgroundColor = data.stateStr().1
        addressLb.text = data.address
    }
    
}
