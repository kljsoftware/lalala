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
        return UITableViewCell()
    }
    
    // MARK: UITableViewDelegate
    // 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    // 头部分区(Section)视图高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    // 头部分区(Section)视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
