//
//  MeSleepModeCell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 休眠模式类型
enum SleepModeType : Int {
    case disbleTimer  // 不开启定时/关闭
    case after15mins  // 15分钟后休眠
    case after30mins  // 30分钟后休眠
    case after60mins  // 60分钟后休眠
    case after90mins  // 90分钟后休眠
    case after120mins // 120分钟后休眠
    case custom       // 自定义时间休眠
}

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
    }
    
    /// 更新单元
    func update(type:SleepModeType) {
        modeLabel.text = dic[type]
    }
}
