//
//  RewardAlertController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/2.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias ConfirmPriceCallback = (Double)->()

class RewardAlertController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var priceLb: UILabel!
    
    @IBOutlet var priceBtns: [UIButton]!
    
    @IBOutlet weak var stableMoneyView: UIView!
    
    @IBOutlet weak var customMoneyView: UIView!
    
    @IBOutlet weak var priceField: UITextField!
    
    @IBOutlet weak var payWayView: UIView!
    
    @IBOutlet weak var zhifubaoBtn: UIButton!
    
    @IBOutlet weak var wechatBtn: UIButton!
    
    @IBOutlet weak var rewardBtn: UIButton!
    
    var articleId = ""
    
    /// 0 支付宝  1 微信 zhifubao/weixin
    var payway = "zhifubao"
    
    var confirmCallback: ConfirmPriceCallback?
    
    var price: Double = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()

        priceField.delegate = self
        for btn in priceBtns {
            btn.addTarget(self, action: #selector(handleTapPriceBtn(_:)), for: .touchUpInside)
        }
        handleTapPriceBtn(priceBtns.first!)
        priceField.delegate = self
        customMoneyView.isHidden = true
        payWayView.isHidden = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPaySuccess(_:)), name: kZhifubaoPaySuccessNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPayFail(_:)), name: kZhifubaoPayFailNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPaySuccess(_:)), name: kWexinPaySuccessNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zhifubaoPayFail(_:)), name: kWexinPayFailNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    ///MARK: - actions
    
    @IBAction func handleTapCloseBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleTapOtherPriceBtn(_ sender: UIButton) {
        stableMoneyView.isHidden = true
        customMoneyView.isHidden = false
    }
    
    
    @IBAction func selectPayWay(_ sender: UIButton) {
        if sender.tag == 1 {
            //支付宝
            zhifubaoBtn.setImage(#imageLiteral(resourceName: "TickOnM3-3b"), for: UIControlState.normal)
            wechatBtn.setImage(#imageLiteral(resourceName: "TickOffM3-3b"), for: UIControlState.normal)
            payway = "zhifubao"
        }
        else if sender.tag == 2 {
            //微信
            wechatBtn.setImage(#imageLiteral(resourceName: "TickOnM3-3b"), for: UIControlState.normal)
            zhifubaoBtn.setImage(#imageLiteral(resourceName: "TickOffM3-3b"), for: UIControlState.normal)
            payway = "weixin"
        }
    }
    
    @IBAction func handleTapRewardBtn(_ sender: UIButton) {
    
        if !customMoneyView.isHidden {
            if priceField.text?.count == 0 {
                return
            }
            else {
                price = Double(priceField.text!)!
            }
        }
        if payWayView.isHidden {
            payWayView.isHidden = false
            rewardBtn.setTitle("确定支付", for: UIControlState.normal)
        }
        else {
            
            
            APIRequest.articleRewardAPI(articleId: articleId, money: price, payway: payway, result: { [weak self](data) in
                if data != nil {
                    let result = data as! ActivityPayResult
                    if self?.payway == "zhifubao" {
                        AlipaySDK.defaultService().payOrder(result.zhifubao, fromScheme: "xinhuacaijing", callback: { (resultDic) in
                            print("支付结果....> \(resultDic!)")
                        })
                    }
                    else if self?.payway == "weixin" {
                        let req = PayReq()
                        req.partnerId = result.weixin.partnerid
                        req.prepayId = result.weixin.prepayid
                        req.package = result.weixin.package
                        req.nonceStr = result.weixin.noncestr
                        req.timeStamp = UInt32(result.weixin.timestamp)!
                        req.sign = result.weixin.sign
                        WXApi.send(req)
                    }
                }
            })
            //支付

        }
        
    }
    
    
    func zhifubaoPaySuccess(_ : Any?) {
        dismiss(animated: true) {
            [weak self] in
            if self?.confirmCallback != nil {
                self?.confirmCallback!(self!.price)
            }
        }
    }
    
    func zhifubaoPayFail(_ : Any?) {
        DispatchQueue.main.async {
            BLHUDBarManager.showError(msg: "支付失败")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                self.dismiss(animated: true) {
                    
                }
            })
        }
        
    }
    
    func handleTapPriceBtn(_ sender: UIButton) {
        let p: [Double] = [5, 10, 50, 100]
        for i in 0..<p.count {
            let btn = priceBtns[i]
            if btn == sender {
                btn.borderColor = themeColor!
                btn.setTitleColor(themeColor, for: .normal)
                price = p[i]
                priceLb.text = "\(price)"
            }
            else {
                btn.borderColor = UIColor(hexString: "b5b5b5")!
                btn.setTitleColor(UIColor(hexString: "b5b5b5"), for: .normal)
            }
        }
    }
    

}
