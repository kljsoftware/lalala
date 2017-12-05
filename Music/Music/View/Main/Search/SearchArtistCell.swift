//
//  SearchArtistCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class SearchArtistCell: UITableViewCell {

    /// 歌手头像图片
    @IBOutlet weak var artistImageView: UIImageView!
    
    /// 歌手名
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - public methods
    /// 刷新数据
    func update(model:ArtistDataModel) {
        artistImageView.setImage(urlStr: model.imageurl, placeholderStr: "default_cover_2", radius: 0)
        artistLabel.text = model.name
    }
}
