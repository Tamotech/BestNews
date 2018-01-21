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
            BSLShareManager.shareToWechat(link: self!.share.link, title: self!.share.title, msg: self!.share.msg, thumb: self!.share.thumb, type: 0)
        }
    }
    
    @IBAction func handleTapTimelineBtn(_ sender: UIButton) {
        dismiss(animated: true) {
            [weak self] in
            BSLShareManager.shareToWechat(link: self!.share.link, title: self!.share.title, msg: self!.share.msg, thumb: self!.share.thumb, type: 1)
        }
    }
    
    @IBAction func handleTapWeiboBtn(_ sender: UIButton) {
    }
    
    @IBAction func handleTapQQBtn(_ sender: UIButton) {
        
        var data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "logo"), 1)
        if share.thumb.count>0 {
            do {
                data = try Data(contentsOf: URL(string: share.thumb)!)
            }
            catch {
                
            }
        }
        let obj = QQApiNewsObject(url: URL(string: share.link)!, title: share.title, description: share.msg, previewImageData: data!, targetContentType: QQApiURLTargetTypeNews)
        
        let send = SendMessageToQQReq(content: obj!)
        let sent = QQApiInterface.send(send)
        print(sent)
        
    }
    
    @IBAction func handleTapQQZornBtn(_ sender: UIButton) {
        var data = UIImageJPEGRepresentation(#imageLiteral(resourceName: "logo"), 1)
        if share.thumb.count>0 {
            do {
                data = try Data(contentsOf: URL(string: share.thumb)!)
            }
            catch {
                
            }
        }
        let obj = QQApiNewsObject(url: URL(string: share.link)!, title: share.title, description: share.msg, previewImageData: data!, targetContentType: QQApiURLTargetTypeNews)
        
        let send = SendMessageToQQReq(content: obj!)
        let sent = QQApiInterface.sendReq(toQZone: send)
        print(sent)
    }
    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
