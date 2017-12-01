//
//  DiscoveryMainModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 发现首页数据返回
class DiscoveryMainResultModel: ResultModel {
    var data = [DiscoveryMainModel]()
}

/// 发现首页数据
class DiscoveryMainModel : NSObject {

    /// 排行榜数组
    var rank = [RankInfoModel]()
    
    /// 重点排行数组
    var enter = [EnterDataModel]()
    
    /// 流行歌单信息数组
    var playlist = [PlaylistInfoModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["rank" : RankInfoModel.self, "enter" : EnterDataModel.self, "playlist" : PlaylistInfoModel.self]
    }
}

/// 排行榜
class RankInfoModel : NSObject {
    
    /// 排行榜id
    var rank_id = 0
    
    /// 标题
    var title = ""
    
    /// 时间戳
    var timestamp = ""
    
    /// 子标题
    var sub_title = ""
    
    /// 封面图片
    var cover_url = ""

    ///
    var source_tip = ""
    
    ///
    var type = 0
}
/// 重点排行模块
class EnterDataModel : NSObject {
    
    /// 重点排行id
    var rank_id = 0
    
    /// 标题
    var title = ""
    
    /// 时间戳
    var timestamp = ""
    
    /// 子标题
    var sub_title = ""
    
    /// 封面图片
    var cover_url = ""
    
    ///
    var source_tip = ""
    
    ///
    var type = 0
    
    /// 
    var open_url = ""
    
    /// 图标
    var icon = ""
    
    ///
    var color = ""
}
/// 歌单信息模块
class PlaylistInfoModel : NSObject {
    
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
    
    /// 歌曲数量
    var song_num = 0
    
    ///
    var song_list_type = ""
    
    /// 分享次数
    var share_count = 0
    
    /// 收藏次数
    var fav_count = 0
    
    ///
    var is_cover_modied = 0
}
