//
//  NetworkMacro.swift
//  Music
//
//  Created by hzg on 2017/11/21.
//  Copyright © 2017年 demo. All rights reserved.
//

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
        return "channel_lang=\(LanguageHelper.shared.language)\(GENERAL_PARAMS_DICT.urlParamsString())"
    }
}

/// api地址
enum NetworkURL {
    case FMChannelList(language:String)   // 获取电台频道列表
    case FMSongList(channelId:Int)       // 获取某一频道的歌曲列表
    
    var url : String {
        var api = ""
        switch self {
        case let .FMChannelList(language):
            api = "/myfm/category/list/\(language)/"
        case let .FMSongList(channelId):
            api = "/myfm/category/\(channelId)/"
        }
        return "\(SERVER_ADDRESS)\(api)?\(BaseInfo.shared.generalParams)"
    }
}
