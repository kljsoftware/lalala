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
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioProgressChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForSongChanged, object: nil)
    }
    
    /// 通知相关音频控制更新
    @objc private func notifyUpdateForAudioStatusChanged(_ sender:Notification) {
        playerView.updateByStatusChanged()
    }
    
    /// 通知进度更新
    @objc private func notifyUpdateForAudioProgressChanged(_ sender:Notification) {
        
        // 进度
        playerView.updateByProgressChanged()
      
        // 歌词
        lyricView.scrollByTime(currentTime: PlayerHelper.shared.current)
    }
    
    /// 通知歌曲更新
    @objc private func notifyUpdateForSongChanged(_ sender:Notification) {
        updateBySongChanged()
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
            if result.isKind(of: FMChannelListResultModel.self) {
                self?.channelView.channelListDataModel = (result as! FMChannelListResultModel).data
            } else if result.isKind(of: FMSongListResultModel.self) {
                let songList = (result as! FMSongListResultModel).data
                switch PlayerHelper.shared.state {
                case .channelChanged:
                    fallthrough
                case .waitingNext:
                    PlayerHelper.shared.addSongList(songList: songList)
                    PlayerHelper.shared.start()
                    PlayerHelper.shared.state = .play
                case .waitingPrev:
                    PlayerHelper.shared.addSongList(songList: songList, isPreInsert: true)
                    PlayerHelper.shared.start()
                    PlayerHelper.shared.state = .play
                default:
                    PlayerHelper.shared.addSongList(songList: songList)
                    break
                }
                
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
            self?.viewModel.getSongList(channelId: channelId)
            PlayerHelper.shared.state = .channelChanged
        }
    }
    
    /// 无限切换视图上一页、下一页切换、点击事件回调
    private func loopPageCallBack() {
        loopPageView.setup(prev: {
            PlayerHelper.shared.prev()
        }, next: {
            PlayerHelper.shared.next()
        }) { [weak self] in
            self?.lyricView.isHidden = false
        }
    }
    
    // 播放控制视图回调
    private func playViewCallBack() {
        /// 按钮点击事件
        playerView.selectButtonClosure = { (type:FMPlayerViewButtonType) in
            switch type {
            case .love:
                break
            case .more:
                break
            default:
                break
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
}
