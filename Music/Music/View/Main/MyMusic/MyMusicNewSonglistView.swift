//
//  MyMusicNewSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

import Toast_Swift

/// 新建/编辑歌单视图
class MyMusicNewSonglistView: UIView {

    /// 编辑回调闭包
    var editClosure:((_ songlistname:String) -> Void)?
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 完成按钮
    @IBOutlet weak var doneButton: UIButton!
    
    /// 歌单名
    @IBOutlet weak var nameTextField: UITextField!
    
    /// 类型: 0表示新建歌单， 1表示编辑歌单
    private var type = 0, songlistName:String?
    
    // MARK: - override methods
    override func awakeFromNib() {
        doneButton.setTitle(LanguageKey.Common_Done.value, for: .normal)
        nameTextField.attributedPlaceholder = NSAttributedString(string: LanguageKey.MyMusic_EditPlaylistNameDescription.value, attributes: [NSForegroundColorAttributeName : COLOR_ABABAB])
    }
    
    /// 设置类型 0表示新建歌单， 1表示编辑歌单
    func setup(type:Int = 0, songlistName:String? = nil) {
        titleLabel.text = type == 0 ? LanguageKey.MyMusic_CreatePlaylist.value : LanguageKey.MyMusic_EditPlaylistIntro.value
        nameTextField.text = songlistName
        self.type = type
        self.songlistName = songlistName
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
        
        /// 新建歌单
        if type == 0 {
            // 歌单已存在
            let results = RealmHelper.shared.query(type: SonglistRealm.self, predicate: NSPredicate(format: "name = %@", name))
            if results.count > 0 {
                AppUI.tip(LanguageKey.Tip_PlaylistExisted.value)
                return
            }
            
            // 创建成功, 存入数据库, 通知并返回
            PlaylistHelper.createPlaylist(name: name)
            AppUI.pop(self)
            return
        }
        
        /// 编辑歌单
        /// 编辑名字没有发生改变
        if self.songlistName! == name {
            AppUI.pop(self)
            return
        }
        
        /// 编辑名字发生改变，更新数据库
        let results = RealmHelper.shared.query(type: SonglistRealm.self, predicate: NSPredicate(format: "name = %@", self.songlistName!))
        if results.count > 0 {
            /// 更新歌单名
            let songlistRealm = SonglistRealm(value:results.first!)
            songlistRealm.name = name
            RealmHelper.shared.insert(obj: songlistRealm, filter: NSPredicate(format: "name = %@", self.songlistName!))
            
            /// 更新所有歌曲对应的歌单名
            let songs = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@", self.songlistName!))
            
            /// 获取所有待更新的歌曲信息
            var newsongs = [SongRealm]()
            for song in songs {
                let newSong = SongRealm(value: song)
                newSong.songlistName = name
                newsongs.append(newSong)
            }
            
            /// 更新
            for newsong in newsongs {
                RealmHelper.shared.insert(obj: newsong, filter: NSPredicate(format: "songlistName = %@", self.songlistName!))
            }
        }
        editClosure?(name)
        NotificationCenter.default.post(name: NoticationUpdateForCreateNewPlaylist, object: nil)
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
