//
//  HomeSearchController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class HomeSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var hotwordView: UIView!
    
    @IBOutlet weak var hostoryTableView: UITableView!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        
    }
    
    
    func setupView() {
        searchBar.backgroundImage = UIImage()
        let field = searchBar.value(forKey: "searchField") as? UITextField
        if field != nil {
            field?.backgroundColor = UIColor(ri: 240, gi: 240, bi: 240)
            field?.textColor = gray51
            field?.layer.cornerRadius = 16
            field?.layer.masksToBounds = true
            field?.clearsOnBeginEditing = true
        }
        
        searchBar.delegate = self
        
        hotwordView.isHidden = false
        hostoryTableView.isHidden = true
        resultTableView.isHidden = true
        
        hostoryTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "HistoryCell")
        hostoryTableView.sectionHeaderHeight = 0.1
        hostoryTableView.sectionFooterHeight = 0.1
        hostoryTableView.rowHeight = 44
        hostoryTableView.separatorInset = .zero
        hostoryTableView.delegate = self
        hostoryTableView.dataSource = self
    }

    //MARK: - actions
    
    @IBAction func handleTapCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: false) {
            
        }
    }
   
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == hostoryTableView {
            return 1
        }
        else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hostoryTableView {
            return 10
        }
        else {
            return 12
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hostoryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
            cell.imageView?.image = #imageLiteral(resourceName: "iconSearchM2-7-2")
            cell.textLabel?.text = "历史搜索二"
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            return cell
        }
        else {
            return UITableViewCell()
        }
        
    }
    
    //MARK: - searchbar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        switchToMode(mode: 1)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        switchToMode(mode: 0)
    }
    
    //MARK: - private
    
    
    /// 切换到模式
    ///
    /// - Parameter mode: 0 默认   1 历史搜索  2 搜索结果
    func switchToMode(mode: Int) {
        hostoryTableView.isHidden = (mode != 1)
        resultTableView.isHidden = (mode != 2)
    }

}
