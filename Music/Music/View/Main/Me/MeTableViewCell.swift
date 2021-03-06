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
    
    /// 模式对应的文字
    @IBOutlet weak var modelLabel: UILabel!
    
    /// 获取内容
    private func getContent(_ type:MeTableCellType) -> String {
        switch type {
        case .amount:
            return LanguageKey.Setting_TodayRemainingDownloads.value
        case .sleepMode:
            return LanguageKey.Setting_SleepMode.value
        case .setting:
            return LanguageKey.Setting_Setting.value
        case .share:
            return LanguageKey.Setting_ShareThisApp.value
        }
    }
    
    /// 更新单元
    func update(type:MeTableCellType, modeText:String? = nil) {
        iconImageView.image = iconDict[type]
        contentLabel.text = getContent(type)
        
        /// 剩余下载次数
        if type == .amount {
            contentLabel.text = "\(contentLabel.text!)\(DOWNLOAD_LIMIT_TIMES - DownloadTaskHelper.shared.amount)"
        }
        arrowImageView.isHidden = (type == .amount)
        
        /// 休眠模式
        if type == .sleepMode {
            modelLabel.isHidden = false
            modelLabel.text = modeText
        } else {
            modelLabel.isHidden = true
        }
    }
}


