//
//  TableViewCellExtension.swift
//  BestNews
//
//  Created by Worthy on 2017/11/12.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit

extension UITableViewCell {

    //返回cell所在的UITableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}
