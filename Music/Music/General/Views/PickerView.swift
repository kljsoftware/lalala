//
//  PickerView.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 底部栏高度、动画时间
private let bottomContentHeight:CGFloat = 220 + DEVICE_INDICATOR_HEIGHT, duration:TimeInterval = 0.3
private let hours = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]
private let mins = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                    11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                    21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
                    31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
                    41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
                    51, 52, 53, 54, 55, 56, 57, 58, 59]

/// 通用数字选择器
class PickerView: UIView {
    
    /// 遮罩按钮
    @IBOutlet weak var coverButton: UIButton!
    
    /// 底部视图高度约束
    @IBOutlet weak var bottomHeightLayoutConstraint: NSLayoutConstraint!
    
    /// 底部视图居底约束
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    /// 取消按钮
    @IBOutlet weak var cancelButton: UIButton!
    
    /// 确定按钮
    @IBOutlet weak var okButton: UIButton!
    
    /// 提示
    @IBOutlet weak var tipLabel: UILabel!
    
    /// 小时
    @IBOutlet weak var hourLabel: UILabel!
    
    /// 分钟
    @IBOutlet weak var minLabel: UILabel!
    
    /// 时间选择器
    @IBOutlet weak var picker: UIPickerView!
    
    /// 数据源
    fileprivate var dataItems = [[Int]]()
    
    /// 闭包
    fileprivate var selectDataClosure: (([Int]) -> Void)?
    
    /// 选中的数字
    fileprivate var selectValues = [Int](), defaultSelectedRows = [Int]()
    
    // MARK: - class methods
    /// 显示
    class func show(dataItems:[[Int]] = [hours, mins], selectRows:[Int] = [1, 15], selectDataClosure: (([Int]) -> Void)?) {
        let view = Bundle.main.loadNibNamed("PickerView", owner: nil, options: nil)?[0] as! PickerView
        let window = (UIApplication.shared.delegate as! AppDelegate).window!
        window.addSubview(view)
        view.dataItems = dataItems
        view.defaultSelectedRows = selectRows
        view.selectValues = [Int](repeating: 0, count: dataItems.count)
        view.selectDataClosure = selectDataClosure
        view.bottomHeightLayoutConstraint.constant = bottomContentHeight
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(APP_SIZE.width)
            maker.bottom.equalTo(window)
            maker.top.equalTo(window).offset(-APP_Y)
        }
        view.show()
    }
    
    // MARK: - private methods
    fileprivate func show() {
        self.perform(#selector(delayAnim), with: nil, afterDelay: 0.1)
    }
    
    /// 延迟动画，不做延迟，动画会斜着出来 [暂时不知道原因]
    @objc private func delayAnim() {
        bottomLayoutConstraint.constant = 0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.coverButton.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        }, completion: {[weak self] (finished) in
            guard let wself = self else {
                return
            }
            
            /// 设置默认选中项
            if wself.dataItems.count > 0 && wself.dataItems.count == wself.defaultSelectedRows.count {
                for component in 0..<wself.dataItems.count {
                    let row = wself.defaultSelectedRows[component]
                    wself.picker.selectRow(row, inComponent: component, animated: false)
                    wself.selectValues[component] = wself.dataItems[component][row]
                }
            }
        })
    }
    
    /// 隐藏
    fileprivate func hide() {
        bottomLayoutConstraint.constant = -bottomContentHeight
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.coverButton.backgroundColor = UIColor(white: 0.0, alpha: 0)
            }, completion: { [weak self](finished) in
                self?.removeFromSuperview()
        })
    }
    
    // MARK: - override methods
    /// 初始化
    override func awakeFromNib() {
        cancelButton.setTitle(LanguageKey.Common_Cancel.value, for: .normal)
        okButton.setTitle(LanguageKey.Common_OK.value, for: .normal)
        tipLabel.text = LanguageKey.Setting_MusicSleepDescription.value
        hourLabel.text = LanguageKey.Common_Hour.value
        minLabel.text = LanguageKey.Common_Minute.value
        cancelButton.isExclusiveTouch = true
        okButton.isExclusiveTouch = true
        coverButton.isExclusiveTouch = true
    }

    /// 点击覆盖按钮
    @IBAction func onCoverButtonClicked(_ sender: UIButton) {
        hide()
    }
    
    /// 点击取消按钮
    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
        hide()
    }
    
    /// 点击确定按钮
    @IBAction func onOkButtonClicked(_ sender: UIButton) {
        selectDataClosure?(selectValues)
        hide()
    }
    
}


// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // 返回的列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataItems.count
    }
    
    // 每列返回的个数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let items = dataItems[component]
        return items.count
    }
    
    // 每行显示内容
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let value   = dataItems[component][row]
        let attributeString = NSMutableAttributedString(string: "\(value)", attributes: [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName : ARIAL_FONT_12])
        return attributeString
    }
    
    // 选中行
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectValues[component] = dataItems[component][row]
    }
}
