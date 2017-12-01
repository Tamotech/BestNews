//
//  SubscriptionListControllerViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh

class SubscriptionListControllerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var newsTableView: UITableView!
    
    @IBOutlet weak var myScriptionBtn: UIButton!
    
    @IBOutlet weak var scriptionListBtn: UIButton!
    
    @IBOutlet weak var columeCollectionView: UICollectionView!
    
    @IBOutlet weak var columeTableView: UITableView!
    
    @IBOutlet weak var subscriptMoreView: UIView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    ///专题列表
    var channels: [NewsChannel] = []
    //机构列表
    var ognizationList = OgnizationList()
    
    //订阅文章列表
    var articles = HomeArticleList()
    var page: Int = 1
    
    let cellIdentifiers = ["TopicBannerCell", "SinglePhotoNewsCell", "ThreePhotosNewsCell", "NoPhotoNewsCell", "SingleBigPhotoNewsCell"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        reloadOgnizationList()
        reloadArticleList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNewsChannel()
    }
    
    func setupView() {
        
        for i in 0..<cellIdentifiers.count {
            let identifier = cellIdentifiers[i]
            let nib = UINib(nibName: identifier, bundle: nil)
            newsTableView.register(nib, forCellReuseIdentifier: identifier)
        }
        newsTableView.estimatedRowHeight = 135
        newsTableView.rowHeight = UITableViewAutomaticDimension
        newsTableView.cr.addHeadRefresh {
            [weak self] in
            self?.reloadArticleList()
        }
        newsTableView.cr.addFootRefresh {
            [weak self] in
            self?.loadMoreArticleList()
        }
        
        let nib2 = UINib(nibName: "SubscriptListCell", bundle: nil)
        columeTableView.register(nib2, forCellReuseIdentifier: "ColumeCell")
        let nib3 = UINib(nibName: "ColumesCollectionViewCell", bundle: nil)
        columeTableView.rowHeight = 96;
        columeCollectionView.register(nib3, forCellWithReuseIdentifier: "Cell")
        
        let layout = columeCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        columeCollectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        scrollview.cr.addHeadRefresh {
            [weak self] in
            self?.loadNewsChannel()
        }
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let w = (screenWidth-15*2-8*2)/3.0
        let h:CGFloat = 108
        layout.itemSize = CGSize(width: w, height: h)
        
        selectItem(index: 0)
    }
    

    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.newsTableView {
            return articles.list.count
        }
        else {
            return ognizationList.list.count > 3 ? 3 : ognizationList.list.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = 0
        if tableView == self.newsTableView {
            let article = articles.list[indexPath.row];
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
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath) as! SubscriptListCell
            let ognization = ognizationList.list[indexPath.row]
            cell.updateCell(ognization)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// WHY?
        if tableView == self.newsTableView {
            let article = articles.list[indexPath.row]
            let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
            vc.articleId = article.id
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count > 9 ? 9 : channels.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ColumesCollectionViewCell
        let channel = channels[indexPath.row]
        cell.updateCell(channel)
        return cell
    }
    
    
    //MARK: - actions
    @IBAction func handleTapMyScriptBtn(_ sender: UIButton) {
        selectItem(index: 0)
    }
    
    @IBAction func handleTapScriptionListBtn(_ sender: UIButton) {
        selectItem(index: 1)
    }
    
    @IBAction func handleTapAllChannels(_ sender: UITapGestureRecognizer) {
        let vc = SelectInterestItemController(nibName: "SelectInterestItemController", bundle: nil)
        vc.entry = 1
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapAllOgnization(_ sender: UITapGestureRecognizer) {
        
        let vc = OrgnizationListController(nibName: "OrgnizationListController", bundle: nil)
        vc.type = 0
        vc.entry = 1
        vc.showCustomTitle(title: "机构")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 我的订阅 | 订阅更多
    func selectItem(index: Int) {
        if index == 0 {
            myScriptionBtn.isSelected = true
            scriptionListBtn.isSelected = false
            newsTableView.isHidden = false
            subscriptMoreView.isHidden = true
        }
        else {
            myScriptionBtn.isSelected = false
            scriptionListBtn.isSelected = true
            newsTableView.isHidden = true
            subscriptMoreView.isHidden = false

        }
    }

}

extension SubscriptionListControllerViewController {
    
    //专题列表
    func loadNewsChannel() {
        APIRequest.getAllChannelAPI { [weak self](data) in
            self?.scrollview.cr.endHeaderRefresh()
            self?.channels = data as! [NewsChannel]
            self?.columeCollectionView.reloadData()
        }
    }
    
    //机构
    func reloadOgnizationList() {
        ognizationList.page = 1
        APIRequest.ognizationListAPI(page: 1) { [weak self](data) in
            
            self?.ognizationList = data as! OgnizationList
            self?.columeTableView.reloadData()
        }
    }
    
    
    func reloadArticleList() {

        APIRequest.subscribeArticleListAPI(page: 1) { [weak self](data) in
            self?.newsTableView.cr.endHeaderRefresh()
            self?.page = 1
            self?.articles = data as! HomeArticleList
            self?.newsTableView.reloadData()
        }
    }
    
    func loadMoreArticleList() {
        if self.articles.list.count == 0 {
            self.reloadArticleList()
            return
        }
        if self.articles.list.count >= self.articles.total {
            newsTableView.cr.noticeNoMoreData()
            return
        }
        
        page = page + 1
        APIRequest.subscribeArticleListAPI(page: page) { [weak self](data) in
            self?.page = 1
            let list = data as? HomeArticleList
            if list != nil {
                self?.articles.list.append(contentsOf: list!.list)
                self?.newsTableView.cr.endLoadingMore()
            }
        }
    }
    
}
