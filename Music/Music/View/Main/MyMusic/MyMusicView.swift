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
        _editButton.titleLabel?.font = ARIAL_FONT_16
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
        
        /// 按钮
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitleColor(COLOR_ABABAB, for: .normal)
        editButton.setTitleColor(COLOR_69EDC8, for: .highlighted)
        editButton.addTarget(self, action: #selector(onEditButtonClicked), for: .touchUpInside)
        
        /// 标题
        let titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.text = "我的音乐"
        titleLabel.textColor = UIColor.white
        titleLabel.font = ARIAL_FONT_19
        addSubview(titleLabel)
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect(x: (frame.width - titleLabel.frame.width)/2, y: (frame.height - titleLabel.frame.height)/2, width: titleLabel.frame.width, height: titleLabel.frame.height)
        
        /// 下划线
        let divideView = UIView()
        divideView.backgroundColor = COLOR_ABABAB.withAlphaComponent(0.5)
        addSubview(divideView)
        divideView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self)
            maker.bottom.equalTo(self).offset(-ONE_PIXELS)
            maker.height.equalTo(ONE_PIXELS)
        }
    }
    
    @objc private func onEditButtonClicked(sender:UIButton) {
        var type = TitleButtonType.edit
        if sender.currentTitle! == "编辑" {
            editButton.setTitle("完成", for: .normal)
            type = .finished
        } else {
            editButton.setTitle("编辑", for: .normal)
        }
        editButtonClickedClosure?(type)
    }
}

/// 我的音乐
class MyMusicView: UIView {

    // 标题视图
    private lazy var titleView:TitleView = {
        let _titleView = TitleView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: titleViewHeight))
        _titleView.backgroundColor = UIColor.clear
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
        
        /// 模糊图
        addSubview(UIView.blurViewWithRect(self.bounds, style:.dark))
        
        /// 标题视图
        titleView.editButtonClickedClosure = { (type) in
            
        }
        
        /// 列表视图
        tableView = Bundle.main.loadNibNamed("MyMusicTableView", owner: nil, options: nil)?[0] as! MyMusicTableView
        addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: titleViewHeight, width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT - titleViewHeight - (BOTTOM_TAB_HEIGHT + DEVICE_INDICATOR_HEIGHT))
    }
}
