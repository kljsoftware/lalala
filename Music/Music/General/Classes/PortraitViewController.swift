//
//  PortraitViewController.swift
//  Music
//
//  Created by hzg on 2017/12/13.
//  Copyright © 2017年 demo. All rights reserved.
//

// 仅支持竖屏
class PortraitViewController: UIViewController {
    
    // 禁止转屏
    override var shouldAutorotate : Bool {
        return false
    }
    
    // 只显示竖屏
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
