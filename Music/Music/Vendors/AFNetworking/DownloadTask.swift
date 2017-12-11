//
//  DownloadTask.swift
//  Music
//
//  Created by hzg on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

typealias DownloadBeginCallback = () -> Void
typealias DownloadFinishedCallback = (_ filePath:String) -> Void
typealias DownloadProgressCallBack = (_ progres: Float) -> Void

///  下载任务类，基于第三方AFNetworking封装
class DownloadTask : NSObject {
    
    /// 开始下载
    var downloadBeginCallBack:DownloadBeginCallback?
    
    /// 下载完成
    var downloadFinishedCallback:DownloadFinishedCallback?
    
    /// 当前下载进度
    var downloadProgressCallback:DownloadProgressCallBack?
    
    /// 下载任务
    private var task:URLSessionTask?
    
    /// 文件句柄
    private var fileHandle:FileHandle?
    
    /// 会话管理
    private lazy var manager:AFURLSessionManager = {
        
        /// 会话管理
        let _manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        /// 开始接收服务器返回的书数据
        _manager.setDataTaskDidReceiveResponseBlock({ [weak self] (session, sessionTask, response) -> URLSession.ResponseDisposition in
            
            /// 取消下载任务
            if nil == self {return URLSession.ResponseDisposition.cancel}
            
            ///  获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
            self!.fileLength = response.expectedContentLength + self!.currentLength
            
            /// 创建文件句柄
            self!.fileHandle = FileHandle(forWritingAtPath: self!.filePath)
            
            DispatchQueue.main.async { [weak self] in
                
                if nil == self {return}
                
                self!.downloadBeginCallBack?()
            }
            
            // 允许处理服务器的响应，才会继续接收服务器返回的数据
            return URLSession.ResponseDisposition.allow
        })
        
        /// 接收下载数据
        _manager.setDataTaskDidReceiveDataBlock({ [weak self](session, sessionTask, data) in
            
            /// 停止接收
            if nil == self {return}
            
            /// 指定数据的写入位置 -- 文件内容的最后面
            self!.fileHandle?.seekToEndOfFile()
            
            /// 写入数据
            self!.fileHandle?.write(data)
            
            /// 拼接文件总长度
            self!.currentLength += Int64(data.count)
            
            DispatchQueue.main.async { [weak self] in
               
                if nil == self {return}
                
                var progress:Float = 0
                if self!.fileLength != 0 {
                    progress = Float(self!.currentLength) / Float(self!.fileLength)
                }
                self!.downloadProgressCallback?(progress)
            }
        })
        
        /// 下载完成
        _manager.setTaskDidComplete({ [weak self](session, sessionTask, error) in
            self?.currentLength = 0
            self?.fileLength = 0
            self?.fileHandle?.closeFile()
            self?.fileHandle = nil
            DispatchQueue.main.async { [weak self] in
                self?.downloadFinishedCallback?(self!.filePath)
                Log.e("下载完成")
            }
        })
        
        return _manager
    }()
    
    /// 文件下载存储目录
    private lazy var downloadDir:String = {
       
        // 沙盒根路径
        let home = NSHomeDirectory()
        
        // 缓存文件夹目录
        let dir = home + "/Documents/Download"
        
        // 若不存在，创建
        if !FileManager.default.fileExists(atPath: dir) {
            try? FileManager.default.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
        }
        
        // 下载缓存目录
        return dir
    }()
    
    /// 下载地址
    var urlString:String?
    
    /// 文件路径
    var filePath = ""
    
    /// 文件总长度
    var fileLength:Int64 = 0
    
    /// 当前文件长度
    var currentLength:Int64 = 0
    
    // MARK: - init/public methods
    /// 创建下载任务
    init(urlString:String?) {
        super.init()
        
        /// 地址为空
        if urlString == nil || urlString!.isEmpty {
            return
        }
        
        /// 下载URL
        guard let url = URL(string: urlString!) else {
            // 无效url
            return
        }
        
        self.urlString = urlString
        
        /// 下载请求
        var request = URLRequest(url: url)
        
        /// 文件路径 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
        filePath = "\(downloadDir)/\(url.lastPathComponent)"
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        /// 当前已经下载的文件长度
        currentLength = fileLength(path:filePath)
        
        // 设置HTTP请求头中的Range
        let range = String.init(format: "bytes=%zd-", currentLength)
        request.addValue(range, forHTTPHeaderField: "Range")
        
        /// 下载任务
        task = manager.dataTask(with: request, completionHandler: nil)
    }
    
    /// 任务开始/继续
    func resume() {
        task?.resume()
    }
    
    /// 暂停下载
    func pause() {
        task?.suspend()
    }
    
    /// 任务是否正在下载
    func isRunning() -> Bool {
        return task != nil && task!.state == .running
    }
    
    /// 停止下载
    func stop() {
        task?.cancel()
        task = nil
        clean()
    }
    
    /// 清理下载文件
    func clean() {
        if FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    /// 获取已下载的文件大小
    func fileLength(path:String) -> Int64 {
        let manager = FileManager.default
        var fileSize:Int64 = 0
        do {
            let attr = try manager.attributesOfItem(atPath: path)
            fileSize = (attr[FileAttributeKey.size] as? Int64) ?? 0
        } catch {
            dump(error)
        }
        return fileSize
    }
}
