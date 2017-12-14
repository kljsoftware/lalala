//
//  SearchResultCell.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 常量
private let serialWidth:CGFloat = 30, artistLeadingLength:CGFloat = 16

/// 搜索结果/歌单 单元
class SearchResultCell: UITableViewCell {

    /// 歌名
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 歌手名
    @IBOutlet weak var artistNameLabel: UILabel!
    
    /// 歌手名居左约束
    @IBOutlet weak var artistLeadingLayoutConstraint: NSLayoutConstraint!
    
    /// 已下载标志
    @IBOutlet weak var downloadedImageView: UIImageView!
    
    /// 更多按钮
    @IBOutlet weak var moreButton: UIButton!
    
    /// 播放指示视图
    @IBOutlet weak var indicatorView: UIView!
    
    /// 序号及宽度约束
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var serialWidthLayoutConstraint: NSLayoutConstraint!
    
    /// 歌曲数据
    private var model:SongRealm?
    
    // MARK: - IBAction
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        let type = PlaylistHelper.isDownloadSong(sid: model?.sid) ? FunctionMenuType.downloaded : FunctionMenuType.download
        FuntionMenuView.show(items: [FunctionMenuType.add, type, FunctionMenuType.share]) { [weak self](type) in
            guard let weakself = self else {
                return
            }
            switch type {
            case .add: // 添加至歌单
                if weakself.model != nil {
                    PlaylistSheet.addToPlaylist(mode: SongRealm(value: weakself.model!))
                    return
                }
            case .download:
                weakself.downloadedImageView.isHidden = false
                weakself.artistLeadingLayoutConstraint.constant = artistLeadingLength
                DownloadTaskHelper.shared.addSongTask(model: SongRealm(value: weakself.model!))
            case .share:
                break
            default:
                break
            }
        }
    }
    
    // MARK: - public methods
    /// 更新
    func update(model:SongRealm, serial:Int? = nil) {
        self.model = model
        songNameLabel.text = model.title
        artistNameLabel.text = model.artist
        let isdownloaded = PlaylistHelper.isDownloadSong(sid: model.sid)
        downloadedImageView.isHidden = !isdownloaded
        artistLeadingLayoutConstraint.constant = isdownloaded ? artistLeadingLength : 0
        guard let serial = serial else {
            serialWidthLayoutConstraint.constant = 0
            serialLabel.isHidden = true
            return
        }
        serialLabel.isHidden = false
        serialWidthLayoutConstraint.constant = serialWidth
        serialLabel.text = "\(serial)"
        serialLabel.textColor = serial <= 3 ? COLOR_69EDC8 : COLOR_ABABAB
    }
    
    /// 设置选中状态
    func setChecked(isChecked:Bool) {
        indicatorView.isHidden = !isChecked
    }
}
