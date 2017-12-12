//
//  SleepHelper.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 休眠管理助手
class SleepHelper {
    
    /// 实例对象
    static let shared = SleepHelper()
    private init() {}
    
    /// 定时提醒日期
    var fireDate:Date?
    
    /// 定时器
    private var timer:Timer?
    
    /// 提示信息
    private var message = ""
    
    /// 定时提醒
    func start(fireDate:Date, message:String) {
        stop()
        self.message = message
        self.fireDate = fireDate
        let interval = fireDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(fire), userInfo: nil, repeats: false)
    }
    
    @objc private func fire() {
        AppUI.tip(message)
    }
    
    /// 停止提醒
    func stop() {
        if nil != timer {
            timer?.invalidate()
            timer = nil
        }
    }
}
