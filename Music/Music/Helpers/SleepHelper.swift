//
//  SleepHelper.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

import UserNotifications

/// 休眠管理助手
class SleepHelper {
    
    /// 实例对象
    static let shared = SleepHelper()
    private init() {}
    
    /// 定时提醒日期
    var fireDate:Date?
    
    private var workItem:DispatchWorkItem?
    
    /// 定时提醒
    func start(fireDate:Date) {
        stop()
        let interval = fireDate.timeIntervalSinceNow
        if interval > 0 {
            workItem = DispatchWorkItem(block: {
                SleepHelper.shared.fireDate = nil
                PlayerHelper.shared.pause()
                AppUI.tip(LanguageKey.Tip_TimeOffMusicStop.value)
                NotificationCenter.default.post(name: NoticationUpdateForTimesup, object: nil)
            })
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + interval, execute: workItem!)
        }
    }

    /// 停止提醒
    func stop() {
        if nil != workItem && !workItem!.isCancelled {
            workItem?.cancel()
        }
        workItem = nil
    }
}
