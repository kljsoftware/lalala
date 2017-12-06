//
//  SearchHistoryCell.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索历史单元
class SearchHistoryCell: UICollectionViewCell {
    
    /// 删除闭包
    var deleteClosure:((_ cell:UICollectionViewCell)-> Void)?
    
    /// 名称
    @IBOutlet weak var nameLabel: UILabel!
    
    /// 模型
    private var model:SearchHistory?
    
    // MARK: - public methods
    func update(model:SearchHistory) {
        nameLabel.text = model.name
        self.model = model
    }
    
    /// 点击删除按钮
    @IBAction func onDeleteButtonClicked(_ sender: UIButton) {
        if model != nil {
            deleteClosure?(self)
        }
    }
}
