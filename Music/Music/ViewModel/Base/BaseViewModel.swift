//
//  BaseViewModel.swift
//  Music
//
//  Created by hzg on 2017/11/27.
//  Copyright © 2017年 demo. All rights reserved.
//

typealias SuccessCallback = (_ result: Any?) -> Void
typealias FailureCallback = (_ result: Any?) -> Void

/// 基类ViewModel
class BaseViewModel: NSObject {
   
    /// 成功回调方法
    var successCallback: SuccessCallback?
    
    /// 失败回调方法
    var failureCallback: FailureCallback?
   
    /// 请求体句柄
    var sessionDataTask:URLSessionDataTask?
    
    /**
     设置完成和失败回调方法
     - parameter successCallback: 成功回调方法
     - parameter failureCallback: 失败回调方法
     */
    func setCompletion(onSuccess successCallback: @escaping SuccessCallback, onFailure failureCallback: @escaping FailureCallback) ->(Void) {
        self.successCallback = successCallback
        self.failureCallback = failureCallback
    }
    
    /// 取消请求
    func cancel() {
        sessionDataTask?.cancel()
    }
}
