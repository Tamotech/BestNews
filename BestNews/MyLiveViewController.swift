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
    var config: AlivcLivePushConfig?
    var liveModel: LiveModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldClearNavBar = true
        loadLiveDetail()
        
        
        //开始直播
        let path = "/live/liveStart.htm?id=\(liveModel?.id ?? "")"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code != 0 {
                BLHUDBarManager.showError(msg: msg)
            }
        }
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        ///屏幕方向
        let app = UIApplication.shared.delegate! as! AppDelegate
        app.allowRotation = true
        UIDevice.switchOritation(UIInterfaceOrientation.landscapeRight)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.barView.removeFromSuperview()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        pusher?.stopPush()
        UIApplication.shared.isIdleTimerDisabled = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        let app = UIApplication.shared.delegate! as! AppDelegate
        app.allowRotation = false
        UIDevice.switchOritation(UIInterfaceOrientation.portrait)
    }

    func initPusher() {
        let config = AlivcLivePushConfig(resolution: .resolution720P)
        config?.fps = AlivcLivePushFPS.FPS30
        config?.targetVideoBitrate = 1200
        config?.minVideoBitrate = 400
        ///判断当前手机方向
        config?.orientation = .landscapeRight
        config?.cameraType = AlivcLivePushCameraType.back
        self.config = config
        pusher = AlivcLivePusher(config: config)
        pusher?.setInfoDelegate(self)
        pusher?.setErrorDelegate(self)
        pusher?.setNetworkDelegate(self)
        pusher?.startPreview(self.view)
        
        let maskLayer  = UIImageView(image: #imageLiteral(resourceName: "nav-black-layer"))
        self.view.addSubview(maskLayer)
        maskLayer.isUserInteractionEnabled = true
        maskLayer.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(64)
        }
        let moreBtn = UIButton(type: UIButtonType.custom)
        moreBtn.setImage(#imageLiteral(resourceName: "more-dot"), for: UIControlState.normal)
        moreBtn.addTarget(self, action: #selector(handleTapMoreBtn(_:)), for: UIControlEvents.touchUpInside)
        maskLayer.addSubview(moreBtn)
        moreBtn.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(0)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        let switchBtn = UIButton(type: UIButtonType.custom)
        switchBtn.setImage(#imageLiteral(resourceName: "switchCamera"), for: UIControlState.normal)
        switchBtn.addTarget(self, action: #selector(handleSwitchCamerabtn(_:)), for: UIControlEvents.touchUpInside)
        maskLayer.addSubview(switchBtn)
        switchBtn.snp.makeConstraints { (make) in
            make.right.equalTo(moreBtn.snp.left).offset(-5)
            make.centerY.equalTo(moreBtn.snp.centerY)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(#imageLiteral(resourceName: "back-white"), for: UIControlState.normal)
        backBtn.addTarget(self, action: #selector(handleTapBackBtn(_:)), for: UIControlEvents.touchUpInside)
        maskLayer.addSubview(backBtn)
        backBtn.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(0)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
    }
    
    @objc func handleTapMoreBtn(_ sender: UIButton) {
        
        
        let sheet = EndLiveAlertView.instanceFromXib() as! EndLiveAlertView
        sheet.show()
        sheet.actionCallback = {
            [weak self](type) in
            if type == "End" {
                
                DispatchQueue.main.async {
                    let alert = XHAlertController()
                    alert.modalPresentationStyle = .overCurrentContext
                    self?.modalPresentationStyle = .currentContext
                    alert.tit = "确认结束直播?"
                    alert.msg = "确认结束后, 直播将会就此停止,\n切不可继续直播"
                    alert.callback = {
                        [weak self](buttonType)in
                        if buttonType == 0 {
                            let path = "/live/liveFinish.htm?id=\(self?.liveModel?.id ?? "")"
                            APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
                                if code != 0 {
                                    BLHUDBarManager.showError(msg: msg)
                                }
                                else {
                                    self?.pusher?.stopPush()
                                    self?.pusher?.destory()
                                    self?.pusher = nil
                                    self?.navigationController?.popViewController(animated: true)
                                }
                            }
                            
                        }
                    }
                    self?.present(alert, animated: false, completion: nil)
                    
                }
            }
        }
        
    }
    
    
    @objc func handleSwitchCamerabtn(_ sender: Any) {
        self.pusher?.switchCamera()
    }
    
    @objc func handleTapBackBtn(_ sender: UIButton) {
        self.pusher?.stopPush()
        self.pusher?.destory()
        self.pusher = nil
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
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
        
//        let path = "/\(liveModel!.livepush_appname)/\(liveModel!.livepush_streamname)"
//        let key = ConversationClientManager.addAuthorKey(url: path)
//        let url = "rtmp://video-center.alivecdn.com\(path)?vhost=videolive.xhfmedia.com&auth_key=\(key)"
        APIRequest.getLivePushURL(liveID: liveModel!.id) { [weak self] (url) in
            if url != nil {
                DispatchQueue.main.async {
                    print("正在推流.....\(url!)")
                    self?.pusher?.startPush(withURLAsync: url as? String)
                }
            }
        }
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
        pusher?.stopPush()
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
    
    func onConnectionLost(_ pusher: AlivcLivePusher!) {
        
    }
    
    func onPushURLAuthenticationOverdue(_ pusher: AlivcLivePusher!) -> String! {
        return ""
    }
    
    func onSendSeiMessage(_ pusher: AlivcLivePusher!) {
        
    }
        
}
