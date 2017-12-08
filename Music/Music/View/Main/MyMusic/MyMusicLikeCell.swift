//
//  MyMusicLikeCell.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 我喜欢的音乐单元
class MyMusicLikeCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = LanguageKey.MyMusic_Favorite.value
    }
}
