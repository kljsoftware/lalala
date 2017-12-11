//
//  LyricView.swift
//  Music
//
//  Created by hzg on 2017/11/30.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌词视图
class LyricView: UIView {
    
    /// 单击歌词回调
    var clickedClosure:(()->Void)?
    
    /// 歌词首尾距顶部、尾部边距、歌词上下空白、歌词左右屏幕边距、渐变区域高度
    private let marginTopBottom:CGFloat = 30, blank:CGFloat = 12, marginLeftRight:CGFloat = 40, gradientHeight:CGFloat = 20

    /// 歌词
    private var lyric:Lyric?
    
    /// 下载任务
    private var download:DownloadTask?
    
    /// 当前索引
    private var index = 0
    
    /// 滚动视图
    private lazy var scrollView:UIScrollView = {
        let _scrollView = UIScrollView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        _scrollView.showsVerticalScrollIndicator = false
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.backgroundColor = UIColor.clear
        self.addSubview(_scrollView)
        return _scrollView
    }()
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击手势
    func performTapGesture(sender:UITapGestureRecognizer) {
        self.isHidden = true
        clickedClosure?()
    }
    
    // MARK: - private methods
    /// 初始化
    private func setup() {
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performTapGesture)))
        let topCoverView = UIView.gradientView(frame: CGRect(x: 0, y: 0, width: frame.width, height: gradientHeight), start: CGPoint.zero, end: CGPoint(x: 0, y: 1.0))
        let bottomCoverView = UIView.gradientView(frame: CGRect(x: 0, y: frame.height - gradientHeight, width: frame.width, height: gradientHeight), start: CGPoint(x: 0.0, y: 1.0), end: CGPoint.zero)
        addSubview(topCoverView)
        addSubview(bottomCoverView)
    }
    
    /// 清除原有视图
    private func removeSubViews() {
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    /// 添加歌词视图
    private func addLyricView(lrcPath:String?) {
        guard let lyric = Lyric.parse(lrcPath: lrcPath) else {
            return
        }
        self.lyric = lyric
        var y:CGFloat = marginTopBottom
        for sentence in lyric.sentences {
            let size = sentence.content.getTextRectSize(ARIAL_FONT_16, maxWidth: frame.width - 2*marginLeftRight, maxHeight: frame.height)
            let label = UILabel(frame:CGRect(x:(frame.width - size.width)/2, y: y, width: size.width, height: size.height))
            label.text = sentence.content
            label.numberOfLines = 0
            label.textColor = UIColor.white
            label.lineBreakMode = .byWordWrapping
            label.textAlignment = .center
            label.font = ARIAL_FONT_16
            scrollView.addSubview(label)
            y += (label.frame.height + blank)
        }
        y += (marginTopBottom - blank)
        scrollView.contentSize = CGSize(width: frame.width, height: y)
        /// 选中第一句
        selectSentence(index: 0)
    }
    
    // 计算自动滚动结束位置
    private func calcScrollY(_ rect:CGRect) -> CGFloat {
        let scrollViewHeight        = frame.size.height
        let scrollViewBaseline      = scrollViewHeight / 2
        let scrollViewContentHeight = scrollView.contentSize.height
        let cellMiddle = rect.midY
        
        var y:CGFloat = 0
        if (scrollViewContentHeight - cellMiddle) < (scrollViewHeight - scrollViewBaseline) {
            y = scrollViewContentHeight - scrollViewHeight
        } else {
            y = cellMiddle - scrollViewBaseline
        }
        
        // 边界处理
        if y < 0 {
            y = 0
        }
        
        if y > scrollViewContentHeight {
            y = scrollViewContentHeight
        }
        return y
    }
    
    /// 选中句子并滚动居中
    private func selectSentence(index:Int) {
        if index >= 0 && index < scrollView.subviews.count {
            let label = (scrollView.subviews[index] as! UILabel)
            label.textColor = COLOR_69EDC8
            scrollView.setContentOffset(CGPoint(x: 0, y: calcScrollY(label.frame)), animated: true)
            self.index = index
        }
    }
    
    /// 取消句子选择状态
    private func unselectSentence(index:Int) {
        if index >= 0 && index < scrollView.subviews.count {
            (scrollView.subviews[index] as! UILabel).textColor = UIColor.white
        }
    }
    
    // MARK: - public methods
    /// 初始化设置
    func setup(lyricUrl:String?) {
        removeSubViews()
        index = 0
        download = nil
        download = DownloadTask(urlString: lyricUrl)
        download?.downloadFinishedCallback = {[weak self](lrcPath) in
            self?.addLyricView(lrcPath: lrcPath)
        }
        download?.resume()
    }
    
    /// 滚动歌词
    func scrollByTime(currentTime:TimeInterval) {
        if lyric == nil || lyric!.sentences.count == 0  || index > lyric!.sentences.count - 1{
            return
        }

        for i in 0..<lyric!.sentences.count {
            let sentence = lyric!.sentences[i]
            if currentTime < sentence.fromTime {
                let index = i - 1
                if index > self.index  {
                    let nextSentence = lyric!.sentences[index]
                    if currentTime > nextSentence.fromTime && !nextSentence.content.isBlank() {
                        unselectSentence(index: self.index)
                        selectSentence(index: index)
                    }
                }
                break
            }
        }
    }
    
}

