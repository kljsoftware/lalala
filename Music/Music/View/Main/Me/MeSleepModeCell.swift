//
//  MeSleepModeCell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 内容字典
private let lan_timer_str = LanguageHelper.shared.getLanguageText(by: "Setting_Timer")
private var dic = [SleepModeType.disbleTimer:LanguageHelper.shared.getLanguageText(by: "Setting_DisableTimer"),
                   SleepModeType.after15mins:String(format: lan_timer_str, "15"),
                   SleepModeType.after30mins:String(format: lan_timer_str, "30"),
                   SleepModeType.after60mins:String(format: lan_timer_str, "60"),
                   SleepModeType.after90mins:String(format: lan_timer_str, "90"),
                   SleepModeType.after120mins:String(format: lan_timer_str, "120"),
                   SleepModeType.custom:LanguageHelper.shared.getLanguageText(by: "Setting_Customize")]

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
    
    /// 更新单元
    func update(type:SleepModeType) {
        modeLabel.text = dic[type]
    }
}
