//
//  ActivityTicketCell.swift
//  BestNews
//
//  Created by Worthy on 2017/10/4.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

class ActivityTicketCell: UITableViewCell {

    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var endDateLb: UILabel!
    
    @IBOutlet weak var priceLb: UILabel!
    
    @IBOutlet weak var statusBtn: UIButton!
    
    @IBOutlet weak var numField
    : UITextField!
    
    
    
    var ticket: ActivityTicket?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(_ ticket: ActivityTicket) {
        self.ticket = ticket
        nameLb.text = ticket.name
        endDateLb.text = ticket.endDateStr()
        priceLb.text = "票价: ¥\(ticket.money)"
        statusBtn.isHidden = ticket.num > 0
        
    }
    
//    @IBAction func tapSub(_ sender: Any) {
//        var num = Int(numField.text!)! - 1
//        if num < 0 {
//            num = 0
//        }
//        numField.text = String(num)
//    }
//
//    @IBAction func tapAdd(_ sender: Any) {
//        var num = Int(numField.text!)! + 1
//        if num >  ticket?.num ?? 10 {
//            num = ticket?.num ?? 10
//        }
//        numField.text = String(num)
//    }
    
    
}
