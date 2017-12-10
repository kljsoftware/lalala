//
//  DiscoverCollectionSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 分区视图
class DiscoverCollectionSectionView: UICollectionReusableView {
   
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    /// type: 0表示排行榜  1表示热门歌单
    private var type:Int?
    
    /// 按钮点击
    @IBAction func onButtonClicked(_ sender: UIButton) {
        if type != nil && type == 0 {
            let view = Bundle.main.loadNibNamed("DiscoverRankDetailView", owner: nil, options: nil)?.first as! DiscoverRankDetailView
            AppUI.push(from: self, to: view, with: APP_SIZE)
        }
    }
    
    // MARK: - public methods
    /// 更新 type: 0表示排行榜  1表示热门歌单
    func update(type:Int) {
        self.type = type
        nameLabel.text = type == 0 ? LanguageKey.Discover_Rank.value : LanguageKey.Discover_PopularPlaylist.value
        arrowImageView.isHidden = type != 0
    }
    
}

/// 空的分区视图
class DiscoverCollectionEmptyView : UICollectionReusableView {}
