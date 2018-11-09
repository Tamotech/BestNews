//
//  UIDeviceExtension.swift
//  BestNews
//
//  Created by wuxi on 2018/11/10.
//  Copyright © 2018 wuxi. All rights reserved.
//

import UIKit

extension UIDevice {

    public class func switchOritation(_ oritation: UIInterfaceOrientation) {
        UIDevice.current.setValue(NSNumber(value: UIInterfaceOrientation.unknown.rawValue), forKey: "orientation")
        UIDevice.current.setValue(NSNumber(value: oritation.rawValue), forKey: "orientation")
    }

}
