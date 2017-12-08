//
//  HistoryRealm.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

import RealmSwift

/// 搜索历史记录
class HistoryRealm : Object {
    
    /// 条目名
    dynamic var name = ""

    /// 时间
    dynamic var date = Date()
}
