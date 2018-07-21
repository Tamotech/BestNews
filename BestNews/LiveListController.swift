//
//  LiveListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class LiveListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    
    var collect = false
    var liveList = LiveModelList()
    // 0: 首页 1: 收藏  2: 视频  3 历史
    var entry = 0
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if entry == 2 {
            self.showCustomTitle(title: "视频")
            self.shouldClearNavBar = false
            tableViewTop.constant = 64
        }
        else {
            self.shouldClearNavBar = true
            tableViewTop.constant = 0
        }

        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didreceiveLiveStartNoti(_:)), name: kLiveDidStartNotify, object: nil)
//        reloadLiveList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadLiveList()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 44))
    }
    
    func didreceiveLiveStartNoti(_ sender: Notification) {
        reloadLiveList()
    }
    
    func setupView() {
        let nib = UINib(nibName: "LiveListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.cr.addHeadRefresh {
            self.reloadLiveList()
        }
        
        tableView.cr.addFootRefresh {
            self.loadMoreLiveList()
        }
        
        self.view.addSubview(emptyView)
        emptyView.emptyString = "还没有直播~"
        emptyView.isHidden = true
        
//        let messageItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_message_white"), style: .plain, target: self, action: #selector(handleTapMessageItem(sender:)))
//        navigationItem.rightBarButtonItem = messageItem
    }
    
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveList.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LiveListCell
        let data = liveList.list[indexPath.row]
        cell.updateCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = liveList.list[indexPath.row]
        if model.state == "l2_coming" {
            return
        }
        if model.state == "l1_finish" && model.videopath.count == 0{
            return
        }
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        let vc = ChatRoomViewController(nibName: "ChatRoomViewController", bundle: nil)
        vc.liveModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func handleTapMessageItem(sender: Any) {
        let vc = MessageCenterController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LiveListController {
    
    func reloadLiveList() {
        
        APIRequest.getLivePageListAPI(page: 1, collect: collect, history: (entry == 3)) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.liveList.page = 1
            self?.liveList = data as! LiveModelList
            self?.tableView.reloadData()
            self?.emptyView.isHidden = self?.liveList.list.count ?? 0 > 0
        }
    }
    
    func loadMoreLiveList() {
        if self.liveList.list.count == 0 {
            self.reloadLiveList()
            return
        }
        if self.liveList.list.count >= self.liveList.total {
            tableView.cr.noticeNoMoreData()
            return
        }
        
        liveList.page = liveList.page + 1
        APIRequest.getLivePageListAPI(page: liveList.page, collect: collect, history: (entry == 3)) { [weak self](data) in
            let list = data as? LiveModelList
            if list != nil {
                self?.liveList.list.append(contentsOf: list!.list)
                self?.tableView.cr.endLoadingMore()
                self?.tableView.reloadData()
            }
        }
    }
}
