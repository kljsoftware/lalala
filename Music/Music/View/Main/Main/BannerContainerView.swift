//
//  BannerContainerView.swift
//  Music
//
//  Created by hzg on 2017/12/20.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 广告容器视图
class BannerContainerView: UIView {
    
    /// 广告数据
    var banners = [AdvertModel]()
    
    /// 滚动视图
    lazy var scrollView:UIScrollView = {
        let _scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.isPagingEnabled = true
        _scrollView.backgroundColor = UIColor.clear
        self.addSubview(_scrollView)
        _scrollView.contentSize = CGSize(width: CGFloat(self.banners.count) * self.frame.width, height: self.frame.height)
        _scrollView.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
        for i in 0..<self.banners.count {
            let banner = Bundle.main.loadNibNamed("BannerView", owner: nil, options: nil)?[0] as! BannerView
            banner.model = self.banners[i]
            banner.frame = CGRect(x: CGFloat(i) * self.frame.width, y: 0, width: self.frame.width, height: self.frame.height)
            _scrollView.addSubview(banner)
        }
        return _scrollView
    }()
    
    /// 页码, 轮播间隔时间
    private var page = 0
    private var timeInterval:TimeInterval = 0
    
    // MARK: - public methods
    /// 初始化
    func setup(banners:[AdvertModel]) {
        if banners.count > 0 {
            self.banners = banners
            scrollView.contentOffset = CGPoint.zero
            page = 0
            if banners.count > 1 { /// 如果大于1，开始轮播显示图片
                timeInterval = TimeInterval(banners.first!.time) ?? 1
                delayPerform()
            }
        }
    }
    
    // MARK: - private methods
    /// 循环执行
    private func delayPerform() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval) { [weak self] in
            guard let wself = self else {
                return
            }
            wself.page = (wself.page + 1) % wself.banners.count
            wself.timeInterval = TimeInterval(wself.banners[wself.page].time) ?? 1
            wself.scrollView.contentOffset = CGPoint(x: wself.frame.width * CGFloat(wself.page), y: 0)
            wself.delayPerform()
        }
    }
}
