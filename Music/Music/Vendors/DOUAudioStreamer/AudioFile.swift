//
//  AudioFile.swift
//  Music
//
//  Created by hzg on 2017/11/22.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 流播放器需实现DOUAudioFile协议
class AudioFile : NSObject, DOUAudioFile {
    
    // 远程播放地址
    var url:URL!
   
    // 覆写DOUAudioFile方法
    func audioFileURL() -> URL! {
        return url
    }
}
