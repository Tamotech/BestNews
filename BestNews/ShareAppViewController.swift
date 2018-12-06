//
//  ShareAppViewController.swift
//  BestNews
//
//  Created by wuxi on 2018/3/25.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ShareAppViewController: BaseViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var qrcodeIv: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var msgLb: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "分享App"
        updateUI()
    }
    
    
    func updateUI() {
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.automaticallyAdjustsScrollViewInsets = false
        if let user = SessionManager.sharedInstance.userInfo {
            if let url = URL.init(string: user.headimg) {
                let rc = ImageResource(downloadURL: url)
                avatar.kf.setImage(with: rc)
            }
            nameLb.text = user.name
            let link = "\(baseUrlString)/app.htm?channelCode=1&uid=\(SessionManager.sharedInstance.userInfo!.id)"
            let im = UIImage.createQRForString(qrString: link)
            qrcodeIv.image = im
        }
    }

    @IBAction func handleTapShareBtn(_ sender: UIButton) {
        
        //截图
        
        UIGraphicsBeginImageContext(CGSize(width: self.view.width, height: msgLb.bottom+20))
        let ctx = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: ctx)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //裁剪
        let tem = img?.cgImage!
        let cgimg = tem?.cropping(to: CGRect(x: 0, y: 64, width: screenWidth, height: msgLb.bottom+20-64))
        let newImg = UIImage(cgImage: cgimg!)
        
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        let share = ShareModel()

        share.msg = "专注财经新闻资讯, 与财经现场, 金融机构, 大咖名人零距离!"
        share.img = newImg
        vc.share = share
        if SessionManager.sharedInstance.userInfo != nil {
            share.link = "\(baseUrlString)/app.htm?channelCode=1&uid=\(SessionManager.sharedInstance.userInfo!.id)"
        }
        presentr.viewControllerForContext = self
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }

}
