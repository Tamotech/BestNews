//
//  SimpleHUDController.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class SimpleHUDController: UIViewController {

    
    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var HUDView: UIView!
    
    
    func setupView(img: UIImage, title: String?) {
        iconView.image = img
        msgLabel.text = title
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //渐变层
        let gl = CAGradientLayer()
        gl.frame = HUDView.bounds
        gl.colors = [UIColor(hexString: "16c6ff")!.cgColor, UIColor(hexString: "0072ff")!.cgColor]
        gl.opacity = 0.6
        gl.startPoint = CGPoint(x: 0, y: 0)
        gl.endPoint = CGPoint(x: 1, y: 1)
        HUDView.layer.insertSublayer(gl, at: 0)
    }

}
