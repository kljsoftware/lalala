//
//  MyMusicSongOrderCell.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 其它歌单
class MyMusicSongOrderCell: UITableViewCell {
    
    /// 歌单名
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - override methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        arrowImageView.isHidden = editing
    }
    
    /// 更新
    func update(model:SonglistRealm) {
        nameLabel.text = model.name
    }
}
