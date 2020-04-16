//
//  MyArticleListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/29.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class MyArticleListController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-64), style: .plain)
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.rowHeight = 136
        v.backgroundColor = UIColor(hex: 0xf2f2f7)
        return v
    }()
    let cellIdentifiers = ["TopicBannerCell", "SinglePhotoNewsCell", "ThreePhotosNewsCell", "NoPhotoNewsCell", "SingleBigPhotoNewsCell"]
    
    var articles = HomeArticleList()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.reloadArticleList()
    }

    func setupView() {
        
        self.showCustomTitle(title: "我的文章")
        self.view.addSubview(tableView)
        
        let identifier = "SinglePhotoNewsCell"
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
        tableView.delegate = self
        tableView.dataSource = self
        for i in 0..<cellIdentifiers.count {
            let identifier = cellIdentifiers[i]
            let nib = UINib(nibName: identifier, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: identifier)
        }
        tableView.estimatedRowHeight = 135
        tableView.rowHeight = UITableViewAutomaticDimension
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
        return articles.list.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = articles.list[indexPath.row]
        var index = 0
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
        let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil)
        let article = articles.list[indexPath.row]
        vc.articleId = article.id
        vc.articleHome = article
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MyArticleListController {
    
    func reloadArticleList() {
        
        APIRequest.subscribeArticleListAPI(page: 1) { [weak self](data) in
            self?.tableView.cr.endHeaderRefresh()
            self?.tableView.cr.resetNoMore()
            self?.page = 1
            self?.articles = data as! HomeArticleList
            self?.tableView.reloadData()
        }
    }
    
    func loadMoreArticleList() {
        if self.articles.list.count == 0 {
            self.reloadArticleList()
            return
        }
        if self.articles.list.count >= self.articles.total {
            tableView.cr.noticeNoMoreData()
            return
        }
        
        page = page + 1
        APIRequest.subscribeArticleListAPI(page: page) { [weak self](data) in
            self?.page = 1
            let list = data as? HomeArticleList
            if list != nil {
                self?.articles.list.append(contentsOf: list!.list)
                self?.tableView.cr.endLoadingMore()
            }
        }
    }
}
