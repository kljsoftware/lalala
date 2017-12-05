//
//  SearchSongResultModel.swift
//  Music
//
//  Created by 孔令杰 on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索歌曲返回
class SearchSongResultModel: ResultModel {
    var data = SearchSongDataModel()
}

/// 搜索歌曲数据
class SearchSongDataModel : NSObject {
    
    /// 是否还有更多
    var has_more = false
    
    /// 歌曲列表
    var items = [FMSongDataModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["items" : FMSongDataModel.self]
    }
}
