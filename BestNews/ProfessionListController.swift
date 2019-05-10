//
//  ProfessionListController.swift
//  BestNews
//
//  Created by Worthy on 2017/11/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

protocol ProfessionListControllerDelegate: class {
    func handleTapConfirmBtn(vc: ProfessionListController, item: String)
}

class ProfessionListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView = UITableView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 420), style: .grouped)
    
    var items: [String] = []
    var selectedItem = ""
    /// 0 普通, 活动用   1 申请名人
    var type = 0
    weak var delegate: ProfessionListControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if type == 0 {
            if SessionManager.sharedInstance.tradeArr.count > 0 {
                items = SessionManager.sharedInstance.tradeArr
                selectedItem = items.first!
            }
        }
        else if type == 1 {
            if SessionManager.sharedInstance.famousTradeArr.count > 0 {
                items = SessionManager.sharedInstance.famousTradeArr
                selectedItem = items.first!
            }
        }
        setupUI()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        self.view.backgroundColor = .clear
        
        let h = 44*CGFloat(items.count)+80+10+50
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(h)
        }
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        header.backgroundColor = .white
        let headerTitleLb = UILabel()
        headerTitleLb.textColor = UIColor(hexString: "#b8b8b8")
        headerTitleLb.text = "请选择行业"
        headerTitleLb.font = UIFont.boldSystemFont(ofSize: 15)
        header.addSubview(headerTitleLb)
        let closeBtn = UIButton()
        closeBtn.setImage(#imageLiteral(resourceName: "close-light-gray"), for: .normal)
        closeBtn.addTarget(self, action: #selector(handleTapClose(_:)), for: .touchUpInside)
        header.addSubview(closeBtn)
        
        headerTitleLb.snp.makeConstraints { (make) in
            make.center.equalTo(header.snp.center)
        }
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.centerY.equalTo(header.snp.centerY)
        }

        tableView.tableHeaderView = header
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 80))
        footer.backgroundColor = .white
        let confirmBtn = UIButton()
        confirmBtn.setTitle("确定", for: .normal)
        confirmBtn.backgroundColor = themeColor
        confirmBtn.layer.cornerRadius = 6
        confirmBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        confirmBtn.addTarget(self, action: #selector(handleTapConfirm(_:)), for: .touchUpInside)
        footer.addSubview(confirmBtn)
        confirmBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-20)
            make.height.equalTo(44)
        }
        tableView.tableFooterView = footer
        
    }
    
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.selectionStyle = .none
            cell?.textLabel?.textColor = UIColor(hexString: "#cbcbcb")
            cell?.tintColor = themeColor
        }
        
        let item = items[indexPath.row]
        if item == selectedItem {
            let att = NSAttributedString(string: item, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
                                                                    NSAttributedStringKey.foregroundColor: themeColor!])
            cell?.textLabel?.attributedText = att
            cell?.accessoryType = .checkmark
        }
        else {
            let att = NSAttributedString(string: item, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
                                                                    NSAttributedStringKey.foregroundColor: UIColor(hexString: "#cbcbcb")!])
            cell?.textLabel?.attributedText = att
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selectedItem = item
        tableView.reloadData()
    }
    
    
    //MARK: - actions
    @objc func handleTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleTapConfirm(_ sender: Any) {
        self.dismiss(animated: true) {
            [weak self] in
            if self?.delegate != nil {
                self?.delegate?.handleTapConfirmBtn(vc: self!, item: self!.selectedItem)
            }
        }
        
    }

}
