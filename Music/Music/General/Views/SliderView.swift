//
//  SliderView.swift
//  Music
//
//  Created by hzg on 2017/11/29.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 滑块视图
class SliderView: UISlider {
    
    /// 按下/抬起 闭包
    var touchBeganClousre:(() -> Void)?
    var touchEndClousre:(() -> Void)?
    
    /// 滑块视图，这里统一默认16*16dp
    let thumbSize = CGSize(width: 16, height: 16)
    
    // MARK: - override methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let pt = touches.first!.location(in: self)
        let rect = trackRect(forBounds: self.bounds)
        let value = minimumValue + Float(pt.x - rect.origin.x - thumbSize.width/2)*(maximumValue - minimumValue) / Float(rect.size.width - thumbSize.width)
        setValue(value, animated: false)
        touchBeganClousre?()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touchEndClousre?()
    }
    
    /// 设置滑块
    func setThumbImage(_ named:String) {
        let thumb = UIImage(named:named)?.scaleToSize(size: thumbSize)
        self.setThumbImage(thumb, for: .normal)
        self.setThumbImage(thumb, for: .highlighted)
    }
}
