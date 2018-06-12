//
//  MyActivityListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/29.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MyActivityListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var ticketList = ActivityTicketDetailList()
    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-64), style: .grouped)
        v.separatorStyle = .none
        v.sectionHeaderHeight = 1
        v.sectionFooterHeight = 1
        v.delegate = self
        v.dataSource = self
        v.estimatedRowHeight = 479
        v.rowHeight = UITableViewAutomaticDimension
        return v
    }()
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
//        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refundTicketSuccessNoti(_:)), name: kActivityRefundSuccessNotify, object: nil)
    }
    
    func setupView() {
        self.showCustomTitle(title: "票券详情")
        let identifier = "ActivityTicketDetailCell"
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.cr.addHeadRefresh {
            [weak self] in
            self?.reloadData()
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreData()
        }
        tableView.cr.beginHeaderRefresh()
        self.view.addSubview(emptyView)
        emptyView.emptyString = "还没有票券~"
        emptyView.isHidden = true
    }

    
    func refundTicketSuccessNoti(_ sender: Notification) {
        self.reloadData()
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ticketList.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityTicketDetailCell
        let ticket = ticketList.list[indexPath.row]
        cell.updateCell(ticket)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ActivityDetailController(nibName: "ActivityDetailController", bundle: nil)
        let ticket = ticketList.list[indexPath.row]
        vc.activityId = ticket.aid
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MyActivityListController {
    
    func reloadData() {
        ticketList.page = 1
        APIRequest.activityTicketDetailList(page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.ticketList = data as! ActivityTicketDetailList
            self?.tableView.reloadData()
            self?.emptyView.isHidden = self?.ticketList.list.count ?? 0 > 0
        }
    }
    
    func loadMoreData() {
        if ticketList.list.count >= ticketList.total {
            tableView.cr.noticeNoMoreData()
            return
        }
        ticketList.page = ticketList.page + 1
        APIRequest.activityTicketDetailList(page: ticketList.page) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
            let list = data as! ActivityTicketDetailList
            self?.ticketList.list.append(contentsOf: list.list)
            self?.tableView.reloadData()
        }
    }
}
