//
//  ActivityRegistController.swift
//  BestNews
//
//  Created by Worthy on 2017/10/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import PopupDialog
import Presentr

class ActivityRegistController: BaseViewController, UINavigationControllerDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.showCustomTitle(title: "活动报名")
        let backBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "iconBack"), style: .plain, target: self, action: #selector(handleTapBackButton(_:)))
        navigationItem.leftBarButtonItem = backBtn
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    func handleTapBackButton(_:Any) {
        let dialog = PopupDialog(title: "确认要离开本页?", message: "离开后已填写的信息将不再保存", image: nil, buttonAlignment: .horizontal, transitionStyle: .zoomIn, gestureDismissal: false) {
            
        }
            //PopupDialog(title: "确认要离开本页?", message: "离开后已填写的信息将不再保存")
        dialog.addButton(PopupDialogButton(title: "取消", action: {
            
        }))
        dialog.addButton(PopupDialogButton(title: "确认", action: {
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(dialog, animated: true, completion: {
            
        })
        
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController != self {
            
        }
    }

}
