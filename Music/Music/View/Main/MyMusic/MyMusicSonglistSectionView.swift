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
    
    /// 循环模式闭包
    var cycleClosure:(()->Void)?
    
    /// 添加闭包
    var addClosure:(()->Void)?
   
    /// 下一首
    @IBOutlet weak var nextButton: UIButton!
    
    /// 循环模式
    @IBOutlet weak var cycleButton: UIButton!
    
    /// 添加按钮, 默认不可见， 只有本地非喜爱歌单可见
    @IBOutlet weak var addButton: UIButton!
    
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
        cycleClosure?()
    }
    
    /// 点击添加按钮
    @IBAction func onAddButtonClicked(_ sender: UIButton) {
        addClosure?()
    }
    
}
