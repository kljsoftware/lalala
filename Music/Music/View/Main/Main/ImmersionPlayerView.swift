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
    
    /// 计时器
    private var timer:Timer? = nil
    
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
    
    // MARK: - init/override methods
    override func awakeFromNib() {
        registerNotification()
        setup()
        Log.e(frame)
    }
    
    deinit {
        unregisterNotification()
        Log.e("deinit#")
    }
    
    // MARK: - private methods
    /// 初始化
    private func setup() {
        bottomLayoutConstraint.constant = DEVICE_INDICATOR_HEIGHT
        loopPageView.setup(prev: {
            
        }, next: {
            
        }) {
            
        }
        update()
        updateProgress()
    }
    
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForAudioStatusChanged), name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 通知相关音频控制更新
    @objc private func notifyUpdateForAudioStatusChanged(_ sender:Notification) {
        update()
    }
    
    /// 按钮初始化设置
    private func setupButtons() {
        loveButton.isExclusiveTouch = true
        prevButton.isExclusiveTouch = true
        controlButton.isExclusiveTouch = true
        nextButton.isExclusiveTouch = true
        moreButton.isExclusiveTouch = true
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
    
    /// 是否正在记时
    private func isFire() -> Bool {
        return nil != timer
    }
    
    /// 计时
    @objc private func fire() {
        updateProgress()
    }
    
    /// 按下
    private func sliderTouchBegin() {
        let current = TimeInterval(slider.value) * PlayerHelper.shared.duration
        PlayerHelper.shared.seekTo(time: current)
        currentLabel.text = current.transferFormat()
    }
    
    /// 抬起
    private func sliderTouchEnd() {
        
    }
    
    /// 更新按钮状态
    private func update() {
        
        /// 按钮状态
        if PlayerHelper.shared.state == .play {
            controlButton.setImage(nor: pauseImages[0], dwn: pauseImages[1])
            if !isFire() {
                startTimer()
            }
        } else {
            stopTimer()
            controlButton.setImage(nor: playImages[0], dwn: playImages[1])
        }
        
        durationLabel.text = PlayerHelper.shared.duration.transferFormat()
    }
    
    /// 更新进度
    private func updateProgress() {
        
        /// 进度
        let value = PlayerHelper.shared.duration != 0 ? PlayerHelper.shared.current/PlayerHelper.shared.duration : 0
        slider.setValue(Float(value), animated: false)
        
        /// 时间
        currentLabel.text = PlayerHelper.shared.current.transferFormat()
    }
    
    // MARK: - IBAction methods
    @IBAction func onLoveButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func onPrevButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        if PlayerHelper.shared.state == .play {
            sender.setImage(nor: pauseImages[0], dwn: pauseImages[1])
            PlayerHelper.shared.pause()
            stopTimer()
        } else {
            sender.setImage(nor: playImages[0], dwn: playImages[1])
            PlayerHelper.shared.resume()
            startTimer()
        }
    }
    
    @IBAction func onNextButtonClicked(_ sender: UIButton) {
        
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
        stopTimer()
        pop()
    }
    
    
}
