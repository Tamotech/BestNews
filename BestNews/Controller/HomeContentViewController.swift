//
//  HomeContentViewController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

///专题详情
class HomeContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YLCycleViewDelegate {
    
    var specialList: [SpecialChannel] = []
    var articleList: HomeArticleList?
    var page: Int = 1
    
    lazy var headerBannerView: YLCycleView = {
       let v = YLCycleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*243.0/375.0), images:["m24_default"], titles: [""])
        //顶部加一个 渐变黑色蒙版
        let maskLayer = CAGradientLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 64)
        maskLayer.colors = [UIColor.black.cgColor, UIColor.init(white: 0, alpha: 0).cgColor]
        maskLayer.startPoint = CGPoint(x: 0.5, y: 0)
        maskLayer.endPoint = CGPoint(x: 0.5, y: 1)
        //v.layer.addSublayer(maskLayer)
        v.delegate = self
        return v
    }()
    
    lazy var tableView: UITableView = {
       let v = UITableView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-49), style: .plain)
        v.separatorStyle = .singleLine
        v.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        v.separatorColor = UIColor(hexString: "f0f0f0")
        v.delegate = self
        v.dataSource = self
        v.estimatedRowHeight = 220
        v.rowHeight = UITableViewAutomaticDimension
        return v
    }()
    
    let cellIdentifiers = ["TopicBannerCell", "SinglePhotoNewsCell", "ThreePhotosNewsCell", "NoPhotoNewsCell", "SingleBigPhotoNewsCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        updateBanner()
        self.reloadArticleList()
        self.loadSpecialCannelData()
        self.loadNavChannel()
    }
    
    func setupView() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.right.left.bottom.equalTo(0)
        }
        tableView.tableHeaderView = headerBannerView
        for i in 0..<cellIdentifiers.count {
            let identifier = cellIdentifiers[i]
            let nib = UINib(nibName: identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        tableView.cr.addHeadRefresh {
            [weak self] in
            self?.reloadArticleList()
//            self?.loadSpecialCannelData()
//            self?.loadNavChannel()
            self?.updateBanner()
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
        tableView.cr.beginHeaderRefresh()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
    }
    
    
    //MARK: - banner delegate
    
    func clickedCycleView(_ cycleView: YLCycleView, selectedIndex index: Int) {
        if headerBannerView.banner.count > index {
            let article = headerBannerView.banner[index]
            let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
            vc.articleId = article.id
            vc.articleHome = article
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleList == nil {
            return 0
        }
        return articleList!.list.count+1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //["TopicBannerCell", "SinglePhotoNewsCell", "ThreePhotosNewsCell", "NoPhotoNewsCell", "SingleBigPhotoNewsCell"]
        var index = 0
        if indexPath.row == 0 {
            index = 0
            let identifier = cellIdentifiers[index]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TopicBannerCell
            cell.updateCell(data: specialList)
            cell.selectOneChannel = {
                [weak self] (channel) in
                let vc = SpecialChannelArticleListController()
                vc.channel = channel
                vc.entry = 1
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
        else {
            let article = articleList!.list[indexPath.row - 1];
            if article.preimglist.count == 0 {
                index = 3
            }
            else if article.preimglist.count == 1 && article.preimgtype == "big1" {
                index = 4
            }
            else if article.preimglist.count == 1 && article.preimgtype == "small3" {
                index = 1
            }
            else {
                index = 2
            }
            
            let identifier = cellIdentifiers[index]
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseNewsCell
            cell.updateCell(article: article)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = SpecialChannelListController()
            vc.specialList = specialList
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let article = articleList?.list[indexPath.row - 1]
            if article!.linkurl.count > 0 && !article!.linkurl.contains("null") {
                let wkvc = BaseWKWebViewController()
                wkvc.shareEnable = true
                let share = ShareModel()
                share.title = article?.title ?? ""
                share.msg = "新华财经日报"
                if article!.preimglist.count > 0 {
                    share.thumb = article!.preimglist.first!
                }
                article?.linkurl = article!.linkurl
                wkvc.share = share
                wkvc.urlString = article!.linkurl
                navigationController?.pushViewController(wkvc, animated: true)
            }
            else {
                let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
                vc.articleId = article!.id
                vc.articleHome = article
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -10 && scrollView.contentOffset.y < 100
        {
            autoAjustToNavColor()
        }
        
        if scrollView.contentOffset.y < 0 {
            self.logoTurnRed(true)
        }
    }
    
    ///根据scrollview的位置自动调节到相应的颜色
    func autoAjustToNavColor() {
        let offset = tableView.contentOffset
        guard let vc = self.parent else {
            return
        }
        if !(vc is MainController) {
            return
        }
        weak var parent = vc as? MainController
        if offset.y < 50 {
            parent?.navBarTurnBg(white: false)
        }
        else if offset.y > 50 {
            parent?.navBarTurnBg(white: true)
        }
    }
    
    
    /// 刷新logo变色
    ///
    /// - Parameter red: 是否红色
    func logoTurnRed(_ red: Bool) {
        guard let vc = self.parent else {
            return
        }
        if !(vc is MainController) {
            return
        }
        weak var parent = vc as? MainController
        parent?.logoTurnColor(red)
    }
    
    
    /// 刷新标题
    func updateTitlesView() {
        guard let vc = self.parent else {
            return
        }
        if !(vc is MainController) {
            return
        }
        weak var parent = vc as? MainController
        parent?.setupNavTitleView()
        parent?.setupChildView()
    }

}

// MARK: - load data
extension HomeContentViewController {
    
    func reloadArticleList() {
        APIRequest.getHomeArticleListAPI(page: 1, row: 10) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.page = 1
            self?.articleList = data as? HomeArticleList
            self?.tableView.reloadData()
        }
    }
    
    func loadMoreArticleList() {
        if self.articleList == nil {
            self.reloadArticleList()
            return
        }
        if self.articleList?.list.count ?? 0 >= self.articleList?.total ?? 0 {
            tableView.cr.noticeNoMoreData()
            return
        }
        
        page = page + 1
        APIRequest.getHomeArticleListAPI(page: page, row: 10) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
            let list = data as? HomeArticleList
            if list != nil {
                self?.articleList?.list.append(contentsOf: list!.list)
                self?.tableView.reloadData()
            }
        }
    }
    
    /// load data
    func loadSpecialCannelData() {
        APIRequest.getSpecialListAPI { [weak self](data) in
            self?.specialList = data as! [SpecialChannel]
            self?.tableView.reloadData()
            HomeModel.shareInstansce.specilList1 = data as! [SpecialChannel]
            DispatchQueue.main.async {
                self?.updateTitlesView()
            }
        }
        
        
    }
    
    ///首页导航栏频道
    func loadNavChannel() {
        APIRequest.getNavChannelListAPI { [weak self](data) in
            
            HomeModel.shareInstansce.specilList = data as! [SpecialChannel]
            DispatchQueue.main.async {
                self?.updateTitlesView()
            }
        }
    }
    
    func updateBanner() {
        headerBannerView.reloadData()
    }
    
    func updateSpecialListView() {
        
    }
}

