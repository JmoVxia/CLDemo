//
//  CLBundle.swift
//  CLDemo-Swift
//
//  Created by Chen JmoVxia on 2021/6/22.
//

import UIKit

extension CLLanguageManager {
    enum Language: String {
        ///跟随系统
        case system = ""
        ///英文
        case english = "en"
        ///简体中文
        case chineseSimplified = "zh-Hans"
    }
}

class CLLanguageManager: NSObject {
    static let shared: CLLanguageManager = CLLanguageManager()
    private (set) var bundle: Bundle = Bundle.main
    private (set) var currentLanguage: Language = .system {
        didSet {
            if currentLanguage != oldValue {
                if currentLanguage.rawValue.isEmpty {
                    self.bundle = .main
                    return
                }
                guard let bundlePath = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
                      let bundle = Bundle(path: bundlePath)
                else {
                    return
                }
                self.bundle = bundle
            }
        }
    }
    private override init() {
        super.init()
        defer {
            if let string = UserDefaults.standard.string(forKey: "UserLanguage"),
               let language = Language(rawValue: string) {
                self.currentLanguage = language
            }
        }
    }
}
extension CLLanguageManager {
    ///设置用户自定义语言
    static func setUserLanguage(_ language: Language) {
        UserDefaults.standard.setValue(language.rawValue, forKey: "UserLanguage")
        UserDefaults.standard.synchronize()
        
        shared.currentLanguage = language
    }
}
