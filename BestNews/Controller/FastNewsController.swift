//
//  FastNewsController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class FastNewsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var shangzhenView: UIView!
    
    @IBOutlet weak var shenzhengView: UIView!
    
    @IBOutlet weak var chuangyeView: UIView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func setupView() {
        let nib = UINib(nibName: "FastNewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        let nib1 = UINib(nibName: "FastNewsSectionHeaderView", bundle: nil)
        tableView.register(nib1, forHeaderFooterViewReuseIdentifier: "header")
        tableView.tableHeaderView = headerView
    }
    
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FastNewsCell
        cell.contentLb.text = "快讯，一行显示22个字，显示全部内容。快讯，一行显示22个字，显示全部内容。快讯，一行显示22个字，显示全部内容。"
        return cell
    }
}
