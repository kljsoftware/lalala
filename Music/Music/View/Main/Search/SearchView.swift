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
    
    /// 搜索结果数据
    fileprivate var results = [FMSongDataModel]()
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
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
                weakself.results.append(contentsOf: songResultModel.data.items)
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
            results.removeAll()
        }
        self.query = query
        self.type = type
        searchPage = page
        viewModel.requestSearchResult(query: query, type: type, page: page)
        resultTableView.isHidden = false
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
        return tableView == artistTableView ? artists.count : results.count
    }
    
    // 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == artistTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchArtistCell", for: indexPath) as! SearchArtistCell
            cell.update(model: artists[indexPath.row])
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchResultCell", for: indexPath) as! SearchResultCell
        cell.update(model: results[indexPath.row])
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
        PlayerHelper.shared.changePlaylist(playlist: results, playIndex: indexPath.row)
    }
}
