//
//  BaseShareViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ShareModel: NSObject {
    var title = "新华日报财经"
    var thumb = ""
    var msg = "新华日报财经"
    var link = "http://xhfmedia.com/app.htm"
    var img: UIImage?
}

class BaseShareViewController: UIViewController {

    ///分享内容 TEST:
    var share = ShareModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func handleTapWechatBtn(_ sender: UIButton) {
        
        dismiss(animated: true) {
            [weak self] in
            
            if self?.share.img != nil {
                BSLShareManager.shareToWechatWithImage(title: self!.share.title, msg: self!.share.msg, thumb: self!.share.thumb, img: self!.share.img!, type: 0)
            }
            else {
                BSLShareManager.shareToWechat(link: self!.share.link, title: self!.share.title, msg: self!.share.msg, thumb: self!.share.thumb, type: 0)
            }
        }
    }
    
    @IBAction func handleTapTimelineBtn(_ sender: UIButton) {
        dismiss(animated: true) {
            [weak self] in
            if self?.share.img != nil {
                BSLShareManager.shareToWechatWithImage(title: self!.share.title, msg: self!.share.msg, thumb: self!.share.thumb, img: self!.share.img!, type: 1)
            }
            else {
                BSLShareManager.shareToWechat(link: self!.share.link, title: self!.share.title, msg: self!.share.msg, thumb: self!.share.thumb, type: 1)
            }
        }
    }
    
    @IBAction func handleTapWeiboBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func handleTapQQBtn(_ sender: UIButton) {
        
        BSLShareManager.shareToQQ(title: share.title, msg: share.msg, qqOrZorn: 0, link: share.link, thumb: share.thumb, img: share.img)
    }
    
    @IBAction func handleTapQQZornBtn(_ sender: UIButton) {
        
        
        BSLShareManager.shareToQQ(title: share.title, msg: share.msg, qqOrZorn: 1, link: share.link, thumb: share.thumb, img: share.img)
    }
    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
