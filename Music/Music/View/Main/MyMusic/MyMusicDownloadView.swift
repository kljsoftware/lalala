//
//  MyMusicDownloadView.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

private let cellHeight:CGFloat = 60, sectionHeight:CGFloat = 40

/// 我的下载界面
class MyMusicDownloadView : UIView {
    
    /// 返回、已下载、下载中、编辑按钮和列表视图
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var downloadedButton: UIButton!
    @IBOutlet weak var downloadingButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    /// 已下载、正在下载歌曲列表
    fileprivate var downloadedSonglist = [SongRealm](), checks = [Bool](), playIndex:IndexPath?
    fileprivate var downloadingSonglist = [SongRealm]()
    fileprivate let downloadingEditImage = UIImage(named:"common_btn_edit")!, downloadingEditDoneImage = UIImage(named:"common_btn_edit_done")!
    fileprivate var isDownloadingEditing = true
    
    // MARK: - override methods
    override func awakeFromNib() {
        downloadedButton.setTitle(LanguageKey.MyMusic_Downloaded.value, for: .normal)
        downloadedButton.backgroundColor = COLOR_464646
        downloadingButton.setTitle(LanguageKey.MyMusic_Downloading.value, for: .normal)
        downloadingButton.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "kSearchResultCell")
        tableView.register(UINib(nibName: "MyMusicDownloadingCell", bundle: nil), forCellReuseIdentifier: "kMyMusicDownloadingCell")
        registerNotification()
        reloadSonglist()
    }
    
    deinit {
        unregisterNotification()
        Log.e("deinit")
    }
    
    // MARK: - private methods
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifySongDownloaded), name: NoticationUpdateForSongDownload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifySongDownloaded), name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifySongDownloaded), name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyAudioStatusChanged), name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForSongDownload, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 新建歌单消息
    @objc private func notifySongDownloaded(_ sender:Notification) {
        reloadSonglist()
    }
    
    /// 歌曲状态发生改变
    @objc private func notifyAudioStatusChanged(_ sender:Notification) {
        if PlayerHelper.shared.isOwner(owner: self) {
            if PlayerHelper.shared.state == .stop {
                switch PlayerHelper.shared.playMode {
                case .all:
                    _ = PlayerHelper.shared.next()
                case .one:
                    PlayerHelper.shared.start()
                case .random:
                    let count = downloadingSonglist.count
                    if count > 0 {
                        let row = Int(arc4random() % UInt32(count))
                        PlayerHelper.shared.song = FMSongDataModel.getModel(with: downloadingSonglist[row])
                        PlayerHelper.shared.start()
                    }
                }
            }
        }
    }
    
    private func reloadSonglist() {
        if downloadedButton.isSelected {
            let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "downloadFlag = %d", 2))
            downloadedSonglist = Array(results)
            checks = [Bool](repeating: false, count: downloadedSonglist.count)
        } else {
            let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "downloadFlag = %d", 1))
            downloadingSonglist = Array(results)
        }
        
        /// 设置当前选择状态
        if PlayerHelper.shared.isOwner(owner: self) {
            setSelectedSong()
        } else {
            setunSelectedIndex(indexPath: playIndex)
        }
        
        tableView.reloadData()
    }
    
    /// 设置按钮独占触摸事件
    private func setExclusiveTouchForButtons(){
        backButton.isExclusiveTouch = true
        downloadedButton.isExclusiveTouch = true
        downloadingButton.isExclusiveTouch = true
        editButton.isExclusiveTouch = true
    }
    
    /// 设置当前播放歌曲为选中状态
    fileprivate func setSelectedSong() {
        guard let song = PlayerHelper.shared.song else {
            return
        }
        if downloadedSonglist.count > 0 {
            for i in 0..<downloadedSonglist.count {
                if song.sid == downloadedSonglist[i].sid {
                    setSelectedIndex(indexPath: IndexPath(row: i, section: 0))
                    break
                }
            }
        }
    }
    
    /// 设置选中索引值
    fileprivate func setSelectedIndex(indexPath:IndexPath?) {
        setunSelectedIndex(indexPath: playIndex)
        guard let indexPath = indexPath else {
            return
        }
        if indexPath.row >= 0 && indexPath.row < checks.count {
            checks[indexPath.row] = true
        }
        playIndex = indexPath
        (tableView.cellForRow(at: indexPath) as? SearchResultCell)?.setChecked(isChecked: true)
    }
    
    /// 设置未选中索引值
    fileprivate func setunSelectedIndex(indexPath:IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        if indexPath.row >= 0 && indexPath.row < checks.count {
            checks[indexPath.row] = false
        }
        (tableView.cellForRow(at: indexPath) as? SearchResultCell)?.setChecked(isChecked: false)
    }
    
    // MARK: - IBAction methods
    /// 点击已下载按钮
    @IBAction func onDownloadedButtonClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.backgroundColor = COLOR_464646
            sender.isSelected = true
            downloadingButton.isSelected = false
            downloadingButton.backgroundColor = UIColor.clear
            editButton.setImage(downloadingEditImage, for: .normal)
            reloadSonglist()
        }
    }
    
    /// 点击下载中按钮
    @IBAction func onDownloadingButtonClicked(_ sender: UIButton) {
        if !sender.isSelected {
            sender.backgroundColor = COLOR_464646
            sender.isSelected = true
            downloadedButton.isSelected = false
            downloadedButton.backgroundColor = UIColor.clear
            if isDownloadingEditing {
                editButton.setImage(downloadingEditImage, for: .normal)
            } else {
                editButton.setImage(downloadingEditDoneImage, for: .normal)
            }
            reloadSonglist()
        }
    }
    
    /// 点击编辑按钮
    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        if downloadedButton.isSelected {
            let view = Bundle.main.loadNibNamed("MyMusicSelectSongView", owner: nil, options: nil)?[0] as! MyMusicSelectSongView
            view.setup(songlist: downloadedSonglist)
            AppUI.push(to: view, with: APP_SIZE)
        } else {
            if isDownloadingEditing {
                editButton.setImage(downloadingEditDoneImage, for: .normal)
            } else {
                editButton.setImage(downloadingEditImage, for: .normal)
            }
            isDownloadingEditing = !isDownloadingEditing
        }
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyMusicDownloadView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadedButton.isSelected ? downloadedSonglist.count : downloadingSonglist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if downloadedButton.isSelected {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchResultCell", for: indexPath) as! SearchResultCell
            cell.update(model: downloadedSonglist[indexPath.row])
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicDownloadingCell", for: indexPath) as! MyMusicDownloadingCell
        cell.update(model: downloadingSonglist[indexPath.row])
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 分区(Section)视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight
    }
    
    // 分区(Section)视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = Bundle.main.loadNibNamed("MyMusicSonglistSectionView", owner: nil, options: nil)?[0] as! MyMusicSonglistSectionView
        return view
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if downloadedButton.isSelected {
            let playlist = FMSongDataModel.getModels(with: downloadedSonglist)
            setSelectedIndex(indexPath: indexPath)
            if PlayerHelper.shared.isOwner(owner: self) {
                PlayerHelper.shared.song = playlist[playIndex!.row]
                PlayerHelper.shared.start()
            } else {
                PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: playIndex!.row, owner: self)
            }
        }
    }
}
