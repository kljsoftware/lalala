//
//  SplashView.swift
//  Music
//
//  Created by hzg on 2017/12/19.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 启动页面
class SplashView: UIView {
    
    // 启动页模型文件
    var model:AdvertModel? {
        didSet {
            if nil != model {
                setup()
            }
        }
    }
    
    /// 启动页启动结束
    var finishedClosure:(()->Void)?
    
    /// 广告视图
    @IBOutlet weak var advertView: UIView!
    @IBOutlet weak var advertIamgeView: UIImageView!
    
    /// 跳过广告按钮
    @IBOutlet weak var skipButton: UIButton!
    
    /// 广告展示倒计时
    @IBOutlet weak var countDownTimeLabel: UILabel!
    
    /// 计时器
    private var timer:Timer? = nil
    private var duration = 0, current = 0 /// 倒计时总时间, 当前倒计时时间

    /// 初始化
    override func awakeFromNib() {
        skipButton.setTitle(LanguageKey.Guide_skip.value, for: .normal)
    }
    
    deinit {
        Log.e("deinit")
    }
    
    /// 点击跳过按钮
    @IBAction func onSkipButtonClicked(_ sender: UIButton) {
        stopTimer()
        finished()
    }
    
    /// 跳转至广告页
    @IBAction func onPushAdButtonClicked(_ sender: UIButton) {
        RKBISDKHelper.shared.rkTrackEvent(eventType: .ad)
        AppUI.pushToAdView(model: model!)
    }
    
    // MARK: - private methods
    /// 初始化启动界面
    private func setup() {
        advertView.isHidden = false
        advertIamgeView.setImage(urlStr: model!.img, placeholderStr: "launch", radius: 0)
        duration = Int(model!.time) ?? 0
        current = duration
        showTime()
        startTimer()
    }
    
    /// 显示时间
    private func showTime() {
        if current >= 1 {
            countDownTimeLabel.text = "\(current)"
        }
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
    
    /// 计时
    @objc private func fire() {
        if current <= 1 {
            stopTimer()
            finished()
            return
        }
        current -= 1
        showTime()
    }
    
    /// 启动完成
    private func finished() {
        finishedClosure?()
        removeFromSuperview()
    }
}
