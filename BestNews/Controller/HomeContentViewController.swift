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
    var seconds: Int = 0
    var timer: Timer?
    
    lazy var headerBannerView: YLCycleView = {
       let v = YLCycleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*182.0/375.0), images:["m24_default"], titles: [""])
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
        v.backgroundColor = UIColor(hex: 0xf0f0f0)
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
        NotificationCenter.default.addObserver(self, selector: #selector(needReloadData(_:)), name: kTapReloadNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.needReloadData(_:)), name: kAppDidBecomeActiveNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: kTapReloadNotify, object: nil)
        NotificationCenter.default.removeObserver(self, name: kAppDidBecomeActiveNotify, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTimer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopTimer()
        headerBannerView.resetContentOffset()
    }
    
    func setupTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerEvent(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        timer?.fire()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    ///定时器
    @objc func timerEvent(_ timer: Timer) {
        seconds = seconds + 1
        if seconds >= 20*60 {
            tableView.cr.beginHeaderRefresh()
            seconds = 0
        }
    }
    
    @objc func needReloadData(_ noti: Notification) {
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
            self?.loadSpecialCannelData()
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
            if article.type == "linkchannel" {
                let vc = SpecialChannelArticleListController()
                let channel = SpecialChannel()
                channel.id = article.linkchannelid
                channel.name = article.channelname
                channel.fullname = article.channelname
                vc.entry = 1
                vc.channel = channel
                navigationController?.pushViewController(vc, animated: true)
            }
            else if article.linkurl.count > 0 && !article.linkurl.contains("null") {
                let wkvc = BaseWKWebViewController()
                wkvc.shareEnable = true
                let share = ShareModel()
                share.title = article.title
                share.msg = "新华日报财经"
                share.link = article.linkurl
                if article.preimglist.count > 0 {
                    share.thumb = article.preimglist.first!
                }
                wkvc.share = share
                wkvc.urlString = article.linkurl
                navigationController?.pushViewController(wkvc, animated: true)
            }
            else {
                let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
                vc.articleId = article.id
                vc.articleHome = article
                navigationController?.pushViewController(vc, animated: true)
            }
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
        return articleList?.numberOfRows() ?? 0 + 1
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
                [weak self] (data) in
                if data is SpecialChannel {
                    let vc = SpecialChannelArticleListController()
                    vc.channel = data as? SpecialChannel
                    vc.entry = 1
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                else if data is HomeArticle {
                    self?.jumpToNewsDetail(article: data as! HomeArticle)
                }
            }
            return cell
        }
        else {
            let model = articleList!.cellModel(row: indexPath.row - 1)
            if model is HomeArticle {
                let article = model as! HomeArticle
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
            else if model is [HomeArticle] {
                let articleList = model as! [HomeArticle]
                let c = self.articleList?.getChannelTitle(list: articleList)
                index = 0
                let identifier = cellIdentifiers[index]
                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TopicBannerCell
                cell.updateCell(data: articleList, title: c?.name ?? "专题")
                cell.selectOneChannel = {
                    [weak self] (data) in
                    if data is SpecialChannel {
                        let vc = SpecialChannelArticleListController()
                        vc.channel = data as? SpecialChannel
                        vc.entry = 1
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if data is HomeArticle {
                        self?.jumpToNewsDetail(article: data as! HomeArticle)
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let vc = SpecialChannelListController()
            vc.specialList = specialList
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let model = articleList!.cellModel(row: indexPath.row - 1)
            if model is HomeArticle {
                jumpToNewsDetail(article: model as! HomeArticle)
            }
            else if model is [HomeArticle] {
                if let channel = self.articleList?.getChannelTitle(list: model as! [HomeArticle]) {
                    let vc = SpecialChannelArticleListController()
                    vc.channel = channel
                    vc.entry = 1
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
    }
    
    func jumpToNewsDetail(article: HomeArticle) {
        if article.linkurl.count > 0 && !article.linkurl.contains("null") {
            let wkvc = BaseWKWebViewController()
            wkvc.shareEnable = true
            let share = ShareModel()
            share.title = article.title
            share.msg = "新华日报财经"
            share.link = article.linkurl
            if article.preimglist.count > 0 {
                share.thumb = article.preimglist.first!
            }
            wkvc.share = share
            wkvc.urlString = article.linkurl
            navigationController?.pushViewController(wkvc, animated: true)
        }
        else {
            let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
            vc.articleId = article.id
            vc.articleHome = article
            navigationController?.pushViewController(vc, animated: true)
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
            if data != nil {
                let oldList = self?.articleList
                self?.articleList = data as? HomeArticleList
                ///继承衣钵
                self?.articleList?.channelArticleList = oldList?.channelArticleList ?? [:]
                self?.articleList?.synthesizeArr = oldList?.synthesizeArr ?? []
                self?.tableView.reloadData()
            }
        }
    }
    
    func loadMoreArticleList() {
        if self.articleList == nil {
            self.reloadArticleList()
            tableView.cr.footer?.endRefreshing()
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
                //去重
                guard let ol = self?.articleList?.list else { return }
                let plist = list?.list.filter({ (h) -> Bool in
                    let c = ol.contains(where: { (lh) -> Bool in
                        if lh.id == h.id {
                            return true
                        }
                        return false
                    })
                    return !c
                })
                self?.articleList?.list.append(contentsOf: plist ?? [])
                self?.tableView.reloadData()
            }
        }
    }
    
    /// 横向专题 专题
    func loadSpecialCannelData() {
        APIRequest.getSpecialListAPI { [weak self](data) in
            if data != nil {
                self?.specialList = data as! [SpecialChannel]
                HomeModel.shareInstansce.specilList1 = data as! [SpecialChannel]
                self?.tableView.reloadData()
                DispatchQueue.main.async {
                    self?.updateTitlesView()
                }
            }
        }
        APIRequest.getHengChannelListAPI{ [weak self](data) in
            if data != nil {
                let list = data as! [SpecialChannel]
                HomeModel.shareInstansce.hengChannels = list
                ///加载横向文章集
                self?.articleList?.channelArticleList = [:]
                for channel in list {
                    self?.loadArticleListWithChannel(channelID: channel.id)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    /// 加载专题下的文章列表(横向展示)
    func loadArticleListWithChannel(channelID: String) {
        APIRequest.articleListAPI(id: channelID, type: "channelid", page: 1, row: 5) { [weak self](data) in
            if data == nil {
                return
            }
            if self?.articleList == nil {
                self?.articleList = HomeArticleList()
            }
            if let m = data as? HomeArticleList {
                ///防止重复
                if !self!.articleList!.channelArticleList.keys.contains(channelID) && m.list.count > 0 {
                    self?.articleList?.channelArticleList[channelID] = m.list
                    self?.tableView.reloadData()
                }
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

