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
    
    /// 播放指示视图
    @IBOutlet weak var indicatorView: UIView!
    
    /// 序号及宽度约束
    @IBOutlet weak var serialLabel: UILabel!
    @IBOutlet weak var serialWidthLayoutConstraint: NSLayoutConstraint!
    
    /// 歌曲数据
    private var model:SongRealm?
    
    // MARK: - IBAction
    @IBAction func onMoreButtonClicked(_ sender: UIButton) {
        FuntionMenuView.show(items: [FunctionMenuType.add, FunctionMenuType.download, FunctionMenuType.share]) { [weak self](type) in
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
        guard let serial = serial else {
            serialWidthLayoutConstraint.constant = 0
            serialLabel.isHidden = true
            return
        }
        serialLabel.isHidden = false
        serialWidthLayoutConstraint.constant = 30
        serialLabel.text = "\(serial)"
        serialLabel.textColor = serial <= 3 ? COLOR_69EDC8 : COLOR_ABABAB
    }
    
    /// 设置选中状态
    func setChecked(isChecked:Bool) {
        indicatorView.isHidden = !isChecked
    }
}
