//
//  FMPlayerView.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 按钮类型
enum FMPlayerViewButtonType {
    case love, prev, play, pause, next, more
}

class FMPlayerView: UIView {
    
    /// 按钮回调
    var selectButtonClosure:((FMPlayerViewButtonType) -> Void)?
    
    /// 播放暂停按钮图片资源
    let playImages = [UIImage(named:"fm_player_btn_play_normal")!, UIImage(named:"fm_player_btn_play_pressed")!], pauseImages = [UIImage(named:"fm_player_btn_stop_normal")!, UIImage(named:"fm_player_btn_stop_pressed")!]

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
    
    // MARK: - override methods
    override func awakeFromNib() {
        setup()
    }
    
    // MARK: - private methods
    private func setup() {
        setupProgressView()
        setupButtons()
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
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)//Timer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
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

    // MARK: - IBAction methods
    @IBAction func onLoveButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.love)
    }
    
    @IBAction func onPrevButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.prev)
    }
    
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        if PlayerHelper.shared.state == .play {
            sender.setImage(nor: pauseImages[0], dwn: pauseImages[1])
            PlayerHelper.shared.pause()
            startTimer()
        } else {
            sender.setImage(nor: playImages[0], dwn: playImages[1])
            PlayerHelper.shared.resume()
            stopTimer()
        }
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
    /// 更新状态
    func update() {
        
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
    func updateProgress() {
        
        /// 进度
        let value = PlayerHelper.shared.duration != 0 ? PlayerHelper.shared.current/PlayerHelper.shared.duration : 0
        Log.e(value)
        slider.setValue(Float(value), animated: false)
        
        /// 时间
        currentLabel.text = PlayerHelper.shared.current.transferFormat()
    }
}
