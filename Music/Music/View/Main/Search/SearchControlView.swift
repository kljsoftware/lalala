//
//  SearchControlView.swift
//  Music
//
//  Created by hzg on 2017/12/5.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 常量定义
private let searchingTailConstraint:CGFloat = 92, unsearchingTailConstraint:CGFloat = 48
private let popularCellBlank:CGFloat = 12, cellHeight:CGFloat = 40

/// 搜索分区类型
private enum SearchSectionType : Int {
    case popular  // 热门搜索
    case history  // 历史搜索
}

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
    fileprivate var historys    = [SearchHistory]()
    
    // MARK: - override methods
    override func awakeFromNib() {
        searchTextField.placeholder = LanguageKey.Lang_MyMusic_TrackArtistAlbum.value
        collectionView.register(UINib(nibName: "SearchPopularCell", bundle: nil), forCellWithReuseIdentifier: "kSearchPopularCell")
        collectionView.register(UINib(nibName: "SearchHistoryCell", bundle: nil), forCellWithReuseIdentifier: "kSearchHistoryCell")
        collectionView.register(UINib(nibName: "SearchPopularSectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kSearchPopularSectionView")
    }
    
    /// 搜索
    fileprivate func search(key:String) {
        searchTextField.resignFirstResponder()
        collectionView.isHidden = true
        searchCloure?(key, "song")
        
        /// 增加新的历史数据
        RealmHelper.shared.insert(obj: SearchHistory(value: [key, Date()]), predicate: NSPredicate(format: "name = %@", key))
        
        /// 查询历史记录并按就近时间查询排序
        let history = RealmHelper.shared.query(type: SearchHistory.self)
        historys = history.sorted(by: {$0.0.date > $0.1.date})
        collectionView.reloadData()
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
        
        /// 热门搜索并按搜索次数排序
        let sortTupes = popularDic.sorted(by: {$0.value >= $1.value})
        for (key, _) in sortTupes {
            popularKeys.append(key)
        }
        
        /// 查询历史记录并按就近时间查询排序
        let history = RealmHelper.shared.query(type: SearchHistory.self)
        historys = history.sorted(by: {$0.0.date > $0.1.date})

        /// 刷新界面
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension SearchControlView :  UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    /// 网格分区
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return historys.count == 0 ? 1 : 2
    }
    
    /// 总共网格单元的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch SearchSectionType(rawValue:section)! {
        case .popular:
            return popularKeys.count
        case .history:
            return historys.count
        }
    }
    
    // 网格单元
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch SearchSectionType(rawValue:indexPath.section)! {
        case .popular:
            let popularCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSearchPopularCell", for: indexPath) as! SearchPopularCell
            popularCell.update(name: popularKeys[indexPath.row])
            return popularCell
        case .history:
            let historyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSearchHistoryCell", for: indexPath) as! SearchHistoryCell
            historyCell.deleteClosure = { [weak self] (cell:UICollectionViewCell) in
                guard let weakself = self else {
                    return
                }
                if let indexPath = collectionView.indexPath(for: cell) {
                    RealmHelper.shared.delete(obj: weakself.historys[indexPath.row])
                    weakself.historys.remove(at: indexPath.row)
                    collectionView.reloadData()
                }
            }
            historyCell.update(model: historys[indexPath.row])
            return historyCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "kSearchPopularSectionView", for: indexPath) as! SearchPopularSectionView
        sectionCell.update(type: indexPath.section)
        return sectionCell
    }
    
    /// 单元点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var content = ""
        switch SearchSectionType(rawValue:indexPath.section)! {
        case .popular:
            content = popularKeys[indexPath.row]
        case .history:
            content = historys[indexPath.row].name
        }
        searchTextField.text = content
        search(key: content)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    // 设置选择单元的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch SearchSectionType(rawValue:indexPath.section)! {
        case .popular:
            let size = popularKeys[indexPath.row].sizeWithFont(ARIAL_FONT_16)
            return CGSize(width:size.width+popularCellBlank*2, height:cellHeight)
        case .history:
            return CGSize(width:frame.width-popularCellBlank*2, height:cellHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch SearchSectionType(rawValue:section)! {
        case .popular:
            return popularCellBlank/2
        case .history:
            return 0
        }
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
        search(key:textField.text ?? "")
        return true
    }
}
