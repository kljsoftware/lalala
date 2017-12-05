//
//  DiscoverRankCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 排行榜单元
class DiscoverRankCell: UICollectionViewCell {
    
    /// 封面图片
    @IBOutlet weak var coverImageView: UIImageView!
    
    /// 排行榜名
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 时间名
    @IBOutlet weak var subTitleLabel: UILabel!
    
    // MARK: - public methods
    func update(model:RankInfoModel) {
        coverImageView.setImage(urlStr: model.cover_url, placeholderStr: "default_cover_2", radius: 0)
        titleLabel.text = model.title
        subTitleLabel.text = model.sub_title
    }
    
}
