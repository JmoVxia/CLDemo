//
//  CLHanziToPinyin.swift
//  CL
//
//  Created by Chen JmoVxia on 2021/11/17.
//  Copyright © 2021 JmoVxia. All rights reserved.
//

import UIKit

extension CLPinyinOutputFormat {
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

struct CLPinyinOutputFormat {
    var toneType: PinyinToneType
    var vCharType: PinyinVCharType
    var caseType: PinyinCaseType

    static var `default`: CLPinyinOutputFormat {
        return CLPinyinOutputFormat(toneType: .none, vCharType: .vCharacter, caseType: .lowercased)
    }
}

class CLHanziToPinyin {
    private(set) lazy var unicodeToPinyinTable: [String: String] = {
        guard let resourcePath = Bundle.main.path(forResource: "unicode_to_hanyu_pinyin", ofType: nil) else { return [:] }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resourcePath)) else { return [:] }
        guard let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String] else { return [:] }
        return dictionary
    }()

    private(set) lazy var sentence: [String: String] = {
        guard let resourcePath = Bundle.main.path(forResource: "unicode_to_sentence_pinyin", ofType: nil) else { return [:] }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: resourcePath)) else { return [:] }
        guard let dictionary = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String: String] else { return [:] }
        return dictionary
    }()

    static let start: UInt32 = 0x4E00

    static let end: UInt32 = 0x9FFF

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
    static func stringToPinyin(string: String, outputFormat: CLPinyinOutputFormat = .default, separator: String = " ") -> (long: String, short: String) {
        let tokenizer = CFStringTokenizerCreate(nil, string as CFString, CFRangeMake(CFIndex(0), CFIndex(string.count)), kCFStringTokenizerUnitWordBoundary, nil) // 创建分词器
        CFStringTokenizerAdvanceToNextToken(tokenizer)
        var range: CFRange = CFStringTokenizerGetCurrentTokenRange(tokenizer)
        var longWords = [String]()
        var shortWords = [String]()
        while range.length > 0 {
            let subRang = NSRange(location: range.location, length: range.length)
            let keyWord = (string as NSString).substring(with: subRang)
            if keyWord.unicodeScalars.contains(where: { isHanzi(ofCharCodePoint: $0.value) }) {
                if let sentence = CLHanziToPinyin.sharedInstance.sentence[keyWord] {
                    let longPinyin = " " + CLHanziToPinyin.format(sentence, withOutputFormat: outputFormat)
                    let shortPinyin = longPinyin.components(separatedBy: " ").map { $0.prefix(1) }.joined(separator: " ")
                    longWords.append(longPinyin)
                    shortWords.append(shortPinyin)
                } else {
                    for unicodeScalar in keyWord.unicodeScalars {
                        let pinyinArray = CLHanziToPinyin.pinyinArray(withCharCodePoint: unicodeScalar.value, outputFormat: outputFormat)
                        if pinyinArray.isEmpty {
                            let longPinyin = " " + String(unicodeScalar)
                            let shortPinyin = String(longPinyin.prefix(2))
                            longWords.append(longPinyin)
                            shortWords.append(shortPinyin)
                        } else if let first = pinyinArray.first {
                            let longPinyin = " " + first
                            let shortPinyin = String(longPinyin.prefix(2))
                            longWords.append(longPinyin)
                            shortWords.append(shortPinyin)
                        }
                    }
                }
            } else {
                let word = " " + keyWord
                longWords.append(word)
                shortWords.append(word)
            }
            CFStringTokenizerAdvanceToNextToken(tokenizer)
            range = CFStringTokenizerGetCurrentTokenRange(tokenizer)
        }
        var long = longWords.joined()
        var short = shortWords.joined()

        if long.hasPrefix(" ") {
            long.removeFirst(1)
        }
        if short.hasPrefix(" ") {
            short.removeFirst(1)
        }
        return (long.replacingOccurrences(of: " ", with: separator), short.replacingOccurrences(of: " ", with: separator))
    }

    /// 汉字转拼音，异步
    /// - Parameters:
    ///   - string: 原始字符串
    ///   - outputFormat: 输出格式
    ///   - separator: 分割符
    ///   - completion: 转化后的回调，long为完整字符串，short为首字母字符串
    static func stringToPinyin(string: String, outputFormat: CLPinyinOutputFormat = .default, separator: String = " ", completion: @escaping ((_ pinyin: (long: String, short: String)) -> Void)) {
        DispatchQueue.global(qos: .default).async {
            let pinyin = self.stringToPinyin(string: string, outputFormat: outputFormat, separator: separator)
            DispatchQueue.main.async {
                completion(pinyin)
            }
        }
    }
}

extension CLHanziToPinyin {
    private static func pinyinArray(withCharCodePoint charCodePoint: UInt32, outputFormat: CLPinyinOutputFormat = .default) -> [String] {
        func isValidPinyin(_ pinyin: String) -> Bool {
            return pinyin != "(none0)"
        }

        guard let pinyin = CLHanziToPinyin.sharedInstance.unicodeToPinyinTable[String(format: "%x", charCodePoint).uppercased()],
              isValidPinyin(pinyin)
        else {
            return []
        }

        return pinyin.components(separatedBy: ",").map { format($0, withOutputFormat: outputFormat) }
    }
}

extension CLHanziToPinyin {
    private static func format(_ pinyin: String, withOutputFormat format: CLPinyinOutputFormat) -> String {
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

extension CLHanziToPinyin {
    static func isHanzi(ofCharCodePoint charCodePoint: UInt32) -> Bool {
        return charCodePoint >= start && charCodePoint <= end
    }
}
