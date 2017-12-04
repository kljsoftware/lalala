//
//  MyMusicTableView.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

import Foundation

/// 列表视图区域
class MyMusicTableView : UIView {
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - override methods
    override func awakeFromNib() {
       
        // 注册可复用的列表(tableview)头部单元
        tableView.register(UINib(nibName: "MyMusicDownloadCell", bundle: nil), forCellReuseIdentifier: "kMyMusicDownloadCell")
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
        return 2
    }
    
    // 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 2
    }
    
    // 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicDownloadCell", for: indexPath) as! MyMusicDownloadCell
            return cell
        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicSongOrderCell", for: indexPath) as! MyMusicSongOrderCell
            return cell
        }
        
        let newSongOrderCell = tableView.dequeueReusableCell(withIdentifier: "kMyMusicNewSongOrderCell", for: indexPath) as! MyMusicNewSongOrderCell
        return newSongOrderCell
    }
    
    // MARK: UITableViewDelegate
    // 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 头部分区(Section)视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {return 0}
        return 30
    }
    
    // 头部分区(Section)视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {return nil}
        let sectionHeaderView = Bundle.main.loadNibNamed("MyMusicSongOrderSectionCell", owner: nil, options: nil)?[0] as! MyMusicSongOrderSectionCell
        return sectionHeaderView
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
