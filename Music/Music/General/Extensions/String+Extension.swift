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
    
    /// 测量单行字符串
    func sizeWithFont(_ font:UIFont) -> CGSize {
        let attrs = [NSFontAttributeName:font]
        let string:NSString = self as NSString
        return string.size(attributes: attrs)
    }
    
    /// 测量多行字符串宽高
    func getTextRectSize(_ font:UIFont, maxWidth:CGFloat, maxHeight:CGFloat) -> CGSize {
        let attributes = [NSFontAttributeName: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let size = CGSize(width: maxWidth, height: maxHeight)
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
    // 判断是否全是空白
    func isBlank() -> Bool {
        return trimmingCharacters(in: CharacterSet.whitespaces) == ""
    }
}
