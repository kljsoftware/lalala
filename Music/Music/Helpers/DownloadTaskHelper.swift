//
//  DownloadTaskHelper.swift
//  Music
//
//  Created by hzg on 2017/12/11.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌曲下载任务助手
class DownloadTaskHelper {
    
    /// 实例对象
    static let shared = DownloadTaskHelper()
    private init() {
        
        /// 读取正在下载数组
        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "downloadFlag = %d", 1))
        for result in results {
            let task = DownloadTask(urlString: result.url)
            downloadingTasks.append(task)
            
            /// 下载完成
            task.downloadFinishedCallback = { [weak self](filePath) in
                guard let wself = self else {
                    return
                }
                let newModel = SongRealm(value: result)
                newModel.downloadFlag = 2
                RealmHelper.shared.insert(obj:newModel, filter: NSPredicate(format: "sid = %d", newModel.sid))
                wself.deleteDownloadingTask(task: task)
                NotificationCenter.default.post(name: NoticationUpdateForSongDownload, object: nil)
            }
        }
    }
    
    /// 正在下载数组
    private var downloadingTasks = [DownloadTask]()
    
    /// 添加歌曲任务
    func addSongTask(model:SongRealm) {
        let task = DownloadTask(urlString: model.url)
        downloadingTasks.append(task)
        task.resume()
        
        /// 开始下载
        task.downloadBeginCallBack = {
            model.downloadFlag = 1
            model.downloadFileLength = task.fileLength
            RealmHelper.shared.insert(obj: model)
            NotificationCenter.default.post(name: NoticationUpdateForSongDownload, object: nil)
        }
        
        /// 下载完成
        task.downloadFinishedCallback = { [weak self](filePath) in
            guard let wself = self else {
                return
            }
            let newModel = SongRealm(value: model)
            newModel.downloadFlag = 2
            RealmHelper.shared.insert(obj:newModel, filter: NSPredicate(format: "sid = %d", newModel.sid))
            wself.deleteDownloadingTask(task: task)
            NotificationCenter.default.post(name: NoticationUpdateForSongDownload, object: nil)
        }
    }
    
    /// 获取下载任务
    func getSongTask(model:SongRealm) -> DownloadTask? {
        for task in downloadingTasks {
            if task.urlString != nil && task.urlString! == model.url {
                return task
            }
        }
        return nil
    }
    
    /// 全部继续
    func resumeAll() {
        for downloadingTask in downloadingTasks {
            downloadingTask.resume()
        }
    }
    
    /// 开始/继续下载
    func resume(index:Int) {
        if index >= 0 && index < downloadingTasks.count {
            downloadingTasks[index].resume()
        }
    }
    
    /// 全部暂停
    func pauseAll() {
        for downloadingTask in downloadingTasks {
            downloadingTask.pause()
        }
    }
    
    /// 暂停下载
    func pause(index:Int) {
        if index >= 0 && index < downloadingTasks.count {
            downloadingTasks[index].pause()
        }
    }
    
    /// 删除正在下载任务
    func deleteDownloadingTask(task:DownloadTask) {
        if downloadingTasks.count > 0 {
            for i in 0..<downloadingTasks.count {
                if task == downloadingTasks[i] {
                    downloadingTasks[i].stop()
                    downloadingTasks.remove(at: i)
                }
            }
        }
    }
}
