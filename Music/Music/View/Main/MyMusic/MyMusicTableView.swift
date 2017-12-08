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
    
    // MARK: - override methods
    override func awakeFromNib() {
       
        // 注册可复用的列表(tableview)头部单元
        tableView.register(UINib(nibName: "MyMusicDownloadCell", bundle: nil), forCellReuseIdentifier: "kMyMusicDownloadCell")
        tableView.register(UINib(nibName: "MyMusicLikeCell", bundle: nil), forCellReuseIdentifier: "kMyMusicLikeCell")
        tableView.register(UINib(nibName: "MyMusicSongOrderCell", bundle: nil), forCellReuseIdentifier: "kMyMusicSongOrderCell")
        tableView.register(UINib(nibName: "MyMusicNewSongOrderCell", bundle: nil), forCellReuseIdentifier: "kMyMusicNewSongOrderCell")
        tableView.mj_header = MJRefreshStateHeader(refreshingBlock: { [weak self] in
            self?.tableView.mj_header.beginRefreshing()
            self?.tableView.mj_header.endRefreshing()
        })
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
            return 1
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
    
    // 头部分区(Section)视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch MyMusicSectionType(rawValue:section)! {
        case .owned:
            return sectionHeight
        default:
            return 0
        }
    }
    
    // 头部分区(Section)视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch MyMusicSectionType(rawValue:section)! {
        case .owned:
            let orderSectionCell = Bundle.main.loadNibNamed("MyMusicSongOrderSectionCell", owner: nil, options: nil)?[0] as! MyMusicSongOrderSectionCell
            orderSectionCell.update(orderCount: 1)
            return orderSectionCell
        default:
            return nil
        }
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MyMusicSectionType(rawValue:indexPath.section)! {
        case .downloads:
            let view = Bundle.main.loadNibNamed("MyMusicDownloadView", owner: nil, options: nil)?[0] as! MyMusicDownloadView
            AppUI.push(from: self, to: view, with: CGSize(width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT))
        case .owned:
            break
        case .new:
            break
        }
    }
}
