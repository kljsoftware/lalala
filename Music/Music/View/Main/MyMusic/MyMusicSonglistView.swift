//
//  MyMusicSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

private let cellHeight:CGFloat = 60

/// 歌单视图
class MyMusicSonglistView: UIView {
    
    /// 歌单名
    var songlistName:String? {
        didSet {
            if songlistName != nil {
                setup()
            }
        }
    }

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 列表头部视图
    fileprivate var songlistHeaderView:MyMusicSonglistHeaderView!
    
    /// 歌曲模型列表
    fileprivate var songlist = [SongRealm]()
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Common_Playlist.value
        tableView.tableHeaderView = tableViewHeaderView()
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "kSearchResultCell")
    }
    
    // MARK: - private methods
    /// 初始化
    private func setup() {
        songlistHeaderView.update(name: songlistName!)
        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@", songlistName!))
        if results.count > 0 {
            songlistHeaderView.update(imgurl: results.first!.coverURL)
            songlist = Array(results)
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
        return containerView
    }
    
    /// 点击编辑按钮
    @IBAction func onEditButtonClicked(_ sender: UIButton) {
        ActionSheet.show(items: [LanguageKey.Guide_EditPlaylistInfo.value, LanguageKey.Guide_MultipleOperate.value, LanguageKey.Common_Cancel.value]) { (index) in
            
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
        cell.update(realmModel: songlist[indexPath.row])
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
        let playlist = FMSongDataModel.getModels(with: songlist)
        PlayerHelper.shared.changePlaylist(playlist: playlist, playIndex: indexPath.row)
    }
}
