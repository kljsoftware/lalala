//
//  RealmHelper.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

import Foundation
import RealmSwift

/// 数据库助手，主要使用了第三方库RealmSwift
class RealmHelper {
    
    /// 实例对象
    static let shared = RealmHelper()
    private init() {}
    
    /// 数据库对象
    private lazy var realm:Realm = {
        let _realm = try! Realm(configuration: shared.configRealm(dbName: "LocalData"))
        return _realm
    }()
    
    // MARK: - private methods
    /// 配置数据库
    private func configRealm(dbName:String) -> Realm.Configuration {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(dbName).realm")
        return config
    }
    
    // MARK：- public methods
    /// 插入/更新 
    func insert<T:Object>(obj:T, filter predicate:NSPredicate? = nil) {
        
        /// 存储对象
        try! realm.write({
            
            /// 是否需要更新对象
            if nil != predicate {
                let results = realm.objects(T.self).filter(predicate!)
                for result in results {
                    realm.delete(result)
                }
            }
            
            realm.add(obj)
        })
    }
    
    /// 查询
    func query<T:Object>(type:T.Type, predicate:NSPredicate? = nil) -> Results<T> {
        if predicate != nil {
            return realm.objects(type).filter(predicate!)
        }
        return realm.objects(type)
    }
    
    /// 删除
    func delete<T:Object>(obj:T) {
        try! realm.write({
            realm.delete(obj)
        })
    }
    
}
