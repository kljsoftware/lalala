//
//  MyMusicSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌单视图
class MyMusicSonglistView: UIView {

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    // MAKE: - 
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Common_Playlist.value
    }
    
    /// 点击编辑按钮
    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}
