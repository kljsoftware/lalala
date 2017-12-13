//
//  AppDelegate.swift
//  Music
//
//  Created by hzg on 2017/11/21.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit
import AVFoundation
import Toast_Swift
import UserNotifications

/// 界面工具类
class AppUI {
    
    /// 压栈(栈顶)
    class func push(to view:UIView, with size:CGSize) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.push(to: view, with: size)
    }
    
    /// 压栈(对应子模块栈顶) 注：cuttentView表示当前视图，view表示要压栈的视图, size表示压栈视图的大小
    class func push(from cuttentView:UIView, to view:UIView, with size:CGSize) {

        /// 不断从父级寻找根视图查找对应子模块根视图
        var rootView = cuttentView.superview
        while (rootView != nil) {
            if rootView!.isKind(of: FMView.self)
                || rootView!.isKind(of: MyMusicView.self)
                || rootView!.isKind(of: DiscoverView.self)
                || rootView!.isKind(of: SearchView.self)
                || rootView!.isKind(of: MeView.self) {
                break
            }
            rootView = rootView?.superview
        }
        
        /// 压入子模块栈顶
        rootView?.push(to: view, with: size)
    }
    
    /// 出栈
    class func pop(_ view:UIView) {
        view.pop()
    }
    
    /// 切换语言
    class func change(_ languageType:LanguageType) {
        tip(LanguageKey.Setting_SwitchingLanguage.value)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            LanguageHelper.shared.setLanguage(type: languageType)
            let window = (UIApplication.shared.delegate as! AppDelegate).window
            window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "kMainVC")
        })
    }
    
    /// 提示
    class func tip(_ message:String, position:ToastPosition = .center) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.makeToast(message, duration: 1, position: position)
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
    
    /// ios8~ios10  本地通知消息会走这个方法
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        handleLocalNotification()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UIApplication.shared.endReceivingRemoteControlEvents()
        PlayerHelper.shared.clean()
        SleepHelper.shared.stop()
    }

    // MARK: - private methods
    /// 初始化设置
    private func setup() {
        
        /// 注册本地通知
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            let types10:UNAuthorizationOptions = [.alert]
            center.requestAuthorization(options: types10, completionHandler: { (granted, error) in
                // TODO:
                Log.e(error ?? "")
            })
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: .alert, categories: nil))
        }
        
        /// 设置电池栏前景色
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        /// 音乐接收远程控制
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        /// 同步本地数据
        DataHelper.shared.setup()
    }
    
    /// 处理本地消息
    func handleLocalNotification() {
        SleepHelper.shared.fireDate = nil
        PlayerHelper.shared.pause()
        AppUI.tip(LanguageKey.Tip_TimeOffMusicStop.value)
        NotificationCenter.default.post(name: NoticationUpdateForTimesup, object: nil)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10新增：处理前台收到通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        handleLocalNotification()
    }
    
    //iOS10新增：处理后台点击通知的代理方法
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        handleLocalNotification()
    }
}

