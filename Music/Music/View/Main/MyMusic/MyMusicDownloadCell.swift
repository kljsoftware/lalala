//
//  MyMusicDownloadCell.swift
//  Music
//
//  Created by hzg on 2017/12/4.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 我的下载单元
class MyMusicDownloadCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.text = LanguageKey.MyMusic_MyDownload.value
    }
    
}
