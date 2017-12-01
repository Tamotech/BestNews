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
    
    
    var ognization: OgnizationModel?
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewTop.constant = headerView.height
    }
    
    
    func setupView() {
        
        self.shouldClearNavBar = true
        let nib1 = UINib(nibName: "SinglePhotoNewsCell", bundle: nil)
        newsTableView.register(nib1, forCellReuseIdentifier: "SinglePhotoNewsCell")
        newsTableView.rowHeight = 135
        newsTableView.delegate  = self
        newsTableView.dataSource = self
        
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
        if scrollView == self.scrollView {
            let offset = scrollView.contentOffset
            if offset.y > headerView.height-108-100  && offset.y < headerView.height-108 {
                let alpha = 1-(headerView.height-108-offset.y)/100.0
                navView.alpha = alpha
                self.navigationController?.navigationBar.barTintColor = gray51
                backBtn.setImage(#imageLiteral(resourceName: "back-gray"), for: .normal)
                navigationController?.navigationBar.tintColor = gray51
            }
            else if offset.y > headerView.height-108 {
                navView.alpha = 1
                navigationController?.navigationBar.tintColor = gray51
                backBtn.setImage(#imageLiteral(resourceName: "back-gray"), for: .normal)
            }
            else {
                navView.alpha = 0
                backBtn.setImage(#imageLiteral(resourceName: "back-white"), for: .normal)
               navigationController?.navigationBar.tintColor = UIColor.white
            }
            if offset.y > 0 && offset.y <= headerView.height - 108 {
                
                headerTop.constant = -offset.y
            }
            else if offset.y > headerView.height - 108 {
                headerTop.constant = -(headerView.height - 108)
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == newsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePhotoNewsCell", for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath)
            return cell
        }
    }
    
    //MARK: - collectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
    //MARK: - actions:
    
    @IBAction func handleTapSubscribeBtn(_ sender: UIButton) {
        
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
    
    func loadData() {
        APIRequest.ognizationDetailAPI(id: ognization!.id) { [weak self](data) in
            self?.ognization = data as? OgnizationModel
            self?.updateUI()
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
