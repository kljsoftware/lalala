//
//  FMView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 界面相关常量定义
/// 频道视图相关
private let channelViewRightMargin:CGFloat = 48, channelViewHeight:CGFloat = 48

/// 无限切换视图相关
private let loopViewBlank:CGFloat = 60, loopViewCornerRadius:CGFloat = 8

/// 播放控制视图的高度
private let playViewHeight:CGFloat = 96

/// 电台视图
class FMView: UIView {

    /// 电台业务处理类
    lazy var viewModel:FMViewModel = {
        let _viewModel = FMViewModel()
        _viewModel.getChannelList()
        return _viewModel
    }()
    
    /// 背景图
    lazy var backImageView:UIImageView = {
        let _backImageView = UIImageView()
        _backImageView.contentMode = .scaleAspectFill
        self.insertSubview(_backImageView, at: 0)
        _backImageView.snp.makeConstraints({ (maker) in
            maker.top.bottom.left.right.equalTo(self)
        })
        return _backImageView
    }()
    
    /// 歌词视图
    lazy var lyricView:LyricView = {
        let height = self.frame.height - channelViewHeight - playViewHeight - (BOTTOM_TAB_HEIGHT+DEVICE_INDICATOR_HEIGHT)
        let _lyricView = LyricView(frame: CGRect(x: 0, y: channelViewHeight, width: self.frame.width, height: height))
        _lyricView.isHidden = true
        _lyricView.backgroundColor = UIColor.clear
        self.addSubview(_lyricView)
        return _lyricView
    }()
    
    /// 频道视图
    lazy var channelView:FMChannelView = {
        let _channelView = FMChannelView(frame: CGRect(x: 0, y: 0, width: self.frame.width - channelViewRightMargin, height: channelViewHeight))
        self.addSubview(_channelView)
        return _channelView
    }()
    
    /// 无限切换视图
    lazy var loopPageView:LoopPageView = {
        let height = self.frame.height - channelViewHeight - playViewHeight - (BOTTOM_TAB_HEIGHT+DEVICE_INDICATOR_HEIGHT)
        let _loopPageView = LoopPageView(frame: CGRect(x: 0, y: channelViewHeight, width: self.frame.width, height: height))
        self.addSubview(_loopPageView)
        let imageWH = (self.frame.width >= height) ? height - loopViewBlank*2 : self.frame.width - loopViewBlank*2
        _loopPageView.setup(imageSize: CGSize(width: imageWH, height: imageWH), cornerRadius: loopViewCornerRadius, imageBackColor:COLOR_ABABAB)
        _loopPageView.showLabel()
        return _loopPageView
    }()
    
    /// 播放控制视图
    lazy var playerView:FMPlayerView = {
        let _playerView = Bundle.main.loadNibNamed("FMPlayerView", owner: nil, options: nil)?[0] as! FMPlayerView
        self.addSubview(_playerView)
        _playerView.snp.makeConstraints { (maker) in
            maker.left.right.width.equalTo(self)
            maker.height.equalTo(playViewHeight)
            maker.bottom.equalTo(self).offset(-(BOTTOM_TAB_HEIGHT+DEVICE_INDICATOR_HEIGHT))
        }
        return _playerView
    }()
    
    /// 当前频道id、当前播放列表、播放索引
    private var channelId = 2048, playlist = [FMSongDataModel](), playIndex:Int = 0
    
