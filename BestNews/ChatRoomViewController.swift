//
//  ChatRoomViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/16.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ChatRoomViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ConversationDelegate, RCIMClientReceiveMessageDelegate, UITextFieldDelegate, AliyunVodPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    

    
    var token = ""
    var userId = ""
    var liveModel: LiveModel?

    
    ///评论区
    var list: [RCMessage] = []
    ///主持区
    var anchorList: [RCMessage] = []
    
    @IBOutlet weak var segParentView: UIView!
    
    @IBOutlet weak var playerParentView: UIView!
    @IBOutlet weak var tableView1: UITableView!
    
    @IBOutlet weak var tableView2: UITableView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var anchorView: UIView!
    
    @IBOutlet weak var anchorAvatar: UIImageView!
    
    @IBOutlet weak var anchorNameLb: UILabel!
    
    @IBOutlet weak var subBt: SubscribeButton!
    
    @IBOutlet weak var commentBar: UIView!
    
    @IBOutlet weak var pencilIcon: UIImageView!
    
    @IBOutlet weak var contentTf: UITextField!
    
    @IBOutlet weak var repostBt: UIButton!
    
    @IBOutlet weak var voteBt: UIButton!
    
    @IBOutlet weak var collectBt: UIButton!
    
    @IBOutlet weak var cameraBt: UIButton!
    
    @IBOutlet weak var publishBt: UIButton!
    
    @IBOutlet weak var contentTfLeft: NSLayoutConstraint!
    
    @IBOutlet weak var anchorHeight: NSLayoutConstraint!
    
    @IBOutlet weak var playerTop: NSLayoutConstraint!
    
    
    
    var backBt: UIButton!
    
    var timer: Timer?
    
    var expandBt: UIButton!
    var emptyView1 = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 400))
    var emptyView2 = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 400))
    
    lazy var segment: BaseSegmentControl = {
        let v = BaseSegmentControl(items: ["主持区", "评论区"], defaultIndex: 0)
        v.frame = self.segParentView.bounds
        self.segParentView.addSubview(v)
        return v
    }()
    
    lazy var aliyunVodPlayer:AliyunVodPlayer = {
        //播放器初始化
        let tempPlayer = AliyunVodPlayer()
        tempPlayer.delegate = self as AliyunVodPlayerDelegate
        return tempPlayer
    }()
    
    var coverView = UIImageView()
    var activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    lazy var controlBar: VideoPlayControlBar = {
        let bar = VideoPlayControlBar.instanceFromXib() as! VideoPlayControlBar
        return bar
    }()
    
    var playerBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldClearNavBar = true
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.estimatedRowHeight = 120
        tableView1.rowHeight = UITableViewAutomaticDimension
        let nib1 = UINib.init(nibName: "LiveMessageCell", bundle: nil)
        tableView1.register(nib1, forCellReuseIdentifier: "Cell")
        //tableView1.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        tableView2.delegate = self
        tableView2.dataSource = self
        let nib2 = UINib.init(nibName: "ChatroomMessageCell", bundle: nil)
        tableView2.register(nib2, forCellReuseIdentifier: "Cell")
        tableView1.isHidden = false
        tableView2.isHidden = true
        //tableView2.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        setPlayerContentView()
        setCacheForPlaying()
        if liveModel != nil && SessionManager.sharedInstance.userId != liveModel!.anchoruserid {
            commentBar.isHidden = true
        }
        
        let swipeup = UISwipeGestureRecognizer(target: self, action: #selector(swipeSegment(_:)))
        swipeup.direction = .up
        segment.addGestureRecognizer(swipeup)
        let swipedown = UISwipeGestureRecognizer(target: self, action: #selector(swipeSegment(_:)))
        swipedown.direction = .down
        segment.addGestureRecognizer(swipedown)
        
        tableView1.addSubview(emptyView1)
        tableView2.addSubview(emptyView2)
        emptyView1.emptyString = "还没有主持图文~"
        emptyView2.emptyString = "还没有评论~"

        
        segment.selectItemAction = {[weak self](index, name) in
            if index == 0 {
                self?.tableView1.isHidden = false
                self?.tableView2.isHidden = true
                if self?.liveModel != nil && SessionManager.sharedInstance.userId != self?.liveModel!.anchoruserid {
                    self?.commentBar.isHidden = true
                }
                else {
                    self?.commentBar.isHidden = false
                }
            }
            else {
                self?.tableView1.isHidden = true
                self?.tableView2.isHidden = false
                if self?.liveModel != nil && SessionManager.sharedInstance.userId != self?.liveModel!.anchoruserid {
                    self?.commentBar.isHidden = false
                }
                else {
                    self?.commentBar.isHidden = true
                }
            }
            self?.commentBarChangeState(false)
        }
        
        ConversationClientManager.shareInstanse.delegate = self
        contentTf.delegate = self
        contentTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 32))
        contentTf.leftViewMode = .always
        publishBt.isEnabled = false
        commentBarChangeState(false)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        loadLiveDetail()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        if self.aliyunVodPlayer.playerView != nil {
//            self.aliyunVodPlayer.playerView.frame  = CGRect(x: 0, y: 0, width: self.playerParentView.bounds.size.width, height: self.playerParentView.bounds.size.height)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.aliyunVodPlayer.stop()
//        if self.aliyunVodPlayer.playerView != nil {
//            self.aliyunVodPlayer.playerView.removeFromSuperview()
//        }
//        self.aliyunVodPlayer.release()
        
    }

    //MARK:析构函数
    deinit {
        if timer != nil {
            timer?.invalidate()
            self.timer = nil
        }

        self.aliyunVodPlayer.stop()
        if self.aliyunVodPlayer.playerView != nil {
            self.aliyunVodPlayer.playerView.removeFromSuperview()
        }
        self.aliyunVodPlayer.release()
        print("back click")
    }
   
    ///设置播放视图
    private func setPlayerContentView(){
        
        let h = screenWidth*211/375
        let playerView = aliyunVodPlayer.playerView
        playerView?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: h)
        keyWindow!.addSubview(playerView!)
    
        
        coverView.frame = playerView!.bounds
        playerView?.addSubview(coverView)
        if let url = URL(string: liveModel!.preimgpath) {
            let rc = ImageResource(downloadURL: url)
            coverView.kf.setImage(with: rc)
        }
        coverView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
        
        playerView?.addSubview(activity)
        activity.snp.makeConstraints { (make) in
            make.center.equalTo(playerView!.snp.center)
        }
        activity.startAnimating()
        activity.hidesWhenStopped = true
        
        backBt = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
        backBt.setImage(#imageLiteral(resourceName: "back-white"), for: UIControlState.normal)
        backBt.addTarget(self, action: #selector(handleTapBackBt(_:)), for: UIControlEvents.touchUpInside)
        playerView?.addSubview(backBt)
        backBt.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        expandBt = UIButton(frame: CGRect(x: 0, y: 20, width: 50, height: 40))
        expandBt.setImage(#imageLiteral(resourceName: "expand_m252"), for: UIControlState.normal)
        expandBt.addTarget(self, action: #selector(handleTapExpandBt(_:)), for: UIControlEvents.touchUpInside)
        playerView?.addSubview(expandBt)
        expandBt.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.top.equalTo(20)
            make.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        playerBtn = UIButton()
        playerBtn?.setImage(#imageLiteral(resourceName: "iconPlayM2-5"), for: UIControlState.normal)
        playerBtn?.addTarget(self, action: #selector(handleTapPlayerBtn(_:)), for: UIControlEvents.touchUpInside)
        playerView?.addSubview(playerBtn!)
        playerBtn?.snp.makeConstraints({ (make) in
            make.size.equalTo(CGSize(width: 50, height: 50))
            make.center.equalTo(playerView!.snp.center)
        })
        playerBtn?.isHidden = true
        
        playerView?.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapPlayerBtn(_:)))
        playerView?.addGestureRecognizer(tap)
        
        playerView?.addSubview(controlBar)
        controlBar.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(40)
        }
        controlBar.isHidden = true
        controlBar.videoProgress = {
            [weak self](progress) in
            let ctime = self!.aliyunVodPlayer.duration * TimeInterval(progress)
            self?.aliyunVodPlayer.seek(toTime: ctime)
            self?.aliyunVodPlayer.resume()
            
        }
        
    }
    
    
    
    //缓存设置
    private func setCacheForPlaying(){
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        aliyunVodPlayer.setPlayingCache(false, saveDir: path, maxSize: 30, maxDuration: 10000)
    }
    
    
    //MARK: - actions
    
    
    func handleTapPlayerBtn(_ sender: UIButton) {
        if self.aliyunVodPlayer.playerState() == AliyunVodPlayerState.play {
            self.aliyunVodPlayer.pause()
            self.playerBtn?.isHidden = false
        }
        else if self.aliyunVodPlayer.playerState() == AliyunVodPlayerState.pause {
            self.aliyunVodPlayer.resume()
            self.playerBtn?.isHidden = true
        }
    }
    
    @IBAction func handleTapArrow(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            anchorHeight.constant = 0
            anchorView.isHidden = true
        }
        else {
            anchorHeight.constant = 44
            anchorView.isHidden = false

        }
    }
    
    @IBAction func handleTapSubbt(_ sender: SubscribeButton) {
        
        if self.liveModel?.subscribe == 0 {
            sender.switchStateSub(true)
            APIRequest.subscriptChannelAPI(id: liveModel!.anchoruserid, type: "user") { [weak self](success) in
                if !success {
                    self?.liveModel?.subscribe = 0
                }
                else {
                    self?.liveModel?.subscribe = 1
                }
            }
        }
        else {
            sender.switchStateSub(false)
            APIRequest.cancelSubscriptChannelAPI(id: liveModel!.anchoruserid, type: "user", result: { [weak self](success) in
                if !success {
                    self?.liveModel?.subscribe = 1
                }
                else {
                    self?.liveModel?.subscribe = 0
                }
            })
        }
    }
    
    @IBAction func handleTapRepost(_ sender: UIButton) {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        let share = ShareModel()
        vc.share = share
        self.presentr.viewControllerForContext = self
        self.presentr.shouldIgnoreTapOutsideContext = false
        self.presentr.dismissOnTap = true
        self.customPresentViewController(self.presentr, viewController: vc, animated: true) {
            
        }
    }
    
    @IBAction func handleTapVote(_ sender: UIButton) {
        
        voteBt.setImage(#imageLiteral(resourceName: "vote_select"), for: .normal)
        let frame = self.view.convert(voteBt.frame, from: voteBt.superview)
        let icon = UIImageView(frame: frame)
        self.view.addSubview(icon)
        UIView.animateKeyframes(withDuration: 1.0, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModePaced, animations: {
            icon.y = icon.y - 200
            icon.alpha = 0
        }) { (success) in
            icon.removeFromSuperview()
        }
        
        let path = "/zan/zan.htm?id=\(liveModel?.id ?? "")"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
    }
    
    @IBAction func handleTapCollect(_ sender: UIButton) {
        if liveModel?.collect == 0 {
            APIRequest.collectAPI(id: liveModel!.id, type: "live", result: {[weak self] (success) in
                if success {
                    self?.liveModel?.collect = 1
                    self?.collectBt.setImage(#imageLiteral(resourceName: "star_select"), for: .normal)
                }
                else {
                    self?.liveModel?.collect = 0
                    self?.collectBt.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
                }
            })
        }
        else {
            APIRequest.cancelCollectAPI(id: liveModel!.id, type: "live", result: { [weak self] (success) in
                if !success {
                    self?.liveModel?.collect = 1
                    self?.collectBt.setImage(#imageLiteral(resourceName: "star_select"), for: .normal)
                }
                else {
                    self?.liveModel?.collect = 0
                    self?.collectBt.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
                }
            })
        }
    }
    
    @IBAction func handleTapCamera(_ sender: UIButton) {
        
        let picker = ImageSelectSheetView.instanceFromXib() as! ImageSelectSheetView
        picker.actionCallback = {
            [weak self](type) in
            DispatchQueue.main.async {
                if type == "Camera" {
                    let picker = UIImagePickerController()
                    picker.allowsEditing = true
                    picker.sourceType = .camera
                    picker.delegate = self
                    picker.modalPresentationStyle = .overCurrentContext
                    self?.modalPresentationStyle = .currentContext
                    self?.present(picker, animated: true, completion: nil)
                    self?.aliyunVodPlayer.playerView.isHidden = true
                }
                else if type == "Album" {
                    let picker = UIImagePickerController()
                    picker.allowsEditing = true
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    picker.modalPresentationStyle = .overCurrentContext
                    self?.modalPresentationStyle = .currentContext
                    self?.present(picker, animated: true, completion: nil)
                    self?.aliyunVodPlayer.playerView.isHidden = true
                }
                else if type == "Cancel" {
                    self?.aliyunVodPlayer.playerView.isHidden = false
                }
            }
        }
        picker.show()
        
    }
    
    @IBAction func handleTapPublish(_ sender: UIButton) {
        
        let content = contentTf.text
        if content?.count == 0 {
            return
        }
        
        //敏感词过滤
        for w in SessionManager.sharedInstance.sensitiveWords {
            if content!.contains(w) {
                BLHUDBarManager.showError(msg: "包含敏感词汇~")
                return
            }
        }
        
        if segment.currentIndex == 0 {
            ///主持区
            let content = RCTextMessage(content: contentTf.text)
            var img = SessionManager.sharedInstance.userInfo?.headimg
            if img == nil || img == "" {
                img = "http://"
            }
            content?.content = contentTf.text
            content?.extra = "\(SessionManager.sharedInstance.userInfo?.name ?? "用户");\(img!);\(Int(Date().timeIntervalSince1970*1000))"
//            let msg = CustomeMessage()
//            msg.content = contentTf.text
//            msg.messageType = "compere"
//            msg.date = Int(Date().timeIntervalSince1970)*1000
            
            RCIMClient.shared().sendMessage(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_compere, content: content, pushContent: contentTf.text!, pushData: "", success: { [weak self](id) in
                print("发送消息成功, --- \(id)")
                DispatchQueue.main.async {
                    self?.contentTf.text =  ""
                    let msg = RCMessage(type: RCConversationType.ConversationType_CHATROOM, targetId: self?.liveModel?.chatroom_id_compere, direction: RCMessageDirection.MessageDirection_RECEIVE, messageId: id, content: content!)
                    self?.onReceived(msg, left: 0, object: nil)
                }
                
            }) { (code, id) in
                print("发送消息失败....\(code)")
            }
        }
        else {
            ///评论区
            let content = RCTextMessage(content: contentTf.text)
            var img = SessionManager.sharedInstance.userInfo?.headimg
            if img == nil || img == "" {
                img = "http://"
            }
            content?.extra = "\(SessionManager.sharedInstance.userInfo?.name ?? "用户");\(img!);\(Int(Date().timeIntervalSince1970*1000))"
//            let msg = CustomeMessage()
//            msg.content = contentTf.text
//            msg.messageType = "visitor"
//            msg.date = Int(Date().timeIntervalSince1970)*1000
            
            RCIMClient.shared().sendMessage(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_group, content: content, pushContent: contentTf.text!, pushData: "", success: { [weak self](id) in
                print("发送消息成功, --- \(id)")
                DispatchQueue.main.async {
                    self?.contentTf.text =  ""
                    let msg = RCMessage(type: RCConversationType.ConversationType_CHATROOM, targetId: self?.liveModel?.chatroom_id_group, direction: RCMessageDirection.MessageDirection_RECEIVE, messageId: id, content: content!)
                    self?.onReceived(msg, left: 0, object: nil)
                }
                
            }) { (code, id) in
                print("发送消息失败....\(code)")
            }
        }
    }
    
    
    
    func commentBarChangeState(_ editing: Bool) {
        if editing {
            pencilIcon.isHidden = true
            contentTfLeft.constant = 15
            contentTf.backgroundColor = UIColor(hexString: "#f4f4f4")
            repostBt.isHidden = true
            voteBt.isHidden = true
            collectBt.isHidden = true
            cameraBt.isHidden = true
            publishBt.isHidden = false
        }
        else {
            pencilIcon.isHidden = false
            contentTfLeft.constant = 45
            contentTf.backgroundColor = UIColor(hexString: "#ffffff")
            repostBt.isHidden = false
            voteBt.isHidden = false
            collectBt.isHidden = false
            cameraBt.isHidden = segment.currentIndex == 1
            publishBt.isHidden = true
        }
        
    }
    
    @IBAction func handleTapBackBt(_ sender: UIButton) {
        
        self.aliyunVodPlayer.stop()
        if self.aliyunVodPlayer.playerView != nil {
            self.aliyunVodPlayer.playerView.removeFromSuperview()
        }
        self.aliyunVodPlayer.release()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleTapExpandBt(_ sender: UIButton) {
        
        if sender.tag == 0 {
            //旋转90
            sender.tag = 1
            sender.setImage(#imageLiteral(resourceName: "quit_m258b"), for: UIControlState.normal)
            let transform = self.aliyunVodPlayer.playerView.transform
            self.aliyunVodPlayer.playerView.transform = transform.rotated(by: CGFloat(Double.pi/2))
            self.aliyunVodPlayer.playerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        }
        else {
            sender.tag = 0
            sender.setImage(#imageLiteral(resourceName: "expand_m252"), for: UIControlState.normal)
            let transform = self.aliyunVodPlayer.playerView.transform
            self.aliyunVodPlayer.playerView.transform = transform.rotated(by: CGFloat(-Double.pi/2))
            self.aliyunVodPlayer.playerView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*211/375)
        }
    }
    
    
    ///滑动评论/主持一栏
    func swipeSegment(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            UIView.animate(withDuration: 0.3, animations: {
                self.playerTop.constant = -self.playerParentView.height
                self.aliyunVodPlayer.playerView.y = -self.aliyunVodPlayer.playerView.height
//                self.view.layoutIfNeeded()
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.playerTop.constant = 0
                self.aliyunVodPlayer.playerView.y = 0
//                self.view.layoutIfNeeded()
            })
        }
    }
    
}

extension ChatRoomViewController {
    
    //MARK: -  tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            emptyView1.isHidden = anchorList.count > 0
            return anchorList.count
        }
        else {
            emptyView2.isHidden = list.count > 0
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableView1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LiveMessageCell
            let msg = anchorList[indexPath.row]
            cell.updateCell(msg)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatroomMessageCell
            let msg = list[indexPath.row]
            cell.updateCell(msg)
            return cell
        }
    }
    
    
    //MARK: - textfield
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        commentBarChangeState(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        commentBarChangeState(false)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 0 {
            publishBt.isEnabled = true
            publishBt.alpha = 1
        }
        else {
            publishBt.isEnabled = false
            publishBt.alpha = 0.7

        }
        return true
    }
    
    
    //MARK: - imagepicker
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true) {
            [weak self] in
            self?.aliyunVodPlayer.playerView.isHidden = false
            //发送图片消息
            let im = info[UIImagePickerControllerEditedImage] as! UIImage
            let data = UIImageJPEGRepresentation(im, 0.7)
            let msg = RCImageMessage(imageData: data)
            //图片尺寸已附加字段形式附上
            var img = SessionManager.sharedInstance.userInfo?.headimg
            if img == nil || img == "" {
                img = "http://"
            }
            msg?.extra = "\(SessionManager.sharedInstance.userInfo?.name ?? "用户");\(img!);\(Int(Date().timeIntervalSince1970*1000));\(im.size.width);\(im.size.height)"
            
            let rcmsg = RCMessage(type: RCConversationType.ConversationType_CHATROOM, targetId: self?.liveModel!.chatroom_id_compere, direction: RCMessageDirection.MessageDirection_RECEIVE, messageId: 120000, content: msg)
            
            self?.onReceived(rcmsg!, left: 0, object: "")
            
            RCIM.shared().sendMediaMessage(RCConversationType.ConversationType_CHATROOM, targetId: self?.liveModel!.chatroom_id_compere, content: msg, pushContent: "", pushData: "", progress: { (progress, id) in
                print("上传图片中...\(progress)")
            }, success: { (id) in
                print("上传图片成功...")
            }, error: { (errcode, id) in
                print("上传图片失败...\(errcode)")
            }, cancel: { (id) in
                
            })
        }
        
    }
    
    
    //MARK: - playerViewDelegate
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, fullScreen isFullScreen: Bool) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, lockScreen isLockScreen: Bool) {
        
    }
    
    func onBackViewClick(with playerView: AliyunVodPlayerView!) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onStop currentPlayTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onPause currentPlayTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onSeekDone seekDoneTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onResume currentPlayTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onVideoQualityChanged quality: AliyunVodPlayerVideoQuality) {
        
    }
}

