//
//  ApplyFamousConditionController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ApplyFamousConditionController: BaseViewController {

    
    @IBOutlet weak var colorV1: UIView!
    
    @IBOutlet weak var colorV2: UIView!
    
    @IBOutlet weak var statusLb1: UILabel!
    
    @IBOutlet weak var statusLb2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showCustomTitle(title: "申请名人")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func handleTapIdentifyBt(_ sender: UIButton) {
        
        let vc = ApplyFamousController(nibName: "ApplyFamousController", bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
