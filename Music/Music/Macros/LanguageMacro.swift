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
    case FM            =  "FM_FM"
    case MyMusic       =  "MyMusic_MyMusic"
    case Discover      =  "Discover_Discover"
    case Query_Search  =  "Query_Search"
    case Me            =  "Me_Me"
    
    ///  FM
    case FM_RefreshTracks =  "FM_RefreshTracks"
    
    /// 我的音乐
    case MyMusic_Favorite        =  "MyMusic_Favorite"
    case MyMusic_MyDownload      =  "MyMusic_MyDownload"
    case MyMusic_OwnedPlaylists  =  "MyMusic_OwnedPlaylists"
    case MyMusic_CreatePlaylist  =  "MyMusic_CreatePlaylist"
    case MyMusic_Downloaded      =  "MyMusic_Downloaded"
    case MyMusic_Downloading     =  "MyMusic_Downloading"
    case MyMusic_AddToPlaylist   =  "MyMusic_AddToPlaylist"
    case MyMusic_SelectAll       =  "MyMusic_SelectAll"
    case MyMusic_NumberSeclected =  "MyMusic_NumberSeclected"
    case MyMusic_EditPlaylistNameDescription =  "MyMusic_EditPlaylistNameDescription"
    case MyMusic_TrackArtistAlbum            =  "MyMusic_TrackArtistAlbum"
    case MyMusic_PauseAll = "MyMusic_PauseAll"
    case MyMusic_ContinueAll = "MyMusic_ContinueAll"
    case MyMusic_NoTask = "MyMusic_NoTask"
   
    /// 发现
    case Discover_Rank              =  "Discover_Rank"
    case Discover_PopularPlaylist   =  "Discover_PopularPlaylist"
    
    /// 搜索
    case Query_PopularSearches     =  "Query_PopularSearches"
    case Query_NoResults           =  "Query_NoResults"
    case Query_ClearSearchHistory  =  "Query_ClearSearchHistory"
    case Query_SearchHistory       =  "Query_SearchHistory"
    
    /// 我
    case Setting_TodayRemainingDownloads =  "Setting_TodayRemainingDownloads"
    case Setting_SleepMode          =  "Setting_SleepMode"
    case Setting_Setting            =  "Setting_Setting"
    case Setting_ShareThisApp       =  "Setting_ShareThisApp"
    case Setting_DisableTimer       =  "Setting_DisableTimer"
    case Setting_NumberMinutesLater =  "Setting_NumberMinutesLater"
    case Setting_MusicWillPauseAt   =  "Setting_MusicWillPauseAt"
    case Setting_Customize          =  "Setting_Customize"
    case Setting_LastSelectedChannel =  "Setting_LastSelectedChannel"
    case Setting_AutoPlay            =  "Setting_AutoPlay"
    case Setting_CurrentDisplayLanguage =  "Setting_CurrentDisplayLanguage"
    case Setting_SelectLanguage         =  "Setting_SelectLanguage" /// 四种语言字串 日本語 English 简体 繁體
    case Setting_CurrentVersion         =  "Setting_CurrentVersion"
    case Setting_SwitchingLanguage      =  "Setting_SwitchingLanguage"
    
    /// 通用
    case Common_Edit           =  "Common_Edit"
    case Common_Done           =  "Common_Done"
    case Common_Share          =  "Common_Share"
    case Common_Delete         =  "Common_Delete"
    case Common_Cancel         =  "Common_Cancel"
    case Common_SelectTrack    =  "Common_SelectTrack"
    case Common_Playlist       =  "Common_Playlist"
    case Common_Download       =  "Common_Download"
    case Common_Close          =  "Common_Close"
    case Common_NoContent = "Common_NoContent"

    /// 提示
    case Tip_SequentialModeActivated =  "Tip_SequentialModeActivated"
    case Tip_ShuffleModeActivated    =  "Tip_ShuffleModeActivated"
    case Tip_SingleLoopActivated     =  "Tip_SingleLoopActivated"
    case Tip_AddedToFavorites        =  "Tip_AddedToFavorites"
    case Tip_RemovedFromFavorites    =  "Tip_RemovedFromFavorites"
    case Tip_NoUpdateAvailable       =  "Tip_NoUpdateAvailable"
    case Tip_DownloadTrackSuccess = "Tip_DownloadTrackSuccess"
    case Tip_DownloadTrackNoCredit = "Tip_DownloadTrackNoCredit"
    case Tip_PlaylistExisted = "Tip_PlaylistExisted"
    case Tip_AddingComplete = "Tip_AddingComplete"
    case Tip_AddingFail = "Tip_AddingFail"
    case Tip_PleaseEnterName = "Tip_PleaseEnterName"
    case Tip_ConfirmToDeleteNumberTracks = "Tip_ConfirmToDeleteNumberTracks"
    case Tip_ConfirmToDelete = "Tip_ConfirmToDelete"
    case Tip_ConfirmToDeltePlaylist = "Tip_ConfirmToDeltePlaylist"
    
    // 引导
    case Guide_EditPlaylistInfo = "Guide_EditPlaylistInfo"
    case Guide_MultipleOperate = "Guide_MultipleOperate"
    
    // 歌词
    case Lyric_NoLyrics = "Lyric_NoLyrics"
    /// 获取对应的语言字串
    var value : String {
        return LanguageHelper.shared.getLanguageText(by: self.rawValue)
    }
}


