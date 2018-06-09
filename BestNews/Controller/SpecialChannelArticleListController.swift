//
//  SpecialChannelArticleListController.swift
//  BestNews
//
//  Created by Worthy on 2017/11/28.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

///专题下的文章列表

class SpecialChannelArticleListController: BaseViewController, UITableViewDelegate, UITableViewDataSource, YLCycleViewDelegate {
    
    ///专题
    var channel: SpecialChannel?
    ///频道
    var newsChannel: NewsChannel?
    var articleList: HomeArticleList?
    var coverArticles: [HomeArticle] = []
    var page: Int = 1
    var entry = 0           //0 首页  1 专题详情
    
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-64), style: .plain)
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
        
        if channel != nil {
            showCustomTitle(title: channel!.fullname)
        }
        else if newsChannel != nil {
            showCustomTitle(title: newsChannel!.fullname)
        }
        setupView()
        if entry == 1 {
            self.loadCoverArticle()
            self.tableView.cr.beginHeaderRefresh()
        }
//        self.reloadArticleList()
//        self.loadCoverArticle()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchNav(_:)), name: kDidSwitchNavTitleNotify, object: nil)
        
    }
    
    func setupView() {
        self.view.addSubview(tableView)
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
            self?.loadCoverArticle()
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
//        tableView.cr.beginHeaderRefresh()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        
        tableView.addSubview(emptyView)
        emptyView.emptyString = "还没有新闻~"
        emptyView.isHidden = true
        
        if channel != nil {
            
        }
    }
    
    
    func didSwitchNav(_ sender: Notification) {
        
        let index = sender.object as! Int
        if articleList == nil && CGFloat(index)*screenWidth == self.view.x {
            self.loadCoverArticle()
            tableView.cr.beginHeaderRefresh()
        }
    }
    
    //MARK: - banner delegate
    
    func clickedCycleView(_ cycleView: YLCycleView, selectedIndex index: Int) {
        let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
        vc.articleId = coverArticles[index].id
        if articleList != nil {
            vc.articleHome = articleList!.list[index]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articleList == nil {
            return 0
        }
        return articleList!.list.count
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
        
        let article = articleList!.list[indexPath.row];
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articleList?.list[indexPath.row]
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > -10 && scrollView.contentOffset.y < 100
//        {
//            autoAjustToNavColor()
//        }
//    }
    
    ///根据scrollview的位置自动调节到相应的颜色
    func autoAjustToNavColor() {
        let offset = tableView.contentOffset
        guard let vc = self.parent else {
            return
        }
        if !(vc is MainController) {
            return
        }
        let parent = vc as! MainController
        if offset.y < 50 {
            parent.navBarTurnBg(white: false)
        }
        else if offset.y > 50 {
            parent.navBarTurnBg(white: true)
        }
    }
    
}

// MARK: - load data
extension SpecialChannelArticleListController {
    
    func reloadArticleList() {
        let id = channel == nil ? newsChannel!.id : channel!.id
        APIRequest.articleListAPI(id: id, type: "channelid", page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.page = 1
            self?.articleList = data as? HomeArticleList
            self?.emptyView.isHidden = self?.articleList?.list.count ?? 0 > 0
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
        let id = channel == nil ? newsChannel!.id : channel!.id
        APIRequest.articleListAPI(id: id, type: "channelid", page: page) { [weak self](data) in
            self?.tableView.cr.endLoadingMore()
            let list = data as? HomeArticleList
            if list != nil {
                self?.articleList?.list.append(contentsOf: list!.list)
                self?.tableView.reloadData()
            }
        }
    }
    
    ///封面文章
    func loadCoverArticle() {
        let id = channel == nil ? newsChannel!.id : channel!.id
        APIRequest.channelCoverArticleAPI(id: id) { [weak self](data) in
            self?.coverArticles = data as! [HomeArticle]
            self?.updateCover()
        }
    }
    
    func updateCover() {
        if coverArticles.count > 0 {
            var titles: [String] = []
            var imgs: [String] = []
            for article in coverArticles {
                titles.append(article.title)
                imgs.append(article.titleimgpath)
            }
            let v = YLCycleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*243.0/375.0), images:imgs, titles: titles)
            v.delegate = self
            tableView.tableHeaderView = v
        }
    }
    
    func updateBanner() {
//        headerBannerView.reloadData()
    }
    
    func updateSpecialListView() {
        
    }
}


