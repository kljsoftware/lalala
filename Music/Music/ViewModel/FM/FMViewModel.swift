//
//  FMViewModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 电台业务处理类
class FMViewModel: BaseViewModel {
    
    /// 频道列表数据
    var channelListResultModel:FMChannelListResultModel?
    
    // MARK: - private methods
    /// 指定频道
    private func setupChannel(channelListResultModel:FMChannelListResultModel?) {
        
        /// 频道列表数据
        self.channelListResultModel = channelListResultModel
        
        /// 频道列表为空
        guard let channelList = channelListResultModel?.data.channels else {
            self.failureCallback?("频道列表为空")
            return
        }
        
        /// 频道列表为空
        if channelList.count == 0 {
            self.failureCallback?("频道列表为空")
            return
        }
        
        /// 拉取当前频道的歌曲列表
        var channelId = channelList[0].id
        if DataHelper.shared.channelId != nil {
            for channel in channelList {
                if channel.id == DataHelper.shared.channelId! {
                    channelId = channel.id
                    break
                }
            }
        }
        DataHelper.shared.setupChannel(channelId: channelId)
        getSongList(categoryId: channelId)
    }
    
    // MARK: - public methods
    /// 获取频道列表
    func getChannelList() {
        let url = NetworkURL.FMChannelList(language: LanguageHelper.shared.language).url
        Log.e("request = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            self.setupChannel(channelListResultModel: FMChannelListResultModel.mj_object(withKeyValues: result))
        }) { (error) in
            self.failureCallback?(error)
        }
    }
    
    /// 某一频道的歌曲列表
    func getSongList(categoryId:Int) {
        let url = NetworkURL.FMSongList(categoryId: categoryId).url
        Log.e("request = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = FMSongListResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error)
        }
    }
}
