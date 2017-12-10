//
//  MyMusicTableView.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 分区总数
private let sectionCount = 3, cellHeight:CGFloat = 48, newCellHeight:CGFloat = 80, sectionHeight:CGFloat = 30

/// 分区类型
private enum MyMusicSectionType : Int {
    case downloads     // 我的下载
    case owned         // 创建的歌单
    case new           // 新建歌单
}

/// 列表视图区域
class MyMusicTableView : UIView {
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 本地歌单，除喜爱歌单外
    fileprivate var songlists = [SonglistRealm]()
    
    // MARK: - override methods
    override func awakeFromNib() {
        /// 注册可复用单元
        tableView.register(UINib(nibName: "MyMusicDownloadCell", bundle: nil), forCellReuseIdentifier: "kMyMusicDownloadCell")
        tableView.register(UINib(nibName: "MyMusicLikeCell", bundle: nil), forCellReuseIdentifier: "kMyMusicLikeCell")
        tableView.register(UINib(nibName: "MyMusicSongOrderCell", bundle: nil), forCellReuseIdentifier: "kMyMusicSongOrderCell")
        tableView.register(UINib(nibName: "MyMusicNewSongOrderCell", bundle: nil), forCellReuseIdentifier: "kMyMusicNewSongOrderCell")
        
        /// 加载本地歌单数据
        reloadSonglists()
        
        /// 注册通知
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
    }
    
    // MARK: - private methods
    // 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyCreateNewPlaylist), name: NoticationUpdateForCreateNewPlaylist, object: nil)
    }
    
    // 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForCreateNewPlaylist, object: nil)
    }
    
    /// 新建歌单消息
    @objc private func notifyCreateNewPlaylist(_ sender:Notification) {
        reloadSonglists()
    }
    
    /// 重新加载本地歌单
    fileprivate func reloadSonglists() {
        let results = RealmHelper.shared.query(type: SonglistRealm.self)
        songlists = results.sorted(by: {$0.0.date >= $0.1.date})
        tableView.reloadData()
    }
    
    // MARK: - public methods
    /// 编辑或完成
    func setEditing(isEditing:Bool) {
        
        /// 设置编辑状态
        tableView.isEditing = isEditing
        
        /// 排序完成，更新本地数据库
        if !isEditing {
            for songlist in songlists.reversed() {
                RealmHelper.shared.insert(obj: SonglistRealm(value: [songlist.name, Date()]), filter: NSPredicate(format: "name = %@", songlist.name))
            }
            reloadSonglists()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyMusicTableView :  UITableViewDataSource, UITableViewDelegate {
    
    // MARK:  UITableViewDataSource
    // 分区(Section)个数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    
    // 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch MyMusicSectionType(rawValue:section)! {
        case .downloads:
            return 1
        case .owned:
            return songlists.count + 1
        case .new:
            return 1
        }
    }
    
    // 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch MyMusicSectionType(rawValue:indexPath.section)! {
        case .downloads:
            let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicDownloadCell", for: indexPath) as! MyMusicDownloadCell
            return cell
        case .owned:
            
            /// 我喜爱的歌单
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicLikeCell", for: indexPath) as! MyMusicLikeCell
                return cell
            }
            
            /// 其它歌单
            let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicSongOrderCell", for: indexPath) as! MyMusicSongOrderCell
            cell.update(model: songlists[indexPath.row-1])
            return cell
        case .new:
            let newSongOrderCell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicNewSongOrderCell", for: indexPath) as! MyMusicNewSongOrderCell
            return newSongOrderCell
        }
    }
    
    // MARK: UITableViewDelegate
    // 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch MyMusicSectionType(rawValue:indexPath.section)! {
        case .new:
            return newCellHeight
        default:
            return cellHeight
        }
    }
    
    // 分区(Section)视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch MyMusicSectionType(rawValue:section)! {
        case .owned:
            return sectionHeight
        default:
            return 0
        }
    }
    
    // 分区(Section)视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch MyMusicSectionType(rawValue:section)! {
        case .owned:
            let orderSectionCell = Bundle.main.loadNibNamed("MyMusicSongOrderSectionCell", owner: nil, options: nil)?[0] as! MyMusicSongOrderSectionCell
            orderSectionCell.update(orderCount: songlists.count+1)
            return orderSectionCell
        default:
            return nil
        }
    }
    
    /// 是否显示删除按钮
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let type = MyMusicSectionType(rawValue:indexPath.section)!
        return (type == .owned) && indexPath.row != 0 ? .delete : .none
    }
    
    /// 是否可以移动
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let type = MyMusicSectionType(rawValue:indexPath.section)!
        return (type == .owned) && indexPath.row != 0
    }
    
    /*用户拖动某行sourceIndexPath经过目标行proposedDestinationIndexPath上方时，
     调用此函数询问是否可以移动，若不能移动则返回一个新的目的indexPath，
     否则直接返回proposedDestinationIndexPath,若无特别要求不需要实现*/
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
       
        /// 可以移动
        let type = MyMusicSectionType(rawValue:proposedDestinationIndexPath.section)!
        if (type == .owned) && proposedDestinationIndexPath.row != 0 {
            return proposedDestinationIndexPath
        }
        
        /// 上方滑至第一个
        if type == .new  {
            return IndexPath(row: songlists.count, section: MyMusicSectionType.owned.rawValue)
        }
        
        /// 下方滑至最后一个
        return IndexPath(row: 1, section: MyMusicSectionType.owned.rawValue)
    }
    
    /// 数据交换
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let type = MyMusicSectionType(rawValue:destinationIndexPath.section)!
        if (type == .owned) && destinationIndexPath.row != 0 {
            let data  = songlists[sourceIndexPath.row-1]
            songlists.remove(at: sourceIndexPath.row-1)
            songlists.insert(data, at: destinationIndexPath.row-1)
        }
    }
    
    /// 删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let songlist = songlists[indexPath.row - 1]
            RealmHelper.shared.delete(obj: songlist)
            songlists.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MyMusicSectionType(rawValue:indexPath.section)! {
        case .downloads:
            let view = Bundle.main.loadNibNamed("MyMusicDownloadView", owner: nil, options: nil)?[0] as! MyMusicDownloadView
            AppUI.push(from: self, to: view, with: CGSize(width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT))
        case .owned:
            let view = Bundle.main.loadNibNamed("MyMusicSonglistView", owner: nil, options: nil)?[0] as! MyMusicSonglistView
            view.songlistName = indexPath.row == 0 ? LanguageKey.MyMusic_Favorite.value : songlists[indexPath.row - 1].name
            AppUI.push(from: self, to: view, with: APP_SIZE)
        case .new:
            break
        }
    }
}
