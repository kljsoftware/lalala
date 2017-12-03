//
//  PlayerHelper.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 播放器状态类型
enum PlayerState {
    case stop           // 默认停止
    case play           // 播放
    case pause          // 暂停
    case channelChanged // 切换频道
    case waitingPrev    // 等待上一首播放
    case waitingNext    // 等待下一首播放
}

/// 播放器助手
class PlayerHelper {
    
    /// 实例对象
    static let shared = PlayerHelper()
    private init() {
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
    }
    
    // MARK: - private & public members
    /// 播放器
    private lazy var player:AudioPlayer = {
        let _player = AudioPlayer()
        return _player
    }()
    
    /// 当前正在播放的歌曲列表数据
    private var songList = [FMSongDataModel]()
    
    /// 当前正在播放歌曲
    var song:FMSongDataModel?
    
    // 当前播放器状态
    var state:PlayerState = .stop
    
    /// 当前音乐的总时长
    var duration:TimeInterval {
        return player.audioStreamer?.duration ?? 0
    }
    
    /// 当前音乐播放时长
    var current:TimeInterval {
        return player.audioStreamer?.currentTime ?? 0
    }
    
    /// 当前音乐缓冲进度
    var buffer:TimeInterval {
        return player.audioStreamer?.bufferingRatio ?? 0
    }
    
    /// 计时器
    private var timer:Timer? = nil
    
    // MARK: - private methods
    // 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyAudioStatusChanged), name: NoticationAudioStatusChanged, object: nil)
    }
    
    // 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationAudioStatusChanged, object: nil)
    }
    
    /// 计时开始
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    /// 停止计时
    private func stopTimer() {
        if nil != timer {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 计时
    @objc private func fire() {
        NotificationCenter.default.post(name: NoticationUpdateForAudioProgressChanged, object: nil)
    }
    
    /// 音频状态更新
    @objc private func notifyAudioStatusChanged(_ sender:Notification) {
        
        /// 流播放器为空
        guard let streamer = player.audioStreamer else {
            state = .stop
            NotificationCenter.default.post(name: NoticationUpdateForAudioStatusChanged, object: nil)
            return
        }
        stopTimer()
        switch streamer.status {
        case .buffering:
            break
        case .playing:
            state = .play
            startTimer()
        case .paused:
            state = .pause
        case .error:
            state = .stop
        case .idle:
            state = .stop
        case .finished:
            state = .stop
        }
    
        NotificationCenter.default.post(name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    private func songIndex(song:FMSongDataModel?) -> Int? {
        if nil == song {return nil}
        guard let index = songList.index(of: song!) else {
            return nil
        }
        return index
    }
    
    /// MARK: - public methods
    /// 开始播放
    func start() {
        if nil != song {
            player.start(song!.url)
            NotificationCenter.default.post(name: NoticationUpdateForSongChanged, object: nil)
        }
    }
    
    /// 开始/恢复播放
    func resume() {
        if state == .pause {
            player.resume()
            state = .play
        } else {
            start()
            state = .play
        }
    }
    
    /// 暂停播放
    func pause() {
        player.pause()
        state = .pause
    }
    
    /// 停止播放
    func stop() {
        player.stop()
        state = .stop
    }
    
    /// 快进/快退 value = [0, 1]
    func seekTo(time:TimeInterval) {
       player.seekTo(time)
    }
    
    /// 上一首
    func prev() {
        if let index = songIndex(song: song) {
            if index > 0 {
                song = songList[index - 1]
                start()
                return
            }
        }
        // 请求歌曲列表
    }
    
    /// 下一首
    func next() {
        if let index = songIndex(song: song) {
            if index < songList.count - 1 {
                song = songList[index + 1]
                start()
                return
            }
        }
        // 请求歌曲列表
    }
    
    /// 清空歌曲列表
    func removeSongList() {
        songList.removeAll()
    }
    
    /// 添加歌曲列表
    func addSongList(songList:[FMSongDataModel], isPreInsert:Bool = false) {
        if isPreInsert {
            self.songList.insert(contentsOf: songList, at: 0)
            song = songList.last
        } else {
            self.songList.append(contentsOf: songList)
            song = songList.first
        }
    }
    
    /// 获取三张封面,没有给空串
    func getCoverList() -> [String] {
        var coverList = ["", "", ""]
        
        /// 当前歌索引
        let index = songIndex(song: song)
        if index == nil {
            return coverList
        }
        
        /// 当前封面
        coverList[1] = song!.coverURL
        
        /// 前首歌封面
        if index! > 0 {
            coverList[0] = songList[index! - 1].coverURL
        }
        
        /// 后首歌封面
        if index! < songList.count - 1 {
            coverList[2] = songList[index! + 1].coverURL
        }
        
        return coverList
    }
    
    /// 清理
    func clean() {
        stopTimer()
        player.clean()
    }
}

/// 后台业务处理
class BackgroundViewModel : BaseViewModel {
    
    // 获取歌曲列表
    
    // 获取当前播放歌曲的封面
    
    
}
