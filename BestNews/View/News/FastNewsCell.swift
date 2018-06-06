//
//  FashNewsCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Presentr

typealias RepostFastNewsCallback = (FastNews)->()

class FastNewsCell: UITableViewCell {
    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var collectBtn: UIButton!
    
    @IBOutlet weak var repostBtn: UIButton!
    
    
    var clickRepostCallback: RepostFastNewsCallback?
    
    var news = FastNews()
    
    lazy var presentr:Presentr = {
        let pr = Presentr(presentationType: .fullScreen)
        pr.transitionType = TransitionType.coverVertical
        pr.dismissOnTap = true
        pr.dismissAnimated = true
        return pr
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(news: FastNews) {
        self.news = news
        contentLb.text = news.content
        timeLb.text = news.timeStr()
        collectBtn.isSelected = (news.collect == 1)
    }
    
    @IBAction func handTapRepostBtn(_ sender: UIButton) {
        
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        
        if clickRepostCallback != nil {
            clickRepostCallback!(news)
        }
    }
    @IBAction func handleTapCollectionBtn(_ sender: UIButton) {
        
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            news.collect = 1
            APIRequest.collectAPI(id: news.id, type: "newsflash", result: { [weak self](success) in
                if !success {
                    self?.news.collect = 0
                    self?.collectBtn.isSelected = false
                }
            })
        }
        else {
            news.collect = 0
            APIRequest.cancelCollectAPI(id: news.id, type: "newsflash", result: { [weak self](success) in
                if !success {
                    self?.news.collect = 1
                    self?.collectBtn.isSelected = true
                }
            })
        }
        
    }
    
    
}
