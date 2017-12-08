//
//  PlaylistSheet.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 常量
private let duration:TimeInterval = 0.3, cellHeight:CGFloat = 44, contentHeight:CGFloat = 262

/// 歌单弹出框
class PlaylistSheet: UIView {
    
    /// 罩层按钮
    @IBOutlet weak var coverButton: UIButton!
    
    /// 添加到歌单
    @IBOutlet weak var playlistAddLabel: UILabel!
    
    /// 新建歌单
    @IBOutlet weak var createPlaylistLabel: UILabel!
    
    /// 歌单列表
    @IBOutlet weak var tableView: UITableView!
    
    /// 列表居底约束
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    /// 歌曲模型列表
    fileprivate var songlist = [SonglistRealm]()
    
    /// MARK: - class methods
    class func show() {
        let view = Bundle.main.loadNibNamed("PlaylistSheet", owner: nil, options: nil)?[0] as! PlaylistSheet
        let window = (UIApplication.shared.delegate as! AppDelegate).window!
        window.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(APP_SIZE.width)
            maker.height.equalTo(APP_SIZE.height)
            maker.bottom.equalTo(window)
        }
        
        view.bottomLayoutConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            view.layoutIfNeeded()
            view.coverButton.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        }
    }
    
    /// 初始化
    override func awakeFromNib() {
        playlistAddLabel.text = LanguageKey.MyMusic_AddToPlaylist.value
        createPlaylistLabel.text = LanguageKey.MyMusic_CreatePlaylist.value
        tableView.register(UINib(nibName: "PlaylistSheetCell", bundle: nil), forCellReuseIdentifier: "kPlaylistSheetCell")
        reloadSonglists()
    }
    
    /// 重新加载本地歌单
    fileprivate func reloadSonglists() {
        let results = RealmHelper.shared.query(type: SonglistRealm.self)
        songlist = results.sorted(by: {$0.0.date >= $0.1.date})
        tableView.reloadData()
    }
    
    @IBAction func onCoverButtonClicked(_ sender: UIButton) {
        hide()
    }
    /// 点击新建歌单
    @IBAction func onCreatePlaylistButtonClicked(_ sender: UIButton) {
        let view = Bundle.main.loadNibNamed("MyMusicNewSonglistView", owner: nil, options: nil)?[0] as! MyMusicNewSonglistView
        AppUI.push(to: view, with: APP_SIZE)
    }
    
    fileprivate func hide() {
        bottomLayoutConstraint.constant = -contentHeight
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.coverButton.backgroundColor = UIColor(white: 0.0, alpha: 0)
        }, completion: { [weak self](finished) in
            self?.removeFromSuperview()
        })
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension PlaylistSheet :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songlist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kPlaylistSheetCell", for: indexPath) as! PlaylistSheetCell
        cell.update(name: songlist[indexPath.row].name)
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hide()
    }
}
