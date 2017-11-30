//
//  LoopPageView.swift
//  Music
//
//  Created by hzg on 2017/11/28.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 轮播视图数量
private let count = 3

/// 默认轮播视图封面
fileprivate let defaultImage = UIImage(named: "default_cover_2")

/// 无限轮播视图
class LoopPageView : UIView {
    
    /// 上一页、下一页闭包
    fileprivate var prevPageClosure:(() -> Void)?
    fileprivate var nextPageClosure:(() -> Void)?
    fileprivate var clickedClosure:(() -> Void)?
    
    /// 背景视图
    lazy var pageBackView:PageBackView = {
        let _pageBackView = PageBackView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        _pageBackView.backgroundColor = UIColor.clear
        self.insertSubview(_pageBackView, at: 0)
        return _pageBackView
    }()
    
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
        for i in 0..<count {
            let pageView = PageView(frame: CGRect(x: CGFloat(i) * self.frame.width, y: 0, width: self.frame.width, height: self.frame.height))
            _scrollView.addSubview(pageView)
        }
        return _scrollView
    }()
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performTapGesture)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击手势
    func performTapGesture(sender:UITapGestureRecognizer) {
        self.isHidden = true
        clickedClosure?()
    }
    
    // MARK: - MARK
    /// 初始化配置
    func setup(imageSize:CGSize, cornerRadius:CGFloat, imageBackColor:UIColor = .clear) {
        for subview in scrollView.subviews {
            let pageview = subview as! PageView
            pageview.setup(imageSize: imageSize, cornerRadius: cornerRadius, imageBackColor:imageBackColor)
        }
    }
    
    /// 显示文字
    func showLabel(text:String? = nil) {
        pageBackView.showLabel(text: text)
    }
    
    /// 显示背景
    func showBack(image:UIImage?, size:CGSize) {
        pageBackView.showBack(image: image, size: size)
    }
    
    /// 设置上一页、下一页闭包
    func setup(prev:(() -> Void)?, next:(() -> Void)?, clicked:(() -> Void)?) {
        prevPageClosure = prev
        nextPageClosure = next
        clickedClosure  = clicked
    }
    
    /// 设置轮播图片
    func setup(urls:[String]) {
        for i in 0..<count {
            let pageview = scrollView.subviews[i] as! PageView
            pageview.setup(url: urls[i])
        }
    }
    
    // MARK: - private methods
    /// 下一页
    fileprivate func nextPage() {
        let page0 = scrollView.subviews[0] as! PageView
        let page1 = scrollView.subviews[1] as! PageView
        let page2 = scrollView.subviews[2] as! PageView
        page0.imageView.image = page1.imageView.image
        page1.imageView.image = page2.imageView.image
        page2.imageView.image = defaultImage
        nextPageClosure?()
    }
    
    /// 上一页
    fileprivate func prevPage() {
        let page0 = scrollView.subviews[0] as! PageView
        let page1 = scrollView.subviews[1] as! PageView
        let page2 = scrollView.subviews[2] as! PageView
        page2.imageView.image = page1.imageView.image
        page1.imageView.image = page0.imageView.image
        page0.imageView.image = defaultImage
        prevPageClosure?()
    }
}

/// 背景视图
class PageBackView : UIView {

    /// 底部文字
    private lazy var textLabel:UILabel = {
        let _textLabel = UILabel()
        _textLabel.textAlignment = .center
        _textLabel.font = ARIAL_FONT_12
        _textLabel.textColor = UIColor.white
        self.addSubview(_textLabel)
        _textLabel.snp.makeConstraints({ (maker) in
            maker.width.bottom.equalTo(self).offset(-12)
            maker.height.equalTo(20)
        })
        return _textLabel
    }()
    
    /// 背景
    private lazy var backImageView:UIImageView = {
        let _backImageView = UIImageView()
        self.addSubview(_backImageView)
        return _backImageView
    }()
    
    // MARK: - public methods
    /// 显示文字
    func showLabel(text:String?) {
        textLabel.text = text ?? "------- - -------"
    }
    
    /// 显示背景图片
    func showBack(image:UIImage?, size:CGSize) {
        backImageView.image = image
        backImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self)
            maker.width.equalTo(size.width)
            maker.height.equalTo(size.height)
        }
    }
}


/// 滚动页视图
class PageView : UIView {
    
    private var radius:CGFloat = 0
    
    /// 轮播显示的图片
    lazy var imageView:UIImageView = {
        let _imageView = UIImageView()
        _imageView.image = defaultImage
        _imageView.contentMode = .scaleAspectFill
        self.addSubview(_imageView)
        return _imageView
    }()
    
    /// 初始化配置
    func setup(imageSize:CGSize, cornerRadius:CGFloat, imageBackColor:UIColor) {
        radius = cornerRadius
        imageView.cornerRadius = cornerRadius
        imageView.backgroundColor = imageBackColor
        imageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(imageSize.width)
            maker.height.equalTo(imageSize.height)
            maker.center.equalTo(self)
        }
    }
    
    /// 设置图片
    func setup(url:String) {
        imageView.setImage(urlStr: url, placeholderStr: "default_cover_2", radius: radius)
    }
}

/// MARK: - UIScrollViewDelegate
extension LoopPageView : UIScrollViewDelegate {
    
    /// 滚动结束监听
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > frame.width {
            nextPage()
        } else if scrollView.contentOffset.x < frame.width {
            prevPage()
        }
        scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
    }
}
