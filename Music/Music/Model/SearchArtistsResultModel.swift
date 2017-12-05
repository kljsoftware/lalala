//
//  SearchSingerListResultModel.swift
//  Music
//
//  Created by 孔令杰 on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 获取歌手列表
class SearchArtistsResultModel: ResultModel {
    var data = SearchArtistsDataModel()
}

/// 歌手列表数据
class SearchArtistsDataModel : NSObject {
    
    /// 是否还有更多
    var has_more = false
    
    /// 歌手列表
    var artists = [ArtistDataModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["artists" : ArtistDataModel.self]
    }
}

/// 歌手数据
class ArtistDataModel: NSObject {
    
    /// 歌手id
    var id = 0
    
    /// 名称
    var name = ""
    
    ///
    var aid = 0
    
    ///
    var rate = 0
    
    /// 歌手图片
    var imageurl = ""
    
}
