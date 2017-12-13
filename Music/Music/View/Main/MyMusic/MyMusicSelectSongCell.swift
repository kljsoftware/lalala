//
//  MyMusicSelectSongCell.swift
//  Music
//
//  Created by hzg on 2017/12/13.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 按钮选中/未选中图片
private let checkedImage = UIImage(named:"batch_btn_all_selected")!, uncheckedImage = UIImage(named:"batch_btn_all_normal")!

/// 选择歌曲单元
class MyMusicSelectSongCell: UITableViewCell {
    
    /// 选中按钮
    @IBOutlet weak var selectButton: UIButton!
    
    /// 歌曲名字
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 艺人名字
    @IBOutlet weak var artistLabel: UILabel!
    
    /// 更新
    func update(model:SongRealm) {
        songNameLabel.text = model.title
        artistLabel.text = model.artist
    }
    
    /// 设置选中状态
    func setChecked(checked:Bool) {
        if checked {
            selectButton.setImage(checkedImage, for: .normal)
        } else {
            selectButton.setImage(uncheckedImage, for: .normal)
        }
    }
}
