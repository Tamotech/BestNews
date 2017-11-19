//
//  APIManager.swift
//  Summer
//
//  Created by 武淅 段 on 2017/8/7.
//  Copyright © 2017年 wuxi. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class APIManager: NSObject {

    
    static let shareInstance:APIManager = APIManager()

    let baseUrl:String = "http://116.62.167.116"
    var headers: HTTPHeaders = [
        "device": "app",
        "X-Requested-With":"XMLHttpRequest"
    ]
 
    
    override init() {
        super.init()
        self.getDeviceID()
    }
    
    //MARK: - request
    
    func postRequest(urlString: String, params: [String: Any]?, result: @escaping(_ resultObject: JSON?, _ code: Int, _ msg: String) -> ()) {
        
        var url = urlString
        if !urlString.hasPrefix("http") {
            url = baseUrl+urlString
        }
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            if let value = response.result.value {
                
                let resultDic = JSON(value)
                let num = resultDic["num"]
                let info = resultDic["info"]
                if num.intValue == -1 {
                    //token 失效
                    SessionManager.sharedInstance.logoutCurrentUser()
                    Toolkit.showLoginVC()
                }
                else {
                    result(resultDic, num.intValue, info.stringValue)
                }
            }
            else {
                result(nil, -2222, "网络请求失败!")
            }
        }
    }
    
    ///上传文件
    func uploadFile(data: Data, result: @escaping(_ resultObject: JSON?, _ code: Int, _ msg: String) -> ()) {
        
        let url = baseUrl+"/upload/doUpload.htm"
        
        Alamofire.upload(multipartFormData: { (formData) in
//            formData.append(data, withName: "file")
            formData.append(data, withName: "file", fileName: "avatar.jpg", mimeType: "image/jpg")
        }, usingThreshold: 10_000_000, to: url, method: .post, headers: headers) { (encodingResult) in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    print("\(response)")  //上传成功通过response返回json值
                    if let value = response.result.value {
                        let resultDic = JSON(value)
                        let num = resultDic["num"]
                        let info = resultDic["info"]
                        
                        result(resultDic, num.intValue, info.stringValue)
                    }
                    else {
                        result(nil, -2222, "网络请求失败!")
                    }
                })
            case .failure(let error):
                print(error)
            }

        }
    }
    
    func getDeviceID() {
        let idfv = UIDevice.current.identifierForVendor?.uuidString
        if idfv != nil {
            headers["deviceid"] = idfv!
        }
    }

}
