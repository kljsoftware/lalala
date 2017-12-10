//
//  DiscoverRankDetailResultModel.swift
//  Music
//
//  Created by 孔令杰 on 2017/12/1.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 获取排行榜列表
class DiscoverRankDetailResultModel: ResultModel {
    
    /// 排行榜列表
    var data = [RankInfoModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["data" : RankInfoModel.self]
    }
}
