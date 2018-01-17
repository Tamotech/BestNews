//
//  MessageCenterController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MessageCenterController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tableView = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-64), style: .grouped)
    var messageList = MessageList()
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.reloadArticleList()
    }
    
    func setupView() {
        
        self.showCustomTitle(title: "消息中心")
        let moreItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconoval"), style: .plain, target: self, action: #selector(handleTapHandleMoreItem(_:)))
        navigationItem.rightBarButtonItem = moreItem
        
        let nib = UINib(nibName: "MessageCenterListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 85
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        tableView.cr.addHeadRefresh {
            [weak self] in
            self?.reloadArticleList()
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
        self.view.addSubview(emptyView)
        emptyView.emptyString = "还没有消息~"

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            
        }
    }

    //MARK: - actions
    
    func handleTapHandleMoreItem(_:Any) {
        
    }

    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.isHidden = messageList.list.count > 0
        return messageList.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessageCenterListCell
        let msg = messageList.list[indexPath.row]
        cell.updateCell(msg)
        return cell
    }
}

extension MessageCenterController {
    
    func reloadArticleList() {
        
        APIRequest.messageListAPI(category: nil, page: 1, row: 20) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.messageList.page = 1
            self?.messageList = data as! MessageList
            self?.tableView.reloadData()
        }
    }
    
    func loadMoreArticleList() {
        if self.messageList.list.count == 0 {
            self.reloadArticleList()
            self.tableView.cr.endLoadingMore()
            return
        }
        messageList.page = messageList.page + 1
        APIRequest.messageListAPI(category: nil, page: messageList.page, row: 20) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
            let list = data as? MessageList
            if list != nil {
                self?.messageList.list.append(contentsOf: list!.list)
                self?.tableView.reloadData()
            }
        }
    }
}
