//
//  PlaylistHelper.swift
//  Music
//
//  Created by hzg on 2017/12/9.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 歌单助手
class PlaylistHelper {
    
    /// 创建歌单
    class func createPlaylist(name:String) {
        RealmHelper.shared.insert(obj: SonglistRealm(value: [name, Date()]))
        NotificationCenter.default.post(name: NoticationUpdateForCreateNewPlaylist, object: nil)
    }
    
    /// 批量删除歌曲
    class func batchDeletePlaylist(modes:[SongRealm]) {
        for mode in modes {
            RealmHelper.shared.delete(obj: mode)
        }
    }
    
    /// 批量添加歌曲至歌单
    class func batchAddToPlaylist(modes:[SongRealm], name:String, showTip:Bool = false) {
        for mode in modes {
            addToPlaylist(mode: mode, name: name)
        }
        
        let message = (name == LanguageKey.MyMusic_Favorite.value ? LanguageKey.Tip_AddedToFavorites.value : LanguageKey.Tip_AddingComplete.value)
        if showTip {
            AppUI.tip(message)
        }
    }
    
    /// 添加歌曲至歌单  mode:表示歌曲数据  name:表示歌单名
    class func addToPlaylist(mode:SongRealm, name:String) {
        let newMode = SongRealm(value:mode)
        newMode.songlistName = name
        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@ AND sid = %d", newMode.songlistName, newMode.sid))
        if results.count == 0 {
            RealmHelper.shared.insert(obj:newMode)
        }
        NotificationCenter.default.post(name: NoticationUpdateForPlaylistChanged, object: nil)
    }
 
    /// 添加歌曲至我喜爱的歌单/移除
    class func addOrRemoveFavorites(songModel:FMSongDataModel) {
        let songRealm = SongRealm.getModel(model: songModel)
        songRealm.songlistName = LanguageKey.MyMusic_Favorite.value
        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@ AND sid = %d", songRealm.songlistName, songRealm.sid))
        var message = ""
        if results.count == 0 {
            RealmHelper.shared.insert(obj: songRealm)
            message = LanguageKey.Tip_AddedToFavorites.value
            /// 我喜欢的音乐（收藏哪首）统计
            RKBISDKHelper.shared.rkTrackEvent(eventType: .mymusic(type: .collect(name: songModel.title)))
        } else {
            RealmHelper.shared.delete(obj: results.first!)
            message = LanguageKey.Tip_RemovedFromFavorites.value
        }
        AppUI.tip(message)
        NotificationCenter.default.post(name: NoticationUpdateForPlaylistChanged, object: nil)
    }
    
    ///  判断歌曲是否是我喜爱的歌曲
    class func isMyFavritesSong(songModel:FMSongDataModel) -> Bool {
        let songRealm = SongRealm.getModel(model: songModel)
        songRealm.songlistName = LanguageKey.MyMusic_Favorite.value
        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@ AND sid = %d", songRealm.songlistName, songRealm.sid))
        return results.count != 0
    }
    
    /// 判断歌曲是否已下载
    class func isDownloadSong(sid:Int?) -> Bool {
        guard let sid = sid else {
            return false
        }
        let r1 = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "downloadFlag = %d AND sid = %d", 1, sid))
        let r2 = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "downloadFlag = %d AND sid = %d", 2, sid))
        return r1.count > 0 || r2.count > 0
    }
}
