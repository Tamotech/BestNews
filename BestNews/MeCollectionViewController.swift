//
//  MainController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MeCollectionViewController: BaseViewController, UIScrollViewDelegate, TYPageTitleViewDelegate {
    
    
    var scrollView = UIScrollView(frame: CGRect(x: 0, y: 64, width: screenWidth, height: screenHeight-64))
    var titleView: TYPageTitleView?
    fileprivate var startOffsetX:CGFloat = 0  //按下瞬间的offsetX
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCustomTitle(title: "我的收藏")
        self.shouldClearNavBar = false
        self.setupChildView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.switchToIndex(index: currentIndex)
        self.navigationController?.navigationBar.tintColor = gray51
    }
    
    func setupChildView() {
        let titles = ["新闻","快讯","视频","活动"]
        scrollView.alwaysBounceHorizontal = false
        let style = TYPageStyle()
        style.normalColor = UIColor(hexString: "#333333", alpha: 0.5)!
        style.selectColor = UIColor(hexString: "#333333", alpha: 1)!
        style.backgroundColor = UIColor.white
        style.labelLayout = .divide
        titleView = TYPageTitleView(frame: CGRect.init(x: 0, y: 64, width: screenWidth, height: 44), titles: titles, style: style)
        titleView?.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
        titleView?.layer.shadowOffset = CGSize(width: 0, height: 1)
        titleView?.layer.shadowRadius = 3
        titleView?.layer.shadowOpacity = 1
        titleView?.delegate = self
        
        scrollView.contentSize = CGSize(width: screenWidth*CGFloat(titles.count), height: screenHeight-64)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(scrollView)
        self.view.addSubview(titleView!)
        self.automaticallyAdjustsScrollViewInsets = false
        
        for i in 0..<titles.count {
            if i == 0 {
                let vc = CollectionNewsListController()
                addChildViewController(vc)
                vc.entry = 1
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 44, width: screenWidth, height: screenHeight-44-64)
                scrollView.addSubview(vc.view)
                continue
            }
            else if i == 1 {
                let vc = FastNewsController(nibName: "FastNewsController", bundle: nil)
                vc.entry = 1
                vc.collectFilter = true
                addChildViewController(vc)
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 44, width: screenWidth, height: screenHeight-44-64)
                scrollView.addSubview(vc.view)
                continue
            }
            else if i == 2 {
                let vc = LiveListController(nibName: "LiveListController", bundle: nil)
                vc.collect = true
                vc.entry = 1
                addChildViewController(vc)
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: 44, width: screenWidth, height: screenHeight-44)
                scrollView.addSubview(vc.view)
                continue
            }
            else if i == 3 {
                let vc = ActivityController(nibName: "ActivityController", bundle: nil)
                vc.entry = 1
                vc.collectFlag = true
                addChildViewController(vc)
                let x = screenWidth*CGFloat(i)
                vc.view.frame = CGRect(x: x, y: -20, width: screenWidth, height: screenHeight)
                scrollView.addSubview(vc.view)
                continue
            }
//            let vc = HomeContentViewController()
//            addChildViewController(vc)
//            let x = screenWidth*CGFloat(i)
//            vc.view.frame = CGRect(x: x, y: 44, width: screenWidth, height: screenHeight-44-64)
//            scrollView.addSubview(vc.view)
            
        }
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
    
    
    
    func switchToIndex(index: Int) {
        currentIndex = index
        
//        if index == 1 || index == 2 || index == 4 {
//            self.navBarTurnBg(white: true)
//        }
//        else {
//            let vc = childViewControllers[index]
//            if vc is HomeContentViewController {
//                (vc as! HomeContentViewController).autoAjustToNavColor()
//            }
//            else {
//                self.navBarTurnBg(white: false)
//            }
//        }
    }
    
    /// 导航栏颜色变化
    func navBarTurnBg(white: Bool) {
        let navVC = self.navigationController as! BaseNavigationController
        if white {
            navVC.setBarBackgroundClear(clear: false)
            titleView?.updateTintcolor(currentItemColor: gray51!, unselectItemColor: UIColor(ri: 51, gi: 51, bi: 51, alpha: 0.5)!)
            UIView.animate(withDuration: 0.3, animations: {
                self.barView.alpha = 1
            })
        }
        else {
            navVC.setBarBackgroundClear(clear: true)
            titleView?.updateTintcolor(currentItemColor: UIColor.init(white: 1, alpha: 1), unselectItemColor: UIColor.init(white: 1, alpha: 0.5))
            UIView.animate(withDuration: 0.3, animations: {
                self.barView.alpha = 0
            })
        }
    }
    
}

