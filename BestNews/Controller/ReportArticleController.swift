//
//  ReportArticleController.swift
//  BestNews
//
//  Created by Worthy on 2017/12/25.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ReportArticleController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textView: IQTextView!
    
    var selectItem = "广告"
    var items = ["广告" ,"色青低俗", "谣言", "疑似抄袭", "标题夸张/文不对题", "违法犯罪", "欺诈/恶意营销"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }

   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        let item = items[indexPath.row]
        if selectItem == item {
            let att = NSAttributedString(string: item, attributes: [NSForegroundColorAttributeName: themeColor!,
                                                                    NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
            cell.textLabel?.attributedText = att
            cell.accessoryType = .checkmark
            cell.tintColor = themeColor!
        }
        else {
            let att = NSAttributedString(string: item, attributes: [NSForegroundColorAttributeName: gray72!,
                                                                    NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
            cell.textLabel?.attributedText = att
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectItem = items[indexPath.row]
        tableView.reloadData()
    }
    
    
    @IBAction func tapClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
   
    @IBAction func tapSubmit(_ sender: Any) {
        
        dismiss(animated: true) {
            BLHUDBarManager.showSuccess(msg: "感谢您的反馈,小编将擦亮眼睛重新审核！", seconds: 1)
        }
        
    }
    

}
