//
//  DiscoverRankDetailView.swift
//  Music
//
//  Created by hzg on 2017/12/10.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度
private let cellHeight:CGFloat = 80

/// 排行榜详情列表视图
class DiscoverRankDetailView: UIView {
    
    /// 业务模块
    let viewModel = DiscoverViewModel()

    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 排行榜列表
    fileprivate var ranklist = [RankInfoModel]()
    
    // MARK: - override methods
    /// 初始化
    override func awakeFromNib() {
        setupViewModel()
        setup()
    }
    
    /// 初始化业务模块
    private func setupViewModel() {
        viewModel.requestRankDetail()
        viewModel.setCompletion(onSuccess: { [weak self](resultModel) in
            guard let wself = self else {
                return
            }
            wself.ranklist.append(contentsOf: (resultModel as! DiscoverRankDetailResultModel).data)
            wself.tableView.reloadData()
        }) { (error) in
            Log.e("\(error)")
        }
    }
    
    /// 初始化界面
    private func setup() {
        titleLabel.text = LanguageKey.Discover_Rank.value
        tableView.register(UINib(nibName: "DiscoverRankDetailCell", bundle: nil), forCellReuseIdentifier: "kDiscoverRankDetailCell")
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DiscoverRankDetailView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranklist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kDiscoverRankDetailCell", for: indexPath) as! DiscoverRankDetailCell
        cell.update(model: ranklist[indexPath.row])
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view = Bundle.main.loadNibNamed("DiscoverRankView", owner: nil, options: nil)?.first as! DiscoverRankView
        AppUI.push(from: self, to: view, with: APP_SIZE)
    }
}
