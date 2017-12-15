//
//  RKBISDKHelper.swift
//  Music
//
//  Created by hzg on 2017/12/15.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 埋点
enum EventTracking  {
    case fm(type:FMTrackingType)             // 电台
    case mymusic(type:MyMusicTrackingType)   // 我的音乐
    case discover(type:DiscoverTrackingType) // 发现
    case search(name:String)                 // 搜索 搜索关键词
    case me(type:MeTrackingType)             // 我
    case songshare(name:String)              // 歌曲分享
    case uuid(uuid:String)                   // uid 设备唯一码
    case exitapp                             // 关闭应用
    case appduration(durtion:TimeInterval)   // 应用运行时长
    
    /// 元组类型：事件类型、事件参数
    var tuple:(action:String, key:String?, value:String?) {
        var action = "", key:String?, value:String?
        switch self {
        case let .fm(type):
            action = "action_fm_id"
            switch type {
            case let .category(name):
                key   = "name_category"
                value = name
            case let .song(name):
                key   = "name_song"
                value = name
            }
        case let .mymusic(type):
            action = "action_mymusic_id"
            switch type {
            case let .download(name):
                key   = "name_download"
                value = name
            case let .collect(name):
                key   = "name_collect"
                value = name
            }
        case let .discover(type):
            action = "action_discover_id"
            switch type {
            case let .rank(name):
                key   = "name_download"
                value = name
            case let .playlist(name):
                key   = "name_collect"
                value = name
            }
        case let .search(name):
            action = "action_search_id"
            key    = "name_search"
            value  = name
        case let .me(type):
            action = "action_me_id"
            switch type {
            case let .remainDownloadAmount(times):
                key   = "remainDownloadAmount"
                value = "\(times)"
            case let .share(times):
                key   = "name_share"
                value = "\(times)"
            }
        case let .songshare(name):
            action = "action_songshare_id"
            key    = "name_songshare"
            value  = name
        case let .uuid(uuid):
            action = "action_uuid_id"
            key    = "name_uuid"
            value  = uuid
        case .exitapp:
            action = "action_exitapp_id"
        case let .appduration(durtion):
            action = "action_appduration_id"
            key    = "name_appduration"
            value  = "\(durtion)"
        }
        return (action, key, value)
    }
}

/// 电台具体埋点
enum FMTrackingType {
    case category(name:String)  // 分类点击（热门 华语 流行...等）
    case song(name:String)      // 听了那首歌曲
}

/// 我的音乐具体埋点
enum MyMusicTrackingType {
    case download(name:String)  // 下载哪首歌曲
    case collect(name:String)   // 我喜欢的音乐（收藏哪首）
}

/// 发现具体埋点
enum DiscoverTrackingType {
    case rank(name:String)       // 各榜单
    case playlist(name:String)   // 热门歌单分类
}

/// ‘我’具体埋点
enum MeTrackingType {
    case remainDownloadAmount(times:Int) // 剩余下载次数
    case share(times:Int)                // 分享应用次数
}

/// 基于RKBISDK封装
class RKBISDKHelper {
    static let shared = RKBISDKHelper()
    private init() {}
    
    /// 初始化（必接）
    func rkInit() {
        
        /// 平台判断
        #if arch(i386) || arch(x86_64)
            return
        #endif
        
        RKBIPlatform.getInstance().rkInit()
    }
    
    /// 保存并自动发送统计事件
    func rkTrackEvent(eventType:EventTracking) {
       
        /// 平台判断
        #if arch(i386) || arch(x86_64)
            return
        #endif
        
        /// 获取action、key、value
        let actionkey = eventType.tuple.action
        let key = eventType.tuple.key
        let value = eventType.tuple.value
        
        // 1.添加 action事件
        let event = RKBIEvent.rkBIAddAction(actionkey)
        
        // 2.给此action事件添加参数
        if key != nil && value != nil {
            event.rkBIAdd(key!, value: value!)
        }
        
        // 3.保存发送此action事件
        RKBIPlatform.rkTrackEvent(event)
        
        /*立即发送BI统计
        仅用作检验服务器是否收到立即收到统计数据，正常情况下的统计数据会150秒自动发送给服务器
         */
        if LOG_ENABLED {
            RKBINetworkManager.sendBIRequest()
        }
    }
}
