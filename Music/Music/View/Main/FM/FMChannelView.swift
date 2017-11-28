//
//  FMChannelView.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 频道滚动视图
class FMChannelView: UIView {
    
    /// 频道列表数据
    var channelListDataModel:FMChannelListDataModel? {
        didSet {
            setup()
        }
    }
    
    /// 切换频道
    var selectedClosure:((_ channelId:Int) -> Void)?
    
    /// 滚动视图
    private lazy var scrollView:UIScrollView = {
        let _scrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(_scrollView)
        return _scrollView
    }()
    
    /// 当前选中的频道id
    private var channelId:Int?
    
    /// 布局初始化
    func setup() {
        if channelListDataModel == nil {
            return
        }
        setupSubViews()
        selectedButton(with: DataHelper.shared.channelId!)
    }
    
    /// 初始化子视图
    private func setupSubViews() {

        let blank:CGFloat = 8, letMargin:CGFloat = 8, rightMargin:CGFloat = 8
        var x:CGFloat = letMargin
        for channel in channelListDataModel!.channels {
            let size = channel.name.sizeWithFont(ARIAL_FONT_19)
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: x, y: 0, width: size.width + 2*blank, height: scrollView.frame.height)
            button.setTitle(channel.name, for: .normal)
            button.titleLabel?.font = ARIAL_FONT_19
            button.setTitleColor(UIColor.white, for: .normal)
            button.setTitleColor(COLOR_69EDC8, for: .highlighted)
            button.setTitleColor(COLOR_69EDC8, for: .selected)
            button.addTarget(self, action: #selector(onButtonClicked(_:)), for: .touchUpInside)
            button.tag = channel.id
            scrollView.addSubview(button)
            x += button.frame.width
        }
        scrollView.contentSize = CGSize(width: x+rightMargin, height: scrollView.frame.height)
    }
    
    /// 按钮点击事件
    @objc fileprivate func onButtonClicked(_ sender : UIButton) {
        selectedButton(with: sender.tag)
    }
    
    /// 选中频道按钮
    private func selectedButton(with channelId:Int) {
        if self.channelId != nil {
            unselectedButton(with: self.channelId!)
        }
        let button = scrollView.viewWithTag(channelId) as? UIButton
        button?.isSelected = true
        button?.titleLabel?.font = ARIAL_FONT_21
        self.channelId = channelId
        selectedClosure?(channelId)
        scrollView.sr
    }
    
    /// 取消频道按钮
    private func unselectedButton(with channelId:Int) {
        let button = scrollView.viewWithTag(channelId) as? UIButton
        button?.isSelected = false
        button?.titleLabel?.font = ARIAL_FONT_19
    }
}
