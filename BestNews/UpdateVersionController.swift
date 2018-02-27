//
//  UpdateVersionController.swift
//  Summer
//
//  Created by Worthy on 2017/11/21.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias DismissHandler = () -> Void

class UpdateVersionController: UIViewController {

    
    @IBOutlet weak var updateLabel: UILabel!
    var dismissHandler: DismissHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func handleTapUpdateBtn(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: dismissHandler)
    }
    
    @IBAction func handleTapCloseBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
