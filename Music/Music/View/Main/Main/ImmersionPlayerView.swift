//
//  ImmersionPlayerView.swift
//  Music
//
//  Created by hzg on 2017/12/2.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 界面相关常量
private let titleViewHeight:CGFloat = 44
private let bottomViewHeight:CGFloat = 160
private let loopPageViewTopMagin:CGFloat = TOP_AD_HEIGHT + DEVICE_STATUS_BAR_HEIGHT + titleViewHeight
private let loopPageViewHeight:CGFloat = DEVICE_SCREEN_HEIGHT - loopPageViewTopMagin - bottomViewHeight
private let cdBackWH:CGFloat = 1080, cdWH:CGFloat = 702 // 光碟背景和光碟的原始宽高尺寸
private let loopPageImageBlank:CGFloat = 120 // 光碟与背景光圈的距离，这个需要根据比例变化

/// 播放器界面
class ImmersionPlayerView: UIView {
    
    /// 播放暂停按钮图片资源
    private let playImages = [UIImage(named:"immersion_player_btn_play_normal")!, UIImage(named:"immersion_player_btn_play_pressed")!], pauseImages = [UIImage(named:"immersion_player_btn_stop_normal")!, UIImage(named:"immersion_player_btn_stop_pressed")!]

    /// 距底约束
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    /// 喜欢按钮
    @IBOutlet weak var loveButton: UIButton!
    
    /// 上一首
    @IBOutlet weak var prevButton: UIButton!
    
    /// 音乐播放/暂停控制按钮
    @IBOutlet weak var controlButton: UIButton!
    
    /// 下一首
    @IBOutlet weak var nextButton: UIButton!
    
    /// 更多
    @IBOutlet weak var moreButton: UIButton!
    
    /// 当前播放时长
    @IBOutlet weak var currentLabel: UILabel!
    
    /// 总时长
    @IBOutlet weak var durationLabel: UILabel!
    
    /// 播放进度条
    @IBOutlet weak var slider: SliderView!
    
    /// 背景视图
    @IBOutlet weak var backImageView: UIImageView!
    
    /// 歌名
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 艺人名
    @IBOutlet weak var artistLabel: UILabel!
    
    /// 无限切换视图
    lazy var loopPageView:LoopPageView = {
        let _loopPageView = LoopPageView(frame: CGRect(x: 0, y: titleViewHeight, width: DEVICE_SCREEN_WIDTH, height: loopPageViewHeight))
        self.addSubview(_loopPageView)
        let backImage = UIImage(named:"immersion_bg_cover")!
        let backWH = (DEVICE_SCREEN_WIDTH >= loopPageViewHeight) ? loopPageViewHeight : DEVICE_SCREEN_WIDTH
        let scale:CGFloat = backWH/cdBackWH
        let imageWH = (cdWH+loopPageImageBlank)*scale
        _loopPageView.setup(imageSize: CGSize(width: imageWH, height: imageWH), cornerRadius: imageWH/2, imageBackColor:COLOR_ABABAB)
        _loopPageView.showBack(image: backImage, size: CGSize(width: backWH, height: backWH))
        return _loopPageView
    }()
    
    /// 歌词视图
    lazy var lyricView:LyricView = {
        let height = loopPageViewHeight
        let _lyricView = LyricView(frame: CGRect(x: 0, y: titleViewHeight, width: DEVICE_SCREEN_WIDTH, height: height))
        _lyricView.isHidden = true
        _lyricView.backgroundColor = UIColor.clear
        self.addSubview(_lyricView)
        return _lyricView
    }()
    
    /// 动画
    @IBOutlet weak var animImageView: UIImageView!
    var animation:RotateAnimation?
    
    /// 默认是暂停状态
    private var isPaused:Bool = true
    
    // MARK: - init/override methods
    override func awakeFromNib() {
        registerNotification()
        setup()
    }
    
    deinit {
        unregisterNotification()
        Log.e("deinit#")
    }

    // MARK: - private methods
    /// 初始化
    private func setup() {
        
        /// 距底约束，适配iphoneX
        bottomLayoutConstraint.constant = DEVICE_INDICATOR_HEIGHT
        animation = RotateAnimation(animationView: animImageView)
        animation?.setup(isScaled: true, step: 10, scaleValue: 0.1)
       
        /// 更新歌曲信息、按钮状态与进度
        updateBySongChanged()
        updateByStatusChanged()
        updateByProgressChanged()
        setupProgressView()
        
        /// 歌词
        lyricView.clickedClosure = { [weak self] in
            self?.loopPageView.isHidden = false
        }
        
        /// 无限切换视图
        loopPageView.setup(prev: { [weak self] in
            self?.prevSong()
        }, next: { [weak self] in
            self?.nextSong()
        }) { [weak self] in
            self?.lyricView.isHidden = false
        }
    }
    
