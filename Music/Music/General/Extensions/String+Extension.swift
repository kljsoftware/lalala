//
//  String+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

extension String {
    
    /// [start, end] 从0开始
    func subString(start:Int, end:Int) -> String {
        let startIndex = index(self.startIndex, offsetBy: start)
        let endIndex   = end <= 0 ? index(self.endIndex, offsetBy: end) : index(self.startIndex, offsetBy: end)
        return String(self[startIndex..<endIndex])
    }
    
    // 测量单行字符串
    func sizeWithFont(_ font:UIFont) -> CGSize {
        let attrs = [NSFontAttributeName:font]
        let string:NSString = self as NSString
        return string.size(attributes: attrs)
    }
}
