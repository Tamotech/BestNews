//
//  CommentListController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import CRRefresh
import Presentr

class CommentListController: BaseViewController, UITableViewDelegate, UITableViewDataSource,
CommentCellDelegate, CommentBarDelegate {
    
    var commentList: CommentList?
    var articleId: String = ""
    var tableView = UITableView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: screenHeight-49), style: .grouped)
    var commentBar = NewsCommentBar(frame: CGRect(x: 0, y: screenHeight-49, width: screenWidth, height: 49))
//    var targetCommentId: String?
    
    var emptyView = BaseEmptyView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = gray229
        tableView.separatorInset = UIEdgeInsetsMake(0, 67, 0, 0)
        view.addSubview(tableView)
        let nib = UINib(nibName: "CommentCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) {
            [weak self] in
            self?.reload()
        }
        tableView.cr.addFootRefresh(animator: NormalFooterAnimator()) {
            [weak self] in
            self?.loadMore()
        }
        if (commentList == nil) {
            tableView.cr.beginHeaderRefresh()
        }
        view.addSubview(commentBar)
        commentBar.delegate = self
        commentBar.articleId = articleId
        commentBar.entry = 1
        commentBar.textView.alpha = 1
        commentBar.barView.alpha = 0
        showCustomTitle(title: "评论(\(commentList?.total ?? 0))")
        
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
//        self.reload()
        tableView.addSubview(emptyView)
        emptyView.emptyString = "还没有评论~"
        
        
    }

    //MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyView.isHidden = (commentList?.list.count ?? 0) > 0
        return commentList?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let comment = commentList!.list[indexPath.row]
        return comment.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommentCell
        let comment = commentList!.list[indexPath.row]
        cell.articleId = articleId
        cell.updateCell(comment)
        cell.delegate = self
        return cell
    }
    
    /// MARK: - commentCellDelegate
    func tapCommentBtn(commentId: String, name: String) {
        commentBar.replySomeone = name
        commentBar.targetCommentId = commentId
        commentBar.switchToEditMode(edit: true)
    }
    
    
    /// MARK: - commentBarDelegate
    
    func tapReportHandler() {
        
    }
    
    func tapCommentHandler() {
        let vc = CommentListController()
        vc.commentList = commentList
        vc.articleId = articleId
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tapCollectionHandler() {
        
    }
    
    func tapRepostHandler() {
        let vc = BaseShareViewController(nibName: "BaseShareViewController", bundle: nil)
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = false
        presentr.dismissOnTap = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    
    func tapPublishBtnHandler() {
        
    }
    
    func postSuccessHandler() {
        reload()
    }
    
}

///load data
extension CommentListController {
    
    func reload() {
        loadCommentList(loadMore: false, needLoading: false, page: 1)
    }
    
    func loadMore() {
        if commentList == nil || !commentList!.hasMore() {
            self.tableView.cr.endLoadingMore()
            return
        }
        loadCommentList(loadMore: true, needLoading: false, page: commentList!.page+1)
    }
    
    func loadCommentList(loadMore: Bool, needLoading: Bool, page: Int) {
        
        APIRequest.commentListAPI(articleId: articleId, commentId: nil, page: page) { [weak self](data) in
            let list = data as? CommentList
            if (loadMore && self?.commentList != nil) {
                self?.commentList?.list.append(contentsOf: list!.list)
                self?.tableView.cr.endLoadingMore()
            }
            else {
                self?.commentList = list
                self?.tableView.cr.endHeaderRefresh()
                self?.tableView.cr.resetNoMore()
            }
            self?.showCustomTitle(title: "评论(\(self?.commentList?.total ?? 0))")
            self?.tableView.reloadData()
        }
    }
}
