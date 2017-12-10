//
//  DiscoverRankView.swift
//  Music
//
//  Created by hzg on 2017/12/9.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 单元高度
private let cellHeight:CGFloat = 60

/// 歌曲排行榜
class DiscoverRankView: UIView {
    
    /// 排行榜信息
    var rankInfo:RankInfoModel? {
        didSet {
            if rankInfo != nil {
                titleLabel.text = rankInfo!.title
                let rankId = rankInfo!.rank_id == 0 ? 31000 : rankInfo!.rank_id
                viewModel.requestRankList(randId: rankId)
            }
        }
    }

    /// 业务模块
    private let viewModel = DiscoverViewModel()
    
    /// 标题
    @IBOutlet weak var titleLabel: UILabel!
    
    /// 列表视图
    @IBOutlet weak var tableView: UITableView!
    
    /// 歌曲数据
    fileprivate var songlist = [FMSongDataModel]()
    
    /// MARK: - override methods
    override func awakeFromNib() {
        tableView.register(UINib(nibName: "SearchResultCell", bundle: nil), forCellReuseIdentifier: "kSearchResultCell")
        viewModel.setCompletion(onSuccess: { [weak self](resultModel) in
            guard let wself = self else {
                return
            }
            wself.songlist = (resultModel as! DiscoverRankResultModel).data.songs
            wself.tableView.reloadData()
        }) { (error) in
            Log.e(error)
        }
    }
    
    /// 点击返回按钮
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        AppUI.pop(self)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension DiscoverRankView :  UITableViewDataSource, UITableViewDelegate {
    
    /// 各个分区的单元(Cell)个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songlist.count
    }
    
    /// 单元(cell)视图
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSearchResultCell", for: indexPath) as! SearchResultCell
        cell.update(model: SongRealm.getModel(model: songlist[indexPath.row]), serial: indexPath.row+1)
        return cell
    }
    
    /// 单元(cell)的高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    /// 单元(cell)选中事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlayerHelper.shared.changePlaylist(playlist: songlist, playIndex: indexPath.row, owner: self)
    }
}
