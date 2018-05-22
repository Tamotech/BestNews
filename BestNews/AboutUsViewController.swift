//
//  AboutUsViewController.swift
//  BestNews
//
//  Created by wuxi on 2018/5/12.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import SwiftyJSON


/// 关于我们
class AboutUsViewController: BaseWKWebViewController {
    
    var touchWay = ["s_contact_phone": "",
                    "s_contact_email": "",
                    "s_contact_address": "",
                    "u_contact_map": ""]
    
    lazy var contactUsBtn: UIButton = {
       let b = UIButton(frame: CGRect.zero)
        b.backgroundColor = themeColor
        b.setTitle("联系我们", for: UIControlState.normal)
        b.setTitleColor(UIColor.white, for: UIControlState.normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        b.addTarget(self, action: #selector(handleTapContactBtn(_:)), for: UIControlEvents.touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(contactUsBtn)
        contactUsBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(48)
        }
        webView.snp.updateConstraints { (make) in
            make.bottom.equalTo(-48)
            make.left.right.top.equalTo(0)
        }
        self.showCustomTitle(title: "关于我们")
        self.getTouchWay()
    }

    //获取联系方式
    func getTouchWay() {
        APIRequest.getUserConfig(codes: "s_contact_phone,s_contact_email,s_contact_address,f_aboutus_introduce,u_contact_map") { [weak self](JSONData) in
            let data = JSONData as! JSON
            self?.touchWay["s_contact_phone"] = data["s_contact_phone"]["v"].stringValue
            self?.touchWay["s_contact_email"] = data["s_contact_email"]["v"].stringValue
            self?.touchWay["s_contact_address"] = data["s_contact_address"]["v"].stringValue
            self?.touchWay["u_contact_map"] = data["u_contact_map"]["v"].stringValue
//            self?.htmlString = data["f_aboutus_introduce"]["v"].stringValue
            let htmlPath = Bundle.main.path(forResource: "baseHtml", ofType: "html")
            let htmlStr =
                try? String.init(contentsOfFile: htmlPath!, encoding: String.Encoding.utf8)
            var contentHTML = data["f_aboutus_introduce"]["v"].stringValue
            //去除font
            
            let reg = try! NSRegularExpression(pattern: "font-size:\\d+px", options: [])
            contentHTML =  reg.stringByReplacingMatches(in: contentHTML, options: [], range: NSMakeRange(0, contentHTML.count), withTemplate: "")
            self?.htmlString = htmlStr!.replacingOccurrences(of: "${contentHTML}", with: contentHTML)
            self?.webView.loadHTMLString(self?.htmlString ?? "", baseURL: nil)
        }
    }
    
    @objc func handleTapContactBtn(_ sender: UIButton) {
        let vc = ContactUsController(nibName: "ContactUsController", bundle: nil)
        vc.touchWay = self.touchWay
        navigationController?.pushViewController(vc, animated: true)
    }
}
