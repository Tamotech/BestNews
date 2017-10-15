//
//  ThreePhotosNewsCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/1.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ThreePhotosNewsCell: UITableViewCell {

    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var photoView1: UIImageView!
    
    @IBOutlet weak var photoView2: UIImageView!
    
    @IBOutlet weak var photoView3: UIImageView!
    
    @IBOutlet weak var descLb: UILabel!
    
    @IBOutlet weak var tipBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoView1.image = #imageLiteral(resourceName: "cover3m2_1")
        photoView2.image = #imageLiteral(resourceName: "Cover2M3-1")
        photoView3.image = #imageLiteral(resourceName: "cover4m2_1")
    }
    
}
