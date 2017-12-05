//
//  DiscoverPlaylistCell.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 热门歌单单元
class DiscoverPlaylistCell: UICollectionViewCell {
    
    /// 封面
    @IBOutlet weak var coverImageView: UIImageView!
   
    /// 描述
    @IBOutlet weak var describeLabel: UILabel!
    
    // MARK: - public methods
    /// 更新
    func update(model:PlaylistInfoModel) {
        coverImageView.setImage(urlStr: model.song_list_cover, placeholderStr: "default_cover_2", radius: 0)
        describeLabel.text = model.song_list_desc
    }
}
