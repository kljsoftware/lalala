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
    case love, prev, control, next, more
}

class FMPlayerView: UIView {
    
    /// 按钮回调
    var selectButtonClosure:((FMPlayerViewButtonType) -> Void)?
    
    /// 进度条发生变化
    var sliderValueChangedClosure:((Float)->Void)?

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
        selectButtonClosure?(.love)
    }
    
    @IBAction func onPrevButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.prev)
    }
    
    @IBAction func onControlButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.control)
    }
    
    @IBAction func onNextButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.next)
    }
    
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        selectButtonClosure?(.more)
    }
    
    /// 进度条发生变化
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        sliderValueChangedClosure?(sender.value)
    }
    
    /// 按下
    func sliderTouchBegin() {
        
    }
    
    /// 抬起
    func sliderTouchEnd() {
        
    }
}
