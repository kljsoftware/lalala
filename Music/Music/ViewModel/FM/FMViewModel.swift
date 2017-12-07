//
//  FMViewModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 电台业务处理类
class FMViewModel: BaseViewModel {
    
    // MARK: - public methods
    /// 获取频道列表
    func getChannelList() {
        let url = NetworkURL.FMChannelList(language: LanguageHelper.shared.type.rawValue).url
        Log.e("request = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = FMChannelListResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 某一频道的歌曲列表
    func getSongList(channelId:Int?) {
        if channelId == nil {return}
        let url = NetworkURL.FMSongList(channelId: channelId!).url
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
            self.failureCallback?(error.localizedDescription)
        }
    }
}
