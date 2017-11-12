//
//  ListManager.swift
//  BestNews
//
//  Created by Worthy on 2017/11/3.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON

class ListManager: NSObject {

    var page: Int = 1
    var rows: Int = 10
    
    var jsonData: JSON?
    var path: String = ""
    
    func fetch(result: @escaping(_ success: Bool, _ data: JSON?)->()) {
        
        page = 1
        let url = "\(path)?page=\(page)&rows=\(rows)"
        APIManager.shareInstance.postRequest(urlString: url, params: nil) { (JSON, code, msg) in
            if (code == 0) {
                self.jsonData = JSON!["data"]
                result(true, JSON!["data"])
            }
            else {
                result(false, nil)
            }
        }
    }
    
    func fetchMore(result: @escaping(_ success: Bool, _ data: JSON?)->()) {
        
        page = page + 1
        let url = "\(path)?page=\(page)&rows=\(rows)"
        APIManager.shareInstance.postRequest(urlString: url, params: nil) { (JSON, code, msg) in
            if (code == 0) {
                self.jsonData = JSON!["data"]
                result(true, JSON!["data"])
            }
            else {
                result(false, nil)
            }
        }
    }
}
