//
//  RefundAlertController.swift
//  BestNews
//
//  Created by Worthy on 2018/1/3.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit

class RefundAlertController: UIViewController {

    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var msgLb: UILabel!
    
    
    var tit = ""
    var msg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLb.text = tit
        msgLb.text = msg
    }
    
    
    @IBAction func handleTapOK(_ sender: Any) {
        
        dismiss(animated: true) {
            
        }
    }
    

}
