//
//  LanguageMacro.swift
//  Music
//
//  Created by hzg on 2017/12/7.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 多语言常量设置

/// 多语言键值类型
enum LanguageKey : String {
   
    /// 首页
    case Lang_FM            =  "FM_FM"
    case Lang_MyMusic       =  "MyMusic_MyMusic"
    case Lang_Discover      =  "Discover_Discover"
    case Lang_Query_Search  =  "Query_Search"
    case Lang_Me            =  "Me_Me"
    
    ///  FM
    case Lang_FM_RefreshTracks =  "FM_RefreshTracks"
    
    /// 我的音乐
    case Lang_MyMusic_Favorite        =  "MyMusic_Favorite"
    case Lang_MyMusic_MyDownload      =  "MyMusic_MyDownload"
    case Lang_MyMusic_OwnedPlaylists  =  "MyMusic_OwnedPlaylists"
    case Lang_MyMusic_CreatePlaylist  =  "MyMusic_CreatePlaylist"
    case Lang_MyMusic_Downloaded      =  "MyMusic_Downloaded"
    case Lang_MyMusic_Downloading     =  "MyMusic_Downloading"
    case Lang_MyMusic_AddToPlaylist   =  "MyMusic_AddToPlaylist"
    case Lang_MyMusic_SelectAll       =  "MyMusic_SelectAll"
    case Lang_MyMusic_NumberSeclected =  "MyMusic_NumberSeclected"
    case Lang_MyMusic_EditPlaylistNameDescription =  "MyMusic_EditPlaylistNameDescription"
    case Lang_MyMusic_TrackArtistAlbum            =  "MyMusic_TrackArtistAlbum"
    
    /// 发现
    case Lang_Discover_Rank              =  "Discover_Rank"
    case Lang_Discover_PopularPlaylist   =  "Discover_PopularPlaylist"
    
    /// 搜索
    case Lang_Query_PopularSearches     =  "Query_PopularSearches"
    case Lang_Query_NoResults           =  "Query_NoResults"
    case Lang_Query_ClearSearchHistory  =  "Query_ClearSearchHistory"
    case Lang_Query_SearchHistory       =  "Query_SearchHistory"
    
    /// 我
    case Lang_Setting_TodayRemainingDownloads =  "Setting_TodayRemainingDownloads"
    case Lang_Setting_SleepMode          =  "Setting_SleepMode"
    case Lang_Setting_Setting            =  "Setting_Setting"
    case Lang_Setting_ShareThisApp       =  "Setting_ShareThisApp"
    case Lang_Setting_DisableTimer       =  "Setting_Setting_DisableTimer"
    case Lang_Setting_NumberMinutesLater =  "Setting_NumberMinutesLater"
    case Lang_Setting_MusicWillPauseAt   =  "Setting_MusicWillPauseAt"
    case Lang_Setting_Customize          =  "Setting_Customize"
    case Lang_Setting_LastSelectedChannel =  "Setting_LastSelectedChannel"
    case Lang_Setting_AutoPlay            =  "Setting_AutoPlay"
    case Lang_Setting_CurrentDisplayLanguage =  "Setting_CurrentDisplayLanguage"
    case Lang_Setting_SelectLanguage         =  "Setting_SelectLanguage" /// 四种语言字串 日本語 English 简体 繁體
    case Lang_Setting_CurrentVersion         =  "Setting_CurrentVersion"
    case Lang_Setting_SwitchingLanguage      =  "Setting_SwitchingLanguage"
    
    /// 通用
    case Lang_Common_Edit           =  "Common_Edit"
    case Lang_Common_Done           =  "Common_Done"
    case Lang_Common_Share          =  "Common_Share"
    case Lang_Common_Decasee         =  "Common_Decasee"
    case Lang_Common_Cancel         =  "Common_Cancel"
    case Lang_Common_SelectTrack    =  "Common_SelectTrack"
    case Lang_Common_Playlist       =  "Common_Playlist"
    case Lang_Common_Download       =  "Common_Download"
    case Lang_Common_Close          =  "Common_Close"
    
    /// 提示
    case Lang_Tip_SequentialModeActivated =  "Tip_SequentialModeActivated"
    case Lang_Tip_ShuffleModeActivated    =  "Tip_ShuffleModeActivated"
    case Lang_Tip_SingleLoopActivated     =  "Tip_SingleLoopActivated"
    case Lang_Tip_AddedToFavorites        =  "Tip_AddedToFavorites"
    case Lang_Tip_RemovedFromFavorites    =  "Tip_RemovedFromFavorites"
    case Lang_Tip_NoUpdateAvailable       =  "Tip_NoUpdateAvailable"
    
    /// 获取对应的语言字串
    var value : String {
        return LanguageHelper.shared.getLanguageText(by: self.rawValue)
    }
}


