//
//  Double+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

extension Double {
    
    /// 转换时间格式
    func transferFormat() -> String {
        let t = Int(self)
        let m = t / 60
        var s = t - m * 60
        s = s >= 0 ? s : 0
        return String(format: "%02d:%02d", arguments: [m, s])
    }
    
    /// 转化时间格式"00:00"
    static func transfer(format:String) -> Double {
        let components = format.components(separatedBy: CharacterSet(charactersIn: ":"))
        if components.count < 2 {
            return 0
        }
        let min = Double(components[0]) ?? 0
        let sec = Double(components[1]) ?? 0
        return (min * 60 + sec)
    }
}