/**
 lrc歌词文本中含有两类标签：
 标识标签:
 [ar:歌手名]、[ti:歌曲名]、[al:专辑名]、[by:编辑者(指lrc歌词的制作人)]、[offset:时间补偿值] （其单位是毫秒，正值表示整体提前，负值相反。这是用于总体调整显示快慢的，但多数的MP3可能不会支持这种标签）
 
 时间标签，形式为“[mm:ss]”或“[mm:ss.ff]”(分钟数:秒数.百分之一秒数[2]  )，时间标签需位于某行歌词中的句首部分，一行歌词可以包含多个时间标签(比如歌词中的迭句部分)。当歌曲播放到达某一时间点时，MP3就会寻找对应的时间标签并显示标签后面的歌词文本，这样就完成了“歌词同步”的功能
 */

/// 歌词句子
typealias LyricSentence = (fromTime:TimeInterval, content:String)

/// 歌词
class Lyric : NSObject {
    
    /// 曲名
    var title = ""
    
    /// 专辑名
    var album = ""
    
    /// 艺人名
    var artist = ""
    
    /// 歌词作者
    var author = ""
    
    /// 编者（指编辑LRC歌词的人）
    var by = ""
    
    /// 其单位是毫秒，正值表示整体提前，负值相反。这是用于总体调整显示快慢的。
    var offset = 0
    
    /// 歌词句子数组
    var sentences = [LyricSentence]()
    
    /// 歌词解析
    class func parse(lrcPath:String?) -> Lyric? {
        
        /// 空串
        if lrcPath == nil || lrcPath!.isEmpty {
            return nil
        }
        
        /// 检验是否时合法Url
        guard let content = try? String.init(contentsOfFile: lrcPath!, encoding: String.Encoding.utf8) else {
            return nil
        }
        
        let lrc = Lyric()
        
        let components = content.components(separatedBy: CharacterSet.newlines)
        for component in components {
            if component.hasPrefix("[") {
                if component.hasPrefix("[ti:") || component.hasPrefix("[ar:") || component.hasPrefix("[al:") || component.hasPrefix("[by:") {
                    let tag  = component.subString(start: 1, end: 3)
                    let text = component.subString(start: 4, end: -1)
                    
                    switch tag {
                    case "ti":
                        lrc.title  = text
                    case "ar":
                        lrc.artist = text
                    case "al":
                        lrc.album  = text
                    case "by":
                        lrc.by     = text
                    case "offset":
                        lrc.offset = Int(text) ?? 0
                    default:
                        Log.e(text)
                    }
                }
                else {
                    let result = component.components(separatedBy: CharacterSet(charactersIn: "[]"))
                    if result.count > 2 {
                        let sentence = LyricSentence(Double.transfer(format: result[1]), result[2])
                        lrc.sentences.append(sentence)
                    }
                }
            }
        }
        
        return lrc
    }
}
