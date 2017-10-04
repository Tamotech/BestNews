//
//  ActivityDetailController.swift
//  BestNews
//
//  Created by 武淅 段 on 2017/9/13.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Presentr

class ActivityDetailController: BaseViewController, ActivityTicketListControllerDelgate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var presentr:Presentr = {
        let pr = Presentr(presentationType: .fullScreen)
        pr.transitionType = TransitionType.coverVertical
        pr.dismissOnSwipe = true
        pr.dismissAnimated = true
       return pr
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shouldClearNavBar = true
        let collectionBar = UIBarButtonItem(image: #imageLiteral(resourceName: "iconCollection"), style: .plain, target: self, action: #selector(handleTapCollectionBtn(sender:)))
        let repostBar = UIBarButtonItem(image: #imageLiteral(resourceName: "iconShare"), style: .plain, target: self, action: #selector(handleTapRepostBtn(sender:)))
        navigationItem.rightBarButtonItems = [repostBar, collectionBar]
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }

    

    //MARK: - acions
    func handleTapCollectionBtn(sender: Any) {
        
    }
    
    func handleTapRepostBtn(sender: Any) {
        
    }
    
    @IBAction func handleTapJoinBtn(_ sender: UIButton) {
        let vc = ActivityTicketListController(nibName: "ActivityTicketListController", bundle: nil)
        vc.delegate = self
        presentr.viewControllerForContext = self
        presentr.shouldIgnoreTapOutsideContext = true
        customPresentViewController(presentr, viewController: vc, animated: true) {
            
        }
    }
    
    func handleTapNextBtn(vc: ActivityTicketListController) {
        vc.dismiss(animated: true, completion: nil)
        let registVC = ActivityRegistController(nibName: "ActivityRegistController", bundle: nil)
        navigationController?.pushViewController(registVC, animated: true)
    }
        
}
