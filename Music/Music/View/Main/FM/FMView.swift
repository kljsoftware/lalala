//
//  FMView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 电台视图
class FMView: UIView {
    
    /// 电台业务处理类
    let viewModel = FMViewModel()
    
    // MARK: - override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    /// 初始化
    private func setup() {
        
        // 频道列表视图
        let channelView = FMChannelView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 48, height: 48))
        addSubview(channelView)
        
        viewModel.getChannelList()
        viewModel.setCompletion(onSuccess: { (result) in
            channelView.channelListDataModel = self.viewModel.channelListResultModel?.data
        }) { (error) in
            Log.e("error = \(error as! String)")
        }
        
        // 无限切换视图
        let loopPageView = LoopPageView(frame: CGRect(x: 0, y: 48, width: self.frame.width, height: 200))
        addSubview(loopPageView)
        let backLoopView = UIView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: 200))
        loopPageView.setup(backView: backLoopView, imageSize: CGSize(width: 100, height: 100), cornerRadius: 8)

        // 播放控制视图
        let playerView = Bundle.main.loadNibNamed("FMPlayerView", owner: nil, options: nil)?[0] as! FMPlayerView
        addSubview(playerView)
        playerView.snp.makeConstraints { (maker) in
            maker.left.right.width.equalTo(self)
            maker.height.equalTo(96)
            maker.bottom.equalTo(self).offset(-(BOTTOM_TAB_HEIGHT+DEVICE_INDICATOR_HEIGHT))
        }
    }
}
