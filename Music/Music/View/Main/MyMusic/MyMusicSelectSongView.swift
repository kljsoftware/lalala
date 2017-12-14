//
//  MyMusicSelectSongView.swift
//  Music
//
//  Created by hzg on 2017/12/13.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 常量
private let cellHeight:CGFloat = 60

/// 歌曲来源
enum SelectSourceType : Int {
    case favorite   /// 我喜爱的音乐
    case download   /// 我下载的音乐
}

/// 底部按钮样式
enum BottomViewSelectType : Int {
    case none    /// 无
    case add     /// 仅添加歌单
    case both    /// 删除和添加歌单
}

/// 选择歌曲页面
class MyMusicSelectSongView: UIView {
    
    /// 选择的歌曲
    var selectSonglistClosure:(([SongRealm])->Void)?
    
    /// 取消按钮
    @IBOutlet weak var cancelButton: UIButton!
    
    /// 完成按钮
    @IBOutlet weak var doneButton: UIButton!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 歌曲信息
    fileprivate var songlist = [SongRealm]()
    
    /// 歌曲选中状态 0表示未选中， 1表示选中
    fileprivate var checks = [Bool]()
    
    /// 底部视图
    @IBOutlet weak var bottomView: UIView!
    
    /// 删除视图
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteWidthLayoutConstraint: NSLayoutConstraint!
    
    /// 添加到歌单
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addLabel: UILabel!
    
    /// 底部按钮样式
    private var type = BottomViewSelectType.none
    
    // MARK: - override methods
    /// 初始化
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Common_SelectTrack.value
        cancelButton.setTitle(LanguageKey.Common_Cancel.value, for: .normal)
        doneButton.setTitle(LanguageKey.Common_Done.value, for: .normal)
        tableView.register(UINib(nibName: "MyMusicSelectSongCell", bundle: nil), forCellReuseIdentifier: "kMyMusicSelectSongCell")
        deleteLabel.text = LanguageKey.Common_Delete.value
        addLabel.text = LanguageKey.MyMusic_AddToPlaylist.value
    }
    
    deinit {
        Log.e("deinit")
    }
    
    /// 点击取消按钮
    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
    
    /// 批量添加歌曲
    @IBAction func onBatchAddButtonClicked(_ sender: UIButton) {
        let songlist = getSelectSongs()
        PlaylistSheet.addToPlaylist(modes: songlist)
    }
    
    /// 批量删除歌曲
    @IBAction func onBatchDeleteButtonClicked(_ sender: UIButton) {
        let songlist = getSelectSongs()
        if songlist.count > 0 {
            let message = String(format: LanguageKey.Tip_ConfirmToDeleteNumberTracks.value, "\(songlist.count)")
            AppUI.showAlert(message: message, okClosure: { [weak self] in
                guard let wself = self else {
                    return
                }
                
                /// 删除当前数据
                for i in 0..<songlist.count {
                    for j in 0..<wself.songlist.count {
                        if songlist[i].sid == wself.songlist[j].sid {
                            wself.songlist.remove(at: j)
                            break
                        }
                    }
                }
                
                /// 选中限重置
                wself.checks = [Bool](repeating: false, count: wself.songlist.count)
                
                PlaylistHelper.batchDeletePlaylist(modes: songlist)
                wself.tableView.reloadData()
                
                /// 通知歌单发生变化
                NotificationCenter.default.post(name: NoticationUpdateForPlaylistChanged, object: nil)
            })
        }

    }
    
    /// 点击完成按钮
    @IBAction func onDoneButtonClicked(_ sender: UIButton) {
        switch type {
        case .none:
            let songlist = getSelectSongs()
            if songlist.count > 0 {
                selectSonglistClosure?(songlist)
            }
        default:
            break
        }
        AppUI.pop(self)
    }
    
    /// 设置数据
    func setup(songlist:[SongRealm], type:BottomViewSelectType) {
        self.songlist = songlist
        self.type = type
        switch type {
        case .none:
            bottomView.isHidden = true
        case .add:
            deleteView.isHidden = true
            deleteWidthLayoutConstraint.constant = 0
        case .both:
            deleteView.isHidden = false
            deleteWidthLayoutConstraint.constant = DEVICE_SCREEN_WIDTH/2
        }
        checks = [Bool](repeating: false, count: songlist.count)
        tableView.reloadData()
    }
    
    /// 更新按钮状态
    fileprivate func updateBottomViewStatus() {
        var hasSelected = false
        for check in checks {
            if check {
                hasSelected = true
                break
            }
        }
        
        addButton.isEnabled = hasSelected
        deleteButton.isEnabled = hasSelected
        addLabel.isEnabled = !hasSelected
        deleteLabel.isEnabled = !hasSelected
    }
    
    /// 获取选中歌曲
    fileprivate func getSelectSongs() -> [SongRealm] {
        var songlist = [SongRealm]()
        if checks.count > 0 {
            for index in 0..<checks.count {
                if checks[index] {
                    songlist.append(self.songlist[index])
                }
            }
        }
        return songlist
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyMusicSelectSongView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songlist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicSelectSongCell", for: indexPath) as! MyMusicSelectSongCell
        cell.update(model: songlist[indexPath.row])
        cell.setChecked(checked: checks[indexPath.row])
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MyMusicSelectSongCell else {
            return
        }
        checks[indexPath.row] = !checks[indexPath.row]
        cell.setChecked(checked: checks[indexPath.row])
        updateBottomViewStatus()
    }
}
