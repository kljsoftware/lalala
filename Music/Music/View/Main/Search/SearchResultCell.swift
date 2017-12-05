//
//  SearchResultCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索结果单元
class SearchResultCell: UITableViewCell {

    /// 歌名
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 歌手名
    @IBOutlet weak var artistNameLabel: UILabel!
    
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    // MARK: - override methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBAction
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        ActionSheet.show(items: ["添加到歌单", "下载", "分享"]) { (index) in
            
        }
    }
    
    // MARK: - public methods
    func update(model:FMSongDataModel) {
        songNameLabel.text = model.title
        artistNameLabel.text = model.artist
    }
}
