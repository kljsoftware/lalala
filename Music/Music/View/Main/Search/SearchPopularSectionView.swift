//
//  SearchPopularSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 标签字典
private let nameDic = [0:LanguageHelper.shared.getLanguageText(by: "Query_PopularSearches"),
                       1:LanguageHelper.shared.getLanguageText(by: "Query_SearchHistory")]

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
