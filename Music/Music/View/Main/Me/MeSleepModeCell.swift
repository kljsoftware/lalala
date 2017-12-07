//
//  MeSleepModeCell.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元样式
enum MeSleepModeCellType : Int {
    case disbleTimer  //
    case after15mins
    case after30mins
    case after60mins
    case after90mins
    case after120mins
    case custom
}

class MeSleepModeCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
