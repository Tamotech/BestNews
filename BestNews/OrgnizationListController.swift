//
//  OrgnizationListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class OrgnizationListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    //// 0 机构  1 名人  2 金融
    var type: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    func setupView() {
        
        let nib = UINib(nibName: "SubscriptListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ColumeCell")
        tableView.rowHeight = 95
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath) as! SubscriptListCell
        if type == 0 {
            cell.nameLb.text = "机构名称"
            cell.avtarBtn.setImage(#imageLiteral(resourceName: "orgnization_avatar"), for: .normal)
        }
        else if type == 1 {
            cell.nameLb.text = "名人名称"
            cell.avtarBtn.setImage(#imageLiteral(resourceName: "avatar2M5-1"), for: .normal)
        }
        else {
            cell.nameLb.text = "金融产品"
            cell.avtarBtn.setImage(#imageLiteral(resourceName: "jd_login"), for: .normal)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == 0 {
            let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if type == 1 {
            let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = FinanceProductDetailController(nibName: "FinanceProductDetailController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
