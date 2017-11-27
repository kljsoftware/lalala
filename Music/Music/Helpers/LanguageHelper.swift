//
//  LanguageHelper.swift
//  Music
//
//  Created by hzg on 2017/11/26.
//  Copyright © 2017年 demo. All rights reserved.
//

/// 语言类型
enum LanguageType : String {
    case en     = "en"       // 英
    case zhHans = "zh-Hans"  // 简体汉
}

/// 单例，多语言管理助手
class LanguageHelper {
   
    /// 实例对象
    static let shared = LanguageHelper()

    /// 当前使用的bundle资源
    private var bundle:Bundle?
    
    /// 当前使用语言
    var language = "zh-Hans"
    
    /// 构造
    private init() {
        let systemLanguages = UserDefaults.standard.value(forKey: "AppleLanguages") as! NSArray
        let systemLanguage = systemLanguages.firstObject as! String
        language = isSupportLanguage(systemLanguage) ? systemLanguage : "zh-Hans"
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            Log.e("language \(language) 不存在")
            return
        }
        bundle = Bundle(path: path)
    }
    
    /// 判断是否支持，若不支持，返回Base
    private func isSupportLanguage(_ language:String) -> Bool {
        var isSupported = false
        switch language {
        case LanguageType.en.rawValue, LanguageType.zhHans.rawValue:
            isSupported = true
        default:
            break
        }
        return isSupported
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
        bundle = Bundle(path: path)
    }

    /// 获取对应语言的文字
    func getLanguageText(by key:String) -> String? {
        return bundle?.localizedString(forKey: key, value: nil, table: "Localizable")
    }
}
