//
//  SearchSongResultModel.swift
//  Music
//
//  Created by 孔令杰 on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索歌曲返回
class SearchSongResultModel: ResultModel {
    
    /// 是否还有更多
    var has_more = false
    
    /// 歌曲列表
    var items = [FMSongDataModel]()
    
}
