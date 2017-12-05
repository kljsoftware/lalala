//
//  SearchControlView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

private let searchingTailConstraint:CGFloat = 92, unsearchingTailConstraint:CGFloat = 48
private let collectionViewCellMagin:CGFloat = 12

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
    
    /// 热门搜索/历史记录列表
    @IBOutlet weak var collectionView: UICollectionView!
    fileprivate var popularKeys = [String]()
    
    // MARK: - override methods
    override func awakeFromNib() {
        collectionView.register(UINib(nibName: "SearchPopularCell", bundle: nil), forCellWithReuseIdentifier: "kSearchPopularCell")
        collectionView.register(UINib(nibName: "SearchPopularSectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kSearchPopularSectionView")
    }
    
    // MARK: - IBAction methods
    /// 点击取消按钮
    @IBAction func onCancelButtonClicked(_ sender: UIButton) {
        searchTrailLayoutConstraint.constant = unsearchingTailConstraint
        searchTextField.resignFirstResponder()
        sender.isHidden = true
        searchTextField.text = ""
        collectionView.isHidden = true
        cancelSearchCloure?()
    }
    
    // MARK: - public methods
    /// 设置闭包回调
    func setup(searchBeginCloure:(()->Void)?, cancelSearchCloure:(()->Void)?, searchCloure:((_ query:String, _ type:String) -> Void)?, clearSearchCloure:(()->Void)?) {
        self.searchBeginCloure = searchBeginCloure
        self.cancelSearchCloure = cancelSearchCloure
        self.searchCloure = searchCloure
        self.clearSearchCloure = clearSearchCloure
    }
    
    /// 设置热门数据
    func setup(popularDic:[String:Int]) {
        popularKeys = Array(popularDic.keys)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension SearchControlView :  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    /// 网格分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// 总共网格单元的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularKeys.count
    }
    
    // 网格单元
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let popularCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSearchPopularCell", for: indexPath) as! SearchPopularCell
        popularCell.update(name: popularKeys[indexPath.row])
        return popularCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kSearchPopularSectionView", for: indexPath) as! SearchPopularSectionView
        sectionCell.update(title: "热点搜索")
        return sectionCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    // 设置选择单元的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = popularKeys[indexPath.row].sizeWithFont(ARIAL_FONT_16)
        return CGSize(width:size.width+collectionViewCellMagin*2, height:40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewCellMagin/2
    }
}

// MARK: UITextViewDelegate
extension SearchControlView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        searchTrailLayoutConstraint.constant = searchingTailConstraint
        cancelButton.isHidden = false
        collectionView.isHidden = false
        searchBeginCloure?()
    }
    
    /// 点击清除按钮
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        collectionView.isHidden = false
        clearSearchCloure?()
        return true
    }
    
    /// 点击软键盘Next、go处理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        collectionView.isHidden = true
        searchCloure?(textField.text ?? "", "song")
        return true
    }
}
