//
//  FastNewsController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class FastNewsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var shangzhenView: UIView!
    @IBOutlet weak var shenzhengView: UIView!
    @IBOutlet weak var chuangyeView: UIView!
    @IBOutlet weak var priceLb1: UILabel!
    @IBOutlet weak var priceLb2: UILabel!
    @IBOutlet weak var priceLb3: UILabel!
    @IBOutlet weak var updownLb1: UILabel!
    @IBOutlet weak var updownLb2: UILabel!
    @IBOutlet weak var updownLb3: UILabel!
    @IBOutlet weak var nameLb1: UILabel!
    @IBOutlet weak var nameLb2: UILabel!
    @IBOutlet weak var nameLb3: UILabel!
    @IBOutlet weak var percentLb1: UILabel!
    @IBOutlet weak var percentLb2: UILabel!
    @IBOutlet weak var percentLb3: UILabel!
    var page: Int = 1
    var newsList: FastNewsList?
    var stockStatusArr: [TodayStockStatus]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        self.loadStockStatus()
        
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {
            [weak self] in
            self?.reloadArticleList()
            self?.loadStockStatus()
        }
        tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            [weak self] in
            self?.loadMoreArticleList()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadArticleList()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupView() {
        let nib = UINib(nibName: "FastNewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        let nib1 = UINib(nibName: "FastNewsSectionHeaderView", bundle: nil)
        tableView.register(nib1, forHeaderFooterViewReuseIdentifier: "header")
        tableView.tableHeaderView = headerView
    }
    
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsList?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsList?.numberOsRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! FastNewsSectionHeaderView
        let title = newsList?.titleForSection(section)
        header.dateLb.text = title
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FastNewsCell
        let news = newsList!.newsIn(section: indexPath.section, row: indexPath.row)
        cell.updateCell(news: news)
        return cell
    }
}


/// load data
extension FastNewsController {
    
    
    func reloadArticleList() {
        APIRequest.getFastNewsListAPI(page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.page = 1
            self?.newsList = data as? FastNewsList
            self?.tableView.reloadData()
        }
    }
    
    func loadMoreArticleList() {
        if self.newsList == nil {
            self.reloadArticleList()
            self.tableView.cr.endLoadingMore()
            return
        }
        page = page + 1
        APIRequest.getFastNewsListAPI(page: 1) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
            self?.page = 1
            let list = data as? FastNewsList
            if list != nil {
                self?.newsList?.list.append(contentsOf: list!.list)
                self?.tableView.reloadData()
            }
        }
    }
    
    func loadStockStatus() {
        APIRequest.getStockStatusAPI { [weak self](data) in
            self?.stockStatusArr = data as? [TodayStockStatus]
            self?.updateStaockView()
        }
    }
    
    func updateStaockView() {
        if stockStatusArr == nil {
            return
        }
        if stockStatusArr!.count >= 1 {
            let data = stockStatusArr![0]
            nameLb1.text = data.name
            priceLb1.text = "\(data.price)"
            updownLb1.text = "\(data.updown)"
            percentLb1.text = data.percent
        }
        if stockStatusArr!.count >= 2 {
            let data = stockStatusArr![1]
            nameLb2.text = data.name
            priceLb2.text = "\(data.price)"
            updownLb2.text = "\(data.updown)"
            percentLb2.text = data.percent
        }
        if stockStatusArr!.count >= 3 {
            let data = stockStatusArr![2]
            nameLb3.text = data.name
            priceLb3.text = "\(data.price)"
            updownLb3.text = "\(data.updown)"
            percentLb3.text = data.percent
        }
    }
}
