//
//  LiveListCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class LiveListCell: UITableViewCell {

    
    @IBOutlet weak var liveStatusBtn: UIButton!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var voteBtn: UIButton!
    
    @IBOutlet weak var collectionBtn: UIButton!
    
    @IBOutlet weak var startLive: UIButton!
    
    @IBOutlet weak var coverIm: UIImageView!
    
    
    @IBOutlet weak var greenDotView: UIView!
    var model: LiveModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ data: LiveModel) {
        
        self.model = data
        if data.state == "l1_finish" {
            greenDotView.isHidden = true
            liveStatusBtn.backgroundColor = UIColor(hexString: "#000000", alpha: 0.2)
            liveStatusBtn.layer.borderWidth = 0
            startLive.isHidden = true
        }
        else if data.state == "l2_coming" {
            greenDotView.isHidden = true
            liveStatusBtn.backgroundColor = themeColor!
            liveStatusBtn.layer.borderWidth = 0
            startLive.isHidden = false
        }
        else if data.state == "l3_living" {
            greenDotView.isHidden = true
            liveStatusBtn.backgroundColor = UIColor(hexString: "#000000", alpha: 0.2)
            liveStatusBtn.layer.borderWidth = 1
            liveStatusBtn.borderColor = UIColor(hexString: "#ffffff", alpha: 1)!
            startLive.isHidden = false
        }
        liveStatusBtn.setTitle(data.stateStr(), for: .normal)
        if let url = URL(string: data.preimgpath) {
            let rc = ImageResource(downloadURL: url)
            coverIm.kf.setImage(with: rc)
        }
    }
    
    @IBAction func handleTapCommentBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapVoteBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapCollectionBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapStartLiveBtn(_ sender: UIButton) {
        
        let vc = MyLiveViewController()
        vc.liveModel = model
        ownerController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
