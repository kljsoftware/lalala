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
    
    // 是否正在播放
    var isPlaying : Bool {
        if nil == audioStreamer {
            return false
        }
        return (audioStreamer!.status == DOUAudioStreamerStatus.playing)
    }
    
    /// 是否暂停
    var isPaused:Bool {
        if nil == audioStreamer {
            return false
        }
        return audioStreamer!.status == DOUAudioStreamerStatus.paused
    }
    
    // MARK: - init/deinit methods
    // 构造
    override init() {
        super.init()
    }
    
    deinit {
        removeAudioStreamObserver()
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
    }
    
    // MARK: - observer methods
    // 观察流播放器的播放状态
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &kStatusKVOKey {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NoticationAudioStatusChanged, object: nil)
            }
        } else if context == &kDurationKVOKey {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NoticationAudioStatusChanged, object: nil)
            }
        } else if context == &kBufferingRatioKVOKey {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NoticationAudioStatusChanged, object: nil)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
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
        if isPaused {
            audioStreamer?.play()
        }
    }
    
    // 暂停
    func pause() {
        if isPlaying {
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
    
    /// 清理
    func clean() {
        removeAudioStreamObserver()
    }
}
