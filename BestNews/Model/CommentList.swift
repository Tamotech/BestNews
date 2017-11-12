//
//  CommentList.swift
//  BestNews
//
//  Created by Worthy on 2017/11/8.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

class CommentList: HandyJSON {    
    required init() {}
    
    var total: Int = 0
    var page: Int = 0
    var rows: Int = 0
    var list: [CommentObject] = []
    
    func hasMore() -> Bool {
        return page < total
    }
    
    
    ///回复列表 字符串
    func replyListString() -> NSAttributedString {
        let result = NSMutableAttributedString()
        for comment in list {
            let author = NSAttributedString(string: "\(comment.username):", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightMedium),
               NSForegroundColorAttributeName: UIColor.init(hexString: "#222222")!])
            result.append(author)
            let content = NSAttributedString(string: "\(comment.content)\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12, weight: UIFontWeightRegular),
                NSForegroundColorAttributeName: UIColor.init(hexString: "#555555")!])
            result.append(content)
        }
        return result as NSAttributedString
    }
    
}

class CommentObject: HandyJSON {
    
    /**
     "content": "content1",
     "id": "0fba14dc-35fa-40ee-ab17-16e3135705fb",
     "username": "超级管理员",
     "replynum": 2,
     "headimg": "",
     "praiseflag": 0,
     "praisenum": 0,
     "userid": "admin",
     "createdate": 1508770996668
     */
    
    required init() {}
    
    var content: String = ""
    var id: String = ""
    var username: String = ""
    var replynum: Int = 0
    var headimg: String = ""
    var praiseflag: Int = 0
    var praisenum: Int = 0
    var userid: String = ""
    var createdate: Int = 0
    
    
    /// 以下内容为cell提供
    let commentOriginWidth: CGFloat = screenWidth - 63 - 15
    let replyOriginWidth: CGFloat = screenWidth - 63 - 15 - 30
    ///是否显示所有的回复
    var showReply: Bool = false
    var replyContent: NSAttributedString?
    
    func dateStr() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(createdate/1000))
        return date.newsDateStr()
    }
    
    
    /// 计算cell的高度 仅评论
    ///
    /// - Returns: 高度
    func cellHeight() -> CGFloat {
        ///除去评论和回复区域的高度, 从xib得到
        let emptyHeight: CGFloat = 207 - 54 - 45;
        let commentHeight = self.commentHeight()
        var replyHeight: CGFloat = 20
        if showReply && replyContent != nil {
            replyHeight = self.replyContentHeight()
        }
        else if replynum == 0 {
            replyHeight = -20
        }
        
        return emptyHeight + commentHeight + replyHeight
        
    }
    
    func commentHeight() -> CGFloat {
        return content.getLabHeigh(font: UIFont.systemFont(ofSize: 15), width: commentOriginWidth)+10
    }
    
    func replyContentHeight() -> CGFloat {
        return replyContent!.string.getLabHeigh(font: UIFont.systemFont(ofSize: 12), width: commentOriginWidth)
    }
    
    //点赞 取消
    func praiseAPI(praise: Bool) {
        if praise {
            APIRequest.commentPraiseAPI(commentId: id, result: { (success) in
            })
        }
        else {
            APIRequest.commentCancelPraiseAPI(commentId: id, result: { (success) in
                
            })
        }
    }
}
