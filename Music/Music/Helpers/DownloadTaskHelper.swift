//
//  DownloadTaskHelper.swift
//  Music
//
//  Created by hzg on 2017/12/11.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌曲每天最大下载次数
let DOWNLOAD_LIMIT_TIMES = 20

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
        
        /// 数据库数据同步
        let time = Date().getTime(format: "yyyy-MM-dd")
        let statistics = RealmHelper.shared.query(type: DownloadStatistics.self, predicate: NSPredicate(format: "time = %@", time))
        if statistics.count > 0 {
            amount = statistics.first!.amount
        }
    }
    
    /// 正在下载数组
    var downloadingTasks = [DownloadTask]()
    
    /// 今日下载次数
    var amount = 0
    
    /// 添加歌曲任务
    func addSongTask(model:SongRealm) {
        
        /// 今日下载次数超限
        if amount >= DOWNLOAD_LIMIT_TIMES {
            AppUI.tip(LanguageKey.Tip_DownloadTrackNoCredit.value)
            return
        }
        
        /// 更新下载次数
        amount += 1
        let time = Date().getTime(format: "yyyy-MM-dd")
        RealmHelper.shared.insert(obj: DownloadStatistics(value: [time, amount]), filter: NSPredicate(format: "time = %@", time))
        AppUI.tip(String(format: LanguageKey.Tip_DownloadTrackSuccess.value, model.title, "\(DOWNLOAD_LIMIT_TIMES - amount)"), position: .center)
        
        /// 创建下载任务
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
