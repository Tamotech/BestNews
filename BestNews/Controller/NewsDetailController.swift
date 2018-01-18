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

class NewsDetailController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CommentBarDelegate, WKNavigationDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    
    
    let htmlModelString = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><title></title><style>body {font:48px/1.5 tahoma,arial,sans-serif;color:#55555;text-align:justify;text-align-last:justify;line-height:70px}hr {height:1px;border:none;border-top:1px solid #e8e8e8;} img {width:100%;height:auto}</style></head><body><div style='margin:35px' id=\"content\">${contentHtml}${author}</div></body></html>"
    
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
        return web
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentBar.frame = CGRect(x: 0, y: screenHeight-49, width: screenWidth, height: 49)
        commentBar.delegate = self
        view.addSubview(commentBar)
        let nib = UINib(nibName: "SinglePhotoNewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SinglePhotoNewsCell")
        let nib1 = UINib(nibName: "NoPhotoNewsCell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: "NoPhotoNewsCell")
        tableView.separatorColor = UIColor(hexString: "f0f0f0")
        tableView.sectionFooterHeight = 0.1
        tableView.sectionHeaderHeight = 0.1
//        tableView.rowHeight = 108
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
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
        presentr.shouldIgnoreTapOutsideContext = true
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
        share.link = "http://xhfmedia.com/newsdetail.htm?id=\(articleId)"
        if articleHome != nil && articleHome!.preimglist.count > 0 {
            share.thumb = articleHome!.preimglist.first!
        }
        vc.share = share
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = false
        presentr.dismissOnTap = true
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
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
    }
    
    func dismissPhoto(_ sender: UIGestureRecognizer) {
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
        webView.evaluateJavaScript("document.documentElement.scrollHeight;") { (data, error) in
            print("加载完毕...>\(data!)")
            ///TODO: 高度计算cheat
            if screenWidth < 350 {
                self.webView.height = (data as! CGFloat)*32/100+80
                self.webParentHeight.constant = (data as! CGFloat)*32/100+80
            }
            else if screenWidth < 400 {
                self.webView.height = (data as! CGFloat)*38/100+60
                self.webParentHeight.constant = (data as! CGFloat)*38/100+60
            }
            else {
                self.webView.height = (data as! CGFloat)*43/100+50
                self.webParentHeight.constant = (data as! CGFloat)*42/100+50
            }
        }
        
    }
    
}

/// load data
extension NewsDetailController {
    
    func loadNewsDetail() {
        APIRequest.newsDetailAPI(id: articleId) { [weak self](newsDetail) in
            self?.article = newsDetail as! HomeNewsDetail?
            self?.updateView()
        }
    }
    
    func loadRecommendArticleList() {
        APIRequest.getRecommendArticleListAPI(articleId: articleId, page: 1, row: 20) { (data) in
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
        authorNameLb.text = article?.publisher
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
            let authorTag = "<p color:#999999>编辑: \(article!.author)</p>"
            htmlString = NSString(string: htmlString).replacingOccurrences(of: "${author}", with: authorTag)
        }
        else {
            htmlString = NSString(string: htmlString).replacingOccurrences(of: "${author}", with: "")
        }
        webView.loadHTMLString(htmlString, baseURL: URL(string: htmlString))
    }
    
    //赞赏列表
    func updateRewardView() {
        let canvW = screenWidth - 40
        let top: CGFloat = 15
        let gap: CGFloat = 8
        let w: CGFloat = 30
        let colNum = Int((canvW - top*2)/(w+gap))
        var bottom: CGFloat = 0
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
    
}
