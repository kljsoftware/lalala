//
//  MyMusicView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// 标题高度
private let titleViewHeight:CGFloat = 44

/// 标题按钮类型
private enum TitleButtonType {
    case edit, finished
}

/// 标题视图
private class TitleView : UIView {
    
    /// 回调闭包
    var editButtonClickedClosure:((TitleButtonType)->Void)?
    
    /// 按钮大小
    private let editButtonSize = CGSize(width: 44, height: 44)
    
    /// 编辑按钮
    private lazy var editButton:UIButton = {
        let _editButton = UIButton(type: .custom)
        _editButton.frame = CGRect(x: 12, y: 0, width: self.editButtonSize.width, height: self.editButtonSize.height)
        self.addSubview(_editButton)
        return _editButton
    }()
    
    // MARK：- init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    private func setup() {
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitleColor(COLOR_ABABAB, for: .normal)
        editButton.setTitleColor(COLOR_69EDC8, for: .highlighted)
        editButton.addTarget(self, action: #selector(onEditButtonClicked), for: .touchUpInside)
        
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = "我的音乐"
        titleLabel.textColor = COLOR_ABABAB
        addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect.init(x: (frame.width - titleLabel.frame.width)/2, y: (frame.height - titleLabel.frame.height)/2, width: titleLabel.frame.width, height: titleLabel.frame.height)
    }
    
    @objc private func onEditButtonClicked(sender:UIButton) {
        var type = TitleButtonType.edit
        if sender.currentTitle! == "编辑" {
            editButton.setTitle("完成", for: .normal)
        } else {
            editButton.setTitle("编辑", for: .normal)
            type = .finished
        }
        editButtonClickedClosure?(type)
    }
}

/// 我的音乐
class MyMusicView: UIView {

    // 标题视图
    private lazy var titleView:TitleView = {
        let _titleView = TitleView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: titleViewHeight))
        self.addSubview(_titleView)
        return _titleView
    }()
    
    // 列表视图
    private var tableView:MyMusicTableView!
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    private func setup() {
        titleView.editButtonClickedClosure = { (type) in
            
        }
        
        tableView = Bundle.main.loadNibNamed("MyMusicTableView", owner: nil, options: nil)?[0] as! MyMusicTableView
        addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: titleViewHeight, width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT - titleViewHeight - (BOTTOM_TAB_HEIGHT + DEVICE_INDICATOR_HEIGHT))
    }
}
