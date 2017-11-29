//
//  Dictionary+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

extension Dictionary {
    
    /// 转化成网络参数拼接 "&key=value&key=value"
    func urlParamsString() -> String {
        var str = ""
        for kv in self {
            str += "&\(kv.key)=\(kv.value)"
        }
        return str
    }
}
