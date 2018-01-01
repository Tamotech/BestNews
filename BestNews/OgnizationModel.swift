//
//  OgnizationModel.swift
//  BestNews
//
//  Created by Worthy on 2017/11/19.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import HandyJSON

///机构/名人
class OgnizationModel: HandyJSON {

    required init(){}
    
    var id: String = ""
    var subscribe: Int = 0
    var memo: String = ""
    var headimg: String = ""
    var name: String = ""
    var url: String = ""
    //机构标签
    var tags: String = ""
    //机构类型
    var type = ""
    
    var organize: OgnizationModel?
    
    /// 订阅
    func subscriptIt() {
        
        if id.count == 0 {
            return
        }
        APIRequest.subscriptChannelAPI(id: id, type: "organize") { (success) in
            
        }
    }
    
    ///取消订阅
    func cancelSubsripbeIt() {
        if id.count == 0 {
            return
        }
        APIRequest.cancelSubscriptChannelAPI(id: id, type: "organize") { (success) in
            
        }
    }
}

class OgnizationList: HandyJSON {
    
    required init(){}
    var total: Int = 0
    var page: Int = 0
    var rows: Int = 0
    var list: [OgnizationModel] = []
}
