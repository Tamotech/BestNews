//
//  HomeSearchController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class HomeSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var hostoryTableView: UITableView!
    
    @IBOutlet weak var resultTableView: UITableView!
    
    @IBOutlet weak var historyTableViewBottom: NSLayoutConstraint!
    
    let historyKey = "kHistoryWords"
    //历史搜索记录
    lazy var historyKeywords: [String] = {
        let x = UserDefaults.standard.object(forKey: self.historyKey)
        if x != nil {
            return x as! [String]
        }
        return []
    }()
    
    lazy var hotwordView: UIView = {
        
        let h: CGFloat = 40
        let v = UIView(frame: CGRect(x: 0, y: 65, width: screenWidth, height: 160))
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: h))
        header.backgroundColor = .white
        let fire = UIImageView(frame: CGRect(x: 16, y: 10, width: 20, height: 20))
        fire.image = #imageLiteral(resourceName: "HotM2-7-1")
        fire.contentMode = .scaleAspectFit
        header.addSubview(fire)
        let titleLb = UILabel(frame: CGRect(x: 40, y: 10, width: 100, height: 20))
        titleLb.text = "热搜"
        titleLb.font = UIFont.systemFont(ofSize: 14)
        titleLb.textColor = gray72
        header.addSubview(titleLb)
        let line1 = UIView(frame: CGRect(x: 0, y: h-1, width: screenWidth, height: 1))
        line1.backgroundColor = UIColor.groupTableViewBackground
        header.addSubview(line1)
        v.addSubview(header)
        
        let hotwords = SessionManager.sharedInstance.hotwords
        for i in 0..<hotwords.count {
            let x: CGFloat = 15 + CGFloat(i%2)*screenWidth/2
            let y = 40+CGFloat(i/2)*h+10
            let l = UILabel(frame: CGRect(x: x, y: y, width: screenWidth/2-20, height: 20))
            l.font = UIFont.systemFont(ofSize: 15)
            l.textColor = gray51
            l.text = hotwords[i]
            v.addSubview(l)
            if i%2 == 0 {
                let line2 = UIView(frame: CGRect(x: screenWidth/2, y: y, width: 1, height: h-20))
                line2.backgroundColor = UIColor.groupTableViewBackground
                v.addSubview(line2)
            }
            else {
                let line2 = UIView(frame: CGRect(x: 0, y: y+h-10, width: screenWidth, height: 1))
                line2.backgroundColor = UIColor.groupTableViewBackground
                v.addSubview(line2)
            }
        }
        v.height = CGFloat(hotwords.count/2)*h+h
        v.backgroundColor = .white
        return v
    }()
    
    var searchResult: HomeSearchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.view.addSubview(self.hotwordView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        footer.backgroundColor = .white
        let cleanBtn = UIButton(frame: footer.bounds)
        cleanBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        cleanBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cleanBtn.setTitle("  清空历史记录", for: UIControlState.normal)
        cleanBtn.setImage(#imageLiteral(resourceName: "iconTrashM2-7-2"), for: UIControlState.normal)
        cleanBtn.addTarget(self, action: #selector(handleCleanHistory(_:)), for: UIControlEvents.touchUpInside)
        footer.addSubview(cleanBtn)
        let line = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        line.backgroundColor = UIColor.groupTableViewBackground
        footer.addSubview(line)
        hostoryTableView.tableFooterView = footer
        
        let nib1 = UINib(nibName: "SearchArticleCell", bundle: nil)
        resultTableView.register(nib1, forCellReuseIdentifier: "Article")
        let nib2 = UINib(nibName: "FastNewsCell", bundle: nil)
        resultTableView.register(nib2, forCellReuseIdentifier: "Cell")
        let nib3 = UINib(nibName: "SubscriptListCell", bundle: nil)
        resultTableView.register(nib3, forCellReuseIdentifier: "ColumeCell")
        resultTableView.estimatedRowHeight = 123
        resultTableView.rowHeight = UITableViewAutomaticDimension

    }
    
    deinit {
        UserDefaults.standard.set(historyKeywords, forKey: historyKey)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.removeObserver(self)
    }
    
    //Notification
    func keyboardWillShow(_ noti: Notification) {
        let userinfo = noti.userInfo!
        let bounds = (userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        historyTableViewBottom.constant = bounds.height
    }

    //MARK: - actions
    
    func handleCleanHistory(_ sender: UIButton) {
        historyKeywords.removeAll()
        hostoryTableView.reloadData()
    }
    
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
            if searchResult != nil {
                return searchResult!.sectionNum()
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == hostoryTableView {
            return historyKeywords.count
        }
        else {
            return searchResult!.rowsNumInSection(section)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == hostoryTableView {
            return 0.1
        }
        else {
            
            if section == 0 {
                if searchResult!.normalArticle.list.count == 0 {
                    return 0.1
                }
                return 44
            }
            else if section == 1 {
                if searchResult!.newsflash.list.count == 0 {
                    return 0.1
                }
                return 44
            }
            else if section == 2 {
                if searchResult!.specialArticle.list.count == 0 {
                    return 0.1
                }
                return 44
            }
            else if section == 3 {
                if searchResult!.activity.list.count == 0 {
                    return 0.1
                }
                return 44
            }
            else if section == 4 {
                if searchResult!.organize.list.count == 0 {
                    return 0.1
                }
                return 44
            }
            else if section == 5 {
                if searchResult!.celebrityuser.list.count == 0 {
                    return 0.1
                }
                return 44
            }
            return 44
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if tableView == hostoryTableView {
            return nil
        }
        let v = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        v.backgroundColor = .white
        let l = UILabel(frame: v.bounds)
        l.contentMode = .center
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.textColor = gray51
        v.addSubview(l)
        if section == 0 {
            if searchResult!.normalArticle.list.count == 0 {
                return nil
            }
            l.text = "文章"
            return v
        }
        else if section == 1 {
            if searchResult!.newsflash.list.count == 0 {
                return nil
            }
            l.text = "快讯"
            return v
        }
        else if section == 2 {
            if searchResult!.specialArticle.list.count == 0 {
                return nil
            }
            l.text = "专题"
            return v
        }
        else if section == 3 {
            if searchResult!.activity.list.count == 0 {
                return nil
            }
            l.text = "活动"
            return v
        }
        else if section == 4 {
            if searchResult!.organize.list.count == 0 {
                return nil
            }
            l.text = "机构"
            return v
        }
        else if section == 5 {
            if searchResult!.celebrityuser.list.count == 0 {
                return nil
            }
            l.text = "名人"
            return v
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == hostoryTableView {
            let word = historyKeywords[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
            cell.imageView?.image = #imageLiteral(resourceName: "iconSearchM2-7-2")
            cell.textLabel?.text = word
            cell.selectionStyle = .none
            cell.separatorInset = .zero
            return cell
        }
        else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as! SearchArticleCell
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! HomeArticle
                cell.updateCell(model)
                return cell
            }
            else if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FastNewsCell
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! FastNews
                cell.updateCell(news: model)
                cell.collectBtn.isHidden = true
                cell.repostBtn.isHidden = true
                cell.contentLb.numberOfLines = 2
                return cell
            }
            else if indexPath.section == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as! SearchArticleCell
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! HomeArticle
                cell.updateCell(model)
                return cell
            }
            else if indexPath.section == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Article", for: indexPath) as! SearchArticleCell
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! ActivityModel
                cell.updateCell(model)
                return cell
            }
            else if indexPath.section == 4 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath) as! SubscriptListCell
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! OgnizationModel
                cell.updateCell(model)
                return cell
            }
            else if indexPath.section == 5 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ColumeCell", for: indexPath) as! SubscriptListCell
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! OgnizationModel
                cell.updateCell(model)
                return cell
            }
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == hostoryTableView {
            let word = historyKeywords[indexPath.row]
            switchToMode(mode: 2)
            loadSearchResult(word)
        }
        else {
            if indexPath.section == 0 {
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! HomeArticle
                let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
                vc.articleId = model.id
                navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.section == 1 {
                
            }
            else if indexPath.section == 2 {
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! HomeArticle
                let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
                vc.articleId = model.id
                navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.section == 3 {
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! ActivityModel
                let vc = ActivityDetailController(nibName: "ActivityDetailController", bundle: nil)
                vc.activityId = model.id
                navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.section == 4 {
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! OgnizationModel
                let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
                vc.ognization = model
                navigationController?.pushViewController(vc, animated: true)
            }
            else if indexPath.section == 5 {
                let model = searchResult!.model(section: indexPath.section, row: indexPath.row) as! OgnizationModel
                let vc = OrgnizationController(nibName: "OrgnizationController", bundle: nil)
                vc.ognization = model
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    //MARK: - searchbar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        switchToMode(mode: 1)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text!.count == 0 {
            switchToMode(mode: 0)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //点击搜索
        let word = searchBar.text!
        if word.count>0 && !historyKeywords.contains(word) {
            historyKeywords.append(word)
        }
        if word.count > 0 {
            switchToMode(mode: 2)
            loadSearchResult(word)
        }
    }
    
    //MARK: - private
    
    
    /// 切换到模式
    ///
    /// - Parameter mode: 0 默认   1 历史搜索  2 搜索结果
    func switchToMode(mode: Int) {
        hotwordView.isHidden = (mode != 0)
        hostoryTableView.isHidden = (mode != 1)
        resultTableView.isHidden = (mode != 2)
        if mode == 1 {
            hostoryTableView.reloadData()
        }
    }
    
    //搜索
    func loadSearchResult(_ key: String) {
        APIRequest.homeSearchAPI(keyword: key, type: nil, page: 1, row: 3) { [weak self](data) in
            
            self?.searchResult = data as? HomeSearchModel
            self?.resultTableView.reloadData()
        }
    }

}
