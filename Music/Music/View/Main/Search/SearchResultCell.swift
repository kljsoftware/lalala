//
//  SearchResultCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索结果/歌单 单元
class SearchResultCell: UITableViewCell {

    /// 歌名
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 歌手名
    @IBOutlet weak var artistNameLabel: UILabel!
    
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    /// 歌曲数据
    private var songRealm:SongRealm?, songModel:FMSongDataModel?
    
    // MARK: - override methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBAction
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        ActionSheet.show(items: [LanguageKey.MyMusic_AddToPlaylist.value, LanguageKey.Common_Download.value, LanguageKey.Common_Share.value]) { [weak self](index) in
            guard let weakself = self else {
                return
            }
            switch index {
            case 0: // 添加至歌单
                
                if weakself.songRealm != nil {
                    PlaylistSheet.addToPlaylist(mode: SongRealm(value: weakself.songRealm!))
                    return
                }
                
                if weakself.songModel != nil {
                    PlaylistSheet.addToPlaylist(mode: SongRealm.getModel(with: weakself.songModel!))
                    return
                }
            case 1:
                break
            case 2:
                break
            default:
                break
            }
        }
    }
    
    // MARK: - public methods
    /// 更新
    func update(model:FMSongDataModel) {
        self.songModel = model
        songNameLabel.text = model.title
        artistNameLabel.text = model.artist
    }
    
    /// 更新
    func update(realmModel:SongRealm) {
        self.songRealm = realmModel
        songNameLabel.text = realmModel.title
        artistNameLabel.text = realmModel.artist
    }
}
