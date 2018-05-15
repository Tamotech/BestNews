//
//  MeController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class MeController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarView: UIButton!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var identityBtn: UIButton!
    
    @IBOutlet weak var subscriptionAmountLb: UILabel!
    
    @IBOutlet weak var collectionAmountLb: UILabel!
    
    @IBOutlet weak var historyAmountLb: UILabel!
    
    @IBOutlet weak var articleAmountLb: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loginView: UIView!
    
    ///订阅 收藏 活动 文章
    @IBOutlet var meMenuItemViews: [UIView]!
    
    @IBOutlet var meMenueItemWidths: [NSLayoutConstraint]!
    
    
    var settingData: [(String, UIImage)] = [
        ("我的活动", #imageLiteral(resourceName: "iconVipM2-3")),
//                     ("实名认证", #imageLiteral(resourceName: "me_identity")),
                       ("开通VIP", #imageLiteral(resourceName: "me_open_vip")),
//                       ("我要投稿", #imageLiteral(resourceName: "me_post_article")),
                       ("成为名人", #imageLiteral(resourceName: "me_become_star")),
                       ("分享APP", #imageLiteral(resourceName: "me_share_app")),
                       ("意见反馈", #imageLiteral(resourceName: "me_feed_back")),
                       ("关于我们", #imageLiteral(resourceName: "icon_about")),
                       ("清除缓存", #imageLiteral(resourceName: "clear_icon")),
                       ("退出登录", #imageLiteral(resourceName: "me_logout"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSwitchToMeControllerNoti(_:)), name: kSwitchTabbarItemNotify, object: nil)
    }

    func setupView() {
        
        self.shouldClearNavBar = false
        self.showCustomTitle(title: "我的")
        let nib = UINib(nibName: "ProfileCenterCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        loginView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapLoginView(_:)))
        loginView.addGestureRecognizer(tap)
        
        let messageItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_meassage"), style: .plain, target: self, action: #selector(handleTapMessageBtn(sender:)))
        navigationItem.rightBarButtonItem = messageItem
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateUserInfo(_:)), name: kUserInfoDidUpdateNotify, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = gray51
        self.navigationController?.navigationBar.barTintColor = gray51
        SessionManager.sharedInstance.getUserInfo()
        loadInfoCount()
        updateUI()
    }
    
    ///切换tab
    @objc func didSwitchToMeControllerNoti(_ noti: Notification) {
        let index = noti.object as! Int
        if index == 4 {
            SessionManager.sharedInstance.getUserInfo()
            loadInfoCount()
            updateUI()
        }
    }
    
    ///更新UI
    func updateUI() {
        
        ///是否展示文章
        var showArticle = false
        if SessionManager.sharedInstance.loginInfo.isLogin {
            if let user = SessionManager.sharedInstance.userInfo {
                if let url = URL(string: user.headimg) {
                    let rc = ImageResource(downloadURL: url)
                    avatarView.kf.setImage(with: rc, for: UIControlState.normal, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
                }
                nameLb.text = user.name
                if user.celebrityflag {
                    settingData = [
                                   ("我的活动", #imageLiteral(resourceName: "iconVipM2-3")),
                                   ("分享APP", #imageLiteral(resourceName: "me_share_app")),
                                   ("意见反馈", #imageLiteral(resourceName: "me_feed_back")),
                                   ("关于我们", #imageLiteral(resourceName: "icon_about")),
                                   ("清除缓存", #imageLiteral(resourceName: "clear_icon")),
                                   ("退出登录", #imageLiteral(resourceName: "me_logout"))]
                    showArticle = true
                }
                else if user.idproveflag {
                    identityBtn.setTitleColor(themeColor, for: .normal)
                    identityBtn.borderColor = themeColor!
                    identityBtn.setTitle("已认证", for: .normal)
                    settingData = [
                        ("我的活动", #imageLiteral(resourceName: "iconVipM2-3")),
//                     ("实名认证", #imageLiteral(resourceName: "me_identity")),
                     //("开通VIP", #imageLiteral(resourceName: "me_open_vip")),
//                     ("我要投稿", #imageLiteral(resourceName: "me_post_article")),
                     //("成为名人", #imageLiteral(resourceName: "me_become_star")),
                     ("分享APP", #imageLiteral(resourceName: "me_share_app")),
                     ("意见反馈", #imageLiteral(resourceName: "me_feed_back")),
                     ("关于我们", #imageLiteral(resourceName: "icon_about")),
                     ("清除缓存", #imageLiteral(resourceName: "clear_icon")),
                     ("退出登录", #imageLiteral(resourceName: "me_logout"))]
                }
                else {
                    identityBtn.setTitleColor(gray181, for: .normal)
                    identityBtn.borderColor = gray181!
                    identityBtn.setTitle("未认证", for: .normal)
                    settingData = [
                        ("我的活动", #imageLiteral(resourceName: "iconVipM2-3")),
//                     ("实名认证", #imageLiteral(resourceName: "me_identity")),
                     //("开通VIP", #imageLiteral(resourceName: "me_open_vip")),
//                     ("我要投稿", #imageLiteral(resourceName: "me_post_article")),
                     //("成为名人", #imageLiteral(resourceName: "me_become_star")),
                     ("分享APP", #imageLiteral(resourceName: "me_share_app")),
                     ("意见反馈", #imageLiteral(resourceName: "me_feed_back")),
                     ("关于我们", #imageLiteral(resourceName: "icon_about")),
                     ("清除缓存", #imageLiteral(resourceName: "clear_icon")),
                     ("退出登录", #imageLiteral(resourceName: "me_logout"))]
                }
            }
            loginView.isHidden = true
            subscriptionAmountLb.isHidden = false
            collectionAmountLb.isHidden = false
            historyAmountLb.isHidden = false
            articleAmountLb.isHidden = false
            
        }
        else {
            avatarView.setImage(#imageLiteral(resourceName: "defaultUser"), for: .normal)
            loginView.isHidden = false
            subscriptionAmountLb.isHidden = true
            collectionAmountLb.isHidden = true
            historyAmountLb.isHidden = true
            articleAmountLb.isHidden = true
            settingData = [
//                0op0-------------("我要投稿", #imageLiteral(resourceName: "me_post_article")),
                //("开通VIP", #imageLiteral(resourceName: "me_open_vip")),
                ("分享APP", #imageLiteral(resourceName: "me_share_app")),
                ("意见反馈", #imageLiteral(resourceName: "me_feed_back")),
                ("关于我们", #imageLiteral(resourceName: "icon_about")),
                ("清除缓存", #imageLiteral(resourceName: "clear_icon"))]
        }
        
        if showArticle {
            let w = screenWidth/4
            for i in 0..<meMenueItemWidths.count {
                let consW = meMenueItemWidths[i]
                consW.constant = w
                let v = meMenuItemViews[i]
                v.isHidden = false
            }
        }
        else {
            let w = screenWidth/3
            for i in 0..<meMenueItemWidths.count-1 {
                let consW = meMenueItemWidths[i]
                consW.constant = w
            }
            meMenueItemWidths.last!.constant = 0
            meMenuItemViews.last!.isHidden = true
        }
        
        tableView.reloadData()
        
        
        //新需求 2018-04-17 已认证按钮隐藏
        identityBtn.isHidden = true
    }
    
    ///通知
    func didUpdateUserInfo(_ noti: Notification) {
        self.updateUI()
        loadInfoCount()
    }
    
    
    //MARK: - actions
    func handleTapMessageBtn(sender: Any) {
        
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        let vc = MessageCenterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    func handleTapLoginView(_ sender: Any) {
        Toolkit.showLoginVC()
    }
    
    @IBAction func handleTapAvatarBtn(_ sender: UIButton) {
        
        if SessionManager.sharedInstance.loginInfo.isLogin {
            let vc = ProfileCenterController(nibName: "ProfileCenterController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            Toolkit.showLoginVC()
        }
    }
    
    ///点击已认证
    @IBAction func handleTapIdentifyBtn(_ sender: UIButton) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
    }
    
    @IBAction func handleTapSubscripBtn(_ sender: Any) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        let vc = MySubscriptListController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapCollection(_ sender: Any) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        let vc = MeCollectionViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapHistory(_ sender: UITapGestureRecognizer) {
        let vc = MyActivityListController()
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTapArticle(_ sender: UITapGestureRecognizer) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        let vc = MyArticleListController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
         return 0.1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProfileCenterCell
        let data = settingData[indexPath.row]
        cell.iconView.image = data.1
        cell.titleLb.text = data.0
        if data.0 == "清除缓存" {
            cell.detailTextLabel?.isHidden = false
            //计算缓存
            ImageCache.default.calculateDiskCacheSize { (size) in
                let msize = size/1024/1024
                cell.detailLb.text = "\(msize)MB"
            }
        }
        else {
            cell.detailTextLabel?.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let name = settingData[indexPath.row].0
        if name == "分享APP" {
            
            if SessionManager.sharedInstance.loginInfo.isLogin == false {
                Toolkit.showLoginVC()
                return
            }
            let vc = ShareAppViewController(nibName: "ShareAppViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
        if name == "我的活动" {
            let vc = MyActivityListController()
            if !SessionManager.sharedInstance.loginInfo.isLogin {
                Toolkit.showLoginVC()
                return
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "实名认证" {
            let vc = ApplyIdentifyController(nibName: "ApplyIdentifyController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "我要投稿" {
            let vc = SubmitPaperController(nibName: "SubmitPaperController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "开通VIP" {
            let vc = OpenVIPController(nibName: "OpenVIPController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "意见反馈" {
            let vc = FeedbackViewController(nibName: "FeedbackViewController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "成为名人" {
            
            let vc = ApplyFamousConditionController(nibName: "ApplyFamousConditionController", bundle: nil)
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "退出登录" {
            let alert = XHAlertController()
            alert.modalPresentationStyle = .overCurrentContext
            self.modalPresentationStyle = .currentContext
            alert.tit = "确认退出登录?"
            alert.callback = {
                (buttonType) in
                if buttonType == 0 {
                    DispatchQueue.main.async {
                        SessionManager.sharedInstance.logoutCurrentUser()
                        //跳转到首页
                        let vc = keyWindow?.rootViewController as? BestTabbarViewController
                        vc?.tabbarView.switchToIndex(index: 0)
                    }
                }
            }
            alert.style = 0
            present(alert, animated: false, completion: nil)
            
        }
        else if name == "关于我们" {
            let vc = AboutUsViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
        else if name == "清除缓存" {
            let alert = XHAlertController()
            alert.modalPresentationStyle = .overCurrentContext
            self.modalPresentationStyle = .currentContext
            alert.tit = "确认清除缓存?"
            alert.msg = ""
            alert.callback = {
                [weak self](buttonType) in
                if buttonType == 0 {
                    DispatchQueue.main.async {
                        ImageCache.default.clearDiskCache()
                        BLHUDBarManager.showSuccess(msg: "缓存清除成功", seconds: 1)
                        self?.tableView.reloadData()
                    }
                }
            }
            alert.style = 0
            present(alert, animated: false, completion: nil)
        }
    }

}

extension MeController {
    
    func loadInfoCount() {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            return
        }
        APIRequest.meInfoCountAPI { [weak self](data) in
            let json = data as! JSON
            let subscribeNum = json["subscribeNum"].intValue
            let collectNum = json["collectNum"].intValue
            let viewhistNum = json["viewhistNum"].intValue
            let articleNum = json["articleNum"].intValue
            self?.subscriptionAmountLb.text = "\(subscribeNum)"
            self?.collectionAmountLb.text = "\(collectNum)"
            self?.historyAmountLb.text = "\(viewhistNum)"
            self?.articleAmountLb.text = "\(articleNum)"
        }
    }
    
}

