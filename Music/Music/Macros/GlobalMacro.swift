//
//  GlobalMacro.swift
//  Music
//
//  Created by hzg on 2017/11/21.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 日记输出使能
let LOG_ENABLED = false

/// 屏幕宽
let DEVICE_SCREEN_WIDTH         = UIScreen.main.bounds.size.width

/// 屏幕高
let DEVICE_SCREEN_HEIGHT        = UIScreen.main.bounds.size.height

// 判断是否是iPhoneX
let iPhoneX: Bool               = UIScreen.main.bounds.size == CGSize(width: 375, height: 812)

// 状态栏高
let DEVICE_STATUS_BAR_HEIGHT: CGFloat  = iPhoneX ? 44 : 20

// iPhoneX竖屏底部指示部分
let DEVICE_INDICATOR_HEIGHT: CGFloat    = iPhoneX ? 34 : 0

/// 广告顶层视图
let TOP_AD_HEIGHT:CGFloat       = 44

/// 底部标签栏高度
let BOTTOM_TAB_HEIGHT:CGFloat   = 48

/// 应用界面距顶高度
let APP_Y = DEVICE_STATUS_BAR_HEIGHT + TOP_AD_HEIGHT

/// 应用界面居底高度
let APP_BOTTOM_HEIGHT = BOTTOM_TAB_HEIGHT + DEVICE_INDICATOR_HEIGHT

/// 应用界面的大小
let APP_SIZE = CGSize(width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT)

/// 应用界面高度
let APP_HEIGHT = DEVICE_SCREEN_HEIGHT - APP_Y

// 1px
let ONE_PIXELS: CGFloat = 1.0/UIScreen.main.scale

/// 常用字体定义
let ARIAL_FONT_12 = UIFont(name: "Arial", size: 12)!
let ARIAL_FONT_16 = UIFont(name: "Arial", size: 16)!
let ARIAL_FONT_19 = UIFont(name: "Arial", size: 19)!
let ARIAL_FONT_21 = UIFont(name: "Arial", size: 21)!

/// 常用颜色定义
let COLOR_69EDC8 = UIColor.hexToColor(0x69EDC8)
let COLOR_ABABAB = UIColor.hexToColor(0xABABAB)
let COLOR_464646 = UIColor.hexToColor(0x464646)

