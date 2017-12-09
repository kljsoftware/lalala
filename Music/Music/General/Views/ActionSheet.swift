//
//  ActionSheet.swift
//  Music
//
//  Created by hzg on 2017/12/3.
//  Copyright © 2017年 demo. All rights reserved.
//

import UIKit

class ActionSheet: UIView {
    
    // 选中按钮的索引
    fileprivate var selectedIndex: ((Int) -> Void)?
    // 标题和按钮背景视图
    fileprivate var bottomView: UIView!
    // 选项按钮
    fileprivate var items: [String]!

    
    // MARK: - class methods
    /**
     *  ActionSheet
     *
     *  @param title            标题
     *  @param items            选项数组 最多显示5项，超出5项可滑动
     *  @param selectedIndex    点击按钮回调
     */
    class func show(title: String? = nil, items: [String], cancel: String? = nil, selectedIndex: ((Int) -> Void)?) {
        let window      = UIApplication.shared.keyWindow!
        let actionSheet = ActionSheet(title: title, items: items, cancel: cancel, selectedIndex: selectedIndex)
        window.addSubview(actionSheet)
    }
    
    // MARK: - init methods
    private init(title: String? = nil, items: [String], cancel: String? = nil, selectedIndex: ((Int) -> Void)?) {
        
        super.init(frame: CGRect(x: 0, y: APP_Y, width: DEVICE_SCREEN_WIDTH, height: APP_HEIGHT))
        
        self.selectedIndex      = selectedIndex
        self.items              = items
        self.backgroundColor    = UIColor.clear
        
        // 背景单击手势
        let tap         = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        tap.delegate    = self
        self.addGestureRecognizer(tap)
        
        // 标题和按钮总高度
        let bottomViewH = (title != nil ? 32 : 0) + (items.count > 5 ? 240 : CGFloat(items.count)*48) + (cancel != nil ? 60 : 0) + DEVICE_INDICATOR_HEIGHT
        
        // 标题和按钮背景视图
        bottomView                  = UIView(frame: CGRect(x: 0, y: APP_HEIGHT, width: DEVICE_SCREEN_WIDTH, height: bottomViewH))
        bottomView.backgroundColor  = UIColor.black
        self.addSubview(bottomView)
        
        // 标题
        if title != nil {
            let label               = UILabel(frame: CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 32))
            label.text              = title
            label.font              = ARIAL_FONT_16
            label.textColor         = UIColor.white
            label.textAlignment     = .center
            label.backgroundColor   = UIColor.black
            bottomView.addSubview(label)
        }
        
        // tableview
        let tableView               = UITableView(frame: CGRect(x: 0, y: title != nil ? 32 : 0, width: bottomView.frame.width, height: items.count > 5 ? 240 : CGFloat(items.count)*48), style: .plain)
        tableView.rowHeight         = 48
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.separatorColor    = COLOR_ABABAB
        tableView.separatorInset    = UIEdgeInsets.zero
        tableView.isScrollEnabled   = items.count > 5
        bottomView.addSubview(tableView)
        
        // 取消按钮
        if cancel != nil {
            let cancelBtn   = UIButton(type: .custom)
            cancelBtn.frame = CGRect(x: 0, y: (title != nil ? 32 : 0) + (items.count > 5 ? 240 : CGFloat(items.count)*48) + 12, width: bottomView.frame.width, height: 48)
            cancelBtn.backgroundColor   = COLOR_464646
            cancelBtn.titleLabel?.font  = ARIAL_FONT_16
            cancelBtn.setTitle(cancel!, for: .normal)
            cancelBtn.setTitleColor(UIColor.white, for: .normal)
            cancelBtn.addTarget(self, action: #selector(cancelClicked(sender:)), for: .touchUpInside)
            cancelBtn.addTarget(self, action: #selector(cancelDown(sender:)), for: .touchDown)
            bottomView.addSubview(cancelBtn)
        }
        
        // 分割线
        if title != nil {
            let lineImgView     = UIImageView(frame: CGRect(x: 0, y: 32, width: bottomView.frame.width, height: 0.5))
           // lineImgView.image   = UIImage(named: "common_bottom_line")
            bottomView.addSubview(lineImgView)
        }
        
        // 动画显示
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
            self.bottomView.frame.origin.y = APP_HEIGHT - bottomViewH
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    // 选项按钮点击事件
    @objc private func cancelDown(sender: UIButton) {
        sender.backgroundColor = UIColor.black
    }
    
    @objc private func cancelClicked(sender: UIButton) {
        sender.backgroundColor = UIColor.white
        tapGesture()
    }
    
    // 背景单击手势
    @objc fileprivate func tapGesture() {
        UIView.animate(withDuration: 0.3, animations: { 
            self.backgroundColor = UIColor.clear
            self.bottomView.frame.origin.y = APP_HEIGHT
        }) { (finished) in
            self.removeFromSuperview()
        }
    }
}

// MARK: - tableview代理
extension ActionSheet: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell?.backgroundColor = COLOR_464646
            cell?.selectedBackgroundView = UIView(frame: cell!.frame)
            cell?.selectedBackgroundView?.backgroundColor = UIColor.clear
        }
        cell?.textLabel?.text           = items[indexPath.row]
        cell?.textLabel?.font           = ARIAL_FONT_16
        cell?.textLabel?.textColor      = UIColor.white
        cell?.textLabel?.textAlignment  = .center
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedIndex != nil {
            tapGesture()
            selectedIndex!(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.separatorInset = UIEdgeInsets.zero
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ActionSheet: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // 子视图上禁止父视图的手势
        if touch.view!.isDescendant(of: bottomView) {
            return false
        }
        return true
    }
}
