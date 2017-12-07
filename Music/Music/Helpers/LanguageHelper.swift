//
//  LanguageHelper.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 语言类型
enum LanguageType : String {
    case base   = "Base"
    case en     = "en"       // 英
    case ja     = "ja"       // 日
    case ko     = "ko"       // 韩
    case zhHans = "zh-Hans"  // 简体汉
    case zhHant = "zh-Hant"  // 繁体汉
}

/// 单例，多语言管理助手
class LanguageHelper {
   
    /// 实例对象
    static let shared = LanguageHelper()

    /// 当前使用的bundle资源
    private var bundle:Bundle?
    
    /// 当前使用语言
    var language = LanguageType.zhHans.rawValue
    
    /// 构造
    private init() {
        
        /// 获取应用当前设置的语言
        var lang = UserDefaults.standard.value(forKey: UserDefaultLanguage) as? String
        
        /// 若本地没有存储则获取系统语言作为默认语言
        if nil == lang {
            let systemLanguages = UserDefaults.standard.value(forKey: "AppleLanguages") as! NSArray
            let systemLanguage = systemLanguages.firstObject as! String
            lang = getSystemLanguage(systemLanguage)
        }
        language = lang!
        UserDefaults.standard.set(language, forKey: UserDefaultLanguage)
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            Log.e("language \(language) 不存在")
            return
        }
        bundle = Bundle(path: path)
    }
    
    /// 判断是否支持，若不支持，返回zhHans
    private func getSystemLanguage(_ language:String) -> String {
        var type = LanguageType.zhHans
        if language.hasPrefix(LanguageType.en.rawValue) {
            type = .en
        } else if language.hasPrefix(LanguageType.ja.rawValue) {
            type = .ja
        } else if language.hasPrefix(LanguageType.ko.rawValue) {
            type = .ko
        } else if language.hasPrefix(LanguageType.zhHans.rawValue) {
            type = .zhHans
        } else if language.hasPrefix(LanguageType.zhHant.rawValue) {
            type = .zhHant
        }
        return type.rawValue
    }
    
    /// 切换语言
    func setLanguage(type:LanguageType) {

        if language == type.rawValue {
            return
        }
        guard let path = Bundle.main.path(forResource: type.rawValue, ofType: "lproj") else {
            Log.e("language \(type.rawValue) 不存在")
            return
        }
        language = type.rawValue
        UserDefaults.standard.set(language, forKey: UserDefaultLanguage)
        bundle = Bundle(path: path)
    }

    /// 获取对应语言的文字
    func getLanguageText(by key:String) -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? "null"
    }
}
