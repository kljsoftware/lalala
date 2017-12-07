//
//  MeSleepModeView.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 休眠模式
class MeSleepModeView: UIView {
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 定时模式
    @IBOutlet weak var modelLabel: UILabel!
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageHelper.shared.getLanguageText(by: "Setting_SleepMode")
    }
}
