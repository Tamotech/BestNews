//
//  HomeContentViewController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class HomeContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, YLCycleViewDelegate {
    
    var specialList: [SpecialChannel] = []
    
    lazy var headerBannerView: YLCycleView = {
       let v = YLCycleView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*243.0/375.0), images:["banner-default"], titles: [""])
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
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
    }
    
    
    //MARK: - banner delegate
    
    func clickedCycleView(_ cycleView: YLCycleView, selectedIndex index: Int) {
        
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = cellIdentifiers[indexPath.row%cellIdentifiers.count]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        
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
    
    
}


//MARK: - update View
extension HomeContentViewController {
    
    func updateBanner() {
        headerBannerView.reloadData()
    }
    
    func updateSpecialListView() {
        
    }
}
