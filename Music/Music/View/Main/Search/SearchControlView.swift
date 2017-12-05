//
//  SearchControlView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

private let searchingTailConstraint:CGFloat = 92, unsearchingTailConstraint:CGFloat = 48

/// 搜索功能视图模块
class SearchControlView: UIView {
    
    /// 搜索开始
    fileprivate var searchBeginCloure:(()->Void)?
    
    /// 取消搜索
    fileprivate var cancelSearchCloure:(()->Void)?
    
    /// 清除搜索结果
    fileprivate var clearSearchCloure:(()->Void)?
    
    /// 搜索
    fileprivate var searchCloure:((_ query:String, _ type:String) -> Void)?

    /// 搜索框
    @IBOutlet weak var searchTextField: UITextField!
    
    /// 搜索框居右约束
    @IBOutlet weak var searchTrailLayoutConstraint: NSLayoutConstraint!
   
    /// 取消按钮
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - IBAction methods
    /// 点击取消按钮
    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
        searchTrailLayoutConstraint.constant = unsearchingTailConstraint
        searchTextField.resignFirstResponder()
        sender.isHidden = true
        searchTextField.text = ""
        cancelSearchCloure?()
    }
    
    // MARK: - public methods
    func setup(searchBeginCloure:(()->Void)?, cancelSearchCloure:(()->Void)?, searchCloure:((_ query:String, _ type:String) -> Void)?, clearSearchCloure:(()->Void)?) {
        self.searchBeginCloure = searchBeginCloure
        self.cancelSearchCloure = cancelSearchCloure
        self.searchCloure = searchCloure
        self.clearSearchCloure = clearSearchCloure
    }
}

// MARK: UITextViewDelegate
extension SearchControlView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        searchTrailLayoutConstraint.constant = searchingTailConstraint
        cancelButton.isHidden = false
        searchBeginCloure?()
    }
    
    /// 点击清除按钮
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        clearSearchCloure?()
        return true
    }
    
    /// 点击软键盘Next、go处理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchCloure?(textField.text ?? "", "song")
        return true
    }
}
