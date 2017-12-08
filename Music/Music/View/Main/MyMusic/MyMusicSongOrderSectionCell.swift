//
//  MyMusicSongOrderSectionCell.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 创建的歌单分区单元
class MyMusicSongOrderSectionCell: UITableViewCell {
    
    /// 创建的歌单
    @IBOutlet weak var nameLabel: UILabel!
   
    /// 更新
    func update(orderCount:Int) {
        nameLabel.text = "\(LanguageKey.MyMusic_OwnedPlaylists.value)(\(orderCount))"
    }
    
    /// 点击创建歌单按钮
    @IBAction func onAddButtonClicked(_ sender: UIButton) {
        let view = Bundle.main.loadNibNamed("MyMusicNewSonglistView", owner: nil, options: nil)?[0] as! MyMusicNewSonglistView
        AppUI.push(to: view, with: APP_SIZE)
    }
}
