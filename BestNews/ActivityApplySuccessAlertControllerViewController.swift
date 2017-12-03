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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTapOKBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
