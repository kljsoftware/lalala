//
//  SearchPopularCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 热门搜索标签单元
class SearchPopularCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - public methods
    func update(name:String?) {
        nameLabel.text = name
    }
}
