//
//  SubmitPaperController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class SubmitPaperController: BaseViewController {

    
    @IBOutlet weak var famousView: UIView!
    
    @IBOutlet weak var normalView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showCustomTitle(title: "我要投稿")
        normalView.isHidden = false
        famousView.isHidden = true
        if let user =  SessionManager.sharedInstance.userInfo {
            if user.celebrityflag {
                famousView.isHidden = false
                normalView.isHidden = true
            }
        }
    }


    
    @IBAction func handleTapIdentifyBt(_ sender: UIButton) {
        
        let vc = ApplyFamousConditionController(nibName: "ApplyFamousConditionController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
