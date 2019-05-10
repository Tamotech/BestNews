//
//  FastNewsController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class FastNewsController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    var t: Timer?
    
    ///是否加过滤 仅收藏
    var collectFilter: Bool = false
    
    /// 0 快讯 1 收藏  2 历史
    var entry = 0
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        self.shouldClearNavBar = entry == 0
        if entry == 1 || entry == 2{
            barView.removeFromSuperview()
        }
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {
            [weak self] in
            self?.reloadArticleList()
            if !self!.collectFilter {
                self?.loadStockStatus()
            }
        }
        tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
        self.view.addSubview(emptyView)
        emptyView.emptyString = "还没有快讯~"
        emptyView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadArticleList()
        self.loadStockStatus()
        t?.fire()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        t?.fire()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupView() {
        let nib = UINib(nibName: "FastNewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        let nib1 = UINib(nibName: "FastNewsSectionHeaderView", bundle: nil)
        tableView.register(nib1, forHeaderFooterViewReuseIdentifier: "header")
        
        if !collectFilter {
            tableView.tableHeaderView = headerView
        }
        
        t = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(timerEvent(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(t!, forMode: RunLoopMode.commonModes)
        t?.fire()
    }
    
    
    @objc func didSwitchNav(_ sender: Notification) {
        
        let index = sender.object as! Int
        if newsList == nil && CGFloat(index)*screenWidth == self.view.x && !collectFilter {
            self.tableView.cr.beginHeaderRefresh()
        }
    }
    
    @objc func timerEvent(_ sender: Timer) {
        self.loadStockStatus()
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        emptyView.isHidden = (newsList?.numberOfSections() ?? 0) > 0
        return newsList?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        emptyView.isHidden = (newsList?.numberOsRowsInSection(section: section) ?? 0) > 0
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
        //记录仪浏览历史
        if SessionManager.sharedInstance.loginInfo.isLogin {
            APIRequest.recordViewHistoryAPI(ids: news.id, type: "newsflash") { (data) in
            }
        }
        cell.updateCell(news: news)
        cell.clickRepostCallback = {
            [weak self] news in
            
            let rootVC = self?.navigationController?.childViewControllers.first as! MainController
            let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
            let share = ShareModel()
            share.title = news.content
            share.msg = "新华日报财经"
            vc.share = share
            rootVC.presentr.viewControllerForContext = rootVC
            rootVC.presentr.dismissOnSwipe = true
            rootVC.customPresentViewController(self!.presentr, viewController: vc, animated: true)
        }
        return cell
    }
}


/// load data
extension FastNewsController {
    
    
    func reloadArticleList() {
        
        APIRequest.getFastNewsListAPI(page: 1, collect: collectFilter, history: (entry == 2)) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.page = 1
            self?.newsList = data as? FastNewsList
            self?.tableView.reloadData()
            self?.emptyView.isHidden = (self?.newsList?.numberOfSections() ?? 0) > 0
        }
    }
    
    func loadMoreArticleList() {
        if self.newsList == nil {
            self.reloadArticleList()
            self.tableView.cr.endLoadingMore()
            return
        }
        page = page + 1
        APIRequest.getFastNewsListAPI(page: page, collect: collectFilter, history: (entry == 2)) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
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
            updownLb1.text = String.init(format: "%.2f",data.updown)
            percentLb1.text = String.init(format: "%.2f",data.percent)
        }
        if stockStatusArr!.count >= 2 {
            let data = stockStatusArr![1]
            nameLb2.text = data.name
            priceLb2.text = "\(data.price)"
            updownLb2.text = String.init(format: "%.2f",data.updown)
            percentLb2.text = String.init(format: "%.2f",data.percent)
        }
        if stockStatusArr!.count >= 3 {
            let data = stockStatusArr![2]
            nameLb3.text = data.name
            priceLb3.text = "\(data.price)"
            updownLb3.text = String.init(format: "%.2f",data.updown)
            percentLb3.text = String.init(format: "%.2f",data.percent)
        }
    }
}
