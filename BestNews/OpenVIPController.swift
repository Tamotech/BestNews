//
//  OpenVIPController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class OpenVIPController: BaseViewController {

    @IBOutlet var priceLbs: [UILabel]!
    
    @IBOutlet var priceBgViews: [UIImageView]!
    
    
    @IBOutlet weak var alipayIcon: UIImageView!
    
    @IBOutlet weak var wechatPayIcon: UIImageView!
    
    @IBOutlet weak var priceLb: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let prices = ["15", "20", "55", "160"]
    override func viewDidLoad() {
        super.viewDidLoad()

        showCustomTitle(title: "开通VIP")
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        for im in priceBgViews {
            im.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(selectVipPrice(_:)))
            im.addGestureRecognizer(tap)
        }
    }
    
    //MARK: - actions
    
    @objc func selectVipPrice(_ ges: UITapGestureRecognizer) {
        for i in 0..<priceBgViews.count {
            let im = priceBgViews[i]
            if im == ges.view {
                im.image = #imageLiteral(resourceName: "vip-bg-2")
                priceLb.text = prices[i]
            }
            else {
                im.image = #imageLiteral(resourceName: "vip-bg-1")
            }
        }
    }
    
    @IBAction func selectAliPay(_ sender: UITapGestureRecognizer) {
        wechatPayIcon.image = #imageLiteral(resourceName: "TickOffM3-3b")
        alipayIcon.image = #imageLiteral(resourceName: "TickOnM3-3b")
    }
    
    @IBAction func selectWechatPay(_ sender: UITapGestureRecognizer) {
        alipayIcon.image = #imageLiteral(resourceName: "TickOffM3-3b")
        wechatPayIcon.image = #imageLiteral(resourceName: "TickOnM3-3b")
    }
    
    @IBAction func handleTapConfirmBtn(_ sender: UIButton) {
        
    }
    
}
