//
//  MeTableViewCell.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 按钮类型
enum MyTableCellType:Int {
    case amount, sleepMode, copyRight, setting, share
}

/// 图标字典
private let iconDict = [MyTableCellType.amount:UIImage(named:"mine_ic_amount")!,
                        MyTableCellType.sleepMode:UIImage(named:"mine_ic_sleep_mode")!,
                        MyTableCellType.copyRight:UIImage(named:"mine_ic_copyright")!,
                        MyTableCellType.setting:UIImage(named:"mine_ic_setting")!,
                        MyTableCellType.share:UIImage(named:"mine_ic_share")!]

/// 内容字典
private let contentDict = [MyTableCellType.amount:"今日剩余下载数",
                           MyTableCellType.sleepMode:"休眠模式",
                           MyTableCellType.copyRight:"版权声明",
                           MyTableCellType.setting:"设置",
                           MyTableCellType.share:"分享此应用"]

class MeTableViewCell: UITableViewCell {

    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    
    /// 箭头
    @IBOutlet weak var arrowImageView: UIImageView!
    
    // MARK: - override methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - public methods
    func update(type:MyTableCellType) {
        iconImageView.image = iconDict[type]
        contentLabel.text = contentDict[type]
        if type == .amount {
            contentLabel.text = "\(contentDict[type]!) :  20"
        }
        arrowImageView.isHidden = (type == .amount)
    }
}
