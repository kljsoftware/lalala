//
//  DiscoveryMainModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 发现模块加载更多流行歌单
class DiscoveryLoadSonglistResultModel: ResultModel {
    var data = DiscoveryLoadSonglistDataModel()
}

/// 发现模块加载更多流行歌单数据模型
class DiscoveryLoadSonglistDataModel : NSObject {
    
    /// 是否还有更多
    var has_more = false
    
    /// 歌单列表
    var song_lists = [PlaylistInfoModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["song_lists" : PlaylistInfoModel.self]
    }
}

