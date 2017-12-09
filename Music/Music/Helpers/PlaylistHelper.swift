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
    
    /// 添加歌曲至歌单  mode:表示歌曲数据  name:表示歌单名
    class func addToPlaylist(mode:SongRealm, name:String) {
        mode.songlistName = name
        let message = (name == LanguageKey.MyMusic_Favorite.value ? LanguageKey.Tip_AddedToFavorites.value : LanguageKey.Tip_AddingComplete.value)
        let results = RealmHelper.shared.query(type: SongRealm.self, predicate: NSPredicate(format: "songlistName = %@ AND sid = %d", mode.songlistName, mode.sid))
        if results.count == 0 {
            RealmHelper.shared.insert(obj: mode)
        }
        AppUI.tip(message)
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
        } else {
            RealmHelper.shared.delete(obj: results.first!)
            message = LanguageKey.Tip_RemovedFromFavorites.value
        }
        AppUI.tip(message)
        NotificationCenter.default.post(name: NoticationUpdateForPlaylistChanged, object: nil)
    }
}
