//
//  MyMusicSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

private let cellHeight:CGFloat = 60, sectionHeight:CGFloat = 40

/// 歌单视图
class MyMusicSonglistView: UIView {
    
    /// 歌单名
    var songlistName:String? {
        didSet {
            if songlistName != nil {
                isLocalSonglist = true
                setup()
            }
        }
    }
    
    /// 网络歌单信息
    var playlistInfo:PlaylistInfoModel? {
        didSet {
            isLocalSonglist = false
            setupViewModel()
        }
    }
    
    /// 判断是否是本地歌曲
    fileprivate var isLocalSonglist = false
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 列表头部视图
    fileprivate var songlistHeaderView:MyMusicSonglistHeaderView!
    
    /// 歌曲模型列表
    fileprivate var songlist = [SongRealm](), checks = [Bool](), playIndex:IndexPath?
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Common_Playlist.value
        tableView.tableHeaderView = tableViewHeaderView()
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "kSearchResultCell")
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
        Log.e("deinit")
    }
    
    // MARK: - private methods
    /// 初始化
    private func setup() {
        songlistHeaderView.update(name: songlistName!)
        reloadLocalSonglist()
    }
    
    /// 初始化业务模块
    private func setupViewModel() {
        let viewModel = DiscoverViewModel()
        viewModel.requestDiscoverSonglistDetail(songlistId: playlistInfo!.song_list_id)
        viewModel.setCompletion(onSuccess: { [weak self](resultModel) in
            guard let wself = self else {
                return
            }
            let playlist = (resultModel as! DiscoverSongListResultModel).data.songs
            wself.songlist = SongRealm.getModels(models:playlist)
            wself.checks = [Bool](repeating: false, count: wself.songlist.count)
            wself.songlistHeaderView.update(name: wself.playlistInfo!.song_list_name)
            wself.songlistHeaderView.update(imgurl: wself.playlistInfo!.song_list_cover)
            wself.tableView.reloadData()
        }) { (error) in
            Log.e("error = \(error)")
        }
    }
    
    /// 列表头部视图
    private func tableViewHeaderView() -> UIView {
        let containerView = UIView(frame:CGRect(x: 0, y: 0, width: DEVICE_SCREEN_WIDTH, height: 120))
        containerView.clipsToBounds = true
        songlistHeaderView = Bundle.main.loadNibNamed("MyMusicSonglistHeaderView", owner: nil, options: nil)?[0] as! MyMusicSonglistHeaderView
        containerView.addSubview(songlistHeaderView)
        songlistHeaderView.snp.makeConstraints { (maker) in
            maker.left.top.width.height.equalTo(containerView)
        }
        songlistHeaderView.clickedClosure = { [weak self] in
            guard let wself = self else {
                return
            }
            /// 暂无内容
            if wself.songlist.count == 0 {
                AppUI.tip(LanguageKey.Common_NoContent.value)
                return
            }
            /// 播放第一首歌
            let playlist = FMSongDataModel.getModels(with: wself.songlist)
            PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: 0, owner: wself)
            wself.tableView.cellForRow(at: IndexPath(row: 0, section: 0))?.setSelected(true, animated: false)
        }
        return containerView
    }
    
    /// 重新加载数据
    fileprivate func reloadLocalSonglist() {
        if isLocalSonglist {
            let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@", songlistName!))
            if results.count > 0 {
                songlistHeaderView.update(imgurl: results.first!.coverURL)
                songlist = Array(results)
                checks = [Bool](repeating: false, count: songlist.count)
            }
        }
        tableView.reloadData()
    }
    
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaylistChanged), name: NoticationUpdateForPlaylistChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaylistChanged), name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaylistChanged), name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaylistChanged), name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForPlaylistChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 新建歌单消息
    @objc private func notifyPlaylistChanged(_ sender:Notification) {
        reloadLocalSonglist()
        if PlayerHelper.shared.isOwner(owner: self) {
            setSelectedSong()
        } else {
            setunSelectedIndex(indexPath: playIndex)
        }
    }
    
    /// 设置当前播放歌曲为选中状态
    fileprivate func setSelectedSong() {
        guard let song = PlayerHelper.shared.song else {
            return
        }
        if songlist.count > 0 {
            for i in 0..<songlist.count {
                if song.sid == songlist[i].sid {
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
    
    /// 点击编辑按钮
    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        
        if isLocalSonglist && songlistName! != LanguageKey.MyMusic_Favorite.value {
            ActionSheet.show(items: [LanguageKey.Guide_EditPlaylistInfo.value, LanguageKey.Guide_MultipleOperate.value], cancel: LanguageKey.Common_Cancel.value) { [weak self](index) in
                guard let wself = self else {
                    return
                }
                switch index {
                case 0: /// 编辑歌单信息
                    let view = Bundle.main.loadNibNamed("MyMusicNewSonglistView", owner: nil, options: nil)?[0] as! MyMusicNewSonglistView
                    view.setup(type: 1, songlistName: wself.songlistName!)
                    view.editClosure = {[weak self](songlistname) in
                        guard let wself = self else {
                            return
                        }
                        wself.songlistName = songlistname
                        wself.songlistHeaderView.update(name: songlistname)
                    }
                    AppUI.push(to: view, with: APP_SIZE)
                case 1: /// 批处理操作
                    let view = Bundle.main.loadNibNamed("MyMusicSelectSongView", owner: nil, options: nil)?[0] as! MyMusicSelectSongView
                    view.setup(songlist: wself.songlist)
                    AppUI.push(to: view, with: APP_SIZE)
                default:
                    break
                }
            }
        } else {
            let view = Bundle.main.loadNibNamed("MyMusicSelectSongView", owner: nil, options: nil)?[0] as! MyMusicSelectSongView
            view.setup(songlist: songlist)
            AppUI.push(to: view, with: APP_SIZE)
        }
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyMusicSonglistView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songlist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchResultCell", for: indexPath) as! SearchResultCell
        cell.update(model: songlist[indexPath.row])
        cell.setChecked(isChecked: checks[indexPath.row])
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
        view.update(isHiddenAdded: !(isLocalSonglist && songlistName != nil && songlistName! != LanguageKey.MyMusic_Favorite.value))
        
        /// 下一首
        view.nextClosure = {
            
        }
        
        /// 循环模式
        view.cycleClosure = {
            
        }
        
        /// 添加歌曲到歌单，只有本地非喜爱歌单有这个功能
        view.addClosure = {
            ActionSheet.show(items: [LanguageKey.MyMusic_Favorite.value, LanguageKey.MyMusic_MyDownload.value], cancel:LanguageKey.Common_Cancel.value, selectedIndex: {(index) in
                let view = Bundle.main.loadNibNamed("MyMusicSelectSongView", owner: nil, options: nil)?[0] as! MyMusicSelectSongView
                var songlist = [SongRealm]()
                switch SelectSourceType(rawValue:index)! {
                case .favorite:
                    let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@", LanguageKey.MyMusic_Favorite.value))
                    if results.count > 0 {
                        songlist = Array(results)
                    }
                case .download:
                    let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "downloadFlag = %d", 2))
                    if results.count > 0 {
                        songlist = Array(results)
                    }
                }
                view.setup(songlist: songlist)
                view.selectSonglistClosure = { [weak self](songlist) in
                    guard let wself = self else {
                        return
                    }
                    /// 只有本地非喜爱歌单有这个功能，所以songlistName肯定不为空
                    PlaylistHelper.batchAddToPlaylist(modes: songlist, name: wself.songlistName!)
                }
                AppUI.push(to: view, with: APP_SIZE)
            })
        }
        return view
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let playlist = FMSongDataModel.getModels(with: songlist)
        setSelectedIndex(indexPath: indexPath)
        if PlayerHelper.shared.isOwner(owner: self) {
            PlayerHelper.shared.song = playlist[playIndex!.row]
            PlayerHelper.shared.start()
        } else {
            PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: playIndex!.row, owner: self)
        }
    }
}
