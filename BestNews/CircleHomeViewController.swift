//
//  CircleHomeViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class CircleHomeViewController: BaseViewController, UIScrollViewDelegate, TYPageTitleViewDelegate {

    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var titleView: TYPageTitleView?
    fileprivate var startOffsetX:CGFloat = 0  //按下瞬间的offsetX
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldClearNavBar = false
        self.setupChildView()
        self.setupNavigationItems()
        
    }
    
    override func viewDidLayoutSubviews() {
     super.viewDidLayoutSubviews()
        let navVC = self.navigationController as! BaseNavigationController
        navVC.setBarBackgroundClear(clear: false)
        titleView?.updateTintcolor(currentItemColor: gray51!, unselectItemColor: UIColor(ri: 51, gi: 51, bi: 51, alpha: 0.5)!)
    }
    
    func setupChildView() {
//        let titles = ["机构","名人","理财"]
        let titles = ["财经号"]
        //titleView = TYPageTitleView(frame: CGRect.init(x: 0, y: 0, width: screenWidth-49-88, height: 44), titles: titles)
        let style = TYPageStyle()
        style.labelLayout = .divide
        titleView = TYPageTitleView(frame: CGRect.init(x: 0, y: 0, width: screenWidth-49-88, height: 44), titles: titles, style: style)
        titleView?.delegate = self
        ///TEST:
        titleView?.lineView.isHidden = true
//        self.navigationItem.titleView = titleView
        self.showCustomTitle(title: "财经号")
        
        
        scrollView.contentSize = CGSize(width: screenWidth*CGFloat(titles.count), height: screenHeight-49)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        for i in 0..<titles.count {
            let vc = OrgnizationListController(nibName: "OrgnizationListController", bundle: nil)
            vc.type = i
            vc.shouldClearNavBar = true
            addChildViewController(vc)
            let x = screenWidth*CGFloat(i)
            vc.view.frame = CGRect(x: x, y: navBarHeight, width: screenWidth, height: screenHeight-49 - statusBarHeight)
            scrollView.addSubview(vc.view)
        }
    }
    
    func setupNavigationItems() {
//        let searchItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_search_white"), style: .plain, target: self, action: #selector(handleTapSearchItem(sender:)))
//        let messageItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_message_white"), style: .plain, target: self, action: #selector(handleTapMessageItem(sender:)))
//    
//        navigationItem.leftBarButtonItem = searchItem
//        navigationItem.rightBarButtonItem = messageItem
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
    
    func handleTapMessageItem(sender: Any) {
        let vc = MessageCenterController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func switchToIndex(index: Int) {
        currentIndex = index
        
    }

}

