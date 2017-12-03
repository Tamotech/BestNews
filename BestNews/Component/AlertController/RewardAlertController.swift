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
    }

    ///MARK: - actions
    
    @IBAction func handleTapCloseBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleTapOtherPriceBtn(_ sender: UIButton) {
        stableMoneyView.isHidden = true
        customMoneyView.isHidden = false
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
        dismiss(animated: true) {
            [weak self] in
            if self?.confirmCallback != nil {
                self?.confirmCallback!(self!.price)
            }
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
