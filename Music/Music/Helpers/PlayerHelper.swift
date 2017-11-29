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
    private init() {}
    
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
    
    // MARK: - private methods
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
        }
    }
    
    /// 恢复播放
    func resume() {
        player.resume()
    }
    
    /// 暂停播放
    func pause() {
        player.pause()
    }
    
    /// 快进/快退 value = [0, 1]
    func seekTo(value:Float) {
       // player.seekTo()
    }
    
    /// 上一首
    func prev() -> Bool {
        if let index = songIndex(song: song) {
            if index > 0 {
                song = songList[index - 1]
                start()
                return true
            }
            return false
        }
        return false
    }
    
    /// 下一首
    func next() -> Bool {
        if let index = songIndex(song: song) {
            if index < songList.count - 1 {
                song = songList[index + 1]
                start()
                return true
            }
            return false
        }
        return false
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
}
