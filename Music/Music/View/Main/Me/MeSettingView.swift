//
//  MeSettingView.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度及个数
private let cellHeight:CGFloat = 44, numberOfRowsInSection = 4

/// 设置模式类型
enum SettingModeType : Int {
    case last_select_channel  // 记住上次选中频道
    case auto_play            // 自动播放
    case current_language     // 当前界面语言
    case version              // 当前版本
}

/// 设置视图
class MeSettingView: UIView {

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Setting_Setting.value
        tableView.register(UINib(nibName: "MeSettingType0Cell", bundle: nil), forCellReuseIdentifier: "kMeSettingType0Cell")
        tableView.register(UINib(nibName: "MeSettingType1Cell", bundle: nil), forCellReuseIdentifier: "kMeSettingType1Cell")
    }
    
    // MARK: - private methods
    fileprivate func getContent(type:SettingModeType) -> String {
        switch type {
        case .last_select_channel:
            return LanguageKey.Setting_LastSelectedChannel.value
        case .auto_play:
            return LanguageKey.Setting_AutoPlay.value
        case .current_language:
            return LanguageKey.Setting_CurrentDisplayLanguage.value
        case .version:
            return LanguageKey.Setting_CurrentVersion.value
        }
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MeSettingView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = SettingModeType(rawValue: indexPath.row)!
        let content = getContent(type: type)
        switch type {
        case .last_select_channel, .auto_play:
            let cell = tableView.dequeueReusableCell(withIdentifier: "kMeSettingType0Cell", for: indexPath) as! MeSettingType0Cell
            cell.update(text: content)
            return cell
        case .current_language, .version:
            let cell = tableView.dequeueReusableCell(withIdentifier: "kMeSettingType1Cell", for: indexPath) as! MeSettingType1Cell
            cell.update(text: content)
            return cell
        }
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch SettingModeType(rawValue: indexPath.row)! {
        case .last_select_channel:
            break
        case .auto_play:
            break
        case .current_language:
            let view = Bundle.main.loadNibNamed("MeSelectLanguageView", owner: nil, options: nil)?[0] as! MeSelectLanguageView
            AppUI.push(to: view, with: CGSize(width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT))
        case .version:
            break
        }
    }
}
