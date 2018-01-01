//
//  VideoPlayControlBar.swift
//  BestNews
//
//  Created by Worthy on 2018/1/1.
//  Copyright © 2018年 wuxi. All rights reserved.
//

import UIKit

typealias VideoProgressChanged = (CGFloat)->()

class VideoPlayControlBar: BaseView {

   
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var timeLb: UILabel!
    
    var videoProgress: VideoProgressChanged?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let size = CGSize(width: 10, height: 10)
        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(UIColor.white.cgColor)
        ctx?.fillEllipse(in: CGRect(x: 0, y: 0, width: 10, height: 10))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        slider.setThumbImage(img, for: UIControlState.normal)
    }
    
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        
        let progress = sender.value/sender.maximumValue
        if videoProgress != nil {
            videoProgress!(CGFloat(progress))
        }
    }
}
