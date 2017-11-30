//
//  LyricView.swift
//  Music
//
//  Created by hzg on 2017/11/30.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌词视图
class LyricView: UIScrollView {
    
    /// 单击歌词回调
    var clickedClosure:(()->Void)?
    
    /// 歌词句子
    private var sentences = [LyricSentence]()
    
    // MARK: - init/override methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(performTapGesture)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 点击手势
    func performTapGesture(sender:UITapGestureRecognizer) {
        self.isHidden = true
        clickedClosure?()
    }
    
    // MARK: - public methods
    /// 初始化设置
    func setup(lyricUrl:String?) {
        
    }
    
    /// 滚动歌词
    func scrollByTime(currentTime:TimeInterval) {
        
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
        
        guard let path = lrcPath, let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else {
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
                    let sentence = LyricSentence(Double.transfer(format: result[1]), result[2])
                    lrc.sentences.append(sentence)
                }
            }
        }
        
        return lrc
    }
}
