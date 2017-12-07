//
//  MeSleepModeView.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度及个数
private let cellHeight:CGFloat = 44, numberOfRowsInSection = 7

/// 休眠模式
class MeSleepModeView: UIView {
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 定时模式
    @IBOutlet weak var modelLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageHelper.shared.getLanguageText(by: "Setting_SleepMode")
        tableView.register(UINib(nibName: "MeSleepModeCell", bundle: nil), forCellReuseIdentifier: "kMeSleepModeCell")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MeSleepModeView :  UITableViewDataSource, UITableViewDelegate {
    
    // MARK:  UITableViewDataSource
    // 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    // 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMeSleepModeCell", for: indexPath) as! MeSleepModeCell
        cell.update(type: SleepModeType(rawValue: indexPath.row)!)
        return cell
    }
    
    // MARK: UITableViewDelegate
    // 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
    }
}
