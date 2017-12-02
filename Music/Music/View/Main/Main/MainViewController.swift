//
//  MainViewController.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var cdButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    private var animation:RotateAnimation?

    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotification()
        setup()
    }
    
    deinit {
        unregisterNotification()
    }

    // MARK: - private methods
    /// 初始化
    private func setup() {
        setupcdButton()
        setupMainView()
        setupTabView()
    }
    
    /// 设置按钮及按钮动画
    private func setupcdButton() {
        cdButton.isExclusiveTouch = true
        cdButton.setHighlightedImage(nor: UIImage(named:"common_btn_cd_normal"), sel: UIImage(named:"common_btn_cd_activated"))
        animation = RotateAnimation(animationView: cdButton)
    }
    
    /// 设置主视图
    private func setupMainView() {
        let w = DEVICE_SCREEN_WIDTH
        let h = DEVICE_SCREEN_HEIGHT - DEVICE_STATUS_BAR_HEIGHT - TOP_AD_HEIGHT
        let subViews = [FMView(frame: CGRect(x: 0, y: 0, width: w, height: h)),
                        MyMusicView(frame: CGRect(x: 0, y: 0, width: w, height: h)),
                        DiscoverView(frame: CGRect(x: 0, y: 0, width: w, height: h)),
                        SearchView(frame: CGRect(x: 0, y: 0, width: w, height: h)),
                        MeView(frame: CGRect(x: 0, y: 0, width: w, height: h))]
        scrollView.contentSize = CGSize(width: w * CGFloat(subViews.count), height: h)
        for subView in subViews {
            let index = subViews.index(of: subView)!
            subView.frame = CGRect(x: CGFloat(index) * w, y: 0, width: w, height: h)
            subView.backgroundColor = UIColor.clear
            scrollView.addSubview(subView)
        }
    }
    
    /// 设置底部标签视图
    private func setupTabView() {
        let tabView = Bundle.main.loadNibNamed("TabView", owner: nil, options: nil)?[0] as! TabView
        containerView.addSubview(tabView)
        tabView.snp.makeConstraints { (maker) in
            maker.left.right.width.equalTo(containerView)
            maker.height.equalTo(BOTTOM_TAB_HEIGHT)
            maker.bottom.equalTo(containerView).offset(-DEVICE_INDICATOR_HEIGHT)
        }
        tabView.selectedClosure = { [weak self](type) in
            self?.scrollView.setContentOffset(CGPoint(x: CGFloat(type.rawValue)*DEVICE_SCREEN_WIDTH, y: 0), animated: false)
        }
    }

    /// 注册通知
    fileprivate func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(notifyUpdateForAudioStatusChanged), name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 销毁通知
    fileprivate func unregisterNotification() {
        NotificationCenter.default.removeObserver(self, name: NoticationUpdateForAudioStatusChanged, object: nil)
    }
    
    /// 通知相关音频控制更新
    @objc private func notifyUpdateForAudioStatusChanged(_ sender:Notification) {
        if PlayerHelper.shared.state == .stop || PlayerHelper.shared.state == .pause {
            cdButton.isSelected = false
            animation?.stop()
        } else {
            cdButton.isSelected = true
            animation?.start()
        }
    }
    
    /// 点击播放
    @IBAction func onCDButtonClicked(_ sender: UIButton) {
        let immersionPlayerView = Bundle.main.loadNibNamed("ImmersionPlayerView", owner: nil, options: nil)?[0] as! ImmersionPlayerView
        view.push(view: immersionPlayerView, size: CGSize(width: DEVICE_SCREEN_WIDTH, height: DEVICE_SCREEN_HEIGHT - TOP_AD_HEIGHT - DEVICE_STATUS_BAR_HEIGHT))
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        Log.e("remoteControlReceived#")
        if event != nil && event!.type == .remoteControl {
            print("event!.subtype = \(event!.subtype.rawValue)")
            switch event!.subtype {
            case .remoteControlPlay:  // 播放事件【操作：停止状态下，按耳机线控中间按钮一下】
                PlayerHelper.shared.resume()
            case .remoteControlPause: // 暂停事件
                PlayerHelper.shared.pause()
            case .remoteControlStop:  // 停止事件
                 PlayerHelper.shared.stop()
            case .remoteControlTogglePlayPause:      // 播放或暂停切换【操作：播放或暂停状态下，按耳机线控中间按钮一下】
                PlayerHelper.shared.resume()
            case .remoteControlNextTrack:            // 下一曲【操作：按耳机线控中间按钮两下】
                _ = PlayerHelper.shared.next()
            case .remoteControlPreviousTrack:        // 上一曲【操作：按耳机线控中间按钮三下】
                _ = PlayerHelper.shared.prev()
            case .remoteControlBeginSeekingBackward: // 快退开始【操作：按耳机线控中间按钮三下不要松开】
                break
            case .remoteControlEndSeekingBackward:   // 快退停止【操作：按耳机线控中间按钮三下到了快退的位置松开】
                break
            case .remoteControlBeginSeekingForward:  // 快进开始【操作：按耳机线控中间按钮两下不要松开】
                break
            case .remoteControlEndSeekingForward:    // 快进停止【操作：按耳机线控中间按钮两下到了快进的位置松开】
                break
            default:
                break
            }
        }
    }
}
