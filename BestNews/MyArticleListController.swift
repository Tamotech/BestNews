//
//  MyArticleListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/29.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MyArticleListController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    lazy var tableView: UITableView = {
        let v = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-64), style: .plain)
        v.separatorStyle = .none
        v.delegate = self
        v.dataSource = self
        v.rowHeight = 136
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        
        self.showCustomTitle(title: "我的文章")
        self.view.addSubview(tableView)
        
        let identifier = "SinglePhotoNewsCell"
        let nib = UINib(nibName: identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: identifier)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SinglePhotoNewsCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
