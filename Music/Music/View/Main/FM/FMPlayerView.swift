//
//  FMPlayerView.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class FMPlayerView: UIView {
    
    /// 按钮回调
    private var moreButtonClosure:(() -> Void)?
    
    /// 播放暂停按钮图片资源
    private let playImages = [UIImage(named:"fm_player_btn_play_normal")!, UIImage(named:"fm_player_btn_play_pressed")!], pauseImages = [UIImage(named:"fm_player_btn_stop_normal")!, UIImage(named:"fm_player_btn_stop_pressed")!]

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
    
    // MARK: - override methods
    override func awakeFromNib() {
        setup()
    }
    
    // MARK: - private methods
    /// 初始化
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

    // MARK: - IBAction methods
    @IBAction func onLoveButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func onPrevButtonClicked(_ sender: UIButton) {
        PlayerHelper.shared.prev()
    }
    
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        if PlayerHelper.shared.state == .play {
            sender.setImage(nor: pauseImages[0], dwn: pauseImages[1])
            PlayerHelper.shared.pause()
        } else {
            sender.setImage(nor: playImages[0], dwn: playImages[1])
            PlayerHelper.shared.resume()
        }
    }
    
    @IBAction func onNextButtonClicked(_ sender: UIButton) {
        PlayerHelper.shared.next()
    }
    
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
       // moreButtonClosure?()
        ActionSheet.show(items: ["换一批歌曲", "添加到歌单", "下载", "取消"], selectedIndex: { (index) in
            
        })
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
    func setupClosures(moreButtonClosure:(() -> Void)?) {
        self.moreButtonClosure = moreButtonClosure
    }
    
    /// 更新按钮状态
    func updateByStatusChanged() {
        
        /// 按钮状态
        if PlayerHelper.shared.state == .play {
            controlButton.setImage(nor: pauseImages[0], dwn: pauseImages[1])
        } else {
            controlButton.setImage(nor: playImages[0], dwn: playImages[1])
        }
        
        durationLabel.text = PlayerHelper.shared.duration.transferFormat()
    }
    
    /// 更新进度
    func updateByProgressChanged() {
        
        /// 进度
        let value = PlayerHelper.shared.duration != 0 ? PlayerHelper.shared.current/PlayerHelper.shared.duration : 0
        slider.setValue(Float(value), animated: false)
        
        /// 时间
        let current = PlayerHelper.shared.current
        currentLabel.text = current.transferFormat()
    }
}
