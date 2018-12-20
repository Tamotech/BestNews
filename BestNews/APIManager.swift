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
    var tasks: [DataRequest] = []
    #if DEBUG
    let baseUrl:String = "http://xhfmedia.com:8080"
    #else
    let baseUrl:String = "http://xhfmedia.com"
    #endif
    
    
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
        
        /// 一部分host 忽略其登录
        let loginBacknames = ["/member/countUserOPNum.htm", "/articleoperate/getSubscribeArticlePage.htm", "/articleoperate/getCollectArticlePage.htm", "/article/getAllChannnel.htm"]
        
        let request =  Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            self.filterTasks()
            if let value = response.result.value {
                
                let resultDic = JSON(value)
                let num = resultDic["num"]
                let info = resultDic["info"]
                
                if num.intValue == -1002 || num.intValue == -1 || num.intValue == -1004 {
                    //token 失效
                    for w in loginBacknames {
                        if url.contains(w) {
                            result(resultDic, num.intValue, info.stringValue)
                            break
                        }
                    }
                    SessionManager.sharedInstance.logoutCurrentUser()
                    Toolkit.showLoginVC()
                }
                else {
                    result(resultDic, num.intValue, info.stringValue)
                }
            }
            else if response.error != nil {
                let error = response.error!
                if (error as NSError).code != -999 && !urlString.contains("getHangqing.htm") {
                    //非取消 仅首页文章
                    if url.contains("getIdxRecommendArticles.htm") {
                        NotificationCenter.default.post(name: kNetFailNotify, object: nil)
                    }
                    result(nil, -2222, "网络请求失败!")
                }
            }
        }
        tasks.append(request)
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

    
    private func filterTasks() {
        tasks = tasks.filter{[URLSessionTask.State.running, URLSessionTask.State.suspended].contains($0.task?.state)}
    }
    
    ///取消所有网络请求
    public func cancelAllTask() {
        _ = tasks.map{$0.cancel()}
        SwiftNotice.clear()
    }
}
