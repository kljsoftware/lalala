//
//  Float+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

extension Float {
    
    // 浮点型转换为字符串
    func floatToString() -> String {
        return (self*10).truncatingRemainder(dividingBy: 10) == 0 ? "\(Int(self))" : "\(self)"
    }
    
    // 保留几位小数
    func floatDecimal(_ num : Int) -> Float {
        return floor(self*pow(10, Float(num))) / pow(10, Float(num))
    }
    
    // 四舍五入， bit表示保留小数点位数(bit>=1)
    func round(_ bit:Int) -> Float {
        if bit < 1 {
            return self
        }
        return roundf(self*pow(10, Float(bit))) / pow(10, Float(bit))
    }
    
    // 保留N位小数.如果为XX.0 则返回XX
    // 例子: 11.11保留1位 = 11.1   11.01保留1位 = 11    11.001保留2位 = 11
    func floatWithDecimal(_ num : Int) -> String {
        let floatNum = Float(Int(self * powf(10, Float(num)))) / powf(10, Float(num))
        return (floatNum * powf(10, Float(num))).truncatingRemainder(dividingBy: powf(10, Float(num))) == 0 ? "\(Int(floatNum))" : "\(floatNum)"
    }
    
}
