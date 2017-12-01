//
//  HttpRequest.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

// 请求超时时间
let HTTP_REQUEST_TIMEOUT_INTERVAL:TimeInterval = 30

/// 基于第三方库AFNetworking的封装
class HttpRequest {
    
    //通过get请求数据，返回json
    class func get(_ urlString:String, success:((_ dictionary:NSDictionary?) -> Void)?, failure:((_ error:NSError) -> Void)? ) {
        
        // http会话管理
        let sessionManager = AFHTTPSessionManager()

        // 请求超时时间
        sessionManager.requestSerializer.timeoutInterval         = HTTP_REQUEST_TIMEOUT_INTERVAL

        // 接收contentType = "text/html", contentType = "application/json"的内容类型
        sessionManager.responseSerializer.acceptableContentTypes = NSSet(objects: ["text/html","application/json"]) as? Set<String>

        // URL编码
        let urlEncode = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // 开始请求网络数据
        sessionManager.get(urlEncode, parameters: nil, progress:nil, success: { (sessionDataTask, responseObject) -> Void in
            if success != nil {
                success!(responseObject as? NSDictionary)
            }
        }) { (sessionDataTask, error) -> Void in

            if failure != nil {
                failure!(error as NSError)
            }
        }
    }
}
