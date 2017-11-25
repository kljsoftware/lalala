//
//  AudioPlayer.swift
//  Music
//
//  Created by hzg on 2017/11/22.
//  Copyright © 2017年 demo. All rights reserved.
//

import AVFoundation

// 观察对象
private var kStatusKVOKey         = "status"          // 播放状态变化
private var kDurationKVOKey       = "duration"        // 音频总时间
private var kBufferingRatioKVOKey = "bufferingRatio"  // 音频缓冲进度

/// 基于第三方DOUAudioStreamer封装
class AudioPlayer : NSObject {
    
    // 流播放器
    var audioStreamer:DOUAudioStreamer?
    
    // 是否已经停止
    var isStopped:Bool = true
    
    // 代理
    weak var delegate:AudioPlayerDelegate?
    
    // MARK: - init/deinit methods
    // 构造
    override init() {
        super.init()
        
        isStopped = true
        
//        // 监听是否触发home键挂起程序
//        NotificationCenter.default.addObserver(self, selector: #selector(notifyApplicationWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    deinit {
     //   NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        removeAudioStreamObserver()
    }
    
    // MARK: - notification methods
    // 触发home键挂起程序
    @objc func notifyApplicationWillResignActive(){
        stop()
    }
    
    // MARK: - private methods
    // 添加观察者
    fileprivate func addAudioStreamObserver() {
        if nil != audioStreamer {
            audioStreamer?.addObserver(self, forKeyPath: kStatusKVOKey, options: NSKeyValueObservingOptions.new, context: &kStatusKVOKey)
            audioStreamer?.addObserver(self, forKeyPath: kDurationKVOKey, options: NSKeyValueObservingOptions.new, context: &kDurationKVOKey)
            audioStreamer?.addObserver(self, forKeyPath: kBufferingRatioKVOKey, options: NSKeyValueObservingOptions.new, context: &kBufferingRatioKVOKey)
        }
    }
    
    // 删除观察者
    fileprivate func removeAudioStreamObserver() {
        if nil != audioStreamer {
            audioStreamer?.stop()
            audioStreamer?.removeObserver(self, forKeyPath: kStatusKVOKey)
            audioStreamer?.removeObserver(self, forKeyPath: kDurationKVOKey)
            audioStreamer?.removeObserver(self, forKeyPath: kBufferingRatioKVOKey)
            audioStreamer = nil;
        }
    }
    
    // 设置会话类型
    fileprivate func setAudioSessionCategory(_ category:String) {
        do {
            try AVAudioSession.sharedInstance().setCategory(category)
        } catch {
            
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            
        }
    }
    
    // 延时播放
    @objc func delayPlay() {
        audioStreamer?.play()
        //播放开始
        delegate?.onStreamerPlayStart()
    }
    
    // MARK: - observer methods
    // 观察流播放器的播放状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kStatusKVOKey {
            perform(#selector(playbackStateChanged), on: Thread.main, with: nil, waitUntilDone: false)
        } else if context == &kDurationKVOKey {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NoticationAudioDurationChanged, object: nil)
            }
        } else if context == &kBufferingRatioKVOKey {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NoticationAudioBufferRatioChanged, object: nil)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
        
    }
    
    // 流播放器状态发生改变
    @objc func playbackStateChanged() {
       
        let status = audioStreamer?.status
        if status == nil {
            return
        }
        print("YJYDOUAudioStreamerWrapper | status = \(String(describing: status?.rawValue))")
        switch status! {
        case DOUAudioStreamerStatus.buffering:
            break
        case DOUAudioStreamerStatus.playing:
            isStopped = false
            break
        case DOUAudioStreamerStatus.paused:
            isStopped = false
            delegate?.onStreamerPlayPaused?()
            break
        case DOUAudioStreamerStatus.error:
            audioStreamer?.stop()
            delegate?.onStreamerPlayError?()
            break
        case DOUAudioStreamerStatus.idle:
            // 播放完成
            isStopped = true
            delegate?.onStreamerPlayStoped()
            break
        case DOUAudioStreamerStatus.finished:
            audioStreamer?.stop()
            break
        }
    }
    
    // MARK: - public methods
    // 播放
    func start(_ url:String) {
        
        // 取消播放
        removeAudioStreamObserver()
        
        // 要远程播放的音频文件
        let audioFile = AudioFile()
        audioFile.url = URL(string: url)
        
        // 创建流播放器
        audioStreamer = DOUAudioStreamer(audioFile: audioFile)
        
        // 播放
        if (nil != audioStreamer && audioStreamer!.status == DOUAudioStreamerStatus.idle) {
            addAudioStreamObserver()
            setAudioSessionCategory(AVAudioSessionCategoryPlayback)
            // 延时播放，给缓冲时间， 不然会出现一播放就结束的情况
            perform(#selector(delayPlay), with: self, afterDelay: 0.1)
        }
    }
    
    /// 恢复
    func resume() {
        if isPaused() {
            audioStreamer?.play()
        }
    }
    
    // 暂停
    func pause() {
        if isPlaying() {
           audioStreamer?.pause()
        }
    }
    
    // 快进\快退
    func seekTo(_ currentTime:TimeInterval) {
        audioStreamer?.currentTime = currentTime
    }
    
    // 停止
    func stop() {
        audioStreamer?.stop()
    }
    
    // 是否正在播放
    func isPlaying() -> Bool {
        if nil == audioStreamer {
            return false
        }
        return (audioStreamer!.status == DOUAudioStreamerStatus.playing)
    }
    
    func isPaused() -> Bool {
        if nil == audioStreamer {
            return false
        }
        return audioStreamer!.status == DOUAudioStreamerStatus.paused
    }
}

// 代理
@objc protocol AudioPlayerDelegate : NSObjectProtocol {
    
    // 流播放开始
    func onStreamerPlayStart()
    
    // 流播放继续
    @objc optional func onStreamerPlayContinue()
    
    // 流播放暂停
    @objc optional func onStreamerPlayPaused()
    
    // 流播放结束
    func onStreamerPlayStoped()
    
    // 流播放错误
    @objc optional func onStreamerPlayError()
}
