//
//  MyMusicNewSongOrderCell.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 新建歌单单元
class MyMusicNewSongOrderCell: UITableViewCell {

    /// 新建歌单
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        button.setTitle(LanguageKey.MyMusic_CreatePlaylist.value, for: .normal)
    }

    /// 点击新建歌单按钮
    @IBAction func onButtonClicked(_ sender: UIButton) {
        let view = Bundle.main.loadNibNamed("MyMusicNewSonglistView", owner: nil, options: nil)?[0] as! MyMusicNewSonglistView
        view.setup()
        AppUI.push(to: view, with: APP_SIZE)
    }
}
