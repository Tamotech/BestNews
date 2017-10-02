//
//  BaseWKWebViewController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/26.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class BaseWKWebViewController: BaseViewController, WKNavigationDelegate {

    let webView = WKWebView()
    var urlString: String?
    var htmlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        webView.navigationDelegate = self
        if htmlString != nil {
            webView.loadHTMLString(htmlString!, baseURL: nil)
        }
        else if urlString != nil {
            if !urlString!.hasPrefix("http://") {
                urlString = baseUrlString+urlString!
            }
            let url = URL(string: urlString!)!
            webView.load(URLRequest(url: url))
        }
        webView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(0)
        }
        
    }


}
