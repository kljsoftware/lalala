//
//  MyMusicSonglistView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌单视图
class MyMusicSonglistView: UIView {
    
    /// 歌单名
    var songlistName = ""

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 列表头部视图
    fileprivate var songlistHeaderView:MyMusicSonglistHeaderView!
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Common_Playlist.value
        tableView.tableHeaderView = tableViewHeaderView()
//        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@", songlistName))
        
    }
    
    // MARK: - private methods
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
