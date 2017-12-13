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
    
    // MARK: - override methods
    /// 初始化
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Common_SelectTrack.value
        cancelButton.setTitle(LanguageKey.Common_Cancel.value, for: .normal)
        doneButton.setTitle(LanguageKey.Common_Done.value, for: .normal)
        tableView.register(UINib(nibName: "MyMusicSelectSongCell", bundle: nil), forCellReuseIdentifier: "kMyMusicSelectSongCell")
    }
    
    deinit {
        Log.e("deinit")
    }
    
    /// 点击取消按钮
    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
    
    /// 点击完成按钮
    @IBAction func onDoneButtonClicked(_ sender: UIButton) {
        var songlist = [SongRealm]()
        if checks.count > 0 {
            for index in 0..<checks.count {
                if checks[index] {
                    songlist.append(self.songlist[index])
                }
            }
        }
        if songlist.count > 0 {
            selectSonglistClosure?(songlist)
        }
        AppUI.pop(self)
    }
    
    /// 设置数据
    func setup(type:SelectSourceType) {
        switch type {
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
        checks = [Bool](repeating: false, count: songlist.count)
        tableView.reloadData()
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
    }
}
