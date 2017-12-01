//
//  BaseView.swift
//  Summer
//
//  Created by 武淅 段 on 2017/6/19.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Presentr

class BaseView: UIView {

    lazy var presentr:Presentr = {
        let pr = Presentr(presentationType: .fullScreen)
        pr.transitionType = TransitionType.coverVertical
        pr.dismissOnTap = true
        pr.dismissAnimated = true
        return pr
    }()
    
    class func instanceFromXib() -> UIView {
        let className = NSStringFromClass( object_getClass(self.classForCoder())).components(separatedBy: ".").last!
        let view = Bundle.main.loadNibNamed(className, owner: nil, options: nil)?.first as! UIView
        return view
    }
    
    deinit {
        print("deinit ----- \(self.classForCoder)")
    }

}
