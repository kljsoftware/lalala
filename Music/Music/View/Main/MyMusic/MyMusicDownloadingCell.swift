//
//  MyMusicDownloadingCell.swift
//  Music
//
//  Created by hzg on 2017/12/11.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 播放、暂停图片
private let playImage = UIImage(named:"download_btn_start")!, pauseImage = UIImage(named:"download_btn_pause")!

/// 下载中单元
class MyMusicDownloadingCell: UITableViewCell {
    
    /// 歌名
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 下载大小
    @IBOutlet weak var downloadSizeLabel: UILabel!
    
    /// 下载进度条
    @IBOutlet weak var progressView: UIProgressView!
    
    /// 开始、暂停下载按钮
    @IBOutlet weak var controlButton: UIButton!
    
    /// 下载任务
    private var task:DownloadTask?
    
    /// 按钮状态
    private var isPaused = true
    
    /// 总大小
    private var totalSize:Float = 0
    
    /// 按钮点击事件
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        isPaused ? task?.resume() : task?.pause()
        updateButtonImage(isPaused: !isPaused)
        NotificationCenter.default.post(name: NoticationUpdateForPauseOrResumeDownload, object: nil)
    }
    
    /// 更新
    func update(model:SongRealm) {
        
        /// 获取当前下载任务
        task = DownloadTaskHelper.shared.getSongTask(model: model)
        task?.downloadProgressCallback = {[weak self](progress) in
            guard let wself = self else {
                return
            }
            wself.progressView.setProgress(progress, animated: false)
            let currentSize = (progress*wself.totalSize).floatDecimal(1)
            wself.downloadSizeLabel.text = "\(currentSize)/\(wself.totalSize)M"
        }
        
        /// 当前下载大小，总大小，下载进度
        var currentSize:Float = 0, progress:Float = 0
        if nil != task {
            currentSize = (Float(task!.currentLength)/1024/1024).floatDecimal(1)
        }
        totalSize = (Float(model.downloadFileLength)/1024/1024).floatDecimal(1)
        progress = totalSize != 0 ? currentSize/totalSize : 0
        
        /// 歌名、下载量、下载进度
        titleLabel.text = model.title
        downloadSizeLabel.text = "\(currentSize)/\(totalSize)M"
        progressView.setProgress(progress, animated: false)
        
        /// 更新按钮状态
        updateButtonImage(isPaused: !(task?.isRunning() ?? false))
    }
    
    /// 更新按钮状态
    func updateButtonImage(isPaused:Bool) {
        let image = isPaused ? playImage : pauseImage
        controlButton.setImage(image, for: .normal)
        self.isPaused = isPaused
    }
}
