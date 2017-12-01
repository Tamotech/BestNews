//
//  OrgnizationListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class OrgnizationListController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //// 0 机构  1 名人  2 金融
    var type: Int = 0
    // 0  圈子  1 机构
    var entry = 0
    var ognizationList = OgnizationList()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        
        let nib = UINib(nibName: "SubscriptListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ColumeCell")
        tableView.rowHeight = 95
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        tableView.cr.addHeadRefresh {
            [weak self] in
            self?.reloadOgnizationList()
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreOgnizationList()
        }
        
        reloadOgnizationList()
        
        if entry == 0 {
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
        else {
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .always
            } else {
                self.automaticallyAdjustsScrollViewInsets = true
            }
        }
    }
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ognizationList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath) as! SubscriptListCell
        if type == 0 {
            let data = ognizationList.list[indexPath.row]
            cell.updateCell(data)
        }
        else if type == 1 {
            cell.nameLb.text = "名人名称"
            cell.avtarBtn.setImage(#imageLiteral(resourceName: "avatar2M5-1"), for: .normal)
        }
        else {
            cell.nameLb.text = "金融产品"
            cell.avtarBtn.setImage(#imageLiteral(resourceName: "jd_login"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == 0 {
            let data = ognizationList.list[indexPath.row]
            let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
            vc.ognization = data
            navigationController?.pushViewController(vc, animated: true)
        }
        else if type == 1 {
            let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = FinanceProductDetailController(nibName: "FinanceProductDetailController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension OrgnizationListController {
    
    //机构
    func reloadOgnizationList() {
        ognizationList.page = 1
        APIRequest.ognizationListAPI(page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.ognizationList = data as! OgnizationList
            self?.tableView.reloadData()
        }
    }
    
    func loadMoreOgnizationList() {
        if ognizationList.list.count >= ognizationList.total {
            tableView.cr.noticeNoMoreData()
            return
        }
        ognizationList.page = ognizationList.page + 1
        APIRequest.ognizationListAPI(page: ognizationList.page) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
            let list = data as! OgnizationList
            self?.ognizationList.list.append(contentsOf: list.list)
            self?.tableView.reloadData()
        }
    }
}
