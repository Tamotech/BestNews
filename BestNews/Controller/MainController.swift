//
//  MainController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

class MainController: BaseViewController, UIScrollViewDelegate, TYPageTitleViewDelegate {

    let titles = ["推荐","快讯","订阅","直播"]
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var titleView: TYPageTitleView?
    var navBarView: UIView?
    var logoView: UIImageView?
    var messageBt: UIButton?
    var menuBt: UIButton?
    var searchButton: UIButton?
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
        self.setupChildView()
        self.setupTitleView()
//        self.setupNavigationItems()
        
    
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
    
    func setupChildView() {
        
        scrollView.contentSize = CGSize(width: screenWidth*CGFloat(titles.count), height: screenHeight-49)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        self.automaticallyAdjustsScrollViewInsets = false
        
        for i in 0..<titles.count {
            if i == 1 {
                let vc = FastNewsController()
                addChildViewController(vc)
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 64+40, width: screenWidth, height: screenHeight-49-64-40)
                scrollView.addSubview(vc.view)
                continue
            }
            else if i == 2 {
                let vc = SubscriptionListControllerViewController()
                addChildViewController(vc)
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 64, width: screenWidth, height: screenHeight-64)
                scrollView.addSubview(vc.view)
                continue
            }
            else if i == 3 {
                let vc = LiveListController()
                addChildViewController(vc)
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 64+40, width: screenWidth, height: screenHeight-64-40)
                scrollView.addSubview(vc.view)
                continue
            }
            let vc = HomeContentViewController()
            addChildViewController(vc)
            let x = screenWidth*CGFloat(i)
            vc.view.frame = CGRect(x: x, y: 64, width: screenWidth, height: screenHeight-49-64)
            scrollView.addSubview(vc.view)
            
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
        
        titleView = TYPageTitleView(frame: CGRect.init(x: 0, y: 0, width: screenWidth-88, height: 44), titles: titles)
        titleView?.delegate = self
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
        searchButton?.setTitle("     搜搜看", for: UIControlState.normal)
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
        }
        
        let messagebt = UIButton(frame: .zero)
        messagebt.setImage(#imageLiteral(resourceName: "icon_message_white"), for: .normal)
        messagebt.addTarget(self, action: #selector(handleTapMessageItem(sender:)), for: UIControlEvents.touchUpInside)
        barView.addSubview(messagebt)
        messagebt.snp.makeConstraints { (make) in
            make.right.equalTo(-4)
            make.left.equalTo(self.searchButton!.snp.right).offset(4)
            make.centerY.equalTo(logo.snp.centerY)
            make.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        barView.addSubview(titleView!)
        titleView?.snp.makeConstraints({ (make) in
            make.left.equalTo(10)
            make.bottom.equalTo(-8)
            make.height.equalTo(44)
        })
        
        let menubt = UIButton(frame: .zero)
        menubt.setImage(#imageLiteral(resourceName: "icon_menu_white"), for: .normal)
        menubt.addTarget(self, action: #selector(handleTapMenuItem(sender:)), for: UIControlEvents.touchUpInside)
        barView.addSubview(menubt)
        menubt.snp.makeConstraints { (make) in
            make.right.equalTo(-4)
            make.centerY.equalTo(titleView!.snp.centerY)
            make.left.equalTo(titleView!.snp.right).offset(15)
            make.size.equalTo(CGSize(width: 50, height: 40))
        }
        
        self.barView.removeFromSuperview()
        self.navBarView = barView
        self.logoView = logo
        self.messageBt = messagebt
        self.menuBt = menubt
        
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
        //让pageView滚动起来
        titleView?.pageViewScrollEnd(pageIndex: index)
    }
    
    //MARK: - TYTitleView
    
    func pageView(pageView: TYPageTitleView, selectIndex: Int) {
        switchToIndex(index: selectIndex)
        scrollView.setContentOffset(CGPoint.init(x: screenWidth*CGFloat(selectIndex), y: 0), animated: true)
    }
    
    
    //MARK: - actions
    
    func handleTapSearchItem(sender: Any) {
        let vc = HomeSearchController(nibName: "HomeSearchController", bundle: nil)
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func handleTapMenuItem(sender: Any) {
        let selectColumnView = SelectColumeView(frame: UIScreen.main.bounds)
        selectColumnView.show()
    }
    
    func handleTapMessageItem(sender: Any) {
        let vc = MessageCenterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToIndex(index: Int) {
        currentIndex = index
        
        if index == 1 || index == 2 || index == 3 {
            self.navBarTurnBg(white: true)
        }
        else {
            let vc = childViewControllers[index]
            if vc is HomeContentViewController {
                (vc as! HomeContentViewController).autoAjustToNavColor()
            }
            else {
                self.navBarTurnBg(white: false)
            }
        }
        if index == 2 || index == 3 {
            ///订阅
            if !SessionManager.sharedInstance.loginInfo.isLogin {
                Toolkit.showLoginVC()
            }
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
            logoView?.image = #imageLiteral(resourceName: "xinhua_logo_red")
            searchButton?.setTitleColor(gray181, for: UIControlState.normal)
            searchButton?.setImage(#imageLiteral(resourceName: "icon_search"), for: UIControlState.normal)
            messageBt?.setImage(#imageLiteral(resourceName: "icon_meassage"), for: UIControlState.normal)
            menuBt?.setImage(#imageLiteral(resourceName: "icon_menu_dark"), for: UIControlState.normal)
        }
        else {
            titleView?.updateTintcolor(currentItemColor: UIColor.init(white: 1, alpha: 1), unselectItemColor: UIColor.init(white: 1, alpha: 0.5))
            UIView.animate(withDuration: 0.3, animations: {
                self.navBarView?.backgroundColor = .clear
                self.blackLayer.opacity = 1
            })
            logoView?.image = #imageLiteral(resourceName: "xinhua_logo_white")
            searchButton?.setTitleColor(.white, for: UIControlState.normal)
            searchButton?.setImage(#imageLiteral(resourceName: "icon_search_white"), for: UIControlState.normal)
            messageBt?.setImage(#imageLiteral(resourceName: "icon_message_white"), for: UIControlState.normal)
            menuBt?.setImage(#imageLiteral(resourceName: "icon_menu_white"), for: UIControlState.normal)
        }
    }
    
    
    
    /// 新华logo变色
    ///
    /// - Parameter red: 红色 or 白色
    func logoTurnColor(_ red: Bool) {
        if red {
            logoView?.image = #imageLiteral(resourceName: "xinhua_logo_red")
        }
        else {
            logoView?.image = #imageLiteral(resourceName: "xinhua_logo_white")
        }
    }

}
