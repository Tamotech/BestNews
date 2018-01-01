//
//  ActivityApplySuccessAlertControllerViewController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ActivityApplySuccessAlertControllerViewController: UIViewController {

    
    @IBOutlet weak var qrbarView: UIImageView!
    
    @IBOutlet weak var ticketNoLabel: UILabel!
    
    var aaid = ""           //活动报名id
    var orderNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        APIManager.shareInstance.postRequest(urlString: "/activityoperate/queryEwm.htm", params: ["aaid": aaid]) { [weak self](JSON, code, msg) in
            if code == 0 {
                let ano = JSON!["data"]["ano"].rawString()
                let qrImg =  ano?.createQRForString(qrImageName: nil)
                self?.qrbarView.image = qrImg
                var newOrder = ""
                for (i, w) in ano!.enumerated() {
                    if i < 4 || i >= ano!.count - 4 {
                        newOrder.append(w)
                    }
                    else {
                        newOrder.append("*")
                    }
                }
                self?.ticketNoLabel.text = newOrder
                
            }
            else {
                BLHUDBarManager.showError(msg: msg)
            }
        }
        
    }
    
    @IBAction func handleTapOKBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
