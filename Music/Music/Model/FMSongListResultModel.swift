//
//  FMSongListResultModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 指定频道的歌曲列表
class FMSongListResultModel: ResultModel {
    
    // 歌曲列表
    var data = [FMSongDataModel]()
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["data" : FMSongDataModel.self]
    }
}

/// 歌曲
class FMSongDataModel : NSObject {
    
    /// 艺人名
    var artist = ""
    
    var cdn_coverURL = ""
    
    /// 版权列席
    var copyright_type = 1
    
    /// 封面地址
    var coverURL = ""
    
    var flag = 0
    
    var length = 0
    
    /// 歌词地址
    var lyricURL = ""
    
    /// mv
    var mv = [FMSongMVDataModel]()
    
    /// 原封面地址
    var ori_coverURL = ""
    
    /// 歌曲其它资源列表
    var other_sources = [FMSongOtherSourceDataModel]()
    
    /// 分享地址
    var share_uri = ""
    
    /// 歌曲id
    var sid = 0
    
    /// 歌曲id扩展
    var song_id_ext = ""
    
    /// 歌曲来源
    var source = FMSongSourceDataModel()
    
    /// 歌名
    var title = ""
    
    /// 上传者
    var uploader = ""
    
    /// 歌曲地址
    var url = ""
    
    /// 指定数组元素类型
    override class func mj_objectClassInArray() -> [AnyHashable: Any]! {
        return ["other_sources" : FMSongOtherSourceDataModel.self]
    }
}

/// mv
class FMSongMVDataModel : NSObject {
    var comments = 0
    var cover_image = ""
    var ctime = "" // 2017-10-03 19:34:44
    var descrip = ""
    var dislikes = 0
    var duration = "" // 00:03:43
    var embeddable = 1
    var fm_mv_active = 1
    var id = 0
    var is_active = 1
    var is_public = 1
    var language_id = 0
    var likes = 0
    var mtime = "" // 2017-10-03 19:34:44
    var published_at = "" // 2017-09-28 11:26:13
    var rate = 0
    var region_allowed = ""
    var region_blocked = ""
    var review_info = ""
    var source = 0
    var title = ""
    var views = 0
    var y_video_id = "" // 4CqSXTKxZqQ
    
    /// 将属性名换为其他key去字典中取值
    override class func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["description" : "descrip"]
    }
}

/// 歌曲来源
class FMSongSourceDataModel : NSObject {
    
}

/// 歌曲其它资源?
class FMSongOtherSourceDataModel : NSObject {
    
}
