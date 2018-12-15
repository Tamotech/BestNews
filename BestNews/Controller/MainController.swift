//
//  MainController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher


let kSaveInvitorID = "save_invitor_id_key"

class MainController: BaseViewController, UIScrollViewDelegate, TYPageTitleViewDelegate {

    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var titleView: TYPageTitleView?
    var navBarView: UIView?
    var logoView: UIImageView?
    var menuBt: UIButton?
    var searchButton: UIButton?
    
    ///标记childView
    let kStabelChildTag: Int = 1104
    let kUnstabelChildTag: Int = 1105
    
    ///childViewControllers
    var cvcs: [UIViewController] = []
    
    var ad: AdvertiseModel?    //广告
    var adSeconds: Int = 5
    var adView: UIView?
    var skipADBtn: UIButton?
    var logoUrl: String?
    
    
    lazy var blackLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 64+44)
        layer.colors = [UIColor.black.cgColor, UIColor.black.cgColor, UIColor.init(white: 0, alpha: 0).cgColor]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        return layer
    }()
    
    fileprivate var startOffsetX:CGFloat = 0  //按下瞬间的offsetX
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldClearNavBar = false
        view.backgroundColor = .white
        self.setupChildView()
        self.setupTitleView()
        self.setupNavTitleView()
//        self.setupNavigationItems()
        
        self.loadHomeAD()
        self.readADModel()
        self.getLogoInfo()
    
        NotificationCenter.default.addObserver(self, selector: #selector(loginStatusChangeNotifi(_:)), name: kUserLoginStatusChangeNoti, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkFailNoti(_:)), name: kNetFailNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needReloadData(_:)), name: kTapReloadNotify, object: nil)
        
        #if DEBUG
        let lb = UILabel(frame: CGRect(x: 20, y: 100, width: 200, height: 100))
        lb.textColor = .red
        lb.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        lb.text = "测试环境"
        keyWindow?.addSubview(lb)
        #endif
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        titleView?.pageViewScrollEnd(pageIndex: currentIndex)
        switchToIndex(index: currentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)    }
    
    
    @objc func loginStatusChangeNotifi(_ noti: Notification) {
        currentIndex = 0
        titleView?.pageViewScrollEnd(pageIndex: 0)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        switchToIndex(index: 0)
    }
    
    @objc func networkFailNoti(_ noti: Notification) {
        if self.presentedViewController == nil {
            let vc = NetworkFailViewController.init(nibName: "NetworkFailViewController", bundle: nil)
            present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func needReloadData(_ noti: Notification) {
        self.loadHomeAD()
        self.readADModel()
    }
 
    func setupChildView() {
        
        let titles = HomeModel.shareInstansce.navTitles()
        for childView in scrollView.subviews {
            if childView.tag == kUnstabelChildTag {
                childView.removeFromSuperview()
                cvcs.remove(at: scrollView.subviews.count-2)
            }
        }
        
        scrollView.contentSize = CGSize(width: screenWidth*CGFloat(HomeModel.shareInstansce.navTitles().count), height: screenHeight-49-bottomGuideHeight)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        self.automaticallyAdjustsScrollViewInsets = false
        
        ///首次
        if scrollView.subviews.count == 0 {
            for i in 0..<titles.count {
                if i == 0 {
                    let vc = HomeContentViewController()
                    cvcs.append(vc)
                    addChildViewController(vc)
                    let x = screenWidth*CGFloat(i)
                    vc.view.frame = CGRect(x: x, y: 64, width: screenWidth, height: screenHeight-64)
                    scrollView.addSubview(vc.view)
                    vc.view.tag = kStabelChildTag
                }
                else if i == 1 {
                    let vc = FastNewsController(nibName: "FastNewsController", bundle: nil)
                    cvcs.append(vc)
                    addChildViewController(vc)
                    let x = screenWidth*CGFloat(i)
                    vc.view.frame = CGRect(x: x, y: 64+44, width: screenWidth, height: screenHeight-49-64-44)
                    scrollView.addSubview(vc.view)
                    vc.view.tag = kStabelChildTag
                    continue
                }
                else if i == 2 {
                    let vc = SubscriptionListControllerViewController(nibName: "SubscriptionListControllerViewController", bundle: nil)
                    cvcs.append(vc)
                    addChildViewController(vc)
                    let x = screenWidth*CGFloat(i)
                    vc.view.frame = CGRect(x: x, y: 64+44, width: screenWidth, height: screenHeight-64-44)
                    scrollView.addSubview(vc.view)
                    vc.view.tag = kStabelChildTag
                    continue
                }
                else if i == HomeModel.shareInstansce.navTitles().count - 1 {
                    let vc = LiveListController(nibName: "LiveListController", bundle: nil)
                    cvcs.append(vc)
                    addChildViewController(vc)
                    let x = screenWidth*CGFloat(i)
                    vc.view.frame = CGRect(x: x, y: 64+44, width: screenWidth, height: screenHeight-64-44)
                    scrollView.addSubview(vc.view)
                    vc.view.tag = kStabelChildTag
                    continue
                }
                else {
                    //专题
                    let title = HomeModel.shareInstansce.navTitles()[i]
                    let data = HomeModel.shareInstansce.getChannel(title)
                    let vc = SpecialChannelArticleListController()
                    vc.channel = data
                    cvcs.insert(vc, at: cvcs.count-1)
                    addChildViewController(vc)
                    let x = screenWidth*CGFloat(i)
                    vc.view.frame = CGRect(x: x, y: 44, width: screenWidth, height: screenHeight-49-44)
                    scrollView.addSubview(vc.view)
                    vc.view.tag = kUnstabelChildTag
                }
                
            }
        }
        else if scrollView.subviews.count == 4 {
            
            ///调整固定的frame
            let v1 = scrollView.subviews[0]
            let x = screenWidth*CGFloat(0)
            v1.frame = CGRect(x: x, y: 64+44, width: screenWidth, height: screenHeight-49-64-44)
            
            let v2 = scrollView.subviews[1]
            let x2 = screenWidth*CGFloat(1)
            v2.frame = CGRect(x: x2, y: 64+44, width: screenWidth, height: screenHeight-49-64-44)
            
            let v3 = scrollView.subviews[2]
            let x3 = screenWidth*CGFloat(2)
            v3.frame = CGRect(x: x3, y: 64+44, width: screenWidth, height: screenHeight-64-44)
            
            let v4 = scrollView.subviews[3]
            let x4 = screenWidth*CGFloat(titles.count-1)
            v4.frame = CGRect(x: x4, y: 64+44, width: screenWidth, height: screenHeight-64-44)
            
            //新加入的专题
            for i in 3..<titles.count-1 {
                let data = HomeModel.shareInstansce.specilList[i-3]
                let vc = SpecialChannelArticleListController()
                vc.channel = data
                vc.showCustomTitle(title: "")
                cvcs.insert(vc, at: cvcs.count-1)
                addChildViewController(vc)
                vc.barView.removeFromSuperview()
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 44, width: screenWidth, height: screenHeight-49-44)
                scrollView.addSubview(vc.view)
                vc.view.tag = kUnstabelChildTag
            }
        }
        if self.navBarView != nil {
            self.view.bringSubview(toFront: self.navBarView!)
        }
    }
    
    func setupNavigationItems() {
        let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_search_white"), style: .plain, target: self, action: #selector(handleTapSearchItem(sender:)))
        let messageItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_message_white"), style: .plain, target: self, action: #selector(handleTapMessageItem(sender:)))
        let menuItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_menu_white"), style: .plain, target: self, action: #selector(handleTapMenuItem(sender:)))
        navigationItem.leftBarButtonItem = searchItem
        navigationItem.rightBarButtonItems = [messageItem, menuItem]
    }
    
    
    
    func setupTitleView() {
     
     
        let barView = UIView(frame: .zero)
        self.view.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(64+40)
     
        }
     
        barView.layer.addSublayer(blackLayer)
     
        let logo = UIImageView(frame: .zero)
        logo.image = #imageLiteral(resourceName: "xinhua_logo_white")
        logo.contentMode = .scaleAspectFit
        barView.addSubview(logo)
        logo.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(20)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
     
        self.searchButton = UIButton(frame: .zero)
        searchButton?.setImage(#imageLiteral(resourceName: "icon_search_white"), for: UIControlState.normal)
        searchButton?.setTitle("     输入您要搜索的内容", for: UIControlState.normal)
        searchButton?.backgroundColor = UIColor(hexString: "#e5e5e5", alpha: 0.5)
        searchButton?.layer.cornerRadius = 15
        searchButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        searchButton?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        searchButton?.imageEdgeInsets = UIEdgeInsetsMake(6, 15, 6, 10)
        barView.addSubview(searchButton!)
        searchButton?.addTarget(self, action: #selector(handleTapSearchItem(sender:)), for: UIControlEvents.touchUpInside)
        searchButton?.snp.makeConstraints { (make) in
            make.left.equalTo(logo.snp.right).offset(10)
            make.centerY.equalTo(logo.snp.centerY).offset(0)
            make.height.equalTo(30)
            make.right.equalTo(-10)
        }
     
//        let messagebt = UIButton(frame: .zero)
//        messagebt.setImage(#imageLiteral(resourceName: "icon_message_white"), for: .normal)
//        messagebt.addTarget(self, action: #selector(handleTapMessageItem(sender:)), for: UIControlEvents.touchUpInside)
//        barView.addSubview(messagebt)
//        messagebt.snp.makeConstraints { (make) in
//            make.right.equalTo(-4)
//            make.left.equalTo(self.searchButton!.snp.right).offset(4)
//            make.centerY.equalTo(logo.snp.centerY)
//            make.size.equalTo(CGSize(width: 50, height: 40))
//        }
     
        let menubt = UIButton(frame: .zero)
        menubt.setImage(#imageLiteral(resourceName: "icon_menu_white"), for: .normal)
        menubt.addTarget(self, action: #selector(handleTapMenuItem(sender:)), for: UIControlEvents.touchUpInside)
        barView.addSubview(menubt)
        menubt.snp.makeConstraints { (make) in  
            make.right.equalTo(-10)
            make.bottom.equalTo(-4)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
     
        self.barView.removeFromSuperview()
        self.navBarView = barView
        self.logoView = logo
        self.menuBt = menubt
        self.navBarTurnBg(white: true)
    }
    
    func setupNavTitleView() {
        if titleView?.superview != nil {
            titleView?.removeFromSuperview()
        }
        titleView = TYPageTitleView(frame: CGRect.init(x: 10, y: 0, width: screenWidth-64-10, height: 36), titles: HomeModel.shareInstansce.navTitles())
        titleView?.delegate = self
        self.navBarView!.addSubview(titleView!)
        titleView?.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-8)
            make.height.equalTo(36)
            make.right.equalTo(-64)
        })
        titleView?.updateTintcolor(currentItemColor: gray51!, unselectItemColor: UIColor(ri: 51, gi: 51, bi: 51, alpha: 0.5)!)
    }
    
    //MARK: - scrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
        isForbideScroll = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if startOffsetX == scrollView.contentOffset.x { return }
        if isForbideScroll { return}
        
        //scroll滚动的情况下，让item大小变化
        var progress:CGFloat = 0
        var nextIndex = 0
        let width = scrollView.bounds.size.width
        let count = Int(scrollView.contentSize.width/width)
        
        //判断是左移还是右移
        if startOffsetX > scrollView.contentOffset.x{    //右移动
            nextIndex = currentIndex - 1
            if nextIndex < 0 {
                nextIndex = 0
            }
            //计算progress
            progress = (startOffsetX - scrollView.contentOffset.x)/width
        }
        if startOffsetX < scrollView.contentOffset.x{    //左移
            
            nextIndex = currentIndex + 1
            if nextIndex > count - 1 {
                nextIndex = count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetX)/width
        }
        titleView?.pageViewScroll(nextIndex: nextIndex, progress: progress)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //拖动结束 计算index
        var index = Int(scrollView.contentOffset.x/scrollView.bounds.size.width)
        let width = scrollView.bounds.size.width
        let count = Int(scrollView.contentSize.width/width)
        if index < 0{
            index = 0
        }
        if index > count - 1 {
            index = count - 1
        }
        //设置viewFrame
        switchToIndex(index: index)
        NotificationCenter.default.post(name: kDidSwitchNavTitleNotify, object: index)
        //让pageView滚动起来
        titleView?.pageViewScrollEnd(pageIndex: index)
        titleView?.pageViewScroll(nextIndex: index-1, progress: 0)
    }
    
    //MARK: - TYTitleView
    
    func pageView(pageView: TYPageTitleView, selectIndex: Int) {
        scrollView.setContentOffset(CGPoint.init(x: screenWidth*CGFloat(selectIndex), y: 0), animated: true)
        switchToIndex(index: selectIndex)
        NotificationCenter.default.post(name: kDidSwitchNavTitleNotify, object: selectIndex)
    }
    
    
    //MARK: - actions
    
    func handleTapSearchItem(sender: Any) {
        let vc = HomeSearchController(nibName: "HomeSearchController", bundle: nil)
        let navVC = BaseNavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: false, completion: nil)
    }
    
    func handleTapMenuItem(sender: Any) {
        let selectColumnView = SelectColumeView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
        selectColumnView.mainVC = self
        selectColumnView.show()
    }
    
    func handleTapMessageItem(sender: Any) {
        let vc = MessageCenterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToIndex(index: Int) {
        currentIndex = index
        let vc = cvcs[index]
        if vc is HomeContentViewController {
            (vc as! HomeContentViewController).autoAjustToNavColor()
        }
        else if vc is FastNewsController {
            self.navBarTurnBg(white: true)
        }
        else if vc is SubscriptionListControllerViewController || vc is LiveListController {
            self.navBarTurnBg(white: true)
            if !SessionManager.sharedInstance.loginInfo.isLogin {
                Toolkit.showLoginVC()
            }
        }
        else if vc.view.tag == kUnstabelChildTag {
            self.navBarTurnBg(white: true)
        }
    }
    
    /// 导航栏颜色变化
    func navBarTurnBg(white: Bool) {
        
        if white {
            titleView?.updateTintcolor(currentItemColor: gray51!, unselectItemColor: UIColor(ri: 51, gi: 51, bi: 51, alpha: 0.5)!)
            UIView.animate(withDuration: 0.3, animations: {
                self.navBarView?.backgroundColor = .white
                self.blackLayer.opacity = 0
            })
            logoView?.sd_setImage(with: URL(string: logoUrl ?? ""), completed: nil)
            searchButton?.setTitleColor(gray181, for: UIControlState.normal)
            searchButton?.setImage(#imageLiteral(resourceName: "m221_search_black"), for: UIControlState.normal)
            menuBt?.setImage(#imageLiteral(resourceName: "icon_menu_dark"), for: UIControlState.normal)
        }
        else {
            //始终显示白色
            /*titleView?.updateTintcolor(currentItemColor: UIColor.init(white: 1, alpha: 1), unselectItemColor: UIColor.init(white: 1, alpha: 0.5))
            UIView.animate(withDuration: 0.3, animations: {
                self.navBarView?.backgroundColor = .clear
                self.blackLayer.opacity = 1
            })
            logoView?.image = #imageLiteral(resourceName: "xinhua_logo_white")
            searchButton?.setTitleColor(.white, for: UIControlState.normal)
            searchButton?.setImage(#imageLiteral(resourceName: "m221_search_white"), for: UIControlState.normal)
            messageBt?.setImage(#imageLiteral(resourceName: "icon_message_white"), for: UIControlState.normal)
            menuBt?.setImage(#imageLiteral(resourceName: "icon_menu_white"), for: UIControlState.normal)*/
        }
 
    }
    
    
    
    /// 新华logo变色
    ///
    /// - Parameter red: 红色 or 白色
    func logoTurnColor(_ red: Bool) {
        
        if red {
            logoView?.sd_setImage(with: URL(string: logoUrl ?? ""), completed: nil)
        }
        else {
            logoView?.sd_setImage(with: URL(string: logoUrl ?? ""), completed: nil)
        }
    }

    ///导航专题
    func updateNavTitleUI() {
        
    }
    
    
    /// 按标题切换
    ///
    /// - Parameter title: 标题
    func switchToVCWithTitle(_ title: String) {
        for (i, item) in titleView!.titles.enumerated() {
            if item == title {
                titleView?.pageViewScrollEnd(pageIndex: i)
                scrollView.setContentOffset(CGPoint.init(x: screenWidth*CGFloat(i), y: 0), animated: true)
                switchToIndex(index: i)
                return
            }
        }
    }
    
    
    //从本地读广告  防止空白页
    func readADModel() {
        let dic = UserDefaults.standard.object(forKey: "start_ad_key001") as? [String: Any]
        if dic != nil {
            let ad = AdvertiseModel()
            ad.path = dic!["path"] as? String ?? ""
            ad.outlink = dic!["link"] as? String ?? ""
            ad.imgData = dic!["data"] as? Data
            ad.code = dic!["code"] as? String ?? ""
            self.ad = ad
            self.showHomeAD(ad)
        }
        
    }
    
    //获取广告 保存本地
    func loadHomeAD() {
        APIRequest.advertisementAPI { [weak self](data) in
            if data != nil {
                let ad = data as! AdvertiseModel
                do {
                    let data = try Data(contentsOf: URL(string: ad.suitADImg)!)
                    //保存本地
                    let dic: [String: Any] = [
                        "path": ad.suitADImg,
                        "link": ad.outlink,
                        "data": data,
                    ]
                    UserDefaults.standard.set(dic, forKey: "start_ad_key001")
                    if self?.ad?.suitADImg != ad.suitADImg {
                        //新下载的广告不同于上次的广告
                        if let adimg = keyWindow?.viewWithTag(1213) as? UIImageView {
                            if let url = URL(string: ad.suitADImg) {
                                let rc = ImageResource(downloadURL: url)
                                adimg.kf.setImage(with: rc)
                            }
                        }
                    }
                }
                catch {
                    
                }
               
            }
        }
    }
    
    //展现广告
    func showHomeAD(_ ad: AdvertiseModel) {
        let im = UIImageView(frame: UIScreen.main.bounds)
        im.contentMode = .scaleAspectFill
        im.backgroundColor = .white
        if ad.imgData != nil {
            im.image = UIImage(data: ad.imgData!)
        }
//        if let url = URL(string: ad.path) {
//            let rc = ImageResource(downloadURL: url)
//            im.kf.setImage(with: rc)
//        }
        im.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAD(_:)))
        im.addGestureRecognizer(tap)
        
        let btn = UIButton(frame: CGRect(x: screenWidth-100, y: 20, width: 70, height: 28))
        btn.backgroundColor = UIColor(hexString: "#000000", alpha: 0.5)
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 10)
        btn.layer.cornerRadius = 14
        btn.setTitle(" 5         ", for: UIControlState.normal)
        btn.setTitleColor(UIColor.init(hexString: "#0098FF"), for: UIControlState.normal)
        btn.addTarget(self, action: #selector(tapSkip(_:)), for: UIControlEvents.touchUpInside)
        im.addSubview(btn)
        let lb = UILabel(frame: CGRect(x: 26, y: 0, width: 40, height: 28))
        lb.textColor = .white
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.text = "跳过"
        btn.addSubview(lb)
        
        im.tag = 1213
        keyWindow?.addSubview(im)
        self.ad = ad
        adView = im
        skipADBtn = btn
        
        let t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleADTimerEvent(_:)), userInfo: nil, repeats: true)
        RunLoop.main.add(t, forMode: RunLoopMode.commonModes)
        t.fire()
    }
    
    func handleADTimerEvent(_ t: Timer) {
        adSeconds = adSeconds - 1
        if adSeconds <= 0 {
            t.invalidate()
            adView?.removeFromSuperview()
        }
        DispatchQueue.main.async {
            self.skipADBtn?.setTitle("\(self.adSeconds)", for: UIControlState.normal)
        }
    }
    
    
    func tapSkip(_ sender: UIButton) {
        let adView = sender.superview
        adView?.removeFromSuperview()
    }
    
    @objc
    func tapAD(_ sender: Any) {
        adView?.removeFromSuperview()
        if let url = URL(string: ad!.outlink) {
            //打开外部链接
            UIApplication.shared.openURL(url)
        }
    }
    
    ///获取首页logo
    func getLogoInfo() {
        let path = "/config/appLogo.htm"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { [weak self] (json, code, msg) in
            if let data = json?["data"]["ios"]["size_3x"].rawString() {
                self?.logoUrl = data
                self?.logoView?.sd_setImage(with: URL(string: data), completed: nil)
            }
        }
    }
}
