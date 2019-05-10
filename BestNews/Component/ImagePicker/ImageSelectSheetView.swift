//
//  ImageSelectSheetView.swift
//  BestNews
//
//  Created by Worthy on 2018/1/2.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit

class ImageSelectSheetView: BaseView {

    @IBOutlet weak var containerBottom: NSLayoutConstraint!
    
    var actionCallback:ButtonActionCallback?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapBG))
        self.addGestureRecognizer(tap)
    }
    
    func show() {
        self.frame = UIScreen.main.bounds
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, animations: {
            self.containerBottom.constant = 0
            self.layoutIfNeeded()
        }) { (success) in
            
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.containerBottom.constant = -210
            self.layoutIfNeeded()
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func tapCamera(_ sender: UIButton) {
        if self.actionCallback != nil {
            self.actionCallback!("Camera")
        }
        dismiss()
    }
    
    @IBAction func tapAlbum(_ sender: UIButton) {
        if self.actionCallback != nil {
            self.actionCallback!("Album")
        }
        dismiss()
    }
    
    @IBAction func tapCancel(_ sender: UIButton) {
        if self.actionCallback != nil {
            self.actionCallback!("Cancel")
        }
        dismiss()
    }
    
    @objc func handleTapBG() {
        dismiss()
    }
    
}
