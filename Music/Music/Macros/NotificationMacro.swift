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

/// 新建/编辑歌单通知, 歌单列表变化（增加或删除）
let NoticationUpdateForCreateNewPlaylist = Notification.Name("NoticationUpdateForCreateNewPlaylist")
let NoticationUpdateForPlaylistChanged = Notification.Name("NoticationUpdateForPlaylistChanged")

/// 歌单切换通知
let NoticationUpdateForChangePlaylist = Notification.Name("NoticationUpdateForChangePlaylist")

/// 下载开始/完成，通知我的下载界面更新
let NoticationUpdateForSongDownload = Notification.Name("NoticationUpdateForSongDownload")

/// 开始下载/继续下载
let NoticationUpdateForPauseOrResumeDownload = Notification.Name("NoticationUpdateForPauseOrResumeDownload")

/// 暂停定时时间到，通知界面更新, 并暂停后台音乐播放
let NoticationUpdateForTimesup = Notification.Name("NoticationUpdateForTimesup")

/// 模式发生改变
let NoticationUpdateForCircleModeChanged = Notification.Name("NoticationUpdateForCircleModeChanged")
