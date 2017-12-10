//
//  DiscoverRankResultModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 获取排行榜内容
class DiscoverRankResultModel: ResultModel {
    var data = DiscoverRankDataModel()
}

class DiscoverRankDataModel : NSObject {
    
    /// 时间戳
    var timestamp = ""
    
    /// 歌曲列表
    var songs = [FMSongDataModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["songs" : FMSongDataModel.self]
    }
}
