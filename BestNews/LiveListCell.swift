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
    
    @IBOutlet weak var labelIm: UIImageView!
    
    @IBOutlet weak var labelText: UILabel!
    
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
        if data.collect == 1 {
            collectionBtn.setImage(#imageLiteral(resourceName: "star_select_small"), for: .normal)
        }
        else {
            collectionBtn.setImage(#imageLiteral(resourceName: "star_light"), for: .normal)
        }
        voteBtn.setTitle(" \(data.collectnum)", for: .normal)
        voteBtn.setTitle(" \(data.zannum)", for: .normal)
        titleLb.text = data.title
        let labelImName = "live-label\(arc4random()%3+1)"
        labelIm.image = UIImage(named: labelImName)
        labelText.text = data.marks
    }
    
    @IBAction func handleTapCommentBtn(_ sender: UIButton) {
        let vc = MyLiveViewController()
        vc.liveModel = model
        ownerController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapVoteBtn(_ sender: UIButton) {
        sender.setImage(#imageLiteral(resourceName: "vote_select"), for: .normal)
        
        let path = "/zan/zan.htm?id=\(model?.id ?? "")"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    @IBAction func handleTapCollectionBtn(_ sender: UIButton) {
        if model?.collect == 0 {
            APIRequest.collectAPI(id: model!.id, type: "live", result: {[weak self] (success) in
                if success {
                    self?.model?.collect = 1
                    sender.setImage(#imageLiteral(resourceName: "star_select"), for: .normal)
                }
                else {
                    self?.model?.collect = 0
                    sender.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
                }
            })
        }
        else {
            APIRequest.cancelCollectAPI(id: model!.id, type: "live", result: { [weak self] (success) in
                if !success {
                    self?.model?.collect = 1
                    sender.setImage(#imageLiteral(resourceName: "star_select"), for: .normal)
                }
                else {
                    self?.model?.collect = 0
                    sender.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
                }
            })
        }
    }
    
    @IBAction func handleTapStartLiveBtn(_ sender: UIButton) {
        
        let vc = MyLiveViewController()
        vc.liveModel = model
        ownerController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
