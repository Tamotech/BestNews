//
//  CommentListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class CommentListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    var tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-49))
    var commentBar = NewsCommentBar(frame: CGRect(x: 0, y: screenHeight-49, width: screenWidth, height: 49))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        view.addSubview(tableView)
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        view.addSubview(commentBar)
    }

    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    

}
