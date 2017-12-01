//
//  SongListDataModel.swift
//  Music
//
//  Created by 孔令杰 on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌单数据
class SongListDataModel: NSObject{
    
    /// 歌单id
    var song_list_id = 0
    
    /// 名称
    var song_list_name = ""
    
    ///
    var permission = 0
    
    /// 播放次数
    var played_count = 0
    
    /// 封面图片
    var song_list_cover = ""
    
    /// 描述
    var song_list_desc = ""
    
    ///
    var song_list_type = ""
    
    /// 分享次数
    var share_count = 0
    
    /// 收藏次数
    var fav_count = 0
    
    ///
    var is_cover_modied = 0
    
    /// 分享地址
    var share_uri = ""
    
    /// 是否有人收藏
    var has_fav = false
    
    /// 评论次数
    var comment_count = 0
    
    /// 分享链接
    var share_link = ""

    /// 歌曲列表
    var songs = [FMSongDataModel]()
}
