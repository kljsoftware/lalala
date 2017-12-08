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
    
    /// 歌单类型 0表示我喜爱的歌单，1表示其它
    dynamic var type = 0
    
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
    
    // 模型转换
    func covertModel(model:FMSongDataModel) {
        artist = model.artist
        coverURL = model.coverURL
        lyricURL = model.lyricURL
        share_uri = model.share_uri
        sid = model.sid
        title = model.title
        url = model.url
    }
}
