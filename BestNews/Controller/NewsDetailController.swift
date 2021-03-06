//
//  NewsDetailController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import WebKit
import Presentr
import Kingfisher
import SnapKit

class NewsDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CommentBarDelegate, WKNavigationDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var scrollBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var avtarBtn: UIButton!
    
    @IBOutlet weak var authorNameLb: UILabel!
    
    @IBOutlet weak var subscriptBtn: SubscribeButton!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var webParentView: UIView!
    
    @IBOutlet weak var webParentHeight: NSLayoutConstraint!
    @IBOutlet weak var rewardView: UIView!
    
    @IBOutlet weak var rewardBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var rewardMenView: UIView!
    
    @IBOutlet weak var rewardHeight: NSLayoutConstraint!
    
    @IBOutlet weak var rewardBottom: NSLayoutConstraint!
    
    @IBOutlet weak var rewardParentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var avatarInfoView: UIView!
    
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var line1: UIView!
    /// 夜间模式 日间模式
    lazy var nightModeBtns: [UIBarButtonItem] = {
        //夜间模式
        let nightModeBar = UIBarButtonItem(image: #imageLiteral(resourceName: "mode_night"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickChangeNightMode(_:)))
        nightModeBar.tag = 0
        let dayModeBar = UIBarButtonItem(image: #imageLiteral(resourceName: "mode_day"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(clickChangeNightMode(_:)))
        dayModeBar.tag = 1
        return [nightModeBar, dayModeBar]
        
    } ()
    
    
    let htmlModelString = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title></title><style>body {font:48px/1.5 tahoma,arial,sans-serif;color:#333333;text-align:justify;text-align-last:justify;line-height:70px}hr {height:1px;border:none;border-top:1px solid #e8e8e8;} img {width:100%;height:auto} .sm_copyright{font-size:42px;} </style></head><body><div style='margin:35px' id=\"content\">${contentHtml}${author}</div></body></html>"
    var currentHTML = ""
    
    ///是否订阅作者 (需要查阅)
    var authorSubscribe = false
    
    var articleId: String = ""
    var article: HomeNewsDetail?
    var articleHome: HomeArticle?
    var recommendArticleList: HomeArticleList?
    var rewardList = RewardManList()
    
    var commentBar = NewsCommentBar()
    
    var commentList: CommentList?
    
    lazy var webView: WKWebView = {
       let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.minimumFontSize = 42
        config.preferences.javaScriptEnabled = true
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        let web = WKWebView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 100), configuration: config)
        web.scrollView.isScrollEnabled = false
        web.autoresizingMask = .flexibleHeight
        web.navigationDelegate = self
        web.backgroundColor = .white
        web.scrollView.backgroundColor = UIColor(hex: 0xf2f2f8)
        let url = Bundle.main.url(forResource: "clickImg", withExtension: "js")
        do {
            let functionStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            web.evaluateJavaScript(functionStr, completionHandler: { (response, error) in
                print(response ?? "")
                print("error--\(String(describing: error))")
            })
        }
        catch {
            
        }
        self.webParentView.addSubview(web)
        web.snp.makeConstraints({ (make) in
            make.top.left.right.bottom.equalTo(0)
        })
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentBar.frame = CGRect(x: 0, y: screenHeight-49, width: screenWidth, height: 49)
        commentBar.delegate = self
        view.addSubview(commentBar)
        commentBar.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(49)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-(keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalToSuperview()
            }
        }
        
        let nib = UINib(nibName: "SinglePhotoNewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SinglePhotoNewsCell")
        let nib1 = UINib(nibName: "NoPhotoNewsCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "NoPhotoNewsCell")
        tableView.separatorColor = UIColor(hexString: "f0f0f0")
        tableView.sectionFooterHeight = 0.1
        tableView.sectionHeaderHeight = 0.1
//        tableView.rowHeight = 108
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollBottom.constant = keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            // Fallback on earlier versions
        }
        self.automaticallyAdjustsScrollViewInsets = false
        
        commentBar.articleId = articleId
        self.loadNewsDetail()
        self.loadRecommendArticleList()
        self.loadCommentList()
        self.loadRewardList()
        
    }
    
    //MARK: - tableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendArticleList?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = recommendArticleList!.list[indexPath.row]
        article.recommendFlag = true
        var identifier = "SinglePhotoNewsCell"
        if article.preimglist.count == 0 {
            identifier = "NoPhotoNewsCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseNewsCell
        cell.updateCell(article: article)
        cell.changeReadBGMode(night: tableView.tag == 1)
        tableViewHeight.constant = tableView.contentSize.height
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = recommendArticleList!.list[indexPath.row]
        let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
        vc.articleId = article.id
        navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: - actions
    
    @IBAction func handleTapSubscriptBtn(_ sender: UIButton) {
        
        if !SessionManager.sharedInstance.loginInfo.isLogin {
            Toolkit.showLoginVC()
        }
        if article != nil {
            if article!.subseribe == 0 {
                subscriptBtn.switchStateSub(true)
                article?.subseribe = 1
                APIRequest.subscriptChannelAPI(id: article!.userid, type: "user", result: { [weak self](success) in
                    if !success {
                        self?.article?.subseribe = 0
                        self?.subscriptBtn.switchStateSub(false)
                    }
                })
            }
            else {
                subscriptBtn.switchStateSub(false)
                article?.subseribe = 0
                APIRequest.cancelSubscriptChannelAPI(id: article!.userid, type: "user", result: { [weak self](success) in
                    if !success {
                        self?.article?.subseribe = 1
                        self?.subscriptBtn.switchStateSub(true)
                    }
                })
            }
        }
    }
    
    
    //夜间模式切换
    @objc func clickChangeNightMode(_ sender: UIBarButtonItem) {
        if sender.tag == 0 {
            self.navigationItem.rightBarButtonItem = nightModeBtns[1]
            self.changeReadBGMode(night: true)
        }
        else {
            self.navigationItem.rightBarButtonItem = nightModeBtns[0]
            self.changeReadBGMode(night: false)
        }
        self.tableView.reloadData()
    }
    
    ///赞赏
    @IBAction func handleTapRewardBtn(_ sender: UIButton) {
        //TODO:
        
        let alert = RewardAlertController(nibName: "RewardAlertController", bundle: nil)
        alert.articleId = articleId
        alert.confirmCallback = { [weak self](price) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
                BLHUDBarManager.showSuccess(msg: "成功打赏", seconds: 1)
            })
            self?.loadRewardList()
        }
        customPresentViewController(presentr, viewController: alert, animated: true) {
            
        }
        
    }
    
    func pay(result: ActivityPayResult) {
        
    }
 
    //MARK: - commentBarDelegate
    
    func tapPostHandler() {
        let content = commentBar.textField.text
        if content?.count == 0 {
            return
        }
        APIRequest.commentAPI(articleId: articleId, commentId: nil, content: content!) { [weak self](JSON) in
            self?.loadCommentList()
            self?.commentBar.textField.text = ""
            self?.commentBar.switchToEditMode(edit: false)
        }
    }
    
    func tapReportHandler() {
        presentr.viewControllerForContext = self
        let vc = ReportArticleController(nibName: "ReportArticleController", bundle: nil)
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    func tapPublishBtnHandler() {
        
    }
    
    func postSuccessHandler() {
        self.article!.commentNum = self.article!.commentNum + 1
        commentBar.commentBtn.setTitle(" \(self.article!.commentNum)", for: UIControlState.normal)
        DispatchQueue.main.async {
            let vc = CommentListController()
            vc.commentList = self.commentList
            vc.articleId = self.articleId
            self.navigationController?.pushViewController(vc, animated: true)
            BLHUDBarManager.showSuccess(msg: "评论成功", seconds: 1)
        }
    }
    
    func tapCommentHandler() {
        let vc = CommentListController()
        vc.commentList = commentList
        vc.articleId = articleId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapCollectionHandler() {
        if article?.collect == 0 {
            APIRequest.collectAPI(id: article!.id, type: "article", result: {[weak self] (success) in
                if success {
                    self?.article?.collect = 1
                    self?.commentBar.collect(true)
                }
                else {
                    self?.article?.collect = 0
                    self?.commentBar.collect(false)
                }
            })
        }
        else {
            APIRequest.cancelCollectAPI(id: article!.id, type: "article", result: { [weak self] (success) in
                if success {
                    self?.article?.collect = 0
                    self?.commentBar.collect(false)
                }
                else {
                    self?.article?.collect = 1
                    self?.commentBar.collect(true)
                }
            })
        }
    }
    
    func tapRepostHandler() {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        let share = ShareModel()
        share.title = article!.title
        share.link = "\(baseUrlString)/newsdetail.htm?id=\(articleId)"
        if articleHome != nil && articleHome!.preimglist.count > 0 {
            share.thumb = articleHome!.preimglist.first!
        }
        vc.share = share
        presentr.viewControllerForContext = self
        presentr.dismissOnSwipe = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
        
    }
    
    
    //MARK: - wkNavigation
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let path = navigationAction.request.url?.absoluteString else {
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        }
        if path.hasSuffix("jpg") || path.hasSuffix("jpge") || path.hasSuffix("png") || path.hasSuffix("PNG") || path.hasSuffix("JPG") || path.hasSuffix("JPEG") {
            let v = UIImageView(frame: UIScreen.main.bounds)
            let rc = ImageResource(downloadURL: URL(string: path)!)
            v.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m252_default2"), options: nil, progressBlock: nil, completionHandler: nil)
            keyWindow?.addSubview(v)
            v.contentMode = .scaleAspectFit
            v.isUserInteractionEnabled = true
            v.backgroundColor = .white
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPhoto(_:)))
            v.addGestureRecognizer(tap)
            v.center = CGPoint(x: screenWidth/2, y: screenHeight/2)
            v.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                v.alpha = 1
            }, completion: { (success) in
                
            })
            decisionHandler(WKNavigationActionPolicy.cancel)
            
        }
        else {
            if path.contains("newsdetail.htm?id=") {
                let vc = NewsDetailController.init(nibName: "NewsDetailController", bundle: nil) as NewsDetailController
                let pattern = "newsdetail.htm?id="
                let location = path.positionOf(sub: pattern)
                if location > 0 {
                    let index = path.index(path.startIndex, offsetBy: location+pattern.count)
                    let id = path.substring(from: index)
                    vc.articleId = id
                    navigationController?.pushViewController(vc, animated: true)
                }
                decisionHandler(WKNavigationActionPolicy.cancel)
            }
            else if path.hasPrefix("http") {
                let vc = BaseWKWebViewController()
                vc.urlString = path
                navigationController?.pushViewController(vc, animated: true)
                decisionHandler(WKNavigationActionPolicy.cancel)
            }
            else {
                decisionHandler(WKNavigationActionPolicy.allow)
            }
        }
        
    }
    
    @objc func dismissPhoto(_ sender: UIGestureRecognizer) {
        let v = sender.view!
        UIView.animate(withDuration: 0.3, animations: {
            v.alpha = 0
        }, completion: { (success) in
            v.removeFromSuperview()
        })
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("开始加载...\(webView.scrollView.contentSize.height)")
        
//        print(webView.url)
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
    
        //点击查看大图
        let clickImgJS = "function registerImageClickAction(){ var imgs = document.getElementsByTagName('img');for(var i=0;i<imgs.length;i++){imgs[i].customIndex = i;imgs[i].onclick=function(){window.location.href=''+this.src;}}}"
        webView.evaluateJavaScript(clickImgJS) { (data, error) in
            if error != nil {
                print(error!)
            }
        }
        
        webView.evaluateJavaScript("registerImageClickAction();") { (data, error) in
            if error != nil {
                print(error!)
            }
        }
        
        
        
        //高度适配 cheat
        
        print("高度...> \(webView.scrollView.contentSize.height)")
        webView.evaluateJavaScript("document.documentElement.scrollHeight;") { [weak self](data, error) in
            print("加载完毕...>\(data!)")
            ///TODO: 高度计算cheat
            var h: CGFloat = 0
            if screenWidth < 350 {
                h = (data as! CGFloat)*32/100+80
            }
            else if screenWidth < 400 {
                h = (data as! CGFloat)*38/100+60
            }
            else {
                h = (data as! CGFloat)*42/100+50
            }
            if self!.article!.proofread.count > 0 {
                h = h + 20
            }
            self!.webParentHeight.constant = h
        }
        
    }
    
}

