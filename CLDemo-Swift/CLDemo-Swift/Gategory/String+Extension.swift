//
//  String+Extension.swift
//  CLDemo
//
//  Created by JmoVxia on 2020/1/27.
//  Copyright © 2020 JmoVxia. All rights reserved.
//

import CryptoSwift

extension String {
    ///验证邮箱
    func isValidEmailStricterFilter(stricterFilter: Bool = true) -> Bool {
        let stricterFilterString = "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$"
        let laxString = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let regex = stricterFilter ? stricterFilterString : laxString
        return matches(regex)
    }
    ///验证指定位数纯数字
    func isValidNumberEqual(to count: Int) -> Bool {
        let regex = "^[0-9]{\(count)}$"
        return matches(regex)
    }
    ///验证全部是空格
    func isValidAllEmpty() -> Bool {
        let regex = "^\\s*$"
        return matches(regex)
    }
    ///验证是否为0
    func isValidZero() -> Bool {
        return self == "0"
    }
    ///验证是否纯数字
    func isValidPureNumbers() -> Bool {
        let regex = "^[0-9]+$"
        return matches(regex)
    }
    ///验证是否小于等于指定位数的纯数字
    func isValidNumbersLessThanOrEqual(to count: Int) -> Bool {
        let regex = "^[0-9]{0,\(count)}$"
        return matches(regex)
    }
    ///验证小数点后位数
    func isValidDecimalPointCount(_ count: Int) -> Bool {
        let regex = "^(([1-9]{1}\\d*)|([0]{1}))(\\.(\\d){0,\(count)})?$"
        return matches(regex)
    }
    ///是否是合法账号(只含有数字、字母、下划线、@、. 位数1到30位)
    func isValidAccount() -> Bool {
        let regex = "^[a-zA-Z0-9_.@]{1,30}$"
        return matches(regex)
    }
    ///是否是合法密码(只含有数字、字母)
    func isValidPassword(from: Int, to: Int) -> Bool {
        let regex = "^[0-9A-Za-z]{\(from),\(to)}$"
        return matches(regex)
    }
    ///是否是有效中文姓名
    func isValidChineseName() -> Bool {
        let regex = "^[\u{4e00}-\u{9fa5}]+(·[\u{4e00}-\u{9fa5}]+)*$"
        return matches(regex)
    }
    ///是否是有效英文姓名
    func isValidEnglishName() -> Bool {
        let regex = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
        return matches(regex)
    }    
    ///根据字体和每一行宽度切割字符串
    func separatedLines(with font: UIFont, width: CGFloat) -> [String] {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key(kCTFontAttributeName as String), value: CTFontCreateWithName((font.fontName) as CFString, font.pointSize, nil), range: NSRange(location: 0, length: attributedString.length))
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: 100000), transform: .identity)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame)
        var linesArray: [String] = []
        for line in (lines as Array) {
            let lineRef = line as! CTLine
            let lineRange: CFRange = CTLineGetStringRange(lineRef)
            let range = NSRange(location: lineRange.location, length: lineRange.length)
            let lineString = (self as NSString).substring(with: range)
            linesArray.append(lineString)
        }
        return linesArray
    }
    ///计算行数
    func calculateLines(with font: UIFont, width: CGFloat) -> Int {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(NSAttributedString.Key(kCTFontAttributeName as String), value: CTFontCreateWithName((font.fontName) as CFString, font.pointSize, nil), range: NSRange(location: 0, length: attributedString.length))
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: 100000), transform: .identity)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame)
        let linesArray: [Any] = lines as? [Any] ?? [Any]()
        return linesArray.count
    }
}
extension String {
    ///最后的文件路径
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    ///文件后缀
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
}
extension String {
    var url: URL? {
        return URL(string: self)
    }
}
extension String {
    ///正则匹配验证（true表示匹配成功）
    func matches(_ string: String) -> Bool {
        return firstMatch(string) != nil
    }
    ///获取第一个匹配结果
    func firstMatch(_ string: String) -> String? {
        let regex = try! Regex(string)
        return regex.firstMatch(in: self)?.string
    }
    ///获取所有的匹配结果
    func matches(_ string: String) -> [String] {
        let regex = try! Regex(string)
        return regex.matches(in: self).map({$0.string})
    }
    ///正则替换
    func replacingMatches(_ string: String, with template: String, count: Int? = nil) -> String {
        let regex = try! Regex(string)
        return regex.replacingMatches(in: self, with: template, count: count).0
    }
}
extension String {
    var int: Int {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.intValue
    }
    var float: Float {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.floatValue
    }
    var double: Double {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.doubleValue
    }
    var cgFloat: CGFloat {
        let decimalNumber = NSDecimalNumber(string: self)
        return CGFloat(decimalNumber.floatValue)
    }
}
extension String {
    ///32位 小写
    var md5ForLower32Bate: String {
        return md5()
    }
    ///32位 大写
    var md5ForUpper32Bate: String {
        return md5().uppercased()
    }
}
extension String {
    ///aes加密字符串
    var aes128Encrypt: String {
        if let aes = try? AES(key: "5A9C0A4D1A3ACC1D", iv: "9AA257C93AEDC915", padding: .pkcs7), let encrypted = try? aes.encrypt(bytes).toBase64() {
            return encrypted
        }else {
            return ""
        }
    }
}
extension String {    
    /// 从某个位置开始截取：
    /// - Parameter index: 起始位置
    subscript(from index: Int) -> String? {
        guard index >= 0 && index < count else { return nil }
        let startIndex = self.index(self.startIndex,offsetBy: index)
        let subString = self[startIndex..<self.endIndex];
        return String(subString);
    }
    
    /// 从零开始截取到某个位置：
    /// - Parameter index: 达到某个位置
    subscript(to index: Int) -> String? {
        guard index >= 0 && index < count else { return nil }
        let endIndex = self.index(self.startIndex, offsetBy: index)
        let subString = self[self.startIndex..<endIndex]
        return String(subString)
    }
    /// 某个范围内截取
    /// - Parameter range: 范围
    subscript<R>(range range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
            let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
                return nil
        }
        return String(self[lowerIndex..<upperIndex])
    }
}
extension String {
    var decimalNumber: NSDecimalNumber {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber == NSDecimalNumber.notANumber ? 0 : decimalNumber
    }
}
extension String {
    ///国际化
    var localized: String {
        return NSLocalizedString(self, tableName: "", bundle: CLLanguageManager.shared.bundle, value: "", comment: "")
    }
}