extension ChatRoomViewController {
    
    func loadLiveDetail() {
        APIRequest.liveDetailAPI(id: liveModel!.id) { [weak self](data) in
            self?.liveModel = data as? LiveModel
            
            self?.titleLb.text = self?.liveModel?.title
            self?.dateLb.text = self?.liveModel?.dateStr()
            if let url = URL(string: self!.liveModel!.anchorheadimg) {
                let rc = ImageResource(downloadURL: url)
                self?.anchorAvatar.kf.setImage(with: rc)
            }
            self?.anchorNameLb.text = self?.liveModel?.anchorusername
            if self?.liveModel?.subscribe == 1 {
                self?.subBt.switchStateSub(true)
            }
            else {
                self?.subBt.switchStateSub(false)
            }
            if self?.liveModel?.collect == 1 {
                self?.collectBt.setImage(#imageLiteral(resourceName: "star_select"), for: .normal)
            }
            else {
                self?.collectBt.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
            }
            let path = "/\(self!.liveModel!.livepush_appname)/\(self!.liveModel!.livepush_streamname)"
            let key = ConversationClientManager.addAuthorKey(url: path)
            
        
            if self?.liveModel?.state == "l1_finish" {
                self?.controlBar.isHidden = false
                if self?.liveModel?.videopath == "" {
                    self?.liveModel?.videopath = "http://cloud.video.taobao.com/play/u/2712925557/p/1/e/6/t/1/40050769.mp4"
                }
                var videoPath = self?.liveModel?.videopath
                if (self?.liveModel?.videopath.contains(","))! {
                    videoPath = self?.liveModel?.videopath.components(separatedBy: ",").last
                }
                
                self?.aliyunVodPlayer.prepare(with: URL(string: videoPath!)!)
                self?.aliyunVodPlayer.start()
                if ConversationClientManager.shareInstanse.finishConnectRMSDK {
                    self?.initRoomView()
                }
            }
            else {
                self?.controlBar.isHidden = true
                let url = "rtmp://videolive.xhfmedia.com\(path)?auth_key=\(key)"
                self?.aliyunVodPlayer.prepare(with: URL(string: url)!)
                self?.aliyunVodPlayer.start()
                if ConversationClientManager.shareInstanse.finishConnectRMSDK {
                    self?.initRoomView()
                }
            }
            DispatchQueue.main.async {
                self?.activity.startAnimating()
            }
            self?.timer = Timer(timeInterval: 1, target: self!, selector: #selector(self?.timerEvent(_:)), userInfo: nil, repeats: true)
            RunLoop.main.add(self!.timer!, forMode: RunLoopMode.commonModes)
            self?.timer?.fire()
        }
    }
    
    func timerEvent(_ sender: Timer) {
        
        if self.aliyunVodPlayer.duration > 0 {
            let progress = self.aliyunVodPlayer.currentTime/self.aliyunVodPlayer.duration
            controlBar.slider.setValue(Float(progress), animated: true)
            let duration = self.aliyunVodPlayer.duration
            let currentT = self.aliyunVodPlayer.currentTime
            let m1 = Int(duration)/60
            let s1 = Int(duration)%60
            let m2 = Int(currentT)/60
            let s2 = Int(currentT)%60
            let t1 = String.init(format: "%.2d:%.2d/%.2d:%.2d", m1, s1, m2, s2)
            self.controlBar.timeLb.text = t1
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentTime" {
            
            if self.aliyunVodPlayer.duration > 0 {
                let progress = self.aliyunVodPlayer.currentTime/self.aliyunVodPlayer.duration
                controlBar.slider.setValue(Float(progress), animated: true)
                
                let duration = self.aliyunVodPlayer.duration
                let currentT = self.aliyunVodPlayer.currentTime
                let m1 = Int(duration)/60
                let s1 = Int(duration)%60
                let m2 = Int(currentT)/60
                let s2 = Int(currentT)%60
                let t1 = String.init(format: "%.2d:%.2d/%.2d:%.2d", m1, s1, m2, s2)
                self.controlBar.timeLb.text = t1

            }
        }
    }
    
    func finishConnectSDK(success: Bool) {
        if success {
            DispatchQueue.main.async {
                if self.liveModel!.chatroom_id_group.count > 0 {
                    self.initRoomView()
                }
                else {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.finishConnectSDK(success: true)
                    })
                }
            }
        }
    }
    
