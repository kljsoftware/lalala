//
//  UIView+Extension.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

private let pushPopAnimationDuration = 0.5, pushPopDelayDuration = 0.1

extension UIView {
    
    /// 圆角
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
    
    /// 模糊
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
    
    /// 视图压栈
    func push(to view:UIView, with size:CGSize) {
        self.isUserInteractionEnabled = false
        self.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.height)
            maker.bottom.equalTo(self)
            maker.left.equalTo(self).offset(size.width)
        }
        self.perform(#selector(pushAnimation), with: view, afterDelay: pushPopDelayDuration)
    }
    
    /// 视图出栈
    func pop() {
        self.superview?.isUserInteractionEnabled = false
        self.snp.updateConstraints({ (maker) in
            maker.left.equalTo(self.superview!).offset(self.frame.width)
        })
        
        UIView.animate(withDuration: pushPopAnimationDuration, animations: {
            self.superview!.layoutIfNeeded()
        }, completion: { (finished) in
            self.superview?.isUserInteractionEnabled = true
            self.removeFromSuperview()
        })
    }
    
    /// 压栈动画
    @objc private func pushAnimation(view:UIView) {
        view.snp.updateConstraints({ (maker) in
            maker.left.equalTo(self)
        })
        UIView.animate(withDuration: pushPopAnimationDuration, animations: {
            self.layoutIfNeeded()
        }, completion: { (finished) in
            self.isUserInteractionEnabled = true
        })
    }
}
