//
//  ActivityTicketDetailCell.swift
//  BestNews
//
//  Created by Worthy on 2017/12/9.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Kingfisher

class ActivityTicketDetailCell: UITableViewCell {

    
    @IBOutlet weak var coverPhoto: UIImageView!
    
    @IBOutlet weak var titleLb: UILabel!
    
    @IBOutlet weak var dateLb: UILabel!
    
    @IBOutlet weak var locationLb: UILabel!
    
    @IBOutlet weak var qrCodeImg: UIImageView!
    
    @IBOutlet weak var qrNoLb: UILabel!
    
    @IBOutlet weak var nameLb: UILabel!
    
    @IBOutlet weak var phoneLb: UILabel!
    
    @IBOutlet weak var ticketTypeLb: UILabel!
    
    @IBOutlet weak var useInstructionLb: UILabel!
    
    @IBOutlet weak var labelLb: UILabel!
    
    @IBOutlet weak var refundBtn: UIButton!
    
    var ticket: ActivityTicketDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateCell(_ ticket: ActivityTicketDetail) {
        self.ticket = ticket
        if let url = URL(string: ticket.preimgpath) {
            let rc = ImageResource(downloadURL: url)
            coverPhoto.kf.setImage(with: rc, placeholder: #imageLiteral(resourceName: "m252_default2"), options: nil, progressBlock: nil, completionHandler: nil)

        }
        titleLb.text = ticket.title
        dateLb.text = ticket.dateStr()
        locationLb.text = ticket.address
        nameLb.text = ticket.username
        phoneLb.text = ticket.mobile
        ticketTypeLb.text = ticket.tname
        var newOrder = ""
        for (i, w) in ticket.ano.enumerated() {
            if i < 4 || i >= ticket.ano.count - 4 {
                newOrder.append(w)
            }
            else {
                newOrder.append("*")
            }
        }
        qrNoLb.text = newOrder
        let qrImg = ticket.ano.createQRForString(qrImageName: nil)
        qrCodeImg.image = qrImg
        if ticket.refundflag == 1 {
            refundBtn.isHidden = false
        }
        else {
            refundBtn.isHidden = true
        }
        
    }
    
    @IBAction func handleTapReturnBtn(_ sender: UIButton) {
        let path = "/activityoperate/refund.htm?aaid=\(ticket!.aaid)"
        APIManager.shareInstance.postRequest(urlString: path, params: nil) { (JSON, code, msg) in
            if code == 0 {
                DispatchQueue.main.async {
                    BLHUDBarManager.showSuccess(msg: msg, seconds: 1)
                    NotificationCenter.default.post(name: kActivityRefundSuccessNotify, object: nil)
                }
                
            }
            else {
                DispatchQueue.main.async {
                    BLHUDBarManager.showError(msg: msg)
                }
            }
        }
    }
    
}
