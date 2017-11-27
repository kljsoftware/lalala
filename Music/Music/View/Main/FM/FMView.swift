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
        let channelView = FMChannelView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 48, height: 48))
        addSubview(channelView)
        
        viewModel.getChannelList()
        viewModel.setCompletion(onSuccess: { (result) in
            channelView.channelListDataModel = self.viewModel.channelListResultModel?.data
        }) { (error) in
            
        }
    }
}
