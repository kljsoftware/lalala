//
//  DiscoverCollectionView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 网格视图分区个数
private let discoverCollectionSectionCount = 3

/// 网格视图分区类型
private enum DiscoverCollectionType : Int {
    case rank      // 排行榜
    case enter     // 每周最热歌曲榜/新歌速递
    case playlist  // 热门歌单
}

/// 分区高度
private let sectionHeight:CGFloat = 40

/// 单元间隔空白
private let blank:CGFloat = 12

/// 排行榜单元宽高
private let rankCellWidth = (DEVICE_SCREEN_WIDTH - blank*4)/3, rankCellHeight:CGFloat = rankCellWidth + 46

/// 每周最热歌曲榜/新歌速递 单元宽高
private let enterCellWidth = (DEVICE_SCREEN_WIDTH - blank*3)/2, enterCellHeight:CGFloat = 80

/// 热门歌单单元宽高
private let playlistCellWidth = (DEVICE_SCREEN_WIDTH - blank*3)/2, playlistCellHeight:CGFloat = playlistCellWidth + 60

/// 网格视图
class DiscoverCollectionView: UIView {
    
    /// 开始加载更多
    var beginFooterRefreshingClosure:((_ page:Int) -> Void)?

    /// 模型文件
    fileprivate var model:DiscoveryMainModel?
    
    /// 网格视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var playlist = [PlaylistInfoModel]()
    fileprivate var page = 0, hasMore:Bool = true
    
    // MARK: - override methods
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "DiscoverRankCell", bundle: nil), forCellWithReuseIdentifier: "kDiscoverRankCell")
        collectionView.register(UINib(nibName: "DiscoverEnterCell", bundle: nil), forCellWithReuseIdentifier: "kDiscoverEnterCell")
        collectionView.register(UINib(nibName: "DiscoverPlaylistCell", bundle: nil), forCellWithReuseIdentifier: "kDiscoverPlaylistCell")
        collectionView.register(UINib(nibName: "DiscoverCollectionSectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kDiscoverCollectionSectionView")
        collectionView.register(UINib(nibName: "DiscoverCollectionEmptyView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DiscoverCollectionEmptyView")
        collectionView.mj_footer = MJRefreshAutoFooter(refreshingBlock: { [weak self] in
            self?.collectionViewFooterRefreshing()
        })
    }
    
    /// 开始加载更多
    private func collectionViewFooterRefreshing() {
        if !hasMore {
            return
        }
        collectionView.mj_footer.beginRefreshing()
        page += 1
        beginFooterRefreshingClosure?(page)
    }
    
    /// 停止加载更多
    private func stopFooterRefreshing() {
        if collectionView.mj_footer.isRefreshing {
            collectionView.mj_footer.endRefreshing()
        }
    }
    
    // MARK: - public methods
    /// 设置数据
    func setup(model:DiscoveryMainModel) {
        self.model = model
        playlist.append(contentsOf: model.playlist)
        collectionView.reloadData()
    }
    
    /// 加载更多的歌单数据
    func setupSonglist(songlistModel:DiscoveryLoadSonglistDataModel) {
        hasMore = songlistModel.has_more
        playlist.append(contentsOf: songlistModel.song_lists)
        collectionView.reloadData()
        stopFooterRefreshing()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension DiscoverCollectionView :  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    /// 网格分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return discoverCollectionSectionCount
    }
    
    /// 总共网格单元的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else {
            return 0
        }
        switch DiscoverCollectionType(rawValue:section)! {
        case .rank:
            return model.rank.count
        case .enter:
            return model.enter.count
        case .playlist:
            return playlist.count
        }
    }
    
    // 网格单元
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch DiscoverCollectionType(rawValue:indexPath.section)! {
        case .rank:
            let rankCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kDiscoverRankCell", for: indexPath) as! DiscoverRankCell
            rankCell.update(model: model!.rank[indexPath.row])
            return rankCell
        case .enter:
            let enterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kDiscoverEnterCell", for: indexPath) as! DiscoverEnterCell
            enterCell.update(model: model!.enter[indexPath.row])
            return enterCell
        case .playlist:
            let playlistCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kDiscoverPlaylistCell", for: indexPath) as! DiscoverPlaylistCell
            playlistCell.update(model: playlist[indexPath.row])
            return playlistCell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch DiscoverCollectionType(rawValue:indexPath.section)! {
        case .rank:
            let sectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kDiscoverCollectionSectionView", for: indexPath) as! DiscoverCollectionSectionView
            sectionCell.update(key: 0)
            return sectionCell
        case .enter:
            let sectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kDiscoverCollectionEmptyView", for: indexPath) as! DiscoverCollectionEmptyView
            sectionCell.backgroundColor = UIColor.clear
            return sectionCell
        case .playlist:
            let sectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kDiscoverCollectionSectionView", for: indexPath) as! DiscoverCollectionSectionView
            sectionCell.update(key: 1)
            return sectionCell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    /// 设置选择单元的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch DiscoverCollectionType(rawValue:indexPath.section)! {
        case .rank:
            return CGSize(width: rankCellWidth, height: rankCellHeight)
        case .enter:
            return CGSize(width: enterCellWidth, height: enterCellHeight)
        case .playlist:
            return CGSize(width: playlistCellWidth, height: playlistCellHeight)
        }
    }
    
    /// 分区大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch DiscoverCollectionType(rawValue:section)! {
        case .rank:
            return CGSize(width: DEVICE_SCREEN_WIDTH, height: sectionHeight)
        case .enter:
            return CGSize.zero
        case .playlist:
            return CGSize(width: DEVICE_SCREEN_WIDTH, height: sectionHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return blank
    }
}
