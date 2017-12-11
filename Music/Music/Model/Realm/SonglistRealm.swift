//
//  SonglistRealm.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

import RealmSwift

/// 歌单记录
class SonglistRealm : Object {
    
    /// 歌单名
    dynamic var name = ""
    
    /// 创建时间
    dynamic var date = Date()
}

/// 歌曲
class SongRealm : Object {
    
    /// 对应歌单的id
    dynamic var songlistName = ""
    
    /// 艺人名
    dynamic var artist = ""
    
    /// 封面地址
    dynamic var coverURL = ""
    
    /// 歌词地址
    dynamic var lyricURL = ""
    
    /// 分享地址
    dynamic var share_uri = ""
    
    /// 歌曲id
    dynamic var sid = 0
    
    /// 歌名
    dynamic var title = ""
    
    /// 歌曲地址
    dynamic var url = ""
    
    /// 下载状态 0 表示未下载， 1表示正在下载， 2表示已下载
    dynamic var downloadFlag = 0
    
    /// 下载文件的总长度
    dynamic var downloadFileLength:Int64 = 0

    /// 歌曲模型转换
    class func getModel(model:FMSongDataModel) -> SongRealm {
        let songRealm = SongRealm()
        songRealm.artist = model.artist
        songRealm.coverURL = model.coverURL
        songRealm.lyricURL = model.lyricURL
        songRealm.share_uri = model.share_uri
        songRealm.sid = model.sid
        songRealm.title = model.title
        songRealm.url = model.url
        return songRealm
    }
    
    /// 歌曲列表模型转换
    class func getModels(models:[FMSongDataModel]) -> [SongRealm] {
        var songRealms = [SongRealm]()
        for model in models {
            songRealms.append(getModel(model:model))
        }
        return songRealms
    }
}
