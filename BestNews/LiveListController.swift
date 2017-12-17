//
//  LiveListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class LiveListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var collect = false
    var liveList = LiveModelList()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        reloadLiveList()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        reloadLiveList()
    }
    
    func setupView() {
        let nib = UINib(nibName: "LiveListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .always
        } else {
            self.automaticallyAdjustsScrollViewInsets = true
        }
        tableView.estimatedRowHeight = 260
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.cr.addHeadRefresh {
            self.reloadLiveList()
        }
        
        tableView.cr.addFootRefresh {
            self.loadMoreLiveList()
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LiveListCell
        let data = liveList.list[indexPath.row]
        cell.updateCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let model = liveList.list[indexPath.row]
        let vc = ChatRoomViewController(nibName: "ChatRoomViewController", bundle: nil)
        vc.liveModel = model
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LiveListController {
    
    func reloadLiveList() {
        
        APIRequest.getLivePageListAPI(page: 1, collect: collect) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.liveList.page = 1
            self?.liveList = data as! LiveModelList
            self?.tableView.reloadData()
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
        APIRequest.getLivePageListAPI(page: liveList.page, collect: collect) { [weak self](data) in
            let list = data as? LiveModelList
            if list != nil {
                self?.liveList.list.append(contentsOf: list!.list)
                self?.tableView.cr.endLoadingMore()
            }
        }
    }
}
