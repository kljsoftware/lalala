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
    
    /**
     通过http下载文件
     - parameter URLString        : 文件URL
     - parameter progressHandler  : 下载进度
     - parameter completionHandler: 下载完成回调
     */
    class func downloadFile(withURLString URLString: String, progressHandler: ((Progress) -> Void)?, completionHandler: @escaping ((URL?, Error?) -> Void)) {
        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let request = URLRequest(url: URL(string: URLString)!)
        let downloadTask = manager.downloadTask(with: request, progress: { (progress) -> Void in
            print("Download progress: \(progress.fractionCompleted)")
            if progressHandler != nil {
                progressHandler!(progress)
            }
        }, destination: { (URL, response) -> Foundation.URL in
            let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            return fileUrl.appendingPathComponent(response.suggestedFilename!)
        }) { (response, URL, error) -> Void in
            completionHandler(URL, error)
        }
        
        downloadTask.resume()
    }
}
