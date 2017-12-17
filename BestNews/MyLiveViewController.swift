//
//  MyLiveViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/6.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import AlivcLivePusher


class MyLiveViewController: BaseViewController, AlivcLivePusherInfoDelegate, AlivcLivePusherErrorDelegate, AlivcLivePusherNetworkDelegate {
    
    
    let pushUrl = "rtmp://video-center.alivecdn.com/AppName/StreamName?vhost=videolive.xhfmedia.com&auth_key=1521133621-0-0-74b312dd2a24a4bd4abacd4404260324"
    var pusher: AlivcLivePusher?
    var liveModel: LiveModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldClearNavBar = true
        loadLiveDetail()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pusher?.stopPush()
    }

    func initPusher() {
        let config = AlivcLivePushConfig(resolution: .resolution720P)
        config?.fps = AlivcLivePushFPS.FPS30
        config?.targetVideoBitrate = 1200
        config?.minVideoBitrate = 400
        config?.orientation = .portrait
        pusher = AlivcLivePusher(config: config)
        pusher?.setInfoDelegate(self)
        pusher?.setErrorDelegate(self)
        pusher?.setNetworkDelegate(self)
        pusher?.startPreview(self.view)
        
        
    }
    
    
    //MARK: - delegate
    
    func onPushStarted(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onPushStoped(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onPushRestart(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onPushPauesed(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onPushResumed(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onPreviewStarted(_ pusher: AlivcLivePusher!) {
        
        //开始推流
//        pusher.startPush(withURL: pushUrl)
        
        let path = "/\(liveModel!.livepush_appname)/\(liveModel!.livepush_streamname)"
        let key = ConversationClientManager.addAuthorKey(url: path)
        let url = "rtmp://video-center.alivecdn.com\(path)?vhost=videolive.xhfmedia.com&auth_key=\(key)"
        print("正在推流.....\(url)")
        pusher.startPush(withURLAsync: url)
    }
    
    func onPreviewStoped(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onFirstFramePreviewed(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onReconnectStart(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onSDKError(_ pusher: AlivcLivePusher!, error: AlivcLivePushError!) {
        
    }
    
    func onSystemError(_ pusher: AlivcLivePusher!, error: AlivcLivePushError!) {
        
    }
    
    func onReconnectError(_ pusher: AlivcLivePusher!, error: AlivcLivePushError!) {
        
    }
    
    func onConnectFail(_ pusher: AlivcLivePusher!, error: AlivcLivePushError!) {
        
    }
    
    func onReconnectSuccess(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onNetworkPoor(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onSendDataTimeout(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onConnectRecovery(_ pusher: AlivcLivePusher!) {
        
    }
    
    deinit {
        pusher?.destory()
        pusher = nil
    }
}

extension MyLiveViewController {
    
    func loadLiveDetail() {
        APIRequest.liveDetailAPI(id: liveModel!.id) { [weak self](data) in
            self?.liveModel = data as? LiveModel
//            let url = "rtmp://video-center.alivecdn.com/\(self!.liveModel!.livepush_appname)/\(self!.liveModel!.livepush_streamname)"
            
            self?.initPusher()
        }
    }
}
