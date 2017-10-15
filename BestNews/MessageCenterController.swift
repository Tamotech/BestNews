//
//  MessageCenterController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MessageCenterController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tableView = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-64), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    func setupView() {
        
        self.showCustomTitle(title: "消息中心")
        let moreItem = UIBarButtonItem(image: #imageLiteral(resourceName: "iconoval"), style: .plain, target: self, action: #selector(handleTapHandleMoreItem(_:)))
        navigationItem.rightBarButtonItem = moreItem
        
        let nib = UINib(nibName: "MessageCenterListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 85
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
            
        }
    }

    //MARK: - actions
    
    func handleTapHandleMoreItem(_:Any) {
        
    }

    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
}
