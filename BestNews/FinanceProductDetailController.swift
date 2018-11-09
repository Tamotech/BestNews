//
//  FinanceProductDetailController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Presentr

class FinanceProductDetailController: BaseViewController, UIScrollViewDelegate {

    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var orgnizationLb: UILabel!
    
    @IBOutlet weak var sevenYearRateLb: UILabel!
    
    @IBOutlet weak var wRateLb: UILabel!
    
    @IBOutlet weak var productTypeLb: UILabel!
    
    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = UIColor.white
    }

    func setupView() {
        let titles = ["近7日年化","万份收益"]
        let v = BaseSegmentControl(items: titles, defaultIndex: 0)
        v.frame = self.segmentView.bounds
        self.segmentView.addSubview(v)
        segmentView.addSubview(v)
        v.selectItemAction = {(index, name)in
            
        }
        scrollView.delegate = self
        self.shouldClearNavBar = false
        barView.alpha = 0
        let collectionBar = UIBarButtonItem(image: #imageLiteral(resourceName: "iconCollection"), style: .plain, target: self, action: #selector(handleTapCollectionBtn(_:)))
        let repostBar = UIBarButtonItem(image: #imageLiteral(resourceName: "iconShare"), style: .plain, target: self, action: #selector(handleTapShareItem(_:)))
        navigationItem.rightBarButtonItems = [repostBar, collectionBar]
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: - acrollView
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        if offset.y > 20 && offset.y <= 100 {
            let alpha = 1-(100-offset.y)/100.0
            barView.alpha = alpha
            navigationController?.navigationBar.tintColor = gray51
        }
        else if offset.y > 100 {
            barView.alpha = 1
            navigationController?.navigationBar.tintColor = gray51
        }
        else {
            barView.alpha = 0
            navigationController?.navigationBar.tintColor = UIColor.white
        }
            
        
    }
    
    //MARK: - actions
    
    func handleTapCollectionBtn(_: UIBarButtonItem) {
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
            return
        }
    }
    
    func handleTapShareItem(_: UIBarButtonItem) {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        presentr.viewControllerForContext = self
        presentr.dismissOnSwipe = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }

}
