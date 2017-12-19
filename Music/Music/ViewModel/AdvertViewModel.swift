//
//  AdvertViewModel.swift
//  Music
//
//  Created by hzg on 2017/12/19.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 广告业务
class AdvertViewModel : BaseViewModel {
    
    /// 请求广告数据
    func requestAdvert() {
        HttpRequest.get(advert_url, success: { (result) in
            Log.e("reponse = \(String(describing: result))")
            let resultModel = AdvertResultModel.mj_object(withKeyValues: result)
            if resultModel != nil {
                self.successCallback?(resultModel!)
            } else {
                self.failureCallback?("服务器内部错误")
            }
        }) { (error) in
            self.failureCallback?(error.localizedDescription)
        }
    }
}
