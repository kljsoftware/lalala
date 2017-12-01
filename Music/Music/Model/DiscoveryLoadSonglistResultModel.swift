//
//  DiscoveryMainModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 发现模块加载更多流行歌单
class DiscoveryLoadSonglistResultModel: ResultModel {
    
    /// 是否还有更多
    var has_more = false
    
    /// 歌单列表
    var song_lists = [PlaylistInfoModel]()
}

