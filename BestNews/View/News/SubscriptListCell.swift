//
//  SubscriptListCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class SubscriptListCell: UITableViewCell {

    @IBOutlet weak var avtarBtn: UIButton!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var subscriptBtn: UIButton!
    
    var ognization: OgnizationModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure
    }
    
    func updateCell(_ data: OgnizationModel) {
        ognization = data
        if data.headimg.count > 0 {
            let rc = ImageResource(downloadURL: URL(string: data.headimg)!)
            avtarBtn.kf.setImage(with: rc, for: .normal)
        }
        nameLb.text = data.name
        descLb.text = data.memo
        subscriptState(data.subscribe == 1)
    }
    
    @IBAction func handleTapScriptBtn(_ sender: UIButton) {
        
        if ognization?.subscribe == 0 {
            ognization?.subscriptIt()
            ognization?.subscribe = 1
            subscriptState(true)
        }
        else {
            ognization?.cancelSubsripbeIt()
            subscriptState(false)
            ognization?.subscribe = 0
        }
    }
    
    func subscriptState(_ hasSubscript: Bool) {
        if hasSubscript {
            subscriptBtn.backgroundColor = UIColor.clear
            subscriptBtn.layer.borderWidth = 1
            subscriptBtn.layer.borderColor = gray146?.cgColor
            subscriptBtn.layer.shadowOpacity = 0
            subscriptBtn.setTitle("已订阅", for: .normal)
            subscriptBtn.setTitleColor(gray72, for: .normal)
        }
        else {
            subscriptBtn.setTitleColor(UIColor.white, for: .normal)
            subscriptBtn.setTitle("订阅", for: .normal)
            subscriptBtn.backgroundColor = themeColor
            subscriptBtn.layer.borderWidth = 0
            subscriptBtn.shadowOpacity = 0.3
        }
    }
}
