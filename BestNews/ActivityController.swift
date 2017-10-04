//
//  ActivityController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ActivityController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    let tableView = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight-50-64), style: .grouped)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showCustomTitle(title: "活动")
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        let nib = UINib(nibName: "ActivityCoverCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        
        let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_search"), landscapeImagePhone: #imageLiteral(resourceName: "icon_search"), style: .plain, target: self, action: #selector(handleTapSearch(_:)))
        let messageItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_meassage"), style: .plain, target: self, action: #selector(handleTapMessage(_:)))
        self.navigationItem.leftBarButtonItem = searchItem
        self.navigationItem.rightBarButtonItem = messageItem
        
    }
    
    
    //MARK: tableView
    
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth*(260/375)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ActivityCoverCell
        
        let n = ["活动标题一行显示19个字，最多显示两行活动标题一行显示19个字，最多显示两行", "活动标题一行显示19个字"]
        cell.titleLb.text = n[indexPath.row%2]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ActivityDetailController(nibName: "ActivityDetailController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - actions
    
    func handleTapSearch(_:Any) {
        
    }
    
    func handleTapMessage(_:Any) {
        
    }


}
