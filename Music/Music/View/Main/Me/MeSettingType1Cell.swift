//
//  MeSettingType1Cell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 设置单元：当前界面语言/当前版本
class MeSettingType1Cell: UITableViewCell {
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 更新
    func update(text:String?) {
        nameLabel.text = text
    }
}
