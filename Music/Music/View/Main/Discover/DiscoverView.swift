//
//  DiscoverView.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 搜索控制高度
private let discoverTitleHeight:CGFloat = 44

/// 标题视图
private class TitleView : UIView {
    
    /// 标题
    private lazy var titleLabel:UILabel = {
        let _titleLabel = UILabel(frame: self.bounds)
        _titleLabel.textColor = UIColor.white
        _titleLabel.font = ARIAL_FONT_19
        _titleLabel.textAlignment = .center
        self.addSubview(_titleLabel)
        return _titleLabel
    }()
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        /// 下划线
        let divideView = UIView()
        divideView.backgroundColor = COLOR_ABABAB.withAlphaComponent(0.5)
        addSubview(divideView)
        divideView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(self)
            maker.bottom.equalTo(self).offset(-ONE_PIXELS)
            maker.height.equalTo(ONE_PIXELS)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - public methods
    func setup(title:String?) {
        titleLabel.text = title
    }
}

/// 发现模块
class DiscoverView: UIView {
    
    /// 业务模块
    let viewModel = DiscoverViewModel()
    
    /// 标题视图
    private lazy var titleView : TitleView = {
        let _titleView = TitleView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: discoverTitleHeight))
        self.addSubview(_titleView)
        return _titleView
    }()
    
    /// 主内容视图
    private lazy var collectionView:DiscoverCollectionView = {
        let _collectionView =  Bundle.main.loadNibNamed("DiscoverCollectionView", owner: nil, options: nil)?[0] as! DiscoverCollectionView
        _collectionView.frame = CGRect(x: 0, y: discoverTitleHeight, width: self.frame.width, height: self.frame.height - (discoverTitleHeight + BOTTOM_TAB_HEIGHT+DEVICE_INDICATOR_HEIGHT))
        self.addSubview(_collectionView)
        return _collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private methods
    private func setup() {
        
        // 标题
        titleView.setup(title: Lang_Discover)
        
        /// 更多加载更多开始闭包
        collectionView.beginFooterRefreshingClosure = { [weak self](page) in
            self?.viewModel.requestLoadSongLists(page: page)
        }
        
        viewModel.requestRankv3()
        viewModel.setCompletion(onSuccess: { [weak self](resultModel) in
            guard let weakself = self else {
                return
            }
            if resultModel.isKind(of: DiscoveryMainResultModel.self) {
                let model = resultModel as! DiscoveryMainResultModel
                weakself.collectionView.setup(model: model.data)
            } else {
                let model = resultModel as! DiscoveryLoadSonglistResultModel
                weakself.collectionView.setupSonglist(songlistModel: model.data)
            }
        }) { (error) in
            Log.e(error)
        }
    }
}
