//
//  CommentCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

protocol CommentCellDelegate: class {
    func tapCommentBtn(commentId: String, name: String)
}

class CommentCell: UITableViewCell {

    @IBOutlet weak var avatarBtn: UIButton!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var voteBtn: UIButton!
    
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var voteCountLb: UILabel!
    
    @IBOutlet weak var commentLb: UILabel!
    
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var replyView: UIView!
    
    @IBOutlet weak var replyLb: UILabel!
    
    @IBOutlet weak var replyHeight: NSLayoutConstraint!
    
    @IBOutlet weak var checkReplyBtn: UIButton!
    
    let commentWidth = screenWidth - 63 - 15
    let replyWidth = screenWidth - 63 - 15 - 30
    
    var articleId: String?
    weak var delegate: CommentCellDelegate?
    var comment: CommentObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadReplyList(_ comment: CommentObject) {
        APIRequest.commentListAPI(articleId: articleId!, commentId: comment.id, page: 1) { [weak self](data) in
            let list = data as! CommentList
            let reply = list.replyListString()
            self?.replyLb.attributedText = reply
            self?.replyLb.sizeToFit()
            comment.replyContent = reply
        }
    }
    
    func updateCell(_ comment: CommentObject) {
        nameLb.text = comment.username
        self.comment = comment
        if comment.headimg.count > 0 {
            let rc = ImageResource(downloadURL: URL.init(string: comment.headimg)!)
            avatarBtn.kf.setImage(with: rc, for: UIControlState.normal, placeholder: #imageLiteral(resourceName: "defaultUser"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        voteCountLb.text = "\(comment.praisenum)"
        commentLb.text = comment.content
        timeLb.text = comment.dateStr()
        replyLb.attributedText = comment.replyContent
        if comment.replynum == 0 {
            replyHeight.constant = 0
            replyView.isHidden = true
        }
        else if comment.showReply == false {
            checkReplyBtn.isHidden = false
            replyLb.isHidden = true
            replyView.isHidden = false
            replyHeight.constant = 40
            checkReplyBtn.setTitle("查看全部\(comment.replynum)条回复", for: .normal)
        }
        else if comment.showReply == true {
            //计算回复的高度
            checkReplyBtn.isHidden = true
            replyLb.isHidden = false
            replyView.isHidden = false
            replyHeight.constant = comment.replyContentHeight()
        }
        if comment.replyContent == nil {
            self.loadReplyList(comment)
        }
        voteBtn.isSelected = (comment.praiseflag == 1)
    }
    
    
    @IBAction func handleTapCheckReply(_ sender: UIButton) {
        replyLb.isHidden = false
        checkReplyBtn.isHidden = true
        comment!.showReply = true
        guard let tableView = self.superTableView() else {
            return
        }
        tableView.reloadData()
    }
    
    @IBAction func handleTapCommentBtn(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.tapCommentBtn(commentId: comment!.id, name: comment?.username ?? "")
        }
    }
    
    @IBAction func handleTapVote(_ sender: UIButton) {
        if comment?.praiseflag == 0 {
            comment?.praiseflag = 1
            comment?.praisenum = comment!.praisenum + 1
            comment?.praiseAPI(praise: true)
            voteBtn.setImage(#imageLiteral(resourceName: "vote_select"), for: .normal)
        }
        else {
            comment?.praiseflag = 0
            comment?.praisenum = comment!.praisenum - 1
            comment?.praiseAPI(praise: false)
            voteBtn.setImage(#imageLiteral(resourceName: "vote_light"), for: .normal)
        }
        voteCountLb.text = "\(comment!.praisenum)"
    }
    
    
}
