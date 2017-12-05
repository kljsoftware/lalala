//
//  BorderView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

// 默认画笔宽度、默认框颜色
private let defaultLineWidth:CGFloat = 1
private let defaultColor = COLOR_ABABAB

/// 边框视图
class BorderView: UIView {
    
    // 画笔宽度、颜色
    private var lineWidth:CGFloat = defaultLineWidth
    private var color = defaultColor
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        drawBorder(lineWidth: lineWidth, color: color)
    }
    
    // MARK: - private methods
    /// 画框
    private func drawBorder(lineWidth:CGFloat, color:UIColor) {
 
        // 边框
        let rect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(lineWidth, lineWidth, lineWidth, lineWidth))
        
        // 贝塞尔曲线路径对象
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0)
        
        // 线框
        path.lineWidth = lineWidth
        
        // 边框内的颜色
        UIColor.clear.setFill()
        
        // 边框的颜色
        color.setStroke()
       
        // 填充颜色
        path.fill()
        path.stroke()
    }
    
    // MARK: - public methods
    // 设置颜色、线框
    func setup(_ color:UIColor, lineWidth:CGFloat = defaultLineWidth) {
        self.color = color
        self.lineWidth = lineWidth
        setNeedsDisplay()
    }
}
