//
//  MeSettingType0Cell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 设置单元：记住上次选中频道/自定播放
class MeSettingType0Cell: UITableViewCell {
    
    /// 切换按钮
    @IBOutlet weak var switchButton: UISwitch!
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - override methods
    override func awakeFromNib() {
        switchButton.transform =  CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchButton.isUserInteractionEnabled = false
    }
    
    /// 更新
    func update(text:String?, type:SettingModeType) {
        nameLabel.text = text
        if type == .auto_play {
            switchButton.isOn = DataHelper.shared.isAutoPlay
        } else if type == .last_select_channel {
            switchButton.isOn = DataHelper.shared.isRememberLastChanneld
        }
    }
}
