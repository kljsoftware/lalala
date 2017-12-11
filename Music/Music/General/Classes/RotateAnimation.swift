//
//  RotateAnimation.swift
//  Music
//
//  Created by hzg on 2017/12/2.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 动画封装
class RotateAnimation {
    
    /// 动画间隔时间
    private let timeInterval:TimeInterval = 0.1
    
    /// 每次旋转幅度 来回缩放范围：【0.66， 1】
    private var step:CGFloat = 2, scaleValue:CGFloat = 0.01
    
    /// 动画视图
    private var animationView:UIView?
    
    /// 计时器
    private var timer:Timer?
    
    // 角度、缩放值、缩放方向
    fileprivate var angle: CGFloat = 0, scale:CGFloat = 1.0, directionValue:CGFloat = 1
    
    // 是否缩放
    fileprivate var isScaled = false
    
    /// 构造
    init(animationView:UIView) {
        self.animationView = animationView
    }
    
    /// 设置动画参数
    func setup(isScaled:Bool = false, step:CGFloat = 2, scaleValue:CGFloat = 0.01) {
        self.isScaled = isScaled
        self.step = step
        self.scaleValue = scaleValue
    }
    
    // MARK: - private methods
    /// 开始计时
    private func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    /// 计时
    @objc private func fire() {
        angle += step
        var transform = CGAffineTransform(rotationAngle: angle*CGFloat(Double.pi/180.0))
        if isScaled {
            var scale = self.scale + (directionValue*scaleValue)
            if directionValue > 0 && scale >= 1.0 {
                directionValue = -1
                scale = 1.0
            }
            if directionValue < 0 && scale <= 0.66 {
                directionValue = 1
                scale = 0.66
            }
            self.scale = scale
            transform = transform.scaledBy(x: scale, y: scale)
        }
        animationView?.transform = transform
    }
    
    /// 停止计时
    private func stopTimer() {
        if nil != timer {
            timer?.invalidate()
            timer = nil
        }
    }
    
    /// 计时是否已停止，停止说明动画已停止
    private func isFire() -> Bool {
        return nil != timer
    }
    
    // MARK: - public methods
    /// 开始动画
    func start() {
        if !isFire() {
            startTimer()
        }
    }
    
    /// 停止动画
    func stop() {
        if isFire() {
            stopTimer()
            angle = 0
            scale = 1.0
            directionValue = 1
            animationView?.transform = CGAffineTransform.identity
        }
    }
}
