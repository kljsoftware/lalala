//
//  SearchSingerListResultModel.swift
//  Music
//
//  Created by 孔令杰 on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 获取默认歌手列表
class SearchSingerListResultModel: ResultModel {
    
    /// 是否还有更多
    var has_more = false
    
    /// 歌手列表
    var data = [SingerModel]()
    
}
