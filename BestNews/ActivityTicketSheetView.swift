//
//  ActivityTicketSheetView.swift
//  BestNews
//
//  Created by Worthy on 2017/10/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

protocol ActivityTicketSelectDelegate: class {
    func handleTapNextBtn()
}

class ActivityTicketSheetView: BaseView,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tableViewTop: NSLayoutConstraint!
    weak var delegate: ActivityTicketSelectDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        
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
        
        let nib = UINib(nibName: "ActivityTicketCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 112
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
    }
    
    
    func show() {
        tableView.reloadData()
        self.frame = UIScreen.main.bounds
        keyWindow?.addSubview(self)
        self.tableViewTop.constant = -self.tableView.height
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.layoutIfNeeded()
        }
    }
    
    func dismiss() {
        self.tableViewTop.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            self.backgroundColor = UIColor(white: 0, alpha: 0)
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = tableView.rowHeight*2
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        self.dismiss()
    }
    
    @IBAction func handleTapNextBtn(_ sender: UIButton) {
        self.dismiss()
        if delegate != nil {
            delegate!.handleTapNextBtn()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
    
}