/// load data
extension NewsDetailController {
    
    func loadNewsDetail() {
        SwiftNotice.wait()
        APIRequest.newsDetailAPI(id: articleId) { [weak self](newsDetail) in
            SwiftNotice.clear()
            self?.article = newsDetail as? HomeNewsDetail
            self?.updateView()
        }
    }
    
    func loadRecommendArticleList() {
        APIRequest.getRecommendArticleListAPI(articleId: articleId, page: 1, row: 5) { (data) in
            self.recommendArticleList = data as? HomeArticleList
            self.tableView.reloadData()
        }
    }
    
    func loadCommentList() {
        APIRequest.commentListAPI(articleId: articleId, commentId: nil, page: 1) { [weak self](data) in
            self?.commentList = data as? CommentList
            self?.updateCommentBar()
        }
    }
    
    func loadRewardList() {
        APIRequest.ArticleReardManListAPI(articleId: articleId) {[weak self] (data) in
            self?.rewardList = data as! RewardManList
            self?.updateRewardView()
        }
    }
    
    func updateView() {
        guard (article != nil) else {
            return
        }
        titleLb.text = article?.title
        if (article?.reporter.contains("null"))! {
            article?.reporter = ""
        }
        authorNameLb.text = "\(article?.publisher ?? "")  \(article?.reporter ?? "")"
        dateLb.text = article?.descString()
        subscriptBtn.isHidden = (article?.type != "normal")
        subscriptBtn.switchStateSub(article!.subseribe == 1)
        commentBar.collect(article!.collect == 1)
        
        //TODO 关闭赞赏入口
        rewardBtn.isHidden = article?.type != "normal"
        
        if let url = URL(string: article!.headimg) {
            let rc = ImageResource(downloadURL: url)
            avtarBtn.kf.setImage(with: rc, for: UIControlState.normal, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        var htmlString = NSString(string: htmlModelString).replacingOccurrences(of: "${contentHtml}", with: article!.content)
        if article!.author.count > 0 {
            var authorTag = "<p color:#999999>编辑: \(article!.author)</p>"
            if article!.proofread.count > 0 {
                authorTag = authorTag + "<p color:#999999>审校: \(article!.proofread)</p>"
            }
            htmlString = NSString(string: htmlString).replacingOccurrences(of: "${author}", with: authorTag)
        }
        else {
            htmlString = NSString(string: htmlString).replacingOccurrences(of: "${author}", with: "")
        }
        currentHTML = htmlString
        webView.loadHTMLString(htmlString, baseURL: URL(string: htmlString))
    }
    
    //赞赏列表
    func updateRewardView() {
//        let canvW = screenWidth - 40
//        let top: CGFloat = 15
//        let gap: CGFloat = 8
//        let w: CGFloat = 30
//        let colNum = Int((canvW - top*2)/(w+gap))
//        var bottom: CGFloat = 0
        for v in rewardMenView.subviews {
            v.removeFromSuperview()
        }
        
        //TODO: 暂时都关闭入口
        /*if rewardList.list.count > 0 {
            
            let max = rewardList.list.count >= colNum*2 ? colNum*2-1 : rewardList.list.count
            for i in 0..<max {
                let man = rewardList.list[i]
                let x = top + CGFloat(i%colNum)*(w+gap)
                let y = top + CGFloat(i/colNum)*(w+gap)
                let v = UIImageView(frame: CGRect(x: x, y: y, width: w, height: w))
                v.image = #imageLiteral(resourceName: "defaultUser")
                v.layer.cornerRadius = w/2
                v.layer.masksToBounds = true
                rewardMenView.addSubview(v)
                if let url = URL(string: man.headimg) {
                    let rc = ImageResource(downloadURL: url)
                    v.kf.setImage(with: rc)
                }
                bottom = v.bottom
            }
            ///更多
            if rewardList.total >= colNum*2 {
                let x = top + CGFloat(colNum - 1)*(w+gap)
                let y = top + (w+gap)
                let v = UIView(frame: CGRect(x: x, y: y, width: w, height: w))
                v.backgroundColor = .white
                v.layer.cornerRadius = w/2
                v.clipsToBounds = true
                let l = UILabel(frame: v.bounds)
                l.font = UIFont.boldSystemFont(ofSize: 13)
                l.textColor = themeColor
                l.textAlignment = .center
                l.text = "\(rewardList.total)"
                v.addSubview(l)
                rewardMenView.addSubview(v)
                bottom = v.bottom
            }
            rewardMenView.isHidden = false
            rewardHeight.constant = bottom + top
            rewardBottom.constant = 40
        }
        else {
            rewardMenView.isHidden = true
            rewardHeight.constant = 0
            rewardBottom.constant = 0
        }*/
        
        
        ///v1.1 打赏隐藏
        rewardMenView.isHidden = true
        rewardHeight.constant = 0
        rewardBottom.constant = 0
        rewardView.isHidden = true
        rewardParentHeight.constant = 0
    }
    
    func updateCommentBar() {
        commentBar.commentBtn.setTitle(" \(commentList?.total ?? 0)", for: .normal)
    }
    
    
    
    /// 切换夜间模式
    ///
    /// - Parameter night: 夜间or日间
    func changeReadBGMode(night: Bool) {
        if night {
            titleLb.textColor = UIColor(hexString: "#9b9b9b")
            self.view.backgroundColor = UIColor(hexString: "#222222")
            self.barView.backgroundColor = UIColor(hexString: "#222222")
            self.barView.shadowOpacity = 0.2
            self.avatarInfoView.backgroundColor = UIColor(hexString: "#222222")
            self.scrollView.subviews.first!.backgroundColor = UIColor(hexString: "#222222")
            self.scrollView.backgroundColor = UIColor(hexString: "#222222")
            self.tableView.backgroundColor = UIColor(hexString: "#222222")
            self.tableHeaderView.backgroundColor = UIColor(hexString: "#222222")
            self.webParentView.backgroundColor = UIColor(hexString: "#222222")
            self.webView.backgroundColor = UIColor(hexString: "#222222")
            self.webView.isOpaque = false
            currentHTML = currentHTML.replacingOccurrences(of: "#555555", with: "#9b9b9b")
            currentHTML = currentHTML.replacingOccurrences(of: "#999999", with: "#464646")
            self.webView.loadHTMLString(currentHTML, baseURL: nil)
            self.tableView.tag = 1
            commentBar.changeReadBGMode(night: true)
            SessionManager.sharedInstance.daynightModel = 2
            line1.backgroundColor = UIColor(hexString: "#111111")
            self.tableView.separatorColor = UIColor(hexString: "#2a2a2a")

        }
        else {
            titleLb.textColor = UIColor(hexString: "#000000")
            self.view.backgroundColor = UIColor(hexString: "#ffffff")
            self.avatarInfoView.backgroundColor = UIColor(hexString: "#ffffff")
            self.barView.backgroundColor = UIColor(hexString: "#ffffff")
            self.barView.shadowOpacity = 0.8
            self.scrollView.subviews.first!.backgroundColor = UIColor.white
            self.scrollView.backgroundColor = UIColor.white
            self.tableView.backgroundColor = UIColor.white
            self.tableHeaderView.backgroundColor = UIColor.white
            self.webView.backgroundColor = UIColor.white
            self.webView.isOpaque = false
            self.webParentView.backgroundColor = .white
            self.tableView.tag = 0
            commentBar.changeReadBGMode(night: false)
            currentHTML = currentHTML.replacingOccurrences(of: "#9b9b9b", with: "#555555")
            currentHTML = currentHTML.replacingOccurrences(of: "#464646", with: "#999999")
            self.webView.loadHTMLString(currentHTML, baseURL: nil)
            SessionManager.sharedInstance.daynightModel = 1
            line1.backgroundColor = UIColor.groupTableViewBackground
            self.tableView.separatorColor = UIColor(hexString: "#e5e5e5")
        }
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
}
