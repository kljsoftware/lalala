//
//  FMPlayerView.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 按钮类型
enum FMPlayerViewButtonType {
    case love, prev, play, pause, next, more
}


class FMPlayerView: UIView {
    
    /// 按钮回调
    var selectButtonClosure:((FMPlayerViewButtonType) -> Void)?

    
    /// 播放暂停按钮图片资源
    private let playImages = [UIImage(named:"fm_player_btn_play_normal")!, UIImage(named:"fm_player_btn_play_pressed")!], pauseImages = [UIImage(named:"fm_player_btn_stop_normal")!, UIImage(named:"fm_player_btn_stop_pressed")!]
    
    /// 默认是暂停状态
    private var isPaused:Bool = true

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
    
    /// 动画
    @IBOutlet weak var animImageView: UIImageView!
    var animation:RotateAnimation?
    
    // MARK: - override methods
    override func awakeFromNib() {
        setup()
    }
    
    // MARK: - private methods
    /// 初始化
    private func setup() {
        
        // 动画设置
        animation = RotateAnimation(animationView: animImageView)
        animation?.setup(isScaled: true, step: 10, scaleValue: 0.1)
        
        // 进度初始化设置
        slider.setThumbImage("common_seek_img_thumb")
        slider.touchBeganClousre = { [weak self] in
            self?.sliderTouchBegin()
        }
        slider.touchEndClousre = { [weak self] in
            self?.sliderTouchEnd()
        }
        
        // 按钮初始化设置
        loveButton.isExclusiveTouch = true
        prevButton.isExclusiveTouch = true
        controlButton.isExclusiveTouch = true
        nextButton.isExclusiveTouch = true
        moreButton.isExclusiveTouch = true
    }
    
    /// 更新动画状态
    private func updateAnimationStatus(_ isForceStopped:Bool = false) {
        var isStopped = false
        if isForceStopped || PlayerHelper.shared.state == .stop || PlayerHelper.shared.state == .pause || PlayerHelper.shared.buffer*PlayerHelper.shared.duration >= PlayerHelper.shared.current {
            isStopped = true
        }
        controlButton.isHidden = !isStopped
        animImageView.isHidden = isStopped
        isStopped ? animation?.stop() : animation?.start()
    }

    // MARK: - IBAction methods
    @IBAction func onLoveButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        selectButtonClosure?(.love)
    }
    
    @IBAction func onPrevButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.prev)
    }
    
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        if isPaused {
            selectButtonClosure?(.play)
            controlButton.setImage(nor: pauseImages[0], dwn: pauseImages[1])
        } else {
            selectButtonClosure?(.pause)
            controlButton.setImage(nor: playImages[0], dwn: playImages[1])
        }
        isPaused = !isPaused
        updateAnimationStatus()
    }
    
    @IBAction func onNextButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.next)
    }
    
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.more)
    }
    
    /// 进度条发生变化
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        let current = TimeInterval(slider.value) * PlayerHelper.shared.duration
        PlayerHelper.shared.seekTo(time: current)
        currentLabel.text = current.transferFormat()
    }
    
    /// 按下
    func sliderTouchBegin() {
        let current = TimeInterval(slider.value) * PlayerHelper.shared.duration
        PlayerHelper.shared.seekTo(time: current)
        currentLabel.text = current.transferFormat()
    }
    
    /// 抬起
    func sliderTouchEnd() {
        
    }
    
    // MARK: - public methods
    func setupClosures(selectButtonClosure:((FMPlayerViewButtonType) -> Void)?) {
        self.selectButtonClosure = selectButtonClosure
    }
    
    /// 其他歌单处于播放状态
    func setupPaused() {
        isPaused = true
        controlButton.setImage(nor: playImages[0], dwn: playImages[1])
        updateAnimationStatus(true)
    }
    
    /// 更新按钮状态
    func updateByStatusChanged() {
        if PlayerHelper.shared.state == .pause || PlayerHelper.shared.state == .stop {
            controlButton.setImage(nor: playImages[0], dwn: playImages[1])
            isPaused = true
        } else {
            controlButton.setImage(nor: pauseImages[0], dwn: pauseImages[1])
            isPaused = false
        }
        durationLabel.text = PlayerHelper.shared.duration.transferFormat()
        updateAnimationStatus()
    }
    
    /// 更新进度
    func updateByProgressChanged() {
        
        /// 进度
        let value = PlayerHelper.shared.duration != 0 ? PlayerHelper.shared.current/PlayerHelper.shared.duration : 0
        slider.setValue(Float(value), animated: false)
        
        /// 时间
        let current = PlayerHelper.shared.current
        currentLabel.text = current.transferFormat()
        updateAnimationStatus()
    }
}
