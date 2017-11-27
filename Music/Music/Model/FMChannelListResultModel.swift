//
//  FMCategoryListResultModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 电台频道列表
class FMChannelListResultModel: ResultModel {
    var data = FMChannelListDataModel()
}

/// 电台频道数据
class FMChannelListDataModel : NSObject {
    
    /// 电台频道数组
    var channels = [FMChannelDataModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["channels" : FMChannelDataModel.self]
    }
}

/// 电台频道
class FMChannelDataModel : NSObject {
    
    /// 封面，可选值
    var cover:String?
   
    /// 电台频道id
    var id     = 0
    
    /// 电台频道名称
    var name   = ""
    
    /// ?
    var source = 0
}

