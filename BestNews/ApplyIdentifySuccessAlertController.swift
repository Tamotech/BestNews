//
//  ApplyIdentifySuccessAlertController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/9.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit


typealias CompleteCallback = ()->()
class ApplyIdentifySuccessAlertController: UIViewController {

    
    var completeCallback: CompleteCallback?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func handleTapOKBtn(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: completeCallback)
    }

}
