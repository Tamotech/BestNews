//
//  WXImagePickerViewController.swift
//  Summer
//
//  Created by 武淅 段 on 2017/7/31.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

typealias ButtonActionCallback = (String) -> ()

class WXImagePickerViewController: UIViewController {

    
    
    @IBOutlet weak var containerView: UIView!
    var actionCallback:ButtonActionCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    


    @IBAction func pickFromAlbum(_ sender: Any) {
        
        dismiss(animated: true) { 
            if self.actionCallback != nil {
                self.actionCallback!("Album")
            }
        }
    }
    
    @IBAction func pickFromCamera(_ sender: Any) {
        dismiss(animated: true) { 
            if self.actionCallback != nil {
                self.actionCallback!("Camera")
            }
        }
    }
    
    @IBAction func handleTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
