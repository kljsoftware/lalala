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

/// 内容字典
private let contentDict = [MeTableCellType.amount:LanguageHelper.shared.getLanguageText(by: "Setting_TodayRemainingDownloads"),
                           MeTableCellType.sleepMode:LanguageHelper.shared.getLanguageText(by: "Setting_SleepMode"),
                           MeTableCellType.setting:LanguageHelper.shared.getLanguageText(by: "Setting_Setting"),
                           MeTableCellType.share:LanguageHelper.shared.getLanguageText(by: "Setting_ShareThisApp")]

class MeTableViewCell: UITableViewCell {

    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    /// 更新单元
    func update(type:MeTableCellType) {
        iconImageView.image = iconDict[type]
        contentLabel.text = contentDict[type]
        if type == .amount {
            contentLabel.text = "\(contentDict[type]!)20"
        }
        arrowImageView.isHidden = (type == .amount)
    }
}
