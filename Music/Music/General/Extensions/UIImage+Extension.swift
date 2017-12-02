//
//  UIImage+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

extension UIImage {
    
    /// 缩放图片至指定大小
    func scaleToSize(size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaleImage
    }
    
    /// 生成对应颜色图片
    class func imageWithColor(color:UIColor, rect:CGRect, radius:CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        path.addClip()
        context?.addPath(path.cgPath)
        context?.drawPath(using: CGPathDrawingMode.fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
