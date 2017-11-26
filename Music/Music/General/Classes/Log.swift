//
//  Log.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 调试信息
class Log {
    class func e(_ msg:Any, fileName:String = #file, lineNum:Int = #line) {
        if LOG_ENABLED {
            print("[\((fileName as NSString).lastPathComponent)(\(lineNum))]\(msg)")
        }
    }
}

