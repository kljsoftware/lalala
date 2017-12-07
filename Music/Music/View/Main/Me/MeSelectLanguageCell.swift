//
//  MeSelectLanguageCell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 内容字典
private var dic = [LanguageType.ja:"日本語",
                   LanguageType.en:"English",
                   LanguageType.zhHans:"简体",
                   LanguageType.zhHant:"繁體"]

class MeSelectLanguageCell: UITableViewCell {

    /// 模式标签
    @IBOutlet weak var languageLabel: UILabel!
    
    /// 当前选择模式
    @IBOutlet weak var checkedImageView: UIImageView!
    
    // 选中/未选中单元
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkedImageView.isHidden = !isSelected
    }
    
    /// 更新单元
    func update(type:LanguageType) {
        languageLabel.text = dic[type]
    }
}
