//
//  MyMusicSonglistHeaderView.swift
//  Music
//
//  Created by hzg on 2017/12/8.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌单头部视图
class MyMusicSonglistHeaderView : UIView {
    
    /// 点击回调
    var clickedClosure:(()->Void)?
    
    /// 背景视图
    @IBOutlet weak var backImageView: UIImageView!
    
    /// 封面视图
    @IBOutlet weak var videoImageView: UIImageView!
    
    /// 歌单名
    @IBOutlet weak var nameLabel: UILabel!
   
    /// 点击视频按钮
    @IBAction func onVideoButtonClicked(_ sender: UIButton) {
        clickedClosure?()
    }
    
    /// 更新名字
    func update(name:String) {
        nameLabel.text = name
    }
    
    /// 更新图片
    func update(imgurl:String) {
        backImageView.setImage(urlStr: imgurl, placeholderStr: "default_cover_3", radius: 0)
        videoImageView.setImage(urlStr: imgurl, placeholderStr: "default_cover_3", radius: 0)
    }
}
