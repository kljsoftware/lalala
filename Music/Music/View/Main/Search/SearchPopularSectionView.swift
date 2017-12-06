//
//  SearchPopularSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 标签字典
private let nameDic = [0:"热门搜索", 1:"历史记录"]

class SearchPopularSectionView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(type:Int) {
        titleLabel.text = nameDic[type]
    }
    
}
