//
//  DiscoverEnterCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class DiscoverEnterCell: UICollectionViewCell {
   
    /// 边框视图
    @IBOutlet weak var borderView: BorderView!
    
    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - public methods
    /// 更新
    func update(model:RankInfoModel) {
        let color = UIColor.hexStringToColor(model.color)
        borderView.setup(color)
        iconImageView.setImage(urlStr: model.icon, placeholderStr: "", radius: 0)
        titleLabel.text = model.title
        titleLabel.textColor = color
    }

}