    /// 进度初始化设置
    private func setupProgressView() {
        slider.setThumbImage("common_seek_img_thumb")
        slider.touchBeganClousre = { [weak self] in
            self?.sliderTouchBegin()
        }
        slider.touchEndClousre = { [weak self] in
            self?.sliderTouchEnd()
        }
    }
    
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
        updateByStatusChanged()
        updateAnimationStatus()
    }
    
    /// 通知进度更新
    @objc private func notifyUpdateForAudioProgressChanged(_ sender:Notification) {
        updateByProgressChanged()
        updateAnimationStatus()
    }
    
    /// 通知歌曲更新
    @objc private func notifyUpdateForSongChanged(_ sender:Notification) {
        updateBySongChanged()
        updateAnimationStatus()
    }
    
    /// 按钮初始化设置
    private func setupButtons() {
        loveButton.isExclusiveTouch = true
        prevButton.isExclusiveTouch = true
        controlButton.isExclusiveTouch = true
        nextButton.isExclusiveTouch = true
        moreButton.isExclusiveTouch = true
    }
    
    /// 按下
    private func sliderTouchBegin() {
        animImageView.isHidden = false
        controlButton.isHidden = true
        let current = TimeInterval(slider.value) * PlayerHelper.shared.duration
        PlayerHelper.shared.seekTo(time: current)
        currentLabel.text = current.transferFormat()
    }
    
    /// 抬起
    private func sliderTouchEnd() {
        
    }
    
    /// 更新动画状态
    private func updateAnimationStatus() {
        var isStopped = false
        if PlayerHelper.shared.state == .stop || PlayerHelper.shared.state == .pause || PlayerHelper.shared.buffer*PlayerHelper.shared.duration >= PlayerHelper.shared.current {
            isStopped = true
        }
        controlButton.isHidden = !isStopped
        animImageView.isHidden = isStopped
        isStopped ? animation?.stop() : animation?.start()
    }
    
    /// 更新歌曲相关信息
    private func updateBySongChanged() {
        let song = PlayerHelper.shared.song
        backImageView.setImage(urlStr: song?.coverURL ?? "", placeholderStr: "", radius: 0)
        loopPageView.setup(urls: PlayerHelper.shared.getCoverList())
        titleLabel.text = song?.title
        artistLabel.text = song?.artist
        lyricView.setup(lyricUrl: song?.lyricURL)
    }
    
    /// 更新按钮状态
    private func updateByStatusChanged() {
        if PlayerHelper.shared.state == .play {
            controlButton.setImage(nor: pauseImages[0], dwn: pauseImages[1])
        } else {
            controlButton.setImage(nor: playImages[0], dwn: playImages[1])
        }
        durationLabel.text = PlayerHelper.shared.duration.transferFormat()
    }
    
    /// 更新进度
    private func updateByProgressChanged() {
        
        /// 进度
        let value = PlayerHelper.shared.duration != 0 ? PlayerHelper.shared.current/PlayerHelper.shared.duration : 0
        slider.setValue(Float(value), animated: false)
        
        /// 时间
        let current = PlayerHelper.shared.current
        currentLabel.text = current.transferFormat()
        
        // 歌词
        lyricView.scrollByTime(currentTime: current)
    }
    
    /// 上一首 注：FM模块要特殊处理，是无限循环
    private func prevSong() {
        guard let owner = PlayerHelper.shared.owner else {
            Log.e("owner = nil")
            return
        }
        if owner.isKind(of: FMView.self) {
            (owner as! FMView).prevSong()
        } else {
            _ = PlayerHelper.shared.prev()
        }
    }
    
    /// 下一首 注：FM模块要特殊处理，是无限循环
    private func nextSong() {
        guard let owner = PlayerHelper.shared.owner else {
            Log.e("owner = nil")
            return
        }
        if owner.isKind(of: FMView.self) {
            (owner as! FMView).nextSong()
        } else {
            _ = PlayerHelper.shared.next()
        }
    }
    
    // MARK: - IBAction methods
    @IBAction func onLoveButtonClicked(_ sender: UIButton) {
        if PlayerHelper.shared.song != nil {
            sender.isSelected = !sender.isSelected
            PlaylistHelper.addOrRemoveFavorites(songModel: PlayerHelper.shared.song!)
        }
    }
    
    @IBAction func onPrevButtonClicked(_ sender: UIButton) {
        prevSong()
    }
    
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        if PlayerHelper.shared.state == .play {
            sender.setImage(nor: pauseImages[0], dwn: pauseImages[1])
            PlayerHelper.shared.pause()
        } else {
            sender.setImage(nor: playImages[0], dwn: playImages[1])
            PlayerHelper.shared.resume()
        }
        updateAnimationStatus()
    }
    
    @IBAction func onNextButtonClicked(_ sender: UIButton) {
        nextSong()
    }
    
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 进度条发生变化
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let current = TimeInterval(slider.value) * PlayerHelper.shared.duration
        PlayerHelper.shared.seekTo(time: current)
        currentLabel.text = current.transferFormat()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}
