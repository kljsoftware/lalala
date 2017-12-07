//
//  SearchPopularSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

class SearchPopularSectionView: UICollectionReusableView {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update(type:Int) {
        titleLabel.text = type == 0 ? LanguageKey.Query_PopularSearches.value : LanguageKey.Query_SearchHistory.value
    }
    
}
