//
//  MyMusicSonglistSectionView.swift
//  Music
//
//  Created by hzg on 2017/12/10.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 分区视图
class MyMusicSonglistSectionView: UIView {
    
    /// 下一首闭包
    var nextClosure:(()->Void)?
    
    /// 添加闭包
    var addClosure:(()->Void)?
   
    /// 下一首
    @IBOutlet weak var nextButton: UIButton!
    
    /// 循环模式
    @IBOutlet weak var cycleButton: UIButton!
    
    /// 添加按钮, 默认不可见， 只有本地非喜爱歌单可见
    @IBOutlet weak var addButton: UIButton!
    
    /// 初始化
    override func awakeFromNib() {
        registerNotification()
        cycleButton.setImage(nor: circleModeDict[PlayerHelper.shared.playMode])
    }
    
    deinit {
        unregisterNotification()
    }
    
    // MARK: - private methods
    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForCircleModeChanged), name: NoticationUpdateForCircleModeChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForCircleModeChanged, object: nil)
    }
    
    /// 通知模式改变
    @objc private func notifyUpdateForCircleModeChanged(_ sender:Notification) {
        cycleButton.setImage(nor: circleModeDict[PlayerHelper.shared.playMode])
    }
    
    /// 更新
    func update(isHiddenAdded:Bool) {
        addButton.isHidden = isHiddenAdded
    }

    // MARK: - IBAction methods
    /// 点击下一首
    @IBAction func onNextButtonClicked(_ sender: UIButton) {
        nextClosure?()
    }
    
    /// 点击模式按钮
    @IBAction func onCycleButtonClicked(_ sender: UIButton) {
        switch PlayerHelper.shared.playMode {
        case .all:
            PlayerHelper.shared.playMode = .one
        case .one:
            PlayerHelper.shared.playMode = .random
        case .random:
            PlayerHelper.shared.playMode = .all
        }
        NotificationCenter.default.post(name: NoticationUpdateForCircleModeChanged, object: nil)
    }
    
    /// 点击添加按钮
    @IBAction func onAddButtonClicked(_ sender: UIButton) {
        addClosure?()
    }
    
}
