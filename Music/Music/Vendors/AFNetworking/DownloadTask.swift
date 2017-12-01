//
//  DownloadTask.swift
//  Music
//
//  Created by hzg on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

///  下载任务类，基于第三方AFNetworking封装
class DownloadTask {
    
    /// 会话管理
    private lazy var manager:AFURLSessionManager = {
        
        /// 会话管理
        let _manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        /// 开始接收服务器返回的书数据
        _manager.setDataTaskDidReceiveResponseBlock({ [weak self] (session, sessionTask, response) -> URLSession.ResponseDisposition in
            
            // 允许处理服务器的响应，才会继续接收服务器返回的数据
            return URLSession.ResponseDisposition.allow
        })
        
        /// 接收下载数据
        _manager.setDataTaskDidReceiveDataBlock({ (session, sessionTask, data) in
            
        })
        
        /// 下载完成
        _manager.setTaskDidComplete({ (session, sessionTask, error) in
            
        })

        return _manager
    }()
    
    /// 下载任务
    private var task:URLSessionTask?
    
    /// 文件句柄
    private var fileHandle:FileHandle?
    
    /// 文件总长度
    private var fileLength = 0
    
    /// 当前文件长度
    private var currentLength = 0
    
    // MARK: - private methods
    /// 开始/继续下载
    func start(urlString:String?) {
        
        /// 地址为空
        if urlString == nil || urlString!.isEmpty {
            return
        }
        
        /// 下载URL
        guard let url = URL(string: urlString!) else {
            // 无效url
            return
        }
        
        /// 下载请求
        let request = URLRequest(url: url)
        

        
        
        /// 下载任务
        task = manager.dataTask(with: request, completionHandler: {(response, responseObject, error) in
            
        })
        
        /// 任务开始/继续
        task?.resume()
    }
    
    /// 暂停下载
    func pause() {
        task?.suspend()
    }
    
    /// 停止下载
    func stop() {
        task?.cancel()
        task = nil
    }
}
