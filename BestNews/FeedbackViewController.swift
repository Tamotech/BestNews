//
//  FeedbackViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedbackViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var tv: IQTextView!
    
    @IBOutlet weak var leftWordsLb: UILabel!
    
    @IBOutlet weak var submitBt: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCustomTitle(title: "意见反馈")
        submitBt.shadowOpacity = 0
        tv.contentInset = UIEdgeInsetsMake(10, 8, 25, 8)
        tv.delegate = self
    }

    
    func textViewDidChange(_ textView: UITextView) {
        let word = textView.text
        if word!.count > 0 {
            submitBt.isEnabled = true
            submitBt.shadowOpacity = 0.3
            submitBt.backgroundColor = themeColor!
        }
        else {
            submitBt.isEnabled = false
            submitBt.shadowOpacity = 0.0
            submitBt.backgroundColor = UIColor(hexString: "#dddddd")!

        }
        if word!.count < 200 {
            leftWordsLb.text = "\(word!.count)/200"
        }
        else {
            //截断
           
        }
        
    }
    
    @IBAction func handleTapSubmitBt(_ sender: UIButton) {
        
        let words = tv.text!
        if words.count == 0 || words.count > 200 {
            return
        }
        let path = "/member/suggest.htm"
        let params = ["content": words]
        APIManager.shareInstance.postRequest(urlString: path, params: params) { [weak self](JSON, code, msg) in
            if code == 0 {
                DispatchQueue.main.async {
                    let vc = ApplyFamousComplateController(nibName: "ApplyFamousComplateController", bundle: nil)
                    vc.data = ("您的意见反馈已提交", "收到您的反馈后，我们会将处理结果发送至您的通知中心，处理需要3-5个工作日，请耐心等待")
                    self!.customPresentViewController(self!.presentr, viewController: vc, animated: false, completion: nil)
                    vc.complete = {
                        [weak self] in
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                }
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
        
        
    }
    
}
