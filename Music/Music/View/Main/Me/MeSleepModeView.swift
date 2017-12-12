//
//  MeSleepModeView.swift
//  Music
//
//  Created by hzg on 2017/12/6.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度及个数
private let cellHeight:CGFloat = 44, numberOfRowsInSection = 7

/// 休眠模式类型
enum SleepModeType : Int {
    case disbleTimer  // 不开启定时/关闭
    case after15mins  // 15分钟后休眠
    case after30mins  // 30分钟后休眠
    case after60mins  // 60分钟后休眠
    case after90mins  // 90分钟后休眠
    case after120mins // 120分钟后休眠
    case custom       // 自定义时间休眠
}

/// 休眠模式
class MeSleepModeView: UIView {
    
    /// 休眠模式回调闭包
    var sleepModeClosure:(()->Void)?
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 定时模式
    @IBOutlet weak var modelLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 是否更改的休眠模式、定时日期
    fileprivate var isChangedSleepMode = false, fireDate:Date?
    
    // MARK: - override methods
    override func awakeFromNib() {
        titleLabel.text = LanguageKey.Setting_SleepMode.value
        modelLabel.text = (SleepHelper.shared.fireDate == nil ? LanguageKey.Common_Close.value : String(format: LanguageKey.Setting_MusicWillPauseAt.value, SleepHelper.shared.fireDate!.getTime(format: "HH:mm:ss")))
        tableView.register(UINib(nibName: "MeSleepModeCell", bundle: nil), forCellReuseIdentifier: "kMeSleepModeCell")
    }
    
    deinit {
        Log.e("deinit")
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        if isChangedSleepMode {
            SleepHelper.shared.fireDate = fireDate
            sleepModeClosure?()
        }
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MeSleepModeView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRowsInSection
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kMeSleepModeCell", for: indexPath) as! MeSleepModeCell
        cell.update(type: SleepModeType(rawValue: indexPath.row)!)
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(true, animated: false)
        isChangedSleepMode = true
        let nowDate = Date()
        switch SleepModeType(rawValue: indexPath.row)! {
        case .disbleTimer:
            fireDate = nil
        case .after15mins:
            fireDate = nowDate.addingTimeInterval(15*60)
        case .after30mins:
            fireDate = nowDate.addingTimeInterval(30*60)
        case .after60mins:
            fireDate = nowDate.addingTimeInterval(60*60)
        case .after90mins:
            fireDate = nowDate.addingTimeInterval(90*60)
        case .after120mins:
            fireDate = nowDate.addingTimeInterval(120*60)
        case .custom:
            isChangedSleepMode = false
            PickerView.show(selectDataClosure: {[weak self] (values) in
                guard let wself = self else {
                    return
                }
                if values.count < 2 {
                    return
                }
                let interval:TimeInterval = TimeInterval(values[0]*3600 + values[1]*60)
                if interval > 0 {
                    wself.fireDate = nowDate.addingTimeInterval(interval)
                    wself.isChangedSleepMode = true
                    wself.modelLabel.text = (wself.fireDate == nil ? LanguageKey.Common_Close.value : String(format: LanguageKey.Setting_MusicWillPauseAt.value, wself.fireDate!.getTime(format: "HH:mm:ss")))
                }
            })
        }
        
        modelLabel.text = (fireDate == nil ? LanguageKey.Common_Close.value : String(format: LanguageKey.Setting_MusicWillPauseAt.value, fireDate!.getTime(format: "HH:mm:ss")))
    }
}
