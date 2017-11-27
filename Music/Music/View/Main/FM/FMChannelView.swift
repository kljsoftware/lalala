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
    
    /// 布局初始化
    func setup() {
        if channelListDataModel == nil {
            return
        }
        let blank:CGFloat = 8, letMargin:CGFloat = 8, rightMargin:CGFloat = 8
        var x:CGFloat = letMargin
        var font = ARIAL_FONT_19
        var color = UIColor.white
        for channel in channelListDataModel!.channels {
            if channel.id == DataHelper.shared.channelId! {
                font = ARIAL_FONT_21
                color = COLOR_69EDC8
            } else {
                font = ARIAL_FONT_19
                color = UIColor.white
            }
            let size = channel.name.sizeWithFont(font)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: 0, width: size.width + 2*blank, height: scrollView.frame.height)
            button.setTitle(channel.name, for: .normal)
            button.titleLabel?.font = font
            button.titleLabel?.textColor = color
            scrollView.addSubview(button)
            x += button.frame.width
        }
        scrollView.contentSize = CGSize(width: x+rightMargin, height: scrollView.frame.height)
    }
}