    func initRoomView() {
        
        ///聊天室 群组
        RCIMClient.shared().joinChatRoom(liveModel!.chatroom_id_compere, messageCount: 20, success: {
            print("加入聊天室成功")
        }) { (errCode) in
            print("加入聊天室失败----\(errCode)")
        }
        ///聊天室 主持人区
        RCIMClient.shared().joinChatRoom(liveModel!.chatroom_id_group, messageCount: 20, success: {
            print("加入主持人聊天室成功")
        }) { (errCode) in
            print("加入主持人聊天室失败----\(errCode)")
        }
        
//        list = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_group, oldestMessageId: 120000, count: 20) as! [RCMessage]
//        anchorList = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_compere, oldestMessageId: 120000, count: 20) as! [RCMessage]
        RCIMClient.shared().setReceiveMessageDelegate(self, object: "comment")
        RCIMClient.shared().setReceiveMessageDelegate(self, object: "comment")
        
        
    }
    
    /// 接收到消息
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
        
        if message.targetId == liveModel!.chatroom_id_group {
            list.append(message)
            DispatchQueue.main.async {
                self.tableView2.reloadData()
                //滚动到底部
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                    self.tableView2.scrollToRow(at: IndexPath.init(row: self.list.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
                })
            }
        }
        else if message.targetId == liveModel!.chatroom_id_compere {
            anchorList.append(message)
            DispatchQueue.main.async {
                self.tableView1.reloadData()
                //滚动到底部
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {
                    self.tableView1.scrollToRow(at: IndexPath.init(row: self.anchorList.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
                })
            }
        }
        
    }
    
}



