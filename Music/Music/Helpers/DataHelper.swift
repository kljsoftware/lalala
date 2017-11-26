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
}
