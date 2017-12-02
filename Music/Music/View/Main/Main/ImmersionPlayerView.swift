//
//  ImmersionPlayerView.swift
//  Music
//
//  Created by hzg on 2017/12/2.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class ImmersionPlayerView: UIView {

    /// 距底约束
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        bottomLayoutConstraint.constant = DEVICE_INDICATOR_HEIGHT
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        pop()
    }
}
