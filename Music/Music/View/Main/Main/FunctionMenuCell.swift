//
//  FunctionMenuCell.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 功能菜单类型
enum FunctionMenuType : String {
    case add      /// 添加到歌单
    case delete   /// 删除
    case download /// 下载
    case refresh  /// 刷新
    case share    /// 分享
}

/// 功能菜单对应的图片
private var dic:[FunctionMenuType:UIImage] = [.add:UIImage(named:"action_ic_add")!,
                                              .delete:UIImage(named:"action_ic_delete")!,
                                              .download:UIImage(named:"action_ic_download")!,
                                              .refresh:UIImage(named:"action_ic_refresh")!,
                                              .share:UIImage(named:"action_ic_share")!]

/// 功能菜单单元
class FunctionMenuCell: UITableViewCell {
    
    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
    
    /// 选项名
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 更新
    func update(type:FunctionMenuType) {
        titleLabel.text = getContent(by: type)
        iconImageView.image = dic[type]
    }
    
    /// 获取内容
    private func getContent(by type:FunctionMenuType) -> String {
        switch type {
        case .add:
            return LanguageKey.MyMusic_AddToPlaylist.value
        case .delete:
            return LanguageKey.Common_Delete.value
        case .download:
            return LanguageKey.Common_Download.value
        case .refresh:
            return LanguageKey.FM_RefreshTracks.value
        case .share:
            return LanguageKey.Common_Share.value
        }
    }
}
