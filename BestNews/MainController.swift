//
//  MainController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/11.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class MainController: BaseViewController, UIScrollViewDelegate, TYPageTitleViewDelegate {

    
    var scrollView = UIScrollView(frame: UIScreen.main.bounds)
    var titleView: TYPageTitleView?
    fileprivate var startOffsetX:CGFloat = 0  //按下瞬间的offsetX
    fileprivate var isForbideScroll:Bool = false
    fileprivate var currentIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldClearNavBar = true
        self.setupChildView()
        self.setupNavigationItems()
        
    }
    
    func setupChildView() {
        let titles = ["推荐","快讯","订阅","十九大","直播", "推荐","快讯","订阅","十九大","直播"]
        titleView = TYPageTitleView(frame: CGRect.init(x: 0, y: 0, width: screenWidth-49-88, height: 44), titles: titles)
        titleView?.delegate = self
        self.navigationItem.titleView = titleView
        
        scrollView.contentSize = CGSize(width: screenWidth*CGFloat(titles.count), height: screenHeight-49)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        for i in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = [UIColor.red, UIColor.green, UIColor.orange][i%3]
            addChildViewController(vc)
            let x = screenWidth*CGFloat(i)
            vc.view.frame = CGRect(x: x, y: 0, width: screenWidth, height: screenHeight-49)
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
        currentIndex = index
        //让pageView滚动起来
        titleView?.pageViewScrollEnd(pageIndex: index)
    }
    
    //MARK: - TYTitleView
    
    func pageView(pageView: TYPageTitleView, selectIndex: Int) {
        scrollView.setContentOffset(CGPoint.init(x: screenWidth*CGFloat(selectIndex), y: 0), animated: true)
    }
    
    
    //MARK: - actions
    
    func handleTapSearchItem(sender: Any) {
        
    }
    
    func handleTapMenuItem(sender: Any) {
        
    }
    
    func handleTapMessageItem(sender: Any) {
        
    }

}
