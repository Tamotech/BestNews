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
        im1.contentMode = UIViewContentMode.scaleAspectFill
        im1.clipsToBounds = true
        im1.image = UIImage(named: "bg1_guide")
        scrollView.addSubview(im1)
        
        let im2 = UIImageView(frame: CGRect(x: screenWidth, y: 0, width: screenWidth, height: screenHeight))
        im2.contentMode = UIViewContentMode.scaleAspectFill
        im2.clipsToBounds = true
        im2.image = UIImage(named: "bg2_guide")
        scrollView.addSubview(im2)
        
        let im3 = UIImageView(frame: CGRect(x: screenWidth*2, y: 0, width: screenWidth, height: screenHeight))
        im3.contentMode = UIViewContentMode.scaleAspectFill
        im3.clipsToBounds = true
        im3.image = UIImage(named: "bg3_guide")
        scrollView.addSubview(im3)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let skipBtn = UIButton(frame: CGRect(x: screenWidth-80, y: topGuideHeight - 44, width: 80, height: 44))
        skipBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        skipBtn.setTitle("跳过", for: UIControlState.normal)
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
    
    @objc func handleTapSkipBtn(_: Any) {
        UIApplication.shared.keyWindow?.rootViewController = BestTabbarViewController()
    }

}
