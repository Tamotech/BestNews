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
       let v = YLCycleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*243.0/375.0), images:["banner-default"], titles: [""])
        //顶部加一个 渐变黑色蒙版
        let maskLayer = CAGradientLayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 64)
        maskLayer.colors = [UIColor.black.cgColor, UIColor.init(white: 0, alpha: 0).cgColor]
        maskLayer.startPoint = CGPoint(x: 0.5, y: 0)
        maskLayer.endPoint = CGPoint(x: 0.5, y: 1)
        v.layer.addSublayer(maskLayer)
        v.delegate = self
        return v
    }()
    
    lazy var tableView: UITableView = {
       let v = UITableView(frame: UIScreen.main.bounds, style: .plain)
        v.separatorStyle = .none
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
    }
    
    func setupView() {
        self.view.addSubview(tableView)
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
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
    }
    
    
    //MARK: - banner delegate
    
    func clickedCycleView(_ cycleView: YLCycleView, selectedIndex index: Int) {
        if headerBannerView.banner.count > index {
            let article = headerBannerView.banner[index]
            let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
            vc.articleId = article.id
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
            let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
            vc.articleId = article!.id
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -10 && scrollView.contentOffset.y < 100
        {
            autoAjustToNavColor()
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
extension HomeContentViewController {
    
    func reloadArticleList() {
        APIRequest.getHomeArticleListAPI(page: 1, row: 10) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
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
            self?.page = 1
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
        }
    }
    
    func updateBanner() {
        headerBannerView.reloadData()
    }
    
    func updateSpecialListView() {
        
    }
}

