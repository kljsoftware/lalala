//
//  TabView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

// 标签按钮类型
enum TabButtonType : Int {
    case none = -1
    case fm
    case music
    case dicover
    case search
    case me
}

class TabView: UIView {
   
    /// 标签点击回调
    var tabClickedClosure:((TabButtonType) -> Void)?
    
    // 当前选中项的按钮类型
    fileprivate var tabType:TabButtonType = .none
    
    // 按钮数组
    fileprivate var buttonArray:[UIButton]!

    /// 电台
    @IBOutlet weak var fmButton: UIButton!
    
    /// 我的音乐
    @IBOutlet weak var musicButton: UIButton!
    
    /// 发现
    @IBOutlet weak var dicoverButton: UIButton!
    
    /// 搜索
    @IBOutlet weak var searchButton: UIButton!
    
    /// ’我‘
    @IBOutlet weak var meButton: UIButton!
    
    // MARK: - override methods
    override func awakeFromNib() {
        setup()
    }
    
    /// 初始化设置
    fileprivate func setup() {
        buttonArray = [fmButton, musicButton, dicoverButton, searchButton, meButton]
        setExclusiveTouchForButtons()
        selectedButtonWithButtonType(.fm)
    }
    
    /// 设置独占触摸事件
    fileprivate func setExclusiveTouchForButtons() {
        fmButton.isExclusiveTouch      = true
        musicButton.isExclusiveTouch   = true
        dicoverButton.isExclusiveTouch = true
        searchButton.isExclusiveTouch  = true
        meButton.isExclusiveTouch      = true
    }
    
    /// 指定按钮为选中状态
    fileprivate func selectedButtonWithButtonType(_ tabType:TabButtonType) {
        
        // 取消上个按钮的选中状态
        unSelectedButtonWithButtonType(self.tabType)
        
        // 选中当前按钮
        let button:UIButton = buttonArray[tabType.rawValue]
        button.isSelected = true
        button.isUserInteractionEnabled = false
        
        // 置当前索引标志
        self.tabType = tabType
    }
    
    // 点击切换
    fileprivate func didSelectedButtonAtButtonType(_ tabType:TabButtonType) {
        
        // 重复选中
        if tabType == self.tabType {
            return
        }
        
        // 切换页面
        tabClickedClosure?(tabType)
        
        // 设置当前选项为选中状态
        selectedButtonWithButtonType(tabType)
    }
    
    // 取消指定项的选中状态
    fileprivate func unSelectedButtonWithButtonType(_ tabType:TabButtonType) {
        if tabType == TabButtonType.none {
            return
        }
        
        let button:UIButton = buttonArray[tabType.rawValue]
        button.isSelected = false
        button.isUserInteractionEnabled = true
    }
    
    // MARK: - IBAction methods
    @IBAction func onFMButtonClicked(_ sender: UIButton) {
        didSelectedButtonAtButtonType(.fm)
    }
    
    @IBAction func onMusicButtonClicked(_ sender: UIButton) {
        didSelectedButtonAtButtonType(.music)
    }
    
    @IBAction func onDicoverButtonClicked(_ sender: UIButton) {
        didSelectedButtonAtButtonType(.dicover)
    }
    
    @IBAction func onSearchButtonClicked(_ sender: UIButton) {
        didSelectedButtonAtButtonType(.search)
    }
    
    @IBAction func onMeButtonClicked(_ sender: UIButton) {
        didSelectedButtonAtButtonType(.me)
    }
}
