//
//  ActivityDetailController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/13.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher
import Presentr
import WebKit
import SnapKit

class ActivityDetailController: BaseViewController, ActivityTicketListControllerDelgate, WKNavigationDelegate {

    
    
    var activityId: String?
    var activity = ActivityDetail()
    
    @IBOutlet weak var coverPhotov: UIImageView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var addressLb: UILabel!
    
    @IBOutlet weak var sponsorLb: UILabel!
    
    @IBOutlet weak var limitNumLb: UILabel!
    
    @IBOutlet weak var ticketPriceLb: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var labelsContainer: LabelsContainerView!
    
    @IBOutlet weak var labelsContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var webParentView: UIView!
    @IBOutlet weak var webViewHeight: NSLayoutConstraint!
    
    lazy var presentr:Presentr = {
        let pr = Presentr(presentationType: .fullScreen)
        pr.transitionType = TransitionType.coverVertical
        pr.dismissOnTap = true
        pr.dismissAnimated = true
       return pr
    }()
    
    lazy var webView: WKWebView = {
       
        let v = WKWebView()
        self.webParentView.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(0)
        })
        return v
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldClearNavBar = true
        webView.navigationDelegate = self
        
        let collectionBar = UIBarButtonItem(image: #imageLiteral(resourceName: "iconCollection"), style: .plain, target: self, action: #selector(handleTapCollectionBtn(sender:)))
        let repostBar = UIBarButtonItem(image: #imageLiteral(resourceName: "iconShare"), style: .plain, target: self, action: #selector(handleTapRepostBtn(sender:)))
        navigationItem.rightBarButtonItems = [repostBar, collectionBar]
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        loadData()
    }

    

    //MARK: - acions
    func handleTapCollectionBtn(sender: Any) {
        
    }
    
    func handleTapRepostBtn(sender: Any) {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = false
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    
    ///退款说明
    @IBAction func handleTappaybackInstruction(_ sender: Any) {
        
        
    }
    
    
    @IBAction func handleTapJoinBtn(_ sender: UIButton) {
        
        if activity.tickets.count == 0 {
            BLHUDBarManager.showError(msg: "该活动暂时无票")
            return
        }
        if SessionManager.sharedInstance.loginInfo.isLogin == false {
            Toolkit.showLoginVC()
            return
        }
        
        let vc = ActivityTicketListController(nibName: "ActivityTicketListController", bundle: nil)
        vc.tickets = activity.tickets
        vc.delegate = self
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    func handleTapNextBtn(vc: ActivityTicketListController, ticket: ActivityTicket) {
        vc.dismiss(animated: true, completion: nil)
        let registVC = ActivityRegistController(nibName: "ActivityRegistController", bundle: nil)
        registVC.activity = activity
        registVC.ticket = ticket
        navigationController?.pushViewController(registVC, animated: true)
    }

    
    //MARK: - wkNavigation
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载...\(webView.scrollView.contentSize.height)")
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("收到重定向...")
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("content 处理完毕...\(webView.scrollView.contentSize.height)")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("数据下载失败...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        //TODO: 高度不准
        print("高度...> \(webView.scrollView.contentSize.height)")
        webView.evaluateJavaScript("document.body.offsetHeight;") { (data, error) in
            print("加载完毕...>\(data!)")
//            self.webView.height = data as! CGFloat
//            self.webViewHeight.constant = data as! CGFloat
        }
    }
}


extension ActivityDetailController {
    
    func loadData() {
        APIRequest.activityDetailAPI(id: activityId!) { [weak self](data) in
            self?.activity = data as! ActivityDetail
            self?.updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.text = activity.title
        if activity.preimgpath.count>0 {
            let rc = ImageResource(downloadURL: URL(string: activity.preimgpath)!)
            coverPhotov.kf.setImage(with: rc)
        }
        dateLb.text = activity.dateStr()
        addressLb.text = activity.address
        sponsorLb.text = "主办方: \(activity.sponsor)"
        limitNumLb.text = "限额: \(activity.num)"
        ticketPriceLb.text = activity.priceString()
        let labels = activity.tags.split(separator: ",")
        labelsContainer.updateUI(labels)
        webView.loadHTMLString(activity.contentHtmlString(), baseURL: nil)
        
    }
}
