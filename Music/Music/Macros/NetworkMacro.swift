//
//  NetworkMacro.swift
//  Music
//
//  Created by hzg on 2017/11/21.
//  Copyright © 2017年 demo. All rights reserved.
//

/// Appstore 地址， 上线地址
let app_url = "https://itunes.apple.com/us/app/id466211510?mt=8"

/// 广告地址
let advert_url = "http://push.sdk.rekoo.net/ads/test"

/// 音乐类信息服务器地址
let SERVER_ADDRESS = "https://theinfoapps.com"

/// URL后缀通用的基本信息
class BaseInfo {
    
    /// 实例对象
    static let shared = BaseInfo()
    private init() {}
    
    /// 通用参数
    private let GENERAL_PARAMS_DICT:[String:String] = ["os_api": "22",
                                               "osv": "5.1",
                                               "device_type": "PRO 5",
                                               "client_id": "",
                                               "dpi": "480",
                                               "device_manufacturer": "Meizu",
                                               "carrier": "",
                                               "e": "",
                                               "install_id": "",
                                               "fmek": "",
                                               "rom": "1495870962",
                                               "jb": "false",
                                               "v": "3.1.7",
                                               "lang": "zh",
                                               "ac": "WiFi",
                                               "sig_hash": "",
                                               "channel": "GOOGLE_PLAY",
                                               "android_id": "",
                                               "appname": "MusicFM",
                                               "carrier_code": "",
                                               "appid": "net.imusic.android.musicfm",
                                               "version_code": "16",
                                               "unique_device_id": "",
                                               "osn": "meizu_PRO5",
                                               "timezone": "8",
                                               "fmev": "",
                                               "country": "CN",
                                               "resolution": "1920x1080",
                                               "device_brand": "Meizu",
                                               "phonetype": "android",
                                               "r": "18e0bc",
                                               "model": "ull_arm64-v8a_armeabi-v7a_armeabi"]
    
    var generalParams:String {
        return "channel_lang=\(LanguageHelper.shared.type.rawValue)\(GENERAL_PARAMS_DICT.urlParamsString())"
    }
}

/// api地址
enum NetworkURL {
    case FMChannelList(language:String)   // 获取电台频道列表
    case FMSongList(channelId:Int)        // 获取某一频道的歌曲列表
    case DiscoverRankV3                   // 发现首页数据获取
    case DiscoverRankLoadSongLists(page:Int)  // 获取更多热门歌曲
    case DiscoverRank(rank_id:Int)        // 获取排行榜内容列表 （歌曲排行榜id拼接 如果rank_id为空 从open_url 取抽取rank_id）
    case DiscoverRankDetail               // 获取排行榜列表
    case DiscoverSonglistDetail(song_list_id:String)   // 获取歌单内容
    case SearchTopArtists(page:Int)       // 热门歌手列表
    case SearchV2(query:String, type:String, page:Int)  // 搜索结果返回
    case SearchPopular                    // 获取热门搜索
    
    /// url地址
    var url : String {
        var api = ""
        switch self {
        case let .FMChannelList(language):
            api = "/myfm/category/list/\(language)/?"
        case let .FMSongList(channelId):
            api = "/myfm/category/\(channelId)/?"
        case .DiscoverRankV3:
            api = "/myfm/rank/v3/?"
        case let .DiscoverRankLoadSongLists(page): //从1开始  每次最多返回10个
            api = "/myfm/rank/load_song_lists/?page_no=\(page)&"
        case let .DiscoverRank(rank_id):
            api = "/myfm/rank/\(rank_id)/?"
        case .DiscoverRankDetail:
            api = "/myfm/rank/detail/?"
        case let .DiscoverSonglistDetail(song_list_id):
            api = "/myfm/songlist/other_detail/?song_list_id=\(song_list_id)&"
        case let .SearchTopArtists(page):
            api = "/myfm/list/topartists/\(page)/?"
        case let .SearchV2(query, type, page):
            api = "/myfm/search/v2/?query=\(query)&type=\(type)&page_no=\(page)&"
        case .SearchPopular:
            api = "/myfm/search/popular/?"
        }
        return "\(SERVER_ADDRESS)\(api)\(BaseInfo.shared.generalParams)"
    }
}
