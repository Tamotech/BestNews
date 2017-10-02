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
    }
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath)
        return cell
    }
    
    
}
