//
//  LoopPageView.swift
//  Music
//
//  Created by hzg on 2017/11/28.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 轮播视图数量
private let count = 3

/// 无限轮播视图
class LoopPageView : UIView {
    
    /// 滚动视图
    lazy var scrollView:UIScrollView = {
        let _scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.isPagingEnabled = true
        _scrollView.backgroundColor = UIColor.clear
        _scrollView.delegate = self
        self.addSubview(_scrollView)
        _scrollView.contentSize = CGSize(width: CGFloat(count) * self.frame.width, height: self.frame.height)
        _scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        let colors = [UIColor.red, UIColor.gray, UIColor.black]
        for i in 0..<count {
            let pageView = PageView(frame: CGRect(x: CGFloat(i) * self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
            pageView.backgroundColor = colors[i]
            _scrollView.addSubview(pageView)
        }
        return _scrollView
    }()
    
    // MARK: - MARK
    /// 初始化配置
    func setup(backView:UIView, imageSize:CGSize, cornerRadius:CGFloat) {
       
        /// 背景视图
        addSubview(backView)
        
        /// 轮播视图
        for subview in scrollView.subviews {
            let pageview = subview as! PageView
            pageview.setup(imageSize: imageSize, cornerRadius: cornerRadius)
        }
    }
}

/// 滚动页视图
class PageView : UIView {
    
    /// 轮播显示的图片
    lazy var imageView:UIImageView = {
        let _imageView = UIImageView()
        _imageView.backgroundColor = UIColor.blue
        _imageView.image = UIImage(named: "default_cover_2")
        self.addSubview(_imageView)
        return _imageView
    }()
    
    /// 初始化配置
    func setup(imageSize:CGSize, cornerRadius:CGFloat) {
        imageView.cornerRadius = cornerRadius
        imageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(imageSize.width)
            maker.height.equalTo(imageSize.height)
            maker.center.equalTo(self)
        }
    }
}

/// MARK: - UIScrollViewDelegate
extension LoopPageView : UIScrollViewDelegate {
    
    /// 滚动结束监听
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
    }
}
