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
    
    /// 每次旋转幅度
    private let step:CGFloat = 2
    
    /// 动画视图
    private var animationView:UIView?
    
    /// 计时器
    private var timer:Timer?
    
    // 角度
    fileprivate var angle: CGFloat = 0
    
    /// 构造
    init(animationView:UIView) {
        self.animationView = animationView
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
        animationView?.transform = CGAffineTransform(rotationAngle: angle*CGFloat(Double.pi/180.0))
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
            animationView?.transform = CGAffineTransform.identity
        }
    }
}
