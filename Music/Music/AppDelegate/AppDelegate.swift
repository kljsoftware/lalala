//
//  AppDelegate.swift
//  Music
//
//  Created by hzg on 2017/11/21.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit
import AVFoundation

/// 界面工具类
class AppUI {
    
    /// 压栈
    class func push(to view:UIView, with size:CGSize) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.push(view: view, size: size)
    }
    
    /// 出栈
    class func pop(_ view:UIView) {
        view.pop()
    }
    
    /// 切换语言
    class func change(_ languageType:LanguageType) {
        LanguageHelper.shared.setLanguage(type: languageType)
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kMainVC")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backTaskId = UIBackgroundTaskInvalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        DataHelper.shared.setAudioSessionActive(AVAudioSessionCategoryPlayback)
        backTaskId = UIApplication.shared.beginBackgroundTask { [weak self] in
            if nil == self { return }
            UIApplication.shared.endBackgroundTask(self!.backTaskId)
            self!.backTaskId = UIBackgroundTaskInvalid
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        Log.e("applicationDidEnterBackground#")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        Log.e("applicationWillEnterForeground#")
        if backTaskId != UIBackgroundTaskInvalid {
            UIApplication.shared.endBackgroundTask(backTaskId)
            backTaskId = UIBackgroundTaskInvalid
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.endReceivingRemoteControlEvents()
        PlayerHelper.shared.clean()
    }
    
    // MARK: - private methods
    /// 初始化设置
    private func setup() {
        
        /// 设置电池栏前景色
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        /// 音乐接收远程控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        /// 同步本地数据
        DataHelper.shared.setup()
    }
}

