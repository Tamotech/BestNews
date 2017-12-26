//
//  CollectionNewsListController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/9.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class CollectionNewsListController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var entry = 0
    var articleList = HomeArticleList()
    var page: Int = 1
    
    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: screenHeight-64-44), style: .plain)
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

        self.shouldClearNavBar = entry == 0
        self.setupView()
        reloadArticleList()
    }
    
    func setupView() {
        self.view.addSubview(tableView)
        for i in 0..<cellIdentifiers.count {
            let identifier = cellIdentifiers[i]
            let nib = UINib(nibName: identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
        }
        if entry == 1 {
            barView.removeFromSuperview()
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
        }
        tableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
    }
    
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleList.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = 0
        
        let article = articleList.list[indexPath.row];
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
      
        let article = articleList.list[indexPath.row]
        let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
        vc.articleId = article.id
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func reloadArticleList() {
        
        APIRequest.collectedArticleListAPI(page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.page = 1
            self?.articleList = data as! HomeArticleList
            self?.tableView.reloadData()
        }
    }
    
    func loadMoreArticleList() {
        if self.articleList.list.count == 0 {
            self.reloadArticleList()
            return
        }
        if self.articleList.list.count >= self.articleList.total {
            tableView.cr.noticeNoMoreData()
            return
        }
        
        page = page + 1
        APIRequest.collectedArticleListAPI(page: page) { [weak self](data) in
            self?.page = 1
            let list = data as? HomeArticleList
            if list != nil {
                self?.articleList.list.append(contentsOf: list!.list)
                self?.tableView.cr.endLoadingMore()
            }
        }
    }

}
