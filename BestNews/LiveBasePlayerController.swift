//
//  LiveBasePlayerController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import AliyunVodPlayerViewSDK

class LiveBasePlayerController: BaseViewController {

//    let url = "http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"
    let url = "rtmp://videolive.xhfmedia.com/AppName/StreamName?auth_key=1512494547-0-0-4092e467db2e3c041ee47dda32ca5e02"
    let playerV = AliyunVodPlayerView(frame: CGRect.zero)
    
    @IBOutlet weak var playerView: UIView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var subscribeBtn: SubscribeButton!
    
    @IBOutlet weak var segmentView: UIView!
    
    
    lazy var segment: BaseSegmentControl = {
        let v = BaseSegmentControl(items: ["主持区", "评论区"], defaultIndex: 0)
        v.frame = self.segmentView.bounds
        self.segmentView.addSubview(v)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        shouldClearNavBar = true
        segment.selectItemAction = {[weak self](index, name) in
            
        }
        
        playerV?.frame = playerView.bounds
        playerView.addSubview(playerV!)
        playerV?.playPrepare(with: URL(string: url)!)
        playerV?.start()
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playerV?.stop()
    }
    
    @IBAction func handleTapSubscibe(_ sender: SubscribeButton) {
    
    }
    

}
