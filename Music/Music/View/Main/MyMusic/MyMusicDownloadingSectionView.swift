//
//  MyMusicDownloadingSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/14.
//  Copyright © 2017年 demo. All rights reserved.
//

private let startTaskImage = UIImage(named:"download_btn_start"), pauseTaskImage = UIImage(named:"download_btn_pause")

/// 下载中section
class MyMusicDownloadingSectionView: UIView {

    /// 控制按钮，暂停所有任务、开始所有任务
    @IBOutlet weak var controlButton: UIButton!
    
    /// 点击按钮,单独点击控制按钮，可点击范围太少
    @IBOutlet weak var clickedButton: UIButton!
    
    /// 控制信息：全部开始、全部暂停、暂无任务
    @IBOutlet weak var controlLabel: UILabel!
    
    /// 是否全部处于暂停状态
    private var isAllPaused = false
    
    override func awakeFromNib() {
        updateControlStatus()
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
    }
    
    // MARK: - private methods
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPauseOrResumeDownload), name: NoticationUpdateForPauseOrResumeDownload, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForPauseOrResumeDownload, object: nil)
    }
    
    /// 新建歌单消息
    @objc private func notifyPauseOrResumeDownload(_ sender:Notification) {
        updateControlStatus()
    }
    
    /// 更新按钮状态
    private func updateControlStatus() {
        let tasks = DownloadTaskHelper.shared.downloadingTasks
        
        /// 暂无任务
        if tasks.count == 0 {
            controlButton.isHidden = true
            clickedButton.isHidden = true
            controlLabel.text = LanguageKey.MyMusic_NoTask.value
            return
        }
        
        /// 有无运行的任务
        var isRunningTask = false
        for task in tasks {
            if task.isRunning() {
                isRunningTask = true
                break
            }
        }
        
        controlButton.isHidden = false
        clickedButton.isHidden = false
        if isRunningTask {
            isAllPaused = false
            controlLabel.text = LanguageKey.MyMusic_PauseAll.value
            controlButton.setImage(pauseTaskImage, for: .normal)
        } else {
            isAllPaused = true
            controlLabel.text = LanguageKey.MyMusic_ContinueAll.value
            controlButton.setImage(startTaskImage, for: .normal)
        }
    }
    
    /// 点击控制按钮
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        if isAllPaused {
            DownloadTaskHelper.shared.resumeAll()
        } else {
            DownloadTaskHelper.shared.pauseAll()
        }
        NotificationCenter.default.post(name: NoticationUpdateForPauseOrResumeDownload, object: nil)
    }
}
