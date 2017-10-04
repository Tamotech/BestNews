//
//  NewsCommentBar.swift
//  BestNews
//
//  Created by Worthy on 2017/10/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

protocol CommentBarDelegate: class {
    
    func tapCommentHandler()
    func tapCollectionHandler()
    func tapRepostHandler()
    func tapReportHandler()
    func tapPostHandler()
    
}

class NewsCommentBar: UIView, UITextViewDelegate {

    lazy var barView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        self.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.left.top.right.bottom.equalTo(0)
        })
        
        
        let pencil = UIImageView.init(image: #imageLiteral(resourceName: "pencil_icon"))
        v.addSubview(pencil)
        pencil.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.centerY.equalTo(v.snp.centerY)
            make.width.height.equalTo(22)
        })
        
        let lb = UILabel()
        lb.textColor = gray181
        lb.font = UIFont.systemFont(ofSize: 15)
        lb.text = "评一下"
        v.addSubview(lb)
        lb.snp.makeConstraints({ (make) in
            make.left.equalTo(pencil.snp.right).offset(10)
            make.centerY.equalTo(pencil.snp.centerY)
        })
        
        let btnWidth:CGFloat = 35
        
        let reportBtn = UIButton()
        reportBtn.setImage(#imageLiteral(resourceName: "report_icon"), for: .normal)
        reportBtn.addTarget(self, action: #selector(handleTapReportBtn(sender:)), for: .touchUpInside)
        v.addSubview(reportBtn)
        reportBtn.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(-15)
            make.width.equalTo(btnWidth)
        })
        
        let repostBtn = UIButton()
        repostBtn.setImage(#imageLiteral(resourceName: "repost_dark"), for: .normal)
        repostBtn.addTarget(self, action: #selector(handleTapRepostBtn(sender:)), for: .touchUpInside)
        v.addSubview(repostBtn)
        repostBtn.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(reportBtn.snp.left)
            make.width.equalTo(btnWidth)
        })
        
        let collectionBtn = UIButton()
        collectionBtn.setImage(#imageLiteral(resourceName: "star_dark"), for: .normal)
        collectionBtn.addTarget(self, action: #selector(handleTapCollectionBtn(sender:)), for: .touchUpInside)
        v.addSubview(collectionBtn)
        collectionBtn.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(repostBtn.snp.left)
            make.width.equalTo(btnWidth)
        })
        
        let commentBtn = UIButton()
        commentBtn.setImage(#imageLiteral(resourceName: "comment_dark"), for: .normal)
        commentBtn.setTitleColor(gray34, for: .normal)
        commentBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        commentBtn.setTitle(" 0", for: .normal)
        commentBtn.addTarget(self, action: #selector(handleTapCommentBtn(sender:)), for: .touchUpInside)
        v.addSubview(commentBtn)
        commentBtn.snp.makeConstraints({ (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo(collectionBtn.snp.left)
            make.width.equalTo(52)
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapBarView(sender:)))
        v.addGestureRecognizer(tap)
        
        self.addSubview(v)
        return v
    }()
    
    lazy var textField:UITextView = {
       let field = UITextView()
        field.layer.cornerRadius = 16
        field.placeholderText = "发表评论..."
        field.font = UIFont.systemFont(ofSize: 15)
        field.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
        field.backgroundColor = gray244
        field.delegate = self
        return field
    }()
    
    lazy var postBtn: UIButton = {
        let b = UIButton()
        b.setTitleColor(themeColor, for: .normal)
        b.setTitle("发布", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        b.addTarget(self, action: #selector(handleTapPostBtn(sender:)), for: .touchUpInside)
        b.isEnabled = false
        b.alpha = 0.5
        return b
    }()
    
    lazy var textView:UIView = {
       let v = UIView()
        v.backgroundColor = UIColor.white
        self.addSubview(v)
        v.snp.makeConstraints({ (make) in
            make.left.top.right.bottom.equalTo(0)
        })
        
        v.addSubview(self.textField)
        self.textField.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.right.equalTo(-59)
            make.height.equalTo(33)
        })
        
        v.addSubview(self.postBtn)
        self.postBtn.snp.makeConstraints({ (make) in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(59)
        })
        
        return v
    }()
    
    weak var delegate: CommentBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        barView.alpha = 1
        textView.alpha = 0
        //阴影线
        let line = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 1))
        line.backgroundColor = gray229
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    //MARK: - actions
    func handleTapCommentBtn(sender: UIButton) {
        if delegate != nil {
            delegate?.tapCommentHandler()
        }
    }
    
    func handleTapCollectionBtn(sender: UIButton) {
        if delegate != nil {
            delegate?.tapCollectionHandler()
        }
    }
    
    func handleTapRepostBtn(sender: UIButton) {
        if delegate != nil {
            delegate?.tapRepostHandler()
        }
    }
    
    func handleTapReportBtn(sender: UIButton) {
        if delegate != nil {
            delegate?.tapReportHandler()
        }
    }
    
    func handleTapPostBtn(sender: UIButton) {
        if delegate != nil {
            delegate?.tapPostHandler()
        }
    }
    
    func handleTapBarView(sender: Any) {
        self.switchToEditMode(edit: true)
    }
    
    
    //MARK: - responder
    override func becomeFirstResponder() -> Bool {
        
        textField.becomeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: - textView

    func textViewDidEndEditing(_ textView: UITextView) {
        textField.text = ""
        sizeToFit()
        switchToEditMode(edit: false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.sizeToFit()
        let text = textView.text.trip()
        if text.characters.count > 0 {
            postBtn.isEnabled = true
            postBtn.alpha = 1
        }
        else {
            postBtn.isEnabled = false
            postBtn.alpha = 0.5
        }
    }
    
    //MARK:- private
    func switchToEditMode(edit: Bool) {
        if edit {
            UIView.animate(withDuration: 0.3, animations: {
                self.textView.alpha = 1
                self.barView.alpha = 0
                _ = self.becomeFirstResponder()
            })
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                self.textView.alpha = 0
                self.barView.alpha = 1
                _ = self.resignFirstResponder()
            })

        }
    }
    
    override func sizeToFit() {
        let maxSize = CGSize(width: textField.width-26, height: 500)
        let text = NSString(cString: textField.text.cString(using: String.Encoding.utf8)!, encoding: String.Encoding.utf8.rawValue)
        let frame = text?.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: textField.font!], context: nil)
        var tarHeight = frame!.size.height+15*2
        if tarHeight > 200 {
            tarHeight = 200
        }
        if tarHeight < 49 {
            tarHeight = 49
        }
        
        self.frame = CGRect(x: 0, y: self.bottom-tarHeight, width: screenWidth, height: tarHeight)
    }

}
