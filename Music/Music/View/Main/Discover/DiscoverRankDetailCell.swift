//
//  DiscoverRankDetailCell.swift
//  Music
//
//  Created by hzg on 2017/12/10.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class DiscoverRankDetailCell: UITableViewCell {

    /// 封面
    @IBOutlet weak var coverImageView: UIImageView!
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 来源
    @IBOutlet weak var sourceLabel: UILabel!
    
    /// 副标题
    @IBOutlet weak var subTitleLabel: UILabel!
    
    /// 更新
    func update(model:RankInfoModel) {
        coverImageView.setImage(urlStr: model.cover_url, placeholderStr: "default_cover_2", radius: 0)
        titleLabel.text = model.title
        sourceLabel.text = model.source_tip
        subTitleLabel.text = model.sub_title
    }
}
