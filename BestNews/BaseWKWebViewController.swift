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

    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        if #available(iOS 10.0, *) {
            config.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypes.video
        } else {
            config.mediaPlaybackRequiresUserAction = false
        }
        
        let v = WKWebView(frame: CGRect.zero, configuration: config)
        return v
    }()
    var urlString: String?
    var htmlString: String?
    var shareEnable = false
    var share: ShareModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(webView)
        if shareEnable {
            let item = UIBarButtonItem(image: #imageLiteral(resourceName: "iconShare"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleTapShare(_:)))
            navigationItem.rightBarButtonItem = item
        }
        webView.navigationDelegate = self
        if htmlString != nil {
            webView.loadHTMLString(htmlString!, baseURL: nil)
        }
        else if urlString != nil {
            if !urlString!.hasPrefix("http") {
                urlString = baseUrlString+urlString!
            }
            let url = URL(string: urlString!)!
            webView.load(URLRequest(url: url))
        }
        webView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(0)
            make.top.equalTo(64)
        }
        
    }
    
    //分享
    func handleTapShare(_ sender: Any) {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        if urlString?.count ?? 0 > 0 {
            share?.link = urlString!
        }
        vc.share = share!
        self.presentr.viewControllerForContext = self
        self.presentr.dismissOnSwipe = true
        self.customPresentViewController(self.presentr, viewController: vc, animated: true) {
            
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        SwiftNotice.wait()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SwiftNotice.clear()
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        SwiftNotice.clear()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        SwiftNotice.clear()
    }
}
