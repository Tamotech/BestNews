//
//  ApplyFamousComplateController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/10.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ApplyFamousComplateController: UIViewController {

    
    var data: (String, String)?
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var msgLb: UILabel!
    
    var complete: CompleteCallback?
    override func viewDidLoad() {
        super.viewDidLoad()

        if data != nil {
            titleLb.text = data!.0
            msgLb.text = data!.1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleTapOKBt(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: self.complete)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
