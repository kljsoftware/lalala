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
    
    /// 播放次数
    @IBOutlet weak var playCountLabel: UILabel!
    
    /// 用户头像
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    /// 歌单名称
    @IBOutlet weak var screenNameLabel: UILabel!
    
    // MARK: - public methods
    /// 更新
    func update(model:PlaylistInfoModel) {
        coverImageView.setImage(urlStr: model.song_list_cover, placeholderStr: "default_cover_2", radius: 0)
        describeLabel.text = model.song_list_desc
        playCountLabel.text = "\(model.played_count)"
        userAvatarImageView.setImage(urlStr: model.user.avatar_url, placeholderStr: "", radius: 12)
        screenNameLabel.text = model.user.screen_name
    }
}
