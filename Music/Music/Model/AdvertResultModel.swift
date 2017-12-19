//
//  AdvertResultModel.swift
//  Music
//
//  Created by hzg on 2017/12/19.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 广告数据模型
class AdvertResultModel : NSObject {
    
    var advert = [AdvertModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["advert" : AdvertModel.self]
    }
}

/// 广告数据模型
class AdvertModel : NSObject {
    
    /// 区分广告类型，有scheme url和http两类
    var type = ""
    
    /// 点击后连接内容，如果sheme url则是一个连接地址，如果是url是一段网址
    var click = ""
    
    /// 广告图片
    var img = ""
    
    /// 广告投放位置目前提供splash页和banner页两种广告
    var pos = ""
    
    /// 广告时间，单位为秒
    var time = ""
}
