//
//  DiscoverCollectionSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

private let nameDic = [0:"排行榜", 1:"热门歌单"]

class DiscoverCollectionSectionView: UICollectionReusableView {
   
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - public methods
    /// 更新 type: 0表示排行榜  1表示热门歌单
    func update(key:Int) {
        nameLabel.text = nameDic[key]
        arrowImageView.isHidden = key != 0
    }
    
}

class DiscoverCollectionEmptyView : UICollectionReusableView {
    
}
