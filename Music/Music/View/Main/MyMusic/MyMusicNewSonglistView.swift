//
//  MyMusicNewSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

import Toast_Swift

/// 新建歌单视图
class MyMusicNewSonglistView: UIView {

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 完成按钮
    @IBOutlet weak var doneButton: UIButton!
    
    /// 歌单名
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: - override methods
    override func awakeFromNib() {
        doneButton.setTitle(LanguageKey.Common_Done.value, for: .normal)
        titleLabel.text = LanguageKey.MyMusic_CreatePlaylist.value
        nameTextField.attributedPlaceholder = NSAttributedString(string: LanguageKey.MyMusic_EditPlaylistNameDescription.value, attributes: [NSForegroundColorAttributeName : COLOR_ABABAB])
    }
   
    // MARK: - IBAction methods
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
    
    /// 点击完成按钮
    @IBAction func onDoneButtonClicked(_ sender: UIButton) {
        
        // 名称不能为nil
        guard let name = nameTextField.text else {
            AppUI.tip(LanguageKey.Tip_PleaseEnterName.value)
            return
        }
        
        // 名称不能为空
        if name.isEmpty {
             AppUI.tip(LanguageKey.Tip_PleaseEnterName.value)
            return
        }
        
        // 歌单已存在
        let results = RealmHelper.shared.query(type: SonglistRealm.self, predicate: NSPredicate(format: "name = %@", name))
        if results.count > 0 {
             AppUI.tip(LanguageKey.Tip_PlaylistExisted.value)
            return
        }
        
        // 创建成功, 存入数据库, 通知并返回
        PlaylistHelper.createPlaylist(name: name)
        AppUI.pop(self)
    }
}

// MARK: UITextViewDelegate
extension MyMusicNewSonglistView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    /// 点击软键盘Next、go处理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
