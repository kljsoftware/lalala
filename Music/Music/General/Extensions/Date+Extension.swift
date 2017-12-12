//
//  Date+Extension.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 日期
extension Date {
    
    /// 格式：例如：yyyy-MM-dd， HH:mm:ss
    func getTime(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
