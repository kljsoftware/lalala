//
//  UIImageView+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

extension UIImageView {
    /**
     * 设置圆形的图片
     * param: urlStr            网络图片地址
     * param: placeholderStr    占位图片名称
     * param: radius            圆角半径
     */
    func setImage(urlStr: String, placeholderStr: String, radius: CGFloat) {
        
        self.sd_setImage(with: URL(string: urlStr), placeholderImage: UIImage(named: placeholderStr), options: SDWebImageOptions.retryFailed){ (image, error, cacheType, url) in
            self.corner(radius: radius)
        }
    }
    
    /**
     * param: radius            圆角半径
     * 注意：只有当imageView.image 不为nil 时，调用此方法才有效果
     */
    // 设置圆角 默认设置全部角
    func corner(radius: CGFloat, cornerType: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor? = nil) {
        
        // 开始图形上下文
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        // 获得图形上下文
        let ctx = UIGraphicsGetCurrentContext()
        if ctx == nil {
            return
        }
        // 圆角路径
        let cornerPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerType, cornerRadii: CGSize(width: radius, height: radius))
        // 裁剪
        cornerPath.addClip()
        // 渲染上下文
        self.layer.render(in: ctx!)
        // 边框
        if borderWidth != 0 && borderColor != nil {
            cornerPath.lineWidth = borderWidth*2
            borderColor?.setStroke()
            cornerPath.stroke()
        }
        // 从上下文上获取剪裁后的照片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        self.image = newImage
    }
}
