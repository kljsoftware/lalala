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
        let backLoopView = UIView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: height))
        let imageWH = (self.frame.width >= height) ? height - loopViewBlank*2 : self.frame.width - loopViewBlank*2
        _loopPageView.setup(backView: backLoopView, imageSize: CGSize(width: imageWH, height: imageWH), cornerRadius: loopViewCornerRadius, imageBackColor:COLOR_ABABAB)
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
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    /// 初始化/相关模块回调处理
    private func setup() {
        
        /// 模糊图
        addSubview(UIView.blurViewWithRect(bounds))
        
        /// 业务模块处理回调 (频道切换/歌曲数据回调)
        viewModelCallback()
        
        /// 频道切换回调
        channelChangedCallBack()
      
        /// 无限切换视图上一页、下一页切换回调
        loopPageCallBack()

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
                case .waitingNext:
                    PlayerHelper.shared.addSongList(songList: songList)
                    PlayerHelper.shared.start()
                    PlayerHelper.shared.state = .play
                case .waitingPrev:
                    PlayerHelper.shared.addSongList(songList: songList, isPreInsert: true)
                    PlayerHelper.shared.start()
                    PlayerHelper.shared.state = .play
                default:
                    break
                }
                self?.loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
                self?.setBackImageView()
            }
        }) { (error) in
            Log.e("error = \(error)")
        }
    }
    
    /// 设置背景
    private func setBackImageView() {
        backImageView.setImage(urlStr: PlayerHelper.shared.song?.coverURL ?? "", placeholderStr: "", radius: 0)
    }
    
    /// 频道切换
    private func channelChangedCallBack() {
        channelView.selectedClosure = { [weak self](channelId:Int) in
            self?.viewModel.getSongList(channelId: channelId)
            PlayerHelper.shared.state = .channelChanged
        }
    }
    
    /// 无限切换视图上一页、下一页切换回调
    private func loopPageCallBack() {
        loopPageView.setup(prev: { [weak self] in
            if !PlayerHelper.shared.prev() {
                PlayerHelper.shared.state = .waitingPrev
                self?.viewModel.getSongList(channelId: DataHelper.shared.channelId)
            } else {
                self?.loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
                self?.setBackImageView()
            }
        }) { [weak self] in
            if !PlayerHelper.shared.next() {
                PlayerHelper.shared.state = .waitingNext
                self?.viewModel.getSongList(channelId: DataHelper.shared.channelId)
            } else {
                self?.loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
                self?.setBackImageView()
            }
        }
    }
    
    // 播放控制视图回调
    private func playViewCallBack() {
        /// 按钮点击事件
        playerView.selectButtonClosure = { [weak self] (type:FMPlayerViewButtonType) in
            switch type {
            case .love:
                break
            case .prev:
                if !PlayerHelper.shared.prev() {
                    PlayerHelper.shared.state = .waitingPrev
                    self?.viewModel.getSongList(channelId: DataHelper.shared.channelId)
                } else {
                    self?.loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
                    self?.setBackImageView()
                }
            case .control:
                break
            case .next:
                if !PlayerHelper.shared.next() {
                    PlayerHelper.shared.state = .waitingNext
                    self?.viewModel.getSongList(channelId: DataHelper.shared.channelId)
                } else {
                    self?.loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
                    self?.setBackImageView()
                }
            case .more:
                break
                
            }
        }
        
        /// 拖动进度条
        playerView.sliderValueChangedClosure = { [weak self] (value:Float) in
            PlayerHelper.shared.seekTo(value: value)
        }
    }
}
