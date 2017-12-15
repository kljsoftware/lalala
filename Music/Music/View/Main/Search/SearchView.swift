//
//  SearchView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索控制高度
private let searchControlHeight:CGFloat = 44, cellHeight:CGFloat = 60

/// 搜索视图模块
class SearchView: UIView {
    
    /// 搜索业务模块
    fileprivate let viewModel = SearchViewModel()
    
    /// 当前歌手列表数据
    fileprivate var artists = [ArtistDataModel]()
    fileprivate var page = 0, hasMore:Bool = false
    
    /// 搜索结果数据:  播放列表、列表歌曲选中状态、当前播放索引
    fileprivate var playlist = [FMSongDataModel](), checks = [Bool](), playIndex:IndexPath?
    fileprivate var searchPage = 0, hasMoreSearchResult:Bool = false, query:String = "", type:String = ""

    /// 搜索控制视图
    fileprivate lazy var searchControlView:SearchControlView = {
        let _searchControlView = Bundle.main.loadNibNamed("SearchControlView", owner: nil, options: nil)?[0] as! SearchControlView
        _searchControlView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: APP_HEIGHT - BOTTOM_TAB_HEIGHT - DEVICE_INDICATOR_HEIGHT)
        self.addSubview(_searchControlView)
        return _searchControlView
    }()
    
    /// 歌手列表视图
    fileprivate lazy var artistTableView:UITableView = {
        let _tableView = UITableView(frame: CGRect(x: 0, y: searchControlHeight, width: self.frame.width, height: self.frame.height - searchControlHeight - BOTTOM_TAB_HEIGHT - DEVICE_INDICATOR_HEIGHT))
        _tableView.separatorColor = UIColor.clear
        _tableView.backgroundColor = UIColor.clear
        _tableView.dataSource = self
        _tableView.delegate = self
        self.addSubview(_tableView)
        return _tableView
    }()
    
    /// 搜索结果列表视图
    fileprivate lazy var resultTableView:UITableView = {
        let _tableView = UITableView(frame: CGRect(x: 0, y: searchControlHeight, width: self.frame.width, height: self.frame.height - searchControlHeight - BOTTOM_TAB_HEIGHT - DEVICE_INDICATOR_HEIGHT))
        _tableView.separatorColor = UIColor.clear
        _tableView.backgroundColor = UIColor.clear
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.isHidden = true
        self.addSubview(_tableView)
        return _tableView
    }()
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewModel()
        setup()
        registerNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unregisterNotification()
    }
    
    // MARK: - private methods
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyPlaylistChanged), name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifySongChanged), name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(notifyAudioStatusChanged), name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForChangePlaylist, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForSongChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 切换歌单消息
    @objc private func notifyPlaylistChanged(_ sender:Notification) {
        if !PlayerHelper.shared.isOwner(owner: self) {
            setunSelectedIndex(indexPath: playIndex)
        }
    }
    
    /// 歌曲发生改变
    @objc private func notifySongChanged(_ sender:Notification) {
        if PlayerHelper.shared.isOwner(owner: self) {
            setSelectedSong()
        }
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
                    let count = playlist.count
                    if count > 0 {
                        let row = Int(arc4random() % UInt32(count))
                        PlayerHelper.shared.song = playlist[row]
                        PlayerHelper.shared.start()
                    }
                }
            }
        }
    }
    
    private func setup() {
        
        /// 搜索控制视图
        searchControlView.setup(searchBeginCloure: { [weak self] in
            self?.artistTableView.isHidden = true
            self?.resultTableView.isHidden = true
        }, cancelSearchCloure: { [weak self] in
            self?.artistTableView.isHidden = false
            self?.resultTableView.isHidden = true
        }, searchCloure: { [weak self](query, type) in
            self?.requestSearchResult(query:query, type:type, page: 0)
        }) { [weak self] in
            self?.resultTableView.isHidden = true
        }
        
        /// 列表视图
        artistTableView.register(UINib(nibName: "SearchArtistCell", bundle: nil), forCellReuseIdentifier: "kSearchArtistCell")
        resultTableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "kSearchResultCell")
        
        /// 上拉加载更多
        artistTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let weakself = self else {
                return
            }
            if weakself.hasMore {
                weakself.artistTableView.mj_footer.beginRefreshing()
                weakself.page += 1
                weakself.viewModel.requestTopArtists(page:weakself.page)
            }
        })
        
        resultTableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            guard let weakself = self else {
                return
            }
            if weakself.hasMoreSearchResult {
                weakself.resultTableView.mj_footer.beginRefreshing()
                weakself.searchPage += 1
                weakself.requestSearchResult(query: weakself.query, type: weakself.type, page: weakself.searchPage)
            }
        })
    }
    
    /// 业务模块
    private func setupViewModel() {
        viewModel.requestTopArtists(page:0)
        viewModel.requestSearchPopular()
        viewModel.setCompletion(onSuccess: { [weak self](resultModel) in
            guard let weakself = self else {
                return
            }
            if resultModel.isKind(of: SearchArtistsResultModel.self) {
                let artistsResultModel = resultModel as! SearchArtistsResultModel
                weakself.hasMore = artistsResultModel.data.has_more
                weakself.artists.append(contentsOf: artistsResultModel.data.artists)
                weakself.artistTableView.reloadData()
                weakself.artistTableView.mj_footer.endRefreshing()
            } else if resultModel.isKind(of: SearchSongResultModel.self){
                let songResultModel = resultModel as! SearchSongResultModel
                weakself.hasMoreSearchResult = songResultModel.data.has_more
                weakself.playlist.append(contentsOf: songResultModel.data.items)
                let count = songResultModel.data.items.count
                if count > 0 {
                    weakself.checks.append(contentsOf: [Bool](repeating: false, count: count))
                }
                if weakself.playlist.count > 0 {
                    let index = weakself.playIndex == nil ? 0 : weakself.playIndex!.row
                    PlayerHelper.shared.changePlaylist(playlist: weakself.playlist, playIndex: index, owner: weakself, playing:false)
                }
                weakself.resultTableView.reloadData()
                weakself.resultTableView.mj_footer.endRefreshing()
            } else {
                let popularResultModel = resultModel as! SearchPopularResultModel
                weakself.searchControlView.setup(popularDic: popularResultModel.data)
            }
        }) { [weak self](error) in
            Log.e(error)
            guard let weakself = self else {
                return
            }
            weakself.artistTableView.mj_footer.endRefreshing()
            weakself.resultTableView.mj_footer.endRefreshing()
        }
    }
    
    /// 请求搜索结果
    private func requestSearchResult(query:String, type:String, page:Int) {
        if page == 0 {
            playIndex = nil
            playlist.removeAll()
            checks.removeAll()
        }
        self.query = query
        self.type = type
        searchPage = page
        viewModel.requestSearchResult(query: query, type: type, page: page)
        resultTableView.isHidden = false
        
        /// 搜索关键词统计
        RKBISDKHelper.shared.rkTrackEvent(eventType: .search(name: query))
    }
    
    /// 设置当前播放歌曲为选中状态
    fileprivate func setSelectedSong() {
        guard let song = PlayerHelper.shared.song else {
            return
        }
        if playlist.count > 0 {
            for i in 0..<playlist.count {
                if song.sid == playlist[i].sid {
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
        (resultTableView.cellForRow(at: indexPath) as? SearchResultCell)?.setChecked(isChecked: true)
    }
    
    /// 设置未选中索引值
    fileprivate func setunSelectedIndex(indexPath:IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        if indexPath.row >= 0 && indexPath.row < checks.count {
            checks[indexPath.row] = false
        }
        (resultTableView.cellForRow(at: indexPath) as? SearchResultCell)?.setChecked(isChecked: false)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SearchView :  UITableViewDataSource, UITableViewDelegate {
    
    // MARK:  UITableViewDataSource
    // 分区(Section)个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == artistTableView ? artists.count : playlist.count
    }
    
    // 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == artistTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchArtistCell", for: indexPath) as! SearchArtistCell
            cell.update(model: artists[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchResultCell", for: indexPath) as! SearchResultCell
        cell.update(model: SongRealm.getModel(model: playlist[indexPath.row]))
        cell.setChecked(isChecked: checks[indexPath.row])
        return cell
    }
    
    // MARK: UITableViewDelegate
    // 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /// 根据歌手名搜索歌单
        if tableView == artistTableView {
            artistTableView.isHidden = true
            searchControlView.search(key: artists[indexPath.row].name)
            return
        }
        
        /// 添加至播放列表并播放
        setSelectedIndex(indexPath: indexPath)
        if PlayerHelper.shared.isOwner(owner: self) {
            PlayerHelper.shared.song = playlist[playIndex!.row]
            PlayerHelper.shared.start()
        } else {
            PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: playIndex!.row, owner: self)
        }
    }
}
