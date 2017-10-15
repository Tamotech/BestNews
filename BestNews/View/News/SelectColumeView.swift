//
//  SelectColumeView.swift
//  BestNews
//
//  Created by Worthy on 2017/10/15.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import SnapKit

///选择栏目页
class SelectColumeView: UIView {

    var buttons: [UIButton] = []
    
    func show() {
        self.frame = UIScreen.main.bounds
        self.x = screenWidth
        keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.x = 0
        }) { (success) in
            
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.x = screenWidth
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor(white: 1, alpha: 0.95)
        //首先创建一个模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        //接着创建一个承载模糊效果的视图
        let blurView = UIVisualEffectView(effect: blurEffect)
        //设置模糊视图的大小（全屏）
        blurView.frame = UIScreen.main.bounds
        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
        self.addSubview(blurView)
        
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 64))
        bgView.backgroundColor = UIColor(white: 1, alpha: 0.93)
        bgView.layer.shadowColor = gray146?.cgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bgView.layer.shadowRadius = 4
        bgView.layer.shadowOpacity = 0.8
        self.addSubview(bgView)
        
        let searchView = UIImageView(image: #imageLiteral(resourceName: "icon_search"))
        bgView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.bottom.equalTo(-12)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        let titleLb = UILabel()
        titleLb.textColor = UIColor(ri: 85, gi: 85, bi: 85)
        titleLb.font = UIFont.systemFont(ofSize: 16)
        titleLb.text = "切换频道"
        bgView.addSubview(titleLb)
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(searchView.snp.right).offset(15)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        let closeBtn = UIButton()
        closeBtn.setImage(#imageLiteral(resourceName: "iconCancelM5-3-2"), for: .normal)
        closeBtn.addTarget(self, action: #selector(handleTapCloseBtn), for: .touchUpInside)
        bgView.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        
        
        let bs = ["推荐", "快讯", "十九大", "直播", "金融", "股票", "投资", "证券", "金融"]
        let horMargin: CGFloat = 20
        let verMargin: CGFloat = 25
        let bWidth: CGFloat = (screenWidth - 4*horMargin)/3.0
        let bHeight: CGFloat = 32
        for (i, item) in bs.enumerated() {
            let x = (CGFloat(i%3)+1)*horMargin + CGFloat(i%3)*bWidth
            let y = 64+(CGFloat(i/3)+1)*verMargin + CGFloat(i/3)*bHeight
            let btn = UIButton(frame: CGRect(x: x, y: y, width: bWidth, height: bHeight))
            btn.setTitle(item, for: .normal)
            btn.backgroundColor = UIColor(ri: 229, gi: 229, bi: 229, alpha: 0.9)
            btn.layer.cornerRadius = bHeight/2
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.setTitleColor(gray34, for: .normal)
            btn.addTarget(self, action: #selector(handleSelectItemBtn(btn:)), for: .touchUpInside)
            self.buttons.append(btn)
            self.addSubview(btn)
        }
        buttons.first?.setTitleColor(themeColor, for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func handleSelectItemBtn(btn: UIButton) {
        for b in buttons {
            if b == btn {
                b.setTitleColor(themeColor, for: .normal)
            }
            else {
                b.setTitleColor(gray34, for: .normal)
            }
        }
        self.dismiss()
    }
    
    func handleTapCloseBtn() {
        self.dismiss()
    }

}
