//
//  CLHanziToPinyin.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/17.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

extension CKDPinyinOutputFormat {
    /// 音调类型
    enum PinyinToneType {
        /// 不带音调
        case none
        /// 数字
        case toneNumber
    }

    /// U显示方式
    enum PinyinVCharType {
        /// u: -> v
        case vCharacter
        /// u: -> ü
        case uUnicode
        /// u: -> u:
        case uAndColon
    }

    /// 字母样式
    enum PinyinCaseType {
        /// 全小写
        case lowercased
        /// 全大写
        case uppercased
        /// 首字母大写
        case capitalized
    }
}

// MARK: - JmoVxia---输出格式

struct CKDPinyinOutputFormat {
    var toneType: PinyinToneType
    var vCharType: PinyinVCharType
    var caseType: PinyinCaseType

    static var `default`: CKDPinyinOutputFormat {
        return CKDPinyinOutputFormat(toneType: .none, vCharType: .vCharacter, caseType: .lowercased)
    }
}

class CLHanziToPinyin {
    private(set) lazy var unicodeToPinyinTable: [String: String] = {
        guard let resourcePath = Bundle.main.path(forResource: "hanyupinyin", ofType: nil) else { return [:] }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resourcePath)) else { return [:] }
        guard let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String] else { return [:] }
        return dictionary
    }()

    private(set) lazy var sentence: [String: String] = {
        guard let resourcePath = Bundle.main.path(forResource: "sentencepinyin", ofType: nil) else { return [:] }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resourcePath)) else { return [:] }
        guard let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String] else { return [:] }
        return dictionary
    }()
    
    static let sharedInstance = CLHanziToPinyin()

    private init() {}
}

extension CLHanziToPinyin {
    /// 汉字转拼音，同步
    /// - Parameters:
    ///   - string: 原始字符串
    ///   - outputFormat: 输出格式
    ///   - separator: 分割符
    /// - Returns: 转化后的字符串，long为完整字符串，short为首字母字符串
    static func stringToPinyin(string: String, outputFormat: CKDPinyinOutputFormat = .default, separator: String = " ") -> (long: String, short: String) {
        let tokenizer = CFStringTokenizerCreate(nil, string as CFString, CFRangeMake(CFIndex(0), CFIndex(string.count)), kCFStringTokenizerUnitWordBoundary, Locale(identifier: "zh-Hans") as CFLocale) // 创建分词器
        CFStringTokenizerAdvanceToNextToken(tokenizer)
        var range: CFRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
        var longWords = [String]()
        var shortWords = [String]()
        while range.length > 0 {
            let subRang = NSRange(location: range.location, length: range.length)
            let keyWord = (string as NSString).substring(with: subRang)
            
            if let sentence = CLHanziToPinyin.sharedInstance.sentence[keyWord] {
                let longPinyin = " " + CLHanziToPinyin.format(sentence, withOutputFormat: outputFormat)
                let shortPinyin = longPinyin.components(separatedBy: " ").map({$0.prefix(1)}).joined(separator: " ")
                longWords.append(longPinyin)
                shortWords.append(shortPinyin)
            } else {
                for word in keyWord {
                    let key = String(word)
                    let pinyinArray = CLHanziToPinyin.pinyinArray(key: key, outputFormat: outputFormat)
                    if pinyinArray.isEmpty {
                        longWords.append(key)
                        shortWords.append(key)
                    } else if let first = pinyinArray.first {
                        let longPinyin = " " + first + " "
                        let shortPinyin = String(longPinyin.prefix(2))
                        longWords.append(longPinyin)
                        shortWords.append(shortPinyin + " ")
                    }
                }
            }
            CFStringTokenizerAdvanceToNextToken(tokenizer)
            range = CFStringTokenizerGetCurrentTokenRange(tokenizer)
        }
        var long = longWords.joined()
        var short = shortWords.joined()

        if long.hasPrefix(" ") {
            long.removeFirst(1)
        }
        if long.hasSuffix(" ") {
            long.removeLast(1)
        }
        if short.hasPrefix(" ") {
            short.removeFirst(1)
        }
        if short.hasSuffix(" ") {
            short.removeLast(1)
        }
        return (long.replacingOccurrences(of: " ", with: separator), short.replacingOccurrences(of: " ", with: separator))
    }

    /// 汉字转拼音，异步
    /// - Parameters:
    ///   - string: 原始字符串
    ///   - outputFormat: 输出格式
    ///   - separator: 分割符
    ///   - completion: 转化后的回调，long为完整字符串，short为首字母字符串
    static func stringToPinyin(string: String, outputFormat: CKDPinyinOutputFormat = .default, separator: String = " ", completion: @escaping ((_ pinyin: (long: String, short: String)) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            let pinyin = self.stringToPinyin(string: string, outputFormat: outputFormat, separator: separator)
            DispatchQueue.main.async {
                completion(pinyin)
            }
        }
    }
}

extension CLHanziToPinyin {
    private static func pinyinArray(key: String, outputFormat: CKDPinyinOutputFormat = .default) -> [String] {
        func isValidPinyin(_ pinyin: String) -> Bool {
            return pinyin != "(none0)"
        }

        guard let pinyin = CLHanziToPinyin.sharedInstance.unicodeToPinyinTable[key],
              isValidPinyin(pinyin)
        else {
            return []
        }

        return pinyin.components(separatedBy: ",").map { format($0, withOutputFormat: outputFormat) }
    }
}

extension CLHanziToPinyin {
    private static func format(_ pinyin: String, withOutputFormat format: CKDPinyinOutputFormat) -> String {
        var formattedPinyin = pinyin

        switch format.toneType {
        case .none:
            formattedPinyin = formattedPinyin.replacingOccurrences(of: "[1-5]", with: "", options: .regularExpression, range: formattedPinyin.startIndex ..< formattedPinyin.endIndex)
        case .toneNumber:
            break
        }

        switch format.vCharType {
        case .vCharacter:
            formattedPinyin = formattedPinyin.replacingOccurrences(of: "u:", with: "v")
        case .uUnicode:
            formattedPinyin = formattedPinyin.replacingOccurrences(of: "u:", with: "ü")
        case .uAndColon:
            break
        }

        switch format.caseType {
        case .lowercased:
            formattedPinyin = formattedPinyin.lowercased()
        case .uppercased:
            formattedPinyin = formattedPinyin.uppercased()
        case .capitalized:
            formattedPinyin = formattedPinyin.capitalized
        }

        return formattedPinyin
    }
}
