//
//  MainViewController.swift
//  Music
//
//  Created by hzg on 2017/11/25.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 主视图容器
    @IBOutlet weak var containerView: UIView!
    
    let player = AudioPlayer()

    // MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - private methods
    private func setup() {
//        let path = Bundle.main.path(forResource: "test", ofType: "lrc")
//        let lyric = Lyric.parse(lrcPath: path)
//        NotificationCenter.default.addObserver(self, selector: #selector(notitfyAudioDurationChanged(_ :)), name: NoticationAudioDurationChanged, object: nil)
        setupMainView()
        setupTabView()
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
        let colors = [UIColor.black, UIColor.red, UIColor.blue, UIColor.brown, UIColor.darkGray]
        for subView in subViews {
            let index = subViews.index(of: subView)!
            subView.frame = CGRect(x: CGFloat(index) * w, y: 0, width: w, height: h)
            subView.backgroundColor = colors[index]
            scrollView.addSubview(subView)
        }
    }
    
    /// 设置底部标签视图
    private func setupTabView() {
        let w = DEVICE_SCREEN_WIDTH
        let h = DEVICE_SCREEN_HEIGHT - DEVICE_STATUS_BAR_HEIGHT - TOP_AD_HEIGHT
        let tabView = Bundle.main.loadNibNamed("TabView", owner: nil, options: nil)?[0] as! TabView
        tabView.frame = CGRect(x: 0, y: h - BOTTOM_TAB_HEIGHT, width: w, height: BOTTOM_TAB_HEIGHT)
        containerView.addSubview(tabView)
        tabView.tabClickedClosure = { [weak self](tabType) in
            self?.scrollView.setContentOffset(CGPoint(x: CGFloat(tabType.rawValue)*w, y: 0), animated: false)
        }
    }
    
    /// 点击播放
    @IBAction func onPlayClicked(_ sender: UIButton) {
        player.start("http://a929.phobos.apple.com/us/r1000/143/Music3/v4/2c/4e/69/2c4e69d7-bd0f-8c76-30ca-75f6a2f51ef5/mzaf_1157339944153759874.plus.aac.p.m4a")
        DataHelper.shared.setPlayingInfo()
    }
    
    @objc func notitfyAudioDurationChanged(_ notify:Notification) {
        let cuttentTime = player.audioStreamer?.currentTime.transferFormat() ?? "00:00"
        let totalTime   = player.audioStreamer?.duration.transferFormat() ?? "00:00"
        print("cuttentTime = \(cuttentTime), totalTime = \(totalTime)")
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        Log.e("remoteControlReceived#")
        if event != nil && event!.type == .remoteControl {
            print("event!.subtype = \(event!.subtype.rawValue)")
            switch event!.subtype {
            case .remoteControlPlay:  // 播放事件【操作：停止状态下，按耳机线控中间按钮一下】
                player.resume()
            case .remoteControlPause: // 暂停事件
                player.pause()
            case .remoteControlStop:  // 停止事件
                break
            case .remoteControlTogglePlayPause:      // 播放或暂停切换【操作：播放或暂停状态下，按耳机线控中间按钮一下】
                break
            case .remoteControlNextTrack:            // 下一曲【操作：按耳机线控中间按钮两下】
                break
            case .remoteControlPreviousTrack:        // 上一曲【操作：按耳机线控中间按钮三下】
                break
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
