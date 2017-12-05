//
//  UIColor+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

extension UIColor {
   
    // 16进制转颜色
    class func hexToColor(_ hex : UInt) -> UIColor {
        let r = (hex & 0xFF0000) >> 16
        let g = (hex & 0x00FF00) >> 8
        let b = hex & 0x0000FF
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    // 字符串转颜色
    class func hexStringToColor(_ hexString: String) -> UIColor{
        var cString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if cString.characters.count < 6 {return UIColor.black}
        if cString.hasPrefix("0X") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 2))}
        if cString.hasPrefix("#") {cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))}
        if cString.characters.count != 6 {return UIColor.black}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
    }
}
