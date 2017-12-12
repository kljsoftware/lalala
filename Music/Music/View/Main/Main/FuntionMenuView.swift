//
//  FuntionMenuView.swift
//  Music
//
//  Created by hzg on 2017/12/12.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 常量
private let cellHeight:CGFloat = 40, duration:TimeInterval = 0.3

/// 功能菜单
class FuntionMenuView: UIView {
   
    // 选中按钮的索引
    fileprivate var selectedIndex: ((FunctionMenuType) -> Void)?
    
    /// 遮罩视图
    @IBOutlet weak var coverButton: UIButton!
    
    /// 内容视图
    @IBOutlet weak var contentView: UIView!
    
    /// 内容高度约束
    @IBOutlet weak var contentHeightLayoutConstraint: NSLayoutConstraint!
    
    /// 内容居底约束
    @IBOutlet weak var contentBottomLayoutConstraint: NSLayoutConstraint!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 取消按钮
    @IBOutlet weak var cancelButton: UIButton!
    
    /// 取消按钮居底约束
    @IBOutlet weak var cancelBottomLayoutConstraint: NSLayoutConstraint!
    
    /// 内容数组
    fileprivate var items = [FunctionMenuType]()
    
    /// 内容高度
    fileprivate var contentHeight:CGFloat = 0
    
    // MARK: - class methods
    /// 显示
    class func show(items:[FunctionMenuType], selectedIndex: ((FunctionMenuType) -> Void)?) {
        let view = Bundle.main.loadNibNamed("FuntionMenuView", owner: nil, options: nil)?[0] as! FuntionMenuView
        let window = (UIApplication.shared.delegate as! AppDelegate).window!
        window.addSubview(view)
        view.items = items
        view.tableView.reloadData()
        view.selectedIndex = selectedIndex
        view.cancelBottomLayoutConstraint.constant = DEVICE_INDICATOR_HEIGHT
        view.contentHeight = CGFloat(items.count + 1) * cellHeight + DEVICE_INDICATOR_HEIGHT
        view.contentHeightLayoutConstraint.constant = view.contentHeight
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(APP_SIZE.width)
            maker.height.equalTo(APP_SIZE.height)
            maker.bottom.equalTo(window)
            maker.top.equalTo(window).offset(-APP_Y)
        }
        
        view.contentBottomLayoutConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            view.layoutIfNeeded()
            view.coverButton.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        }
    }
    
    /// 初始化
    override func awakeFromNib() {
        tableView.register(UINib(nibName: "FunctionMenuCell", bundle: nil), forCellReuseIdentifier: "kFunctionMenuCell")
        cancelButton.setTitle(LanguageKey.Common_Cancel.value, for: .normal)
        cancelButton.setTitleColor(COLOR_ABABAB, for: .normal)
    }
    
    deinit {
        Log.e("deinit")
    }
    
    // MARK: - private methods
    /// 隐藏
    fileprivate func hide() {
        contentBottomLayoutConstraint.constant = -contentHeight
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.layoutIfNeeded()
            self?.coverButton.backgroundColor = UIColor(white: 0.0, alpha: 0)
            }, completion: { [weak self](finished) in
                self?.removeFromSuperview()
        })
    }
    
    /// 点击遮罩按钮
    @IBAction func onCoverButtonClicked(_ sender: UIButton) {
        hide()
    }
    
    /// 点击取消按钮
    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
        hide()
    }
    
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension FuntionMenuView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kFunctionMenuCell", for: indexPath) as! FunctionMenuCell
        cell.update(type: items[indexPath.row])
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex?(items[indexPath.row])
        hide()
    }
}
