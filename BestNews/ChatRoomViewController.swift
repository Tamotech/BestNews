//
//  ChatRoomViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/16.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConversationDelegate, RCIMClientReceiveMessageDelegate, UITextFieldDelegate {

    
    var token = ""
    var userId = ""
    var liveModel: LiveModel?
    let playerV = AliyunVodPlayerView(frame: CGRect.zero)
    var list: [RCMessage] = []
    
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

        
        tableView1.delegate = self
        tableView1.dataSource = self
        let nib = UINib.init(nibName: "ChatroomMessageCell", bundle: nil)
        tableView1.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView2.delegate = self
        tableView2.dataSource = self
        tableView2.register(nib, forCellReuseIdentifier: "Cell")

        
        let playerHeight = screenWidth*211/375
        playerV?.frame = CGRect(x: 0, y: 0, width: screenWidth, height: playerHeight)
        playerParentView.addSubview(playerV!)
        
        
        segment.selectItemAction = {[weak self](index, name) in
            if index == 0 {
                self?.tableView1.isHidden = false
                self?.tableView2.isHidden = true
            }
            else {
                self?.tableView1.isHidden = true
                self?.tableView2.isHidden = false
            }
        }
        
        ConversationClientManager.shareInstanse.delegate = self
        contentTf.delegate = self
        contentTf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 32))
        contentTf.leftViewMode = .always
        publishBt.isEnabled = false
        commentBarChangeState(false)
        
        loadLiveDetail()
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
    }
    
    @IBAction func handleTapVote(_ sender: UIButton) {
    }
    
    @IBAction func handleTapCollect(_ sender: UIButton) {
    }
    
    @IBAction func handleTapCamera(_ sender: UIButton) {
    }
    
    @IBAction func handleTapPublish(_ sender: UIButton) {
        
        let content = RCTextMessage(content: contentTf.text)
        RCIMClient.shared().sendMessage(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_compere, content: content!, pushContent: contentTf.text!, pushData: "", success: { [weak self](id) in
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChatroomMessageCell
        let msg = list[indexPath.row]
        cell.updateCell(msg)
        return cell
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
    
}

extension ChatRoomViewController {
    
    func loadLiveDetail() {
        APIRequest.liveDetailAPI(id: liveModel!.id) { [weak self](data) in
            self?.liveModel = data as? LiveModel
            
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
        
    RCIMClient.shared().joinChatRoom(liveModel!.chatroom_id_compere, messageCount: 20, success: {
            print("加入聊天室成功")
        }) { (errCode) in
            print("加入聊天室失败----\(errCode)")
        }
        
        list = RCIMClient.shared().getHistoryMessages(RCConversationType.ConversationType_CHATROOM, targetId: liveModel?.chatroom_id_compere, oldestMessageId: 120000, count: 20) as! [RCMessage]
        RCIMClient.shared().setReceiveMessageDelegate(self, object: "")
        
        
    }
    
    /// 接收到消息
    func onReceived(_ message: RCMessage!, left nLeft: Int32, object: Any!) {
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
}
