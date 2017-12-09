//
//  PlaylistSheetCell.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌单单元
class PlaylistSheetCell: UITableViewCell {
    
    /// 歌单名
    @IBOutlet weak var nameLabel: UILabel!
    
    // 更新
    func update(name:String?) {
        nameLabel.text = name
    }
}
