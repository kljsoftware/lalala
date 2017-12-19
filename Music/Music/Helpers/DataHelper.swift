//
//  DataHelper.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

import AVFoundation

/// 单例,数据管理助手
class DataHelper {
    
    static let shared = DataHelper()
    private init() {}
    
    /// 当前电台频道id
    var channelId:Int?
    
    ///  记住上次选中的频道
    var isRememberLastChanneld = true
    
    /// 自动播放
    var isAutoPlay = true
    
    /// 第一次进入
    var isFirst = true
    
    /// 分享应用次数
    var shareappCount = 0
    
    /// banner广告数据
    var banners = [AdvertModel]()
    
    /// 同步本地化数据
    func setup() {
        let standard = UserDefaults.standard
        channelId = standard.value(forKey: UserDefaultChannelId) as? Int
        isRememberLastChanneld = standard.bool(forKey: UserDefaultRememberLastChannel)
        isAutoPlay = standard.bool(forKey: UserDefaultAutoPlay)
        shareappCount = standard.integer(forKey: UserDefaultShareAppCount)
        
        /// 统计设备uuid
        var uuid = standard.value(forKey: UserDefaultUUID) as? String
        if uuid == nil {
            uuid = UIDevice.current.identifierForVendor?.uuidString
            if nil != uuid {
                standard.set(uuid, forKey: UserDefaultUUID)
                RKBISDKHelper.shared.rkTrackEvent(eventType: .uuid(uuid: uuid!))
            }
        }
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
}
