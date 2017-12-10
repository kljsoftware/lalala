//
//  DiscoverViewModel.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 发现首页业务模块
class DiscoverViewModel: BaseViewModel {
    
    /// 请求发现首页数据
    func requestRankv3() {
        let url = NetworkURL.DiscoverRankV3.url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = DiscoveryMainResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 请求更多热门歌曲
    func requestLoadSongLists(page:Int) {
        let url = NetworkURL.DiscoverRankLoadSongLists(page: page).url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = DiscoveryLoadSonglistResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 请求排行榜列表
    func requestRankDetail() {
        let url = NetworkURL.DiscoverRankDetail.url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = DiscoverRankDetailResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 获取指定排行榜内容列表
    func requestRankList(randId:Int) {
        let url = NetworkURL.DiscoverRank(rank_id: randId).url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = DiscoverRankResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 获取热门歌单列表
   // func 
}
