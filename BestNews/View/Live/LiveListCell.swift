//
//  LiveListCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class LiveListCell: UITableViewCell {

    
    @IBOutlet weak var liveStatusBtn: UIButton!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var voteBtn: UIButton!
    
    @IBOutlet weak var collectionBtn: UIButton!
    
    @IBOutlet weak var startLive: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func handleTapCommentBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapVoteBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapCollectionBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapStartLiveBtn(_ sender: UIButton) {
        
        let vc = MyLiveViewController()
        ownerController()?.navigationController?.pushViewController(vc, animated: true)
    }
}
