//
//  ActivityController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class ActivityController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    ///是否筛选收藏
    var collectFlag = false
    var activityList = ActivityList()
    let tableView = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-50-64), style: .grouped)
    
    /// 1 收藏  2 历史
    var entry = 0
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showCustomTitle(title: "活动")
        if entry == 1 {
            barView.removeFromSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let nib = UINib(nibName: "ActivityCoverCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0.1
        
//        let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_search"), landscapeImagePhone: #imageLiteral(resourceName: "icon_search"), style: .plain, target: self, action: #selector(handleTapSearch(_:)))
//        let messageItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_meassage"), style: .plain, target: self, action: #selector(handleTapMessage(_:)))
//        self.navigationItem.leftBarButtonItem = searchItem
//        self.navigationItem.rightBarButtonItem = messageItem
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        if collectFlag {
            self.showCustomTitle(title: "")
        }
        
        tableView.cr.addHeadRefresh {
            [weak self]in
            self?.reloadData()
        }
        
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreData()
        }
        reloadData()
        emptyView.emptyString = "还没有活动~"
        tableView.addSubview(emptyView)
        emptyView.isHidden = true
    }
    
    
    //MARK: tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityList.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth*(260/375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityCoverCell
        let data = activityList.list[indexPath.row]
        cell.updateCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let activity = activityList.list[indexPath.row]
        let vc = ActivityDetailController(nibName: "ActivityDetailController", bundle: nil)
        vc.activityId = activity.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - actions
    
    func handleTapSearch(_:Any) {
        let vc = HomeSearchController(nibName: "HomeSearchController", bundle: nil)
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func handleTapMessage(_:Any) {
        let vc = MessageCenterController()
        navigationController?.pushViewController(vc, animated: true)
    }


}


/// load data
extension ActivityController {
    
    func reloadData() {
        activityList.total = 0
        activityList.page = 1
        APIRequest.activityListAPI(collect: collectFlag, history: (entry == 2), page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.activityList = data as! ActivityList
            self?.tableView.reloadData()
            self?.emptyView.isHidden = self?.activityList.list.count ?? 0 > 0
        }
    }
    
    func loadMoreData() {
        if activityList.total <= activityList.list.count {
            self.tableView.cr.noticeNoMoreData()
            return
        }
        activityList.page = activityList.page+1
        APIRequest.activityListAPI(collect: collectFlag, history: (entry == 2), page: activityList.page) { [weak self](data) in
            self?.activityList.list.append(contentsOf: (data as! ActivityList).list)
            self?.tableView.cr.endLoadingMore()
            self?.tableView.reloadData()
        }
    }
}
