//
//  GuideViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

class GuideViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let scrollView = UIScrollView(frame: .zero)
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: screenWidth*3.0, height: screenHeight)
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
        }
        
        let im1 = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        im1.image = #imageLiteral(resourceName: "M0-1-1.png")
        scrollView.addSubview(im1)
        
        let im2 = UIImageView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
        im2.image = #imageLiteral(resourceName: "M0-1-2.png")
        scrollView.addSubview(im2)
        
        let im3 = UIImageView(frame: CGRect(x: screenWidth*2, y: 0, width: screenWidth, height: screenHeight))
        im3.image = #imageLiteral(resourceName: "M01-1-3.png")
        scrollView.addSubview(im3)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let skipBtn = UIButton(frame: CGRect(x: screenWidth-80, y: 20, width: 80, height: 44))
        skipBtn.addTarget(self, action: #selector(handleTapSkipBtn(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(skipBtn)
        
        let skipBtn1 = UIButton(frame: CGRect(x: 0, y: screenHeight-50, width: screenWidth, height: 50))
        skipBtn1.addTarget(self, action: #selector(handleTapSkipBtn(_:)), for: UIControlEvents.touchUpInside)
        im3.addSubview(skipBtn1)
        im3.isUserInteractionEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        self.view.backgroundColor = .white
    }
    
    func handleTapSkipBtn(_: Any) {
        UIApplication.shared.keyWindow?.rootViewController = BestTabbarViewController()
    }

}
