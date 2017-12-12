//
//  DataHelper.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

import AVFoundation
import MediaPlayer

/// 单例,数据管理助手
class DataHelper {
    
    static let shared = DataHelper()
    private init() {}
    
    /// 当前电台频道id
    var channelId:Int?
    
    /// 定时提醒日期
    var fireDate:Date?
    
    /// 同步本地化数据
    func setup() {
        
        /// 轻量数据存储同步
        let standard = UserDefaults.standard
        channelId = standard.value(forKey: UserDefaultChannelId) as? Int
    }

    /// 设置当前频道
    func setupChannel(channelId:Int) {
        self.channelId = channelId
        UserDefaults.standard.set(channelId, forKey: UserDefaultChannelId)
    }
    
    /// 设置并激活音频会话类别
    func setAudioSessionActive(_ category:String, isActive:Bool = true) {
        try? AVAudioSession.sharedInstance().setCategory(category)
        try? AVAudioSession.sharedInstance().setActive(isActive)
    }
    
    /// 设置后台播放需要显示的信息
    func setPlayingInfo() {
        let artwork = MPMediaItemArtwork(image: UIImage(named: "test.png")!)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle:"歌名", MPMediaItemPropertyArtist:"歌手名", MPMediaItemPropertyArtwork:artwork]
    }
    
    /// 休眠提醒
    func sleepAlert(fireDate:Date, alertMessage:String) {
        let notification = UILocalNotification()
        notification.fireDate = fireDate
        notification.alertBody = alertMessage
        notification.timeZone = TimeZone.current
        UIApplication.shared.scheduleLocalNotification(notification)
    }
}
