//
//  BorderView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

// 默认画笔宽度、默认框颜色
private let defaultLineWidth:CGFloat = 1
private let defaultStrokeColor = COLOR_ABABAB
private let defaultFillColor = UIColor.clear

/// 边框视图
@IBDesignable
class BorderView: UIView {
    
    // 画笔宽度、颜色
    private var lineWidth:CGFloat = defaultLineWidth
    
    /// 边框颜色
    private var strokeColor = defaultStrokeColor
    @IBInspectable var stroke : UIColor {
        set {
            strokeColor = newValue
        }
        get {
            return strokeColor
        }
    }
    
    /// 内容颜色
    private var fillColor = defaultFillColor
    @IBInspectable var fill : UIColor {
        set {
            fillColor = newValue
        }
        get {
            return fillColor
        }
    }
    
    /// 圆角半径
    private var _radius:CGFloat = 0
    @IBInspectable var radius : CGFloat {
        set {
            _radius = newValue
        }
        get {
            return _radius
        }
    }
    
    // MARK: - override methods
    override func awakeFromNib() {
        setNeedsDisplay()
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        drawBorder(lineWidth: lineWidth, strokeColor: strokeColor, fillColor: fillColor, radius: radius)
    }
    
    // MARK: - private methods
    /// 画框
    private func drawBorder(lineWidth:CGFloat, strokeColor:UIColor, fillColor:UIColor, radius:CGFloat) {
 
        // 边框
        let rect = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(lineWidth, lineWidth, lineWidth, lineWidth))
        
        // 贝塞尔曲线路径对象
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        
        // 线框
        path.lineWidth = lineWidth
        
        // 边框内的颜色
        fillColor.setFill()
        
        // 边框的颜色
        strokeColor.setStroke()
       
        // 填充颜色
        path.fill()
        path.stroke()
    }
    
    // MARK: - public methods
    // 设置颜色、线框
    func setup(_ strokeColor:UIColor, fillColor:UIColor = defaultFillColor, lineWidth:CGFloat = defaultLineWidth, radius:CGFloat = 0) {
        self.strokeColor = strokeColor
        self.fillColor   = fillColor
        self.lineWidth = lineWidth
        _radius    = radius
        setNeedsDisplay()
    }
}
