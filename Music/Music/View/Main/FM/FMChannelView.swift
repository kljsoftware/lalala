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
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(_scrollView)
        return _scrollView
    }()
    
    /// 当前选中的频道id
    private var channelId:Int?
    
    /// 布局初始化
    func setup() {
        if channelListDataModel == nil && channelListDataModel!.channels.count == 0 {
            return
        }
        setupSubViews()
        selectedButton(with: getChannelId())
    }
    
    /// 获取显示频道
    private func getChannelId() -> Int {
        
        /// 默认第一个频道
        var channelId = channelListDataModel!.channels.first!.id
        
        /// 若没有记录频道或记录频道的数据为空, 则默认显示第一个频道
        if !DataHelper.shared.isRememberLastChanneld || DataHelper.shared.channelId == nil {
            return channelId
        }
        
        /// 遍历当前频道
        for channel in channelListDataModel!.channels {
            if channel.id == DataHelper.shared.channelId! {
                channelId = channel.id
                break
            }
        }
        
        return channelId
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
    private func selectedButton(with channelId:Int?) {
        guard let channelId = channelId else {
            return
        }
        
        if self.channelId != nil {
            unselectedButton(with: self.channelId!)
        }
        let button = scrollView.viewWithTag(channelId) as! UIButton
        button.isSelected = true
        button.titleLabel?.font = ARIAL_FONT_21
        self.channelId = channelId
        scrollToHeader(distance: button.frame.minX - 8) // 第一项位置是居左8dp
        DataHelper.shared.setupChannel(channelId: channelId)
        selectedClosure?(channelId)
        
        guard let channelName = getChannelName(channelId: channelId) else {
            return
        }
        
        /// 统计频道点击数据
        RKBISDKHelper.shared.rkTrackEvent(eventType: .fm(type: .category(name: channelName)))
    }
    
    /// 获取电台名字
    private func getChannelName(channelId:Int) -> String? {
        for channel in channelListDataModel!.channels {
            if channel.id == channelId {
                return channel.name
            }
        }
        return nil
    }
    
    /// 取消频道按钮
    private func unselectedButton(with channelId:Int) {
        let button = scrollView.viewWithTag(channelId) as? UIButton
        button?.isSelected = false
        button?.titleLabel?.font = ARIAL_FONT_19
    }
    
    /// distance:表示要移动的位移
    private func scrollToHeader(distance:CGFloat) {
        
        /// 滚动偏移量
        var contentOffset = scrollView.contentOffset
        
        /// 可移动位移
        let movableDistance = scrollView.contentSize.width - scrollView.frame.width
        let d = movableDistance > 0 ? movableDistance : 0
        contentOffset.x = distance >= d ? d : distance

        /// 执行滚动动画
        scrollView.setContentOffset(contentOffset, animated: true)
    }
}
