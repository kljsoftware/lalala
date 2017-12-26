//
//  BannerView.swift
//  Music
//
//  Created by hzg on 2017/12/19.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 广告视图
class BannerView: UIView {

    /// 模型文件
    var model:AdvertModel? {
        didSet {
            if nil != model {
                setup()
            }
        }
    }
    
    /// 广告视图
    @IBOutlet weak var bannerImageView: UIImageView!
    
    /// 初始化
    private func setup() {
        bannerImageView.setImage(urlStr: model!.img, placeholderStr: "default_ad_banner", radius: 0)
    }
    
    /// 点击广告
    @IBAction func onBannerClicked(_ sender: UIButton) {
        if nil != model {
            RKBISDKHelper.shared.rkTrackEvent(eventType: .ad)
            AppUI.pushToAdView(model: model!)
        }
    }
}
