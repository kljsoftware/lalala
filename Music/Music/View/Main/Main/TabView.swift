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
    var selectedClosure:((TabButtonType) -> Void)?
    
    // 当前选中项的按钮类型
    fileprivate var tabType:TabButtonType = .none
    
    // 按钮数组&按钮名数组
    fileprivate var buttonArray:[UIButton]!
    fileprivate var labelArray:[UILabel]!

    /// 电台
    @IBOutlet weak var fmButton: UIButton!
    @IBOutlet weak var fmLabel: UILabel!
    
    /// 我的音乐
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var musicLabel: UILabel!
    
    /// 发现
    @IBOutlet weak var discoverButton: UIButton!
    @IBOutlet weak var discoverLabel: UILabel!
    
    /// 搜索
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchLabel: UILabel!
    
    /// ’我‘
    @IBOutlet weak var meButton: UIButton!
    @IBOutlet weak var meLabel: UILabel!
    
    // MARK: - override methods
    override func awakeFromNib() {
        setup()
    }
    
    /// 初始化设置
    fileprivate func setup() {
        buttonArray = [fmButton, musicButton, discoverButton, searchButton, meButton]
        labelArray  = [fmLabel, musicLabel, discoverLabel, searchLabel, meLabel]
        setExclusiveTouchForButtons()
        selectedButtonWithButtonType(.fm)
        setLabelsText() 
    }
    
    /// 设置独占触摸事件
    fileprivate func setExclusiveTouchForButtons() {
        fmButton.isExclusiveTouch      = true
        musicButton.isExclusiveTouch   = true
        discoverButton.isExclusiveTouch = true
        searchButton.isExclusiveTouch  = true
        meButton.isExclusiveTouch      = true
    }
    
    /// 设置标签文字
    fileprivate func setLabelsText() {
        fmLabel.text = LanguageHelper.shared.getLanguageText(by: "FM_FM")
        musicLabel.text = LanguageHelper.shared.getLanguageText(by: "MyMusic_MyMusic")
        discoverLabel.text = LanguageHelper.shared.getLanguageText(by: "Discover_Discover")
        searchLabel.text = LanguageHelper.shared.getLanguageText(by: "Query_Search")
        meLabel.text = LanguageHelper.shared.getLanguageText(by: "Me_Me")
    }
    
    // 取消指定项的选中状态
    fileprivate func unSelectedButtonWithButtonType(_ tabType:TabButtonType) {
        if tabType == TabButtonType.none {
            return
        }
        
        let button:UIButton = buttonArray[tabType.rawValue]
        button.isSelected = false
        button.isUserInteractionEnabled = true
        labelArray[tabType.rawValue].textColor = UIColor.white
    }
    
    /// 指定按钮为选中状态
    fileprivate func selectedButtonWithButtonType(_ tabType:TabButtonType) {
        
        // 取消上个按钮的选中状态
        unSelectedButtonWithButtonType(self.tabType)
        
        // 选中当前按钮&颜色
        let button:UIButton = buttonArray[tabType.rawValue]
        button.isSelected = true
        button.isUserInteractionEnabled = false
        labelArray[tabType.rawValue].textColor = COLOR_69EDC8
        
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
        selectedClosure?(tabType)
        
        // 设置当前选项为选中状态
        selectedButtonWithButtonType(tabType)
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
