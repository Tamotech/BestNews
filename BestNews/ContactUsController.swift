//
//  ContactUsController.swift
//  BestNews
//
//  Created by wuxi on 2018/5/12.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ContactUsController: BaseViewController {

    
    @IBOutlet weak var phoneLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    @IBOutlet weak var addressLb: UILabel!
    @IBOutlet weak var mapView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var touchWay = ["s_contact_phone": "",
                    "s_contact_email": "",
                    "s_contact_address": "",
                    "u_contact_map": ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCustomTitle(title: "联系我们")
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        phoneLb.text = touchWay["s_contact_phone"]
        emailLb.text = touchWay["s_contact_email"]
        addressLb.text = touchWay["s_contact_address"]
        if let url = URL(string: touchWay["u_contact_map"]!) {
            let rc = ImageResource(downloadURL: url)
            mapView.kf.setImage(with: rc)
        }
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
