//
//  ActivityTicketListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

protocol ActivityTicketListControllerDelgate: class {
    func handleTapNextBtn(vc: ActivityTicketListController)
}

class ActivityTicketListController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    weak var delegate: ActivityTicketListControllerDelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 65))
        header.backgroundColor = UIColor.white
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.textColor = gray51
        lb.text = "活动票种"
        lb.sizeToFit()
        lb.left = 20
        lb.bottom = 60
        header.addSubview(lb)
        tableView.tableHeaderView = header
        tableView.isScrollEnabled = false
        let nib = UINib(nibName: "ActivityTicketCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 112
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        
        tableViewHeight.constant = tableView.rowHeight*2+65
    }
    
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    //MARK: - actions
    @IBAction func handleTapConfirmBtn(_ sender: UIButton) {
        if delegate != nil {
            delegate?.handleTapNextBtn(vc: self)
        }
    }
    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
