//
//  MeSleepModeCell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 休眠模式单元
class MeSleepModeCell: UITableViewCell {

    /// 模式标签
    @IBOutlet weak var modeLabel: UILabel!
    
    /// 当前选择模式
    @IBOutlet weak var checkedImageView: UIImageView!
    
    // 选中/未选中单元
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkedImageView.isHidden = !isSelected
        if selected {
            // TODO: 更新当前选择模式
        }
    }
    
    /// 获取内容
    private func getContent(_ type:SleepModeType) -> String {
        switch type {
        case .disbleTimer:
            return LanguageKey.Lang_Setting_DisableTimer.value
        case .after15mins:
            return String(format: LanguageKey.Lang_Setting_NumberMinutesLater.value, "15")
        case .after30mins:
            return String(format: LanguageKey.Lang_Setting_NumberMinutesLater.value, "30")
        case .after60mins:
            return String(format: LanguageKey.Lang_Setting_NumberMinutesLater.value, "60")
        case .after90mins:
            return String(format: LanguageKey.Lang_Setting_NumberMinutesLater.value, "90")
        case .after120mins:
            return String(format: LanguageKey.Lang_Setting_NumberMinutesLater.value, "120")
        case .custom:
            return LanguageKey.Lang_Setting_Customize.value
        }
    }
    
    /// 更新单元
    func update(type:SleepModeType) {
        modeLabel.text = getContent(type)
    }
}
