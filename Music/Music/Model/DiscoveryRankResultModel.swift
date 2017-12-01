//
//  DiscoveryMainModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 获取排行榜内容
class DiscoveryRankResultModel: ResultModel {
    
    /// 时间戳
    var timestamp = ""
    
    /// 歌曲列表
    var songs = [FMSongDataModel]()
}

