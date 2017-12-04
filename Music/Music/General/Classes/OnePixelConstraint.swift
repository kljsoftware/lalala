//
//  OnePixelConstraint.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

/**
 
 在storyboard中创建1像素的分割线
 
 @IBDesignable
 @IBDesignable的宏的功能就是让XCode动态渲染出该类图形化界面。
 
 @IBInspectable
 让支持KVC的属性能够在Attribute Inspector中配置。
 */

@IBDesignable
class OnePixelConstraint: NSLayoutConstraint {
    fileprivate var _onePixelConstant : Int = 0
    @IBInspectable var onePixelConstant : Int {
        set {
            _onePixelConstant = newValue
            self.constant = Pixel.px2dp(px: CGFloat(_onePixelConstant))
        }
        
        get {
            return _onePixelConstant
        }
    }
}

// 像素
class Pixel {
    class func px2dp(px:CGFloat) -> CGFloat {
        return (px * 1.0) / UIScreen.main.scale
    }
}
