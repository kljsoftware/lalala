//
//  FMChannelView.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 频道视图
class FMChannelView: UIView {
    
    /// 频道列表数据
    var channelListDataModel:FMChannelListDataModel? {
        didSet {
            setup()
        }
    }
    
    /// 滚动视图
    private lazy var scrollView:UIScrollView = {
        let _scrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(_scrollView)
        return _scrollView
    }()
    
//    /// MARK: - override methods
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    /// 布局初始化
    func setup() {
        if channelListDataModel == nil {
            return
        }
        var x:CGFloat = 0
        for channel in channelListDataModel!.channels {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: 0, width: 50, height: scrollView.frame.height)
            button.titleLabel?.text = channel.name
            scrollView.addSubview(button)
            x += button.frame.width
        }
        scrollView.contentSize = CGSize(width: x, height: scrollView.frame.height)
    }
}
