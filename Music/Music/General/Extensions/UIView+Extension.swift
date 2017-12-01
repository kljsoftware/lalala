//
//  UIView+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

extension UIView {
    
    // 圆角
    var cornerRadius:CGFloat {
    
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = false
            layer.shouldRasterize = true // 性能优化 参照http://www.jianshu.com/p/687bf79b4fd3
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    // 模糊
    class func blurViewWithRect(_ rect: CGRect, style:UIBlurEffectStyle = .light) -> UIView {
        let view = UIView(frame: rect)
        view.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        view.addSubview(blurView)
        return view
    }
    
    /// 渐变视图
    class func gradientView(frame:CGRect, start:CGPoint, end:CGPoint, color:UIColor = UIColor.black) -> UIView {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.startPoint = start
        gradientLayer.endPoint = end
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.0).cgColor]
        view.layer.addSublayer(gradientLayer)
        return view
    }
}
