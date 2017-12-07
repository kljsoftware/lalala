//
//  MeSelectLanguageView.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度及个数
private let cellHeight:CGFloat = 44, numberOfRowsInSection = 4

/// 选择语言类型
enum SelectLanguageType : Int {
    case ja            // 日本語
    case en            // English
    case zhHans        // 简体
    case zhHant        // 繁體
}

/// 选择语言
class MeSelectLanguageView: UIView {

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!

    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Lang_Setting_SelectLanguage.value
        tableView.register(UINib(nibName: "MeSelectLanguageCell", bundle: nil), forCellReuseIdentifier: "kMeSelectLanguageCell")
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MeSelectLanguageView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMeSelectLanguageCell", for: indexPath) as! MeSelectLanguageCell
        cell.update(type: SelectLanguageType(rawValue: indexPath.row)!)
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
        switch SelectLanguageType(rawValue: indexPath.row)! {
        case .ja:
            AppUI.change(.ja)
        case .en:
            AppUI.change(.en)
        case .zhHans:
            AppUI.change(.zhHans)
        case .zhHant:
            AppUI.change(.zhHant)
        }
    }
}
