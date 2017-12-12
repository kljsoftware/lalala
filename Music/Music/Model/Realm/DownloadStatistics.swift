//
//  DownloadStatistics.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

import RealmSwift

/// 下载统计
class DownloadStatistics : Object {
    
    /// 时间格式yyyy-MM-dd
    dynamic var time = ""
    
    /// 下载次数统计
    dynamic var amount = 0
}
