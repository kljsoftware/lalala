//
//  DiscoverViewModel.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 发现首页业务模块
class DiscoverViewModel: BaseViewModel {
    
    func requestRankv3() {
        let url = NetworkURL.DiscoverRandV3.url
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
}
