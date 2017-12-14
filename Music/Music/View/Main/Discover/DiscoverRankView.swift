//
//  DiscoverRankView.swift
//  Music
//
//  Created by hzg on 2017/12/9.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度
private let cellHeight:CGFloat = 60

/// 歌曲排行榜
class DiscoverRankView: UIView {
    
    /// 排行榜信息
    var rankInfo:RankInfoModel? {
        didSet {
            if rankInfo != nil {
                titleLabel.text = rankInfo!.title
                let rankId = rankInfo!.rank_id == 0 ? 31000 : rankInfo!.rank_id
                viewModel.requestRankList(randId: rankId)
            }
        }
    }

    /// 业务模块
    private let viewModel = DiscoverViewModel()
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 歌曲数据
    fileprivate var playlist = [FMSongDataModel](), checks = [Bool](), playIndex:IndexPath?
    
    /// MARK: - override methods
    override func awakeFromNib() {
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "kSearchResultCell")
        viewModel.setCompletion(onSuccess: { [weak self](resultModel) in
            guard let wself = self else {
                return
            }
            wself.playlist = (resultModel as! DiscoverRankResultModel).data.songs
            wself.checks = [Bool](repeating: false, count: wself.playlist.count)
            wself.tableView.reloadData()
        }) { (error) in
            Log.e(error)
        }
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
        Log.e("deinit")
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
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
        if !setSelectedSong() {
            setunSelectedIndex(indexPath: playIndex)
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
    
    /// 设置当前播放歌曲为选中状态
    fileprivate func setSelectedSong() -> Bool {
        guard let song = PlayerHelper.shared.song else {
            return false
        }
        if playlist.count > 0 {
            for i in 0..<playlist.count {
                if song.sid == playlist[i].sid {
                    setSelectedIndex(indexPath: IndexPath(row: i, section: 0))
                    return true
                }
            }
        }
        return false
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
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DiscoverRankView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchResultCell", for: indexPath) as! SearchResultCell
        cell.update(model: SongRealm.getModel(model: playlist[indexPath.row]), serial: indexPath.row+1)
        cell.setChecked(isChecked: checks[indexPath.row])
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setSelectedIndex(indexPath: indexPath)
        if PlayerHelper.shared.isOwner(owner: self) {
            PlayerHelper.shared.song = playlist[playIndex!.row]
            PlayerHelper.shared.start()
        } else {
            PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: playIndex!.row, owner: self)
        }
    }
}
