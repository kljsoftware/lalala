//
//  FMPlayerView.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class FMPlayerView: UIView {

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
    
    /// 缓冲进度条
    @IBOutlet weak var cacheProgressView: UIProgressView!
   
    /// 播放进度条
    @IBOutlet weak var progressSlider: UISlider!
    
    
}
