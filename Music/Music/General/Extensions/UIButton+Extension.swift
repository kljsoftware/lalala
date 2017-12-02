//
//  UIButton+Extension.swift
//  Music
//
//  Created by hzg on 2017/12/2.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

extension UIButton {
    
    // 按钮背景颜色
    func setButtonBackground(nor:UIColor? = nil, dwn:UIColor? = nil, dis:UIColor? = nil, radius:CGFloat = 0) {
        
        if nor != nil {
            setBackgroundImage(UIImage.imageWithColor(color: nor!, rect: bounds, radius: radius), for: .normal)
        }
        
        if dwn != nil {
            setBackgroundImage(UIImage.imageWithColor(color: dwn!, rect:bounds, radius: radius), for: .highlighted)
        }
        
        if dis != nil {
            setBackgroundImage(UIImage.imageWithColor(color: dis!, rect:bounds, radius: radius), for: .disabled)
        }
    }
    
    // 按钮背景颜色
    func setImage(nor:UIImage? = nil, dwn:UIImage? = nil, sel:UIImage? = nil, dis:UIImage? = nil) {
        
        if nor != nil {
            setImage(nor!, for: .normal)
        }
        
        if dwn != nil {
            setImage(dwn!, for: .highlighted)
        }
        
        if sel != nil {
            setImage(sel!, for: .selected)
        }
        
        if dis != nil {
            setImage(dis!, for: .disabled)
        }
    }
    
    /// 设置选中和非选中按下状态
    func setHighlightedImage(nor:UIImage?, sel:UIImage?) {
        setImage(nor, for: [.normal, .highlighted])
        setImage(sel, for: [.selected, .highlighted])
    }
    
}
