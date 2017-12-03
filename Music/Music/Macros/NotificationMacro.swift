//
//  NotificationMacro.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

// 通知常量定义

/// 音频播放器消息  音频播放状态、音频时长、音频缓冲进度
let NoticationAudioStatusChanged  = Notification.Name("NoticationAudioStatusChanged")

//通知界面更新
/// 音频播放器、歌曲播放进度、歌曲发生改变
let NoticationUpdateForAudioStatusChanged = Notification.Name("NoticationUpdateForAudioStatusChanged")
let NoticationUpdateForAudioProgressChanged = Notification.Name("NoticationUpdateForAudioProgressChanged")
let NoticationUpdateForSongChanged = Notification.Name("NoticationUpdateForSongChanged")