extension ChatRoomViewController {
    
    
    //MARK:播放器代理方法
    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, onEventCallback event: AliyunVodPlayerEvent) {
        vodPlayer.playerView.bringSubview(toFront: coverView)
        vodPlayer.playerView.bringSubview(toFront: backBt)
        vodPlayer.playerView.bringSubview(toFront: expandBt)
        if event == AliyunVodPlayerEvent.stop ||
            event == AliyunVodPlayerEvent.finish {
            coverView.isHidden = false
        }
        else if event == AliyunVodPlayerEvent.firstFrame {
            coverView.isHidden = true
            activity.stopAnimating()
        }
        
    }
    
    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, playBack errorModel: ALPlayerVideoErrorModel!) {
        print("播放失败----- \(errorModel.debugDescription)")
        vodPlayer.playerView.bringSubview(toFront: backBt)
        vodPlayer.playerView.bringSubview(toFront: expandBt)
        coverView.isHidden = false
    }
    
    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, willSwitchTo quality: AliyunVodPlayerVideoQuality) {
        
    }
    
    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, didSwitchTo quality: AliyunVodPlayerVideoQuality) {
        
    }
    
    func vodPlayer(_ vodPlayer: AliyunVodPlayer!, failSwitchTo quality: AliyunVodPlayerVideoQuality) {
        
    }
    
    
    
    
}
