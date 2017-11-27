//
//  FMViewModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

class Test : NSObject {
    var test = ""
}

/// 电台业务处理类
class FMViewModel: BaseViewModel {
    
    /// 获取电台类型列表
    func getChannelList() {
        let url = NetworkURL.FMChannelList(language: LanguageHelper.shared.language).url
        Log.e("request = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = FMChannelListResultModel.mj_object(withKeyValues: result)
            if resultModel != nil && resultModel!.status == "1" {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error)
        }
    }
    
    /// 某一类型电台的歌曲列表
    func getSongList(categoryId:Int) {
        let url = NetworkURL.FMSongList(categoryId: categoryId).url
        Log.e("request = \(url)")
        HttpRequest.get(url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
//            let resultModel = FMCategoryListResultModel.mj_object(withKeyValues: result)
//            if resultModel != nil && resultModel!.status == 1 {
//                self.successCallback?(resultModel!)
//            } else {
//                self.failureCallback?("服务器内部错误")
//            }
        }) { (error) in
            self.failureCallback?(error)
        }
    }
}
