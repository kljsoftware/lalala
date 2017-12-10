//
//  SearchViewModel.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索业务处理类
class SearchViewModel: BaseViewModel {
    
    /// 请求热门歌手列表
    func requestTopArtists(page:Int) {
        let url = NetworkURL.SearchTopArtists(page: page).url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = SearchArtistsResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 请求搜索结果
    func requestSearchResult(query:String, type:String, page:Int) {
        let url = NetworkURL.SearchV2(query: query, type: type, page: page).url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = SearchSongResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == 1 {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
    
    /// 请求热门搜索数据
    func requestSearchPopular() {
        let url = NetworkURL.SearchPopular.url
        Log.e("url = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = SearchPopularResultModel.mj_object(withKeyValues: result)
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
