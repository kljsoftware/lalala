//
//  MyMusicSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

import Toast_Swift

/// 新建歌单视图
class MyMusicSonglistView: UIView {

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 完成按钮
    @IBOutlet weak var doneButton: UIButton!
    
    /// 歌单名
    @IBOutlet weak var nameLabel: UILabel!
   
    // MARK: - IBAction methods
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
    
    /// 点击完成按钮
    @IBAction func onDoneButtonClicked(_ sender: UIButton) {
        
        // 名称不能为空
        guard let name = nameLabel.text else {
           // makeToast(LanguageKey.My)
            return
        }
        
        // 歌单已存在
        
        // 创建成功返回
        AppUI.pop(self)
    }
}
