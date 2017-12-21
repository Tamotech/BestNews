//
//  SpecialChannelListController.swift
//  BestNews
//
//  Created by Worthy on 2017/11/5.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit


class SpecialChannelListController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    
    var specialList: [SpecialChannel] = []
    lazy var tableView: UITableView = {
       let v = UITableView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: screenHeight - 64), style: .plain)
        v.separatorStyle = .none
        let nib = UINib(nibName: "SpecialChannelCell", bundle: nil)
        v.register(nib, forCellReuseIdentifier: "Cell")
        v.estimatedRowHeight = 211
        v.rowHeight = UITableViewAutomaticDimension
        self.view.addSubview(v)
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.showCustomTitle(title: "专题")
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SpecialChannelCell
        let channel = specialList[indexPath.row]
        cell.updateCell(data: channel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = specialList[indexPath.row]
        let vc = SpecialChannelArticleListController()
        vc.channel = channel
        navigationController?.pushViewController(vc, animated: true)
    }
}
