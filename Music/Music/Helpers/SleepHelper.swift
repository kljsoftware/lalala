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
    
    /// 定时提醒
    func start(fireDate:Date) {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.body = "test"
            let interval = fireDate.timeIntervalSinceNow
            Log.e(interval)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: "RequestIdentifier", content: content, trigger: trigger), withCompletionHandler: { (error) in
                if nil != error {
                    Log.e(error!.localizedDescription)
                }
            })
        } else {
            let notification = UILocalNotification()
            notification.fireDate = fireDate
            notification.timeZone = TimeZone.current
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }

    /// 停止提醒
    func stop() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            UIApplication.shared.cancelAllLocalNotifications()
        }
    }
}