    // MARK: - override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerNotification()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unregisterNotification()
    }

    // MARK: - private methods
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForAudioStatusChanged), name: NoticationUpdateForAudioStatusChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForAudioProgressChanged), name: NoticationUpdateForAudioProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForSongChanged), name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForChangePlaylist), name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForPlaylistChanged), name: NoticationUpdateForPlaylistChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioProgressChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForPlaylistChanged, object: nil)
    }
    
    /// 通知相关音频控制更新
    @objc private func notifyUpdateForAudioStatusChanged(_ sender:Notification) {
        if PlayerHelper.shared.isOwner(owner: self) {
            playerView.updateByStatusChanged()
        }
    }
    
    /// 通知进度更新
    @objc private func notifyUpdateForAudioProgressChanged(_ sender:Notification) {
        if PlayerHelper.shared.isOwner(owner: self) {
            playerView.updateByProgressChanged()
            lyricView.scrollByTime(currentTime: PlayerHelper.shared.current)
        }
    }
    
    /// 通知歌曲更新
    @objc private func notifyUpdateForSongChanged(_ sender:Notification) {
        if PlayerHelper.shared.isOwner(owner: self) {
            updateBySongChanged()
        }
        updateLoveButtonStatus()
    }
    
    /// 通知歌单切换
    @objc private func notifyUpdateForChangePlaylist(_ sender:Notification) {
        if !PlayerHelper.shared.isOwner(owner: self) {
            playerView.setupPaused()
        }
    }
    
    /// 歌单发生变化
    @objc private func notifyUpdateForPlaylistChanged(_ sender:Notification) {
        updateLoveButtonStatus()
    }

    /// 初始化/相关模块回调处理
    private func setup() {
        
        /// 模糊图
        addSubview(UIView.blurViewWithRect(self.bounds, style:.dark))
        
        /// 业务模块处理回调 (频道切换/歌曲数据回调)
        viewModelCallback()
        
        /// 歌词点击回调
        lyricViewCallBack()
      
        /// 无限切换视图上一页、下一页切换回调
        loopPageCallBack()
        
        /// 频道切换回调
        channelChangedCallBack()

        /// 播放控制视图回调
        playViewCallBack()
    }
    
    /// 业务模块处理回调 (频道切换/歌曲数据回调)
    private func viewModelCallback() {
        viewModel.setCompletion(onSuccess: { [weak self](result) in
            guard let wself = self else {
                return
            }
            if result.isKind(of: FMChannelListResultModel.self) {
                wself.channelView.channelListDataModel = (result as! FMChannelListResultModel).data
            } else if result.isKind(of: FMSongListResultModel.self) {
                // 歌曲列表
                let playlist = (result as! FMSongListResultModel).data
                if playlist.count == 0 {
                    return
                }
                // 若当前没有歌曲列表，则播放索引初始化0
                if wself.playlist.count == 0 {
                    wself.playIndex = 0
                    wself.playlist.append(contentsOf: playlist)
                } else if wself.playIndex == 0 { // 若有歌曲列表，并且当前索引为0，说明是请求上一首操作，置索引为新歌曲列表尾
                    wself.playIndex = playlist.count - 1
                    wself.playlist.insert(contentsOf: playlist, at: 0)
                } else { // 若有歌曲列表，并且当前索引为末尾，说明是请求下一首操作，置索引为旧歌曲列表尾
                    wself.playIndex = wself.playlist.count
                    wself.playlist.append(contentsOf: playlist)
                }
                PlayerHelper.shared.changePlaylist(playlist: wself.playlist, playIndex: wself.playIndex, owner: wself)
            }
        }) { (error) in
            Log.e("error = \(error)")
        }
    }
    
    /// 歌词点击回调
    private func lyricViewCallBack() {
        lyricView.clickedClosure = { [weak self] in
            self?.loopPageView.isHidden = false
        }
    }
    
    /// 频道切换
    private func channelChangedCallBack() {
        channelView.selectedClosure = { [weak self](channelId:Int) in
            guard let wself = self else {
                return
            }
            wself.viewModel.getSongList(channelId: channelId)
            wself.playlist.removeAll()
        }
    }
    
    /// 无限切换视图上一页、下一页切换、点击事件回调
    private func loopPageCallBack() {
        loopPageView.setup(prev: { [weak self] in
            self?.prevSong()
        }, next: { [weak self] in
            self?.nextSong()
        }) { [weak self] in
            self?.lyricView.isHidden = false
        }
    }
    
    // 播放控制视图回调
    private func playViewCallBack() {
        playerView.setupClosures { [weak self](type) in
            guard let wself = self else {
                return
            }
            switch type {
            case .love: /// 添加到我喜爱的歌单\从我喜爱的歌单里移除
                if wself.playIndex >= 0 && wself.playIndex < wself.playlist.count {
                    PlaylistHelper.addOrRemoveFavorites(songModel: wself.playlist[wself.playIndex])
                }
            case .prev:
                wself.prevSong()
            case .play:
                if PlayerHelper.shared.isOwner(owner: wself) {
                    PlayerHelper.shared.resume()
                } else {
                    PlayerHelper.shared.changePlaylist(playlist: wself.playlist, playIndex: wself.playIndex, owner: wself)
                }
            case .pause:
                PlayerHelper.shared.pause()
            case .next:
                wself.nextSong()
            case .more: /// 点击更多按钮
                ActionSheet.show(items: [LanguageKey.FM_RefreshTracks.value, LanguageKey.MyMusic_AddToPlaylist.value, LanguageKey.Common_Download.value, LanguageKey.Common_Cancel.value], selectedIndex: {[weak self] (index) in
                    guard let wself = self else {
                        return
                    }
                    switch index {
                    case 0: // 换一批歌
                        wself.playIndex = 0
                        wself.playlist.removeAll()
                        wself.viewModel.getSongList(channelId: wself.channelId)
                    case 1: // 添加至歌单
                        if wself.playIndex >= 0 && wself.playIndex < wself.playlist.count {
                            PlaylistSheet.addToPlaylist(mode: SongRealm.getModel(model: wself.playlist[wself.playIndex]))
                        }
                    case 2: // 下载
                        if wself.playIndex >= 0 && wself.playIndex < wself.playlist.count {
                            DownloadTaskHelper.shared.addSongTask(model: SongRealm.getModel(model: wself.playlist[wself.playIndex]))
                        }
                    case 3: // 取消
                        break
                    default:
                        break
                    }
                })
            }
        }
    }
    
    /// 歌曲发生改变，界面更新
    private func updateBySongChanged() {
        let song = PlayerHelper.shared.song
        backImageView.setImage(urlStr: song?.coverURL ?? "", placeholderStr: "", radius: 0)
        loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
        let text = (song != nil) ? ("\(song!.title) / \(song!.artist)") : nil
        loopPageView.showLabel(text: text)
        lyricView.setup(lyricUrl: song?.lyricURL)
    }
    
    /// 更新我喜爱按钮的状态
    private func updateLoveButtonStatus() {
        
        if PlayerHelper.shared.isOwner(owner: self) {
            if PlayerHelper.shared.song != nil {
                playerView.loveButton.isSelected = PlaylistHelper.isMyFavritesSong(songModel: PlayerHelper.shared.song!)
            }
            return
        }
        
        if playIndex >= 0 && playIndex < playlist.count - 1 {
            playerView.loveButton.isSelected = PlaylistHelper.isMyFavritesSong(songModel: playlist[playIndex])
        }
    }
    
    // MAKR: - public methods
    /// 上一首
    func prevSong() {
        /// 如当前播放列表不是改界面拥有者，则需要切换列表
        if !PlayerHelper.shared.isOwner(owner: self) {
            if playIndex > 0 && playIndex < playlist.count {
                playIndex -= 1
                PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: playIndex, owner: self)
            } else {
                viewModel.getSongList(channelId: channelId)
            }
            return
        }
        
        /// 如果存在上一首，播放并使索引-1， 否则请求歌曲列表
        if PlayerHelper.shared.prev() {
            playIndex -= 1
        } else {
            viewModel.getSongList(channelId: channelId)
        }
    }
    
    /// 下一首
    func nextSong() {
        
        /// 如当前播放列表不是改界面拥有者，则需要切换列表
        if !PlayerHelper.shared.isOwner(owner: self) {
            if playIndex >= 0 && playIndex < playlist.count - 1 {
                playIndex += 1
                PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: playIndex, owner: self)
            } else {
                viewModel.getSongList(channelId: channelId)
            }
            return
        }
        
        /// 如果存在下一首，播放并使索引+1， 否则请求歌曲列表
        if PlayerHelper.shared.next() {
            playIndex += 1
        } else {
            viewModel.getSongList(channelId: channelId)
        }
    }
}
