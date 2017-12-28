//
//  OrgnizationController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class OrgnizationController: BaseViewController,
UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    ///外部的org, 同步订阅状态
    var originOrg: OgnizationModel?
    var ognization: OgnizationModel?
    var articlePage: Int = 1
    var famousPage: Int = 1
    var famousList = OgnizationList()
    var articleList = HomeArticleList()
    var interestOrgList = OgnizationList()
    let cellIdentifiers = ["TopicBannerCell", "SinglePhotoNewsCell", "ThreePhotosNewsCell", "NoPhotoNewsCell", "SingleBigPhotoNewsCell"]
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var subscripBtn: UIButton!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var newsTableView: UITableView!
    
    @IBOutlet weak var personTableView: UITableView!
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var headerTop: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var avatarSmallView: UIImageView!
    
    @IBOutlet weak var nameSmallLb: UILabel!
    
    @IBOutlet weak var navSubscriptBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    
    lazy var segment: BaseSegmentControl = {
       let v = BaseSegmentControl(items: ["新闻", "名人"], defaultIndex: 0)
        v.frame = self.segmentView.bounds
        self.segmentView.addSubview(v)
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.updateUI()
        self.loadData()
        self.reloadArticleList()
        self.reloadFamousList()
        self.loadInterestOgnizationList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        originOrg?.subscribe = (ognization?.subscribe)!
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewTop.constant = headerView.height
    }
    
    
    func setupView() {
        
        self.shouldClearNavBar = true
        originOrg = ognization
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
        newsTableView.delegate  = self
        newsTableView.dataSource = self
        newsTableView.isScrollEnabled = false
        
        let nib2 = UINib(nibName: "SubscriptListCell", bundle: nil)
        personTableView.register(nib2, forCellReuseIdentifier: "ColumeCell")
        personTableView.rowHeight = 98
        personTableView.delegate = self
        personTableView.dataSource = self
        
        
        let nib3 = UINib(nibName: "RecommendColumnCell", bundle: nil)
        collectionView.register(nib3, forCellWithReuseIdentifier: "Cell")
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0.1
        layout.minimumInteritemSpacing = 0.1
        layout.itemSize = CGSize(width: 102, height: 168)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        segment.selectItemAction = {[weak self](index, name) in
            self?.newsTableView.isHidden = index == 1
            self?.personTableView.isHidden = index == 0
        }
        
        personTableView.isHidden = true
        if #available(iOS 11.0, *) {
            newsTableView.contentInsetAdjustmentBehavior = .never
            personTableView.contentInsetAdjustmentBehavior = .never
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        navView.alpha = 0
        scrollView.delegate = self
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    

    //MARK: - acrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let topH: CGFloat = 64
        if scrollView == self.scrollView {
            let offset = scrollView.contentOffset
            if offset.y > headerView.height-topH-100  && offset.y < headerView.height-topH {
                let alpha = 1-(headerView.height-topH-offset.y)/100.0
                navView.alpha = alpha
                self.navigationController?.navigationBar.barTintColor = gray51
                backBtn.setImage(#imageLiteral(resourceName: "back-gray"), for: .normal)
                navigationController?.navigationBar.tintColor = gray51
            }
            else if offset.y > headerView.height-topH {
                navView.alpha = 1
                navigationController?.navigationBar.tintColor = gray51
                backBtn.setImage(#imageLiteral(resourceName: "back-gray"), for: .normal)
            }
            else {
                navView.alpha = 0
                backBtn.setImage(#imageLiteral(resourceName: "back-white"), for: .normal)
               navigationController?.navigationBar.tintColor = UIColor.white
            }
            if offset.y > 0 && offset.y <= headerView.height - topH {
                
                headerTop.constant = -offset.y
            }
            else if offset.y > headerView.height - topH {
                headerTop.constant = -(headerView.height - topH)
            }
            else {
                headerTop.constant = 0
            }
 
        }
    }
    
    //MARK: -tablewview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == newsTableView {
            return articleList.list.count
        }
        else {
            return famousList.list.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newsTableView {
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
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath) as! SubscriptListCell
            let famous = famousList.list[indexPath.row]
            cell.updateCell(famous)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == newsTableView {
            let article = articleList.list[indexPath.row];
            let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
            vc.articleId = article.id
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let famous = famousList.list[indexPath.row]
            let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
            vc.ognization = famous
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interestOrgList.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! RecommendColumnCell
        let org = interestOrgList.list[indexPath.row]
        cell.updateCell(org)
        return cell
    }
    
    
    //MARK: - actions:
    
    @IBAction func handleTapSubscribeBtn(_ sender: UIButton) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        if ognization == nil {
            return
        }
        if ognization?.subscribe == 0 {
            ognization?.subscribe = 1
            APIRequest.subscriptChannelAPI(id: ognization!.id, type: "organize", result: { [weak self](success) in
                if !success {
                    self?.ognization?.subscribe = 0
                    self?.updateUI()
                }
            })
        }
        else {
            ognization?.subscribe = 0
            APIRequest.cancelSubscriptChannelAPI(id: ognization!.id, type: "organize", result: { [weak self](success) in
                if !success {
                    self?.ognization?.subscribe = 1
                    self?.updateUI()
                }
            })
        }
        updateUI()
    }
    
    @IBAction func handleTapBackBtn(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension OrgnizationController {
    
    ///机构详情
    func loadData() {
        APIRequest.ognizationDetailAPI(id: ognization!.id) { [weak self](data) in
            self?.ognization = data as? OgnizationModel
            self?.updateUI()
        }
    }
    
    func reloadArticleList() {
        APIRequest.articleListAPI(id: ognization!.id, type: "organizeid", page: 1) { [weak self](data) in
            self?.newsTableView.cr.endHeaderRefresh()
            self?.newsTableView.cr.resetNoMore()
            self?.articlePage = 1
            self?.articleList = data as! HomeArticleList
            self?.newsTableView.reloadData()
            if self?.articleList.list.count == 0 {
                self?.contentViewHeight.constant = 300
                self?.newsTableView.isHidden = true
                self?.personTableView.isHidden = true
            }
            else {
                self?.contentViewHeight.constant = (self?.newsTableView.contentSize.height)!
                self?.newsTableView.isHidden = false

            }
        }
    }
    
    func loadMoreArticleList() {
        if self.articleList.list.count == 0 {
            self.reloadArticleList()
            return
        }
        if self.articleList.list.count >= self.articleList.total {
            newsTableView.cr.noticeNoMoreData()
            return
        }
        
        articlePage = articlePage + 1
        APIRequest.articleListAPI(id: ognization!.id, type: "organizeid", page: articlePage) { [weak self](data) in
            
            self?.articlePage = 1
            let list = data as? HomeArticleList
            if list != nil {
                self?.articleList.list.append(contentsOf: list!.list)
                self?.newsTableView.reloadData()
            }
            self?.contentViewHeight.constant = (self?.newsTableView.contentSize.height)!
            self?.newsTableView.isHidden = false
        }
    }
    
    func reloadFamousList() {
        APIRequest.famousListAPI(id: ognization!.id, type: "organizeid", page: 1) { [weak self](data) in
            self?.personTableView.cr.endHeaderRefresh()
            self?.personTableView.cr.resetNoMore()
            self?.famousPage = 1
            self?.famousList = data as! OgnizationList
            self?.personTableView.reloadData()
        }
    }
    
    func loadMoreFamousList() {
        if self.famousList.list.count == 0 {
            self.reloadFamousList()
            return
        }
        if self.famousList.list.count >= self.famousList.total {
            personTableView.cr.noticeNoMoreData()
            return
        }
        
        famousPage = famousPage + 1
        APIRequest.famousListAPI(id: ognization!.id, type: "organizeid", page: famousPage) { [weak self](data) in
            
            self?.famousPage = 1
            let list = data as? OgnizationList
            if list != nil {
                self?.famousList.list.append(contentsOf: list!.list)
                self?.personTableView.reloadData()
            }
        }
    }
    
    //感兴趣的机构
    func loadInterestOgnizationList() {
        APIRequest.ognizationListAPI(xgorganizeid: ognization!.id, page: 1) { [weak self](data) in
            self?.interestOrgList = (data as? OgnizationList)!
            self?.collectionView.reloadData()
        }
    }
    
    func updateUI() {
        if ognization == nil {
            return
        }
        nameLb.text = ognization?.name
        nameSmallLb.text = ognization?.name
        let para = NSMutableParagraphStyle()
        para.lineSpacing = 5
        let memo = NSAttributedString(string: ognization!.memo, attributes:
            [NSParagraphStyleAttributeName: para,
             NSForegroundColorAttributeName: UIColor.init(white: 1, alpha: 0.7),
             NSFontAttributeName: UIFont.systemFont(ofSize: 13)])
        descLb.attributedText = memo
        
        if let url = URL(string: ognization!.headimg) {
            let rc = ImageResource(downloadURL: url)
            avatarView.kf.setImage(with: rc)
            avatarSmallView.kf.setImage(with: rc)
        }
        if ognization?.subscribe == 0 {
            subscripBtn.backgroundColor = themeColor
            subscripBtn.layer.borderWidth = 0
            subscripBtn.setTitle("订阅", for: .normal)
            navSubscriptBtn.layer.borderWidth = 1
            navSubscriptBtn.borderColor = themeColor!
            navSubscriptBtn.setTitleColor(themeColor, for: .normal)
            navSubscriptBtn.setTitle("订阅", for: .normal)
        }
        else {
            subscripBtn.backgroundColor = .clear
            subscripBtn.layer.borderColor = UIColor.white.cgColor
            subscripBtn.layer.borderWidth = 1
            subscripBtn.setTitle("已订阅", for: .normal)
            navSubscriptBtn.layer.borderWidth = 1
            navSubscriptBtn.borderColor = gray181!
            navSubscriptBtn.setTitleColor(gray181, for: .normal)
            navSubscriptBtn.setTitle("已订阅", for: .normal)
        }
    }
}
