//
//  ChatRoomViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/16.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import ImagePicker

class ChatRoomViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, ConversationDelegate, RCIMClientReceiveMessageDelegate, UITextFieldDelegate, ImagePickerDelegate, AliyunVodPlayerViewDelegate {
    
    

    
    var token = ""
    var userId = ""
    var liveModel: LiveModel?
    let playerV = AliyunVodPlayerView(frame: CGRect.zero)
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
    
    lazy var segment: BaseSegmentControl = {
        let v = BaseSegmentControl(items: ["主持区", "评论区"], defaultIndex: 0)
        v.frame = self.segParentView.bounds
        self.segParentView.addSubview(v)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldClearNavBar = true
        tableView1.delegate = self
        tableView1.dataSource = self
        tableView1.estimatedRowHeight = 120
        tableView1.rowHeight = UITableViewAutomaticDimension
        let nib1 = UINib.init(nibName: "LiveMessageCell", bundle: nil)
        tableView1.register(nib1, forCellReuseIdentifier: "Cell")
        
        tableView2.delegate = self
        tableView2.dataSource = self
        let nib2 = UINib.init(nibName: "ChatroomMessageCell", bundle: nil)
        tableView2.register(nib2, forCellReuseIdentifier: "Cell")
        tableView1.isHidden = false
        tableView2.isHidden = true
        
        let playerHeight = screenWidth*211/375
        playerV?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: playerHeight)
        playerParentView.addSubview(playerV!)
        playerV?.isLockPortrait = false
        playerV?.isLockScreen = false
        playerV?.setBackHidden(true)
        playerV?.delegate = self
        
        
        segment.selectItemAction = {[weak self](index, name) in
            if index == 0 {
                self?.tableView1.isHidden = false
                self?.tableView2.isHidden = true
            }
            else {
                self?.tableView1.isHidden = true
                self?.tableView2.isHidden = false
            }
            self?.commentBarChangeState(false)
        }
        
        ConversationClientManager.shareInstanse.delegate = self
        contentTf.delegate = self
        contentTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 32))
        contentTf.leftViewMode = .always
        publishBt.isEnabled = false
        commentBarChangeState(false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        loadLiveDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerV?.frame = playerParentView.bounds
    }

    
    func applicationDidEnterForeground() {
        playerV?.frame = playerParentView.bounds
    }
    
    //MARK: - actions
    
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
    }
    
    @IBAction func handleTapRepost(_ sender: UIButton) {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        let share = ShareModel()
        share.title = liveModel?.title ?? "直播标题"
        share.msg = ""
        share.thumb = ""
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
        
        let picker = ImagePickerController()
        picker.imageLimit = 1
        picker.delegate = self
        self.present(picker, animated: true) {
            
        }
    }
    
    @IBAction func handleTapPublish(_ sender: UIButton) {
        
        
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
}

extension ChatRoomViewController {
    
    //MARK: -  tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableView1 {
            return anchorList.count
        }
        else {
            return list.count
        }
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
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true) {
            [weak self] in
            //发送图片消息
            let im = images.first!
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
//                let rcmsg = RCIMClient.shared().getMessage(id)
//                let cmsg = CustomeMessage()
//                cmsg.date = Int(Date().timeIntervalSince1970*1000)
//                cmsg.messageType = "compere"
//                cmsg.img = (rcmsg?.content as! RCImageMessage).imageUrl
//                RCIMClient.shared().sendMessage(RCConversationType.ConversationType_CHATROOM, targetId: self!.liveModel!.chatroom_id_compere, content: cmsg, pushContent: "", pushData: "", success: { (id) in
//                    print("发送消息成功, --- \(id)")
//                
//                    
//                }) { (code, id) in
//                    print("发送消息失败....\(code)")
//                }
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
            if self?.liveModel?.collect == 1 {
                self?.collectBt.setImage(#imageLiteral(resourceName: "star_select"), for: .normal)
            }
            else {
                self?.collectBt.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
            }
            let path = "/\(self!.liveModel!.livepush_appname)/\(self!.liveModel!.livepush_streamname)"
            let key = ConversationClientManager.addAuthorKey(url: path)
            let url = "rtmp://videolive.xhfmedia.com\(path)?auth_key=\(key)"
            
            self?.playerV?.playPrepare(with: URL(string: url)!)
            self?.playerV?.coverUrl = URL(string: self!.liveModel!.preimgpath)
            self?.playerV?.setBackHidden(true)
            self?.playerV?.start()
            if ConversationClientManager.shareInstanse.finishConnectRMSDK {
                self?.initRoomView()
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
        
        list = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_group, oldestMessageId: 120000, count: 20) as! [RCMessage]
        anchorList = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_compere, oldestMessageId: 120000, count: 20) as! [RCMessage]
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
                    //                self.tableView2.setContentOffset(CGPoint.init(x: 0, y: self.tableView2.contentSize.height), animated: true)
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
