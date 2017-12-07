//
//  MeTableViewCell.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 按钮类型
enum MeTableCellType:Int {
    case amount, sleepMode, setting, share
}

/// 图标字典
private let iconDict = [MeTableCellType.amount:UIImage(named:"mine_ic_amount")!,
                        MeTableCellType.sleepMode:UIImage(named:"mine_ic_sleep_mode")!,
                        MeTableCellType.setting:UIImage(named:"mine_ic_setting")!,
                        MeTableCellType.share:UIImage(named:"mine_ic_share")!]

class MeTableViewCell: UITableViewCell {

    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    /// 获取内容
    private func getContent(_ type:MeTableCellType) -> String {
        switch type {
        case .amount:
            return LanguageKey.Lang_Setting_TodayRemainingDownloads.value
        case .sleepMode:
            return LanguageKey.Lang_Setting_SleepMode.value
        case .setting:
            return LanguageKey.Lang_Setting_Setting.value
        case .share:
            return LanguageKey.Lang_Setting_ShareThisApp.value
        }
    }
    
    /// 更新单元
    func update(type:MeTableCellType) {
        iconImageView.image = iconDict[type]
        contentLabel.text = getContent(type)
        if type == .amount {
            contentLabel.text = "\(contentLabel.text!)20"
        }
        arrowImageView.isHidden = (type == .amount)
    }
}


