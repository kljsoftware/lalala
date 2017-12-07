//
//  MeView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

/// '我'控制高度
private let meTitleHeight:CGFloat = 44

/// 单元高度及个数
private let cellHeight:CGFloat = 44, numberOfRowsInSection = 4

/// 标题视图
private class TitleView : UIView {
    
    /// 标题
    private lazy var titleLabel:UILabel = {
        let _titleLabel = UILabel(frame: self.bounds)
        _titleLabel.textColor = UIColor.white
        _titleLabel.font = ARIAL_FONT_19
        _titleLabel.textAlignment = .center
        self.addSubview(_titleLabel)
        return _titleLabel
    }()
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    func setup(title:String?) {
        titleLabel.text = title
    }
}

/// ‘我’界面
class MeView: UIView {
    
    /// 标题视图
    private lazy var titleView : TitleView = {
        let _titleView = TitleView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: meTitleHeight))
        _titleView.backgroundColor = UIColor.clear
        self.addSubview(_titleView)
        return _titleView
    }()
    
    /// 列表视图
    private lazy var tableView:UITableView = {
        let _tableView = UITableView(frame: CGRect(x: 0, y: meTitleHeight, width: self.frame.width, height: self.frame.height))
        _tableView.separatorColor = UIColor.clear
        _tableView.backgroundColor = UIColor.clear
        _tableView.dataSource = self
        _tableView.delegate = self
        self.addSubview(_tableView)
        return _tableView
    }()

    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 初始化
    private func setup() {
        
        // 标题
        titleView.setup(title: Lang_Me)
        
        /// 列表视图
        tableView.register(UINib(nibName: "MeTableViewCell", bundle: nil), forCellReuseIdentifier: "kMeTableViewCell")
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MeView :  UITableViewDataSource, UITableViewDelegate {
    
    // MARK:  UITableViewDataSource
    // 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    // 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMeTableViewCell", for: indexPath) as! MeTableViewCell
        cell.update(type: MeTableCellType(rawValue: indexPath.row)!)
        return cell
    }
    
    // MARK: UITableViewDelegate
    // 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    // 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MeTableCellType(rawValue: indexPath.row)! {
        case .amount:
            break
        case .sleepMode:
            let sleepModeView = Bundle.main.loadNibNamed("MeSleepModeView", owner: nil, options: nil)?[0] as! MeSleepModeView
            AppUI.push(to: sleepModeView, with: CGSize(width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT))
        case .setting:
            let settingView = Bundle.main.loadNibNamed("MeSettingView", owner: nil, options: nil)?[0] as! MeSettingView
            AppUI.push(to: settingView, with: CGSize(width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT))
        case .share:
            break
        }
    }
}
